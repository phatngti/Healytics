"""
ai_services/ner-service/app/utils/db_fetcher.py

Fetch service candidates from PostgreSQL with 3-case spatial routing:

  TH1 — Có GPS thật (fallback_used=False):
    - ST_DWithin(user_coords, radius) — vẽ vòng tròn bất chấp ranh giới hành chính
        - ORDER BY match_confidence DESC, avg_rating DESC, distance_meters ASC
    - Không áp locationCode (GPS đã đủ chính xác)

  TH2 — Fallback Province (fallback_used=True, level=PROVINCE):
    - Không dùng ST_DWithin (quét domain quá lớn, tâm tỉnh không đại diện được)
    - Áp ranh giới hành chính: loc_p.code = :loc_code
        - ORDER BY match_confidence DESC, avg_rating DESC

  TH3 — Fallback District/Ward (fallback_used=True, level=DISTRICT/WARD):
    - ST_DWithin(district_center, radius) — cho phép vượt ranh giới quận
    - Không áp loc_d.code (mở rộng sang quận giáp ranh)
        - ORDER BY match_confidence DESC, avg_rating DESC, distance_meters ASC

  Không có spatial:
    - Text-only query + optional filters
        - ORDER BY match_confidence DESC, avg_rating DESC, p.created_at DESC
"""

import logging
from typing import Any, Dict, List, Optional
from sqlalchemy import text
from app.core.database import async_session
from app.schemas.ner_schema import ServiceCandidate, PriceInfo, RatingInfo, LocationInfo

logger = logging.getLogger(__name__)


# ─── SQL base fragments ──────────────────────────────────────────────────────

_SELECT_BASE = """
    SELECT DISTINCT
        p.id,
        p.name,
        p.slug,
        p.base_price,
        p.sale_price,
        p.type,
        p.vendor_name,
        p.created_at,
        c.name AS category_name,
        pd.duration_minutes,
        pm.url AS image_url,
        hpp.brand_name AS partner_brand,
        loc_d.full_name AS district_name,
        loc_p.full_name AS province_name,
        COALESCE(
            (SELECT AVG(pr.rating) FROM product_reviews pr WHERE pr.product_id = p.id),
            0
        ) AS avg_rating"""

_ST_DISTANCE_EXPR = """ST_Distance(
            hpp.location,
            ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography
        )"""

_SELECT_DISTANCE = f""",
        {_ST_DISTANCE_EXPR} AS distance_meters"""

_FROM_JOINS = """
    FROM products p
    LEFT JOIN categories c                    ON p.category_id = c.id
    LEFT JOIN product_definitions pd          ON p.id = pd.product_id
    LEFT JOIN product_media pm                ON p.id = pm.product_id AND pm.is_thumbnail = true
    LEFT JOIN product_employee_eligibility pee ON p.id = pee.product_id
    LEFT JOIN employees e                     ON pee.employee_id = e.id
    LEFT JOIN health_partner_profile hpp      ON e.partner_id = hpp.id
    LEFT JOIN location loc_d                  ON hpp.district_id = loc_d.id
    LEFT JOIN location loc_p                  ON hpp.province_id = loc_p.id
    WHERE p.status = 'active' AND p.is_visible_online = true"""

_WHERE_LOCATION_NOT_NULL = """
    AND hpp.location IS NOT NULL"""

_ST_DWITHIN = """ST_DWithin(
        hpp.location,
        ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography,
        :radius_m
    )"""

_ST_DISTANCE_GTE = f"""{_ST_DISTANCE_EXPR} >= :distance_min_m"""


def _extract_business_types(query_params: Dict[str, Any]) -> list[str]:
    business_types: list[str] = []
    seen: set[str] = set()

    raw_list = query_params.get("businessTypes")
    if isinstance(raw_list, str):
        raw_list = [raw_list]
    if isinstance(raw_list, list):
        for bt in raw_list:
            bt_str = str(bt).strip() if bt is not None else ""
            if bt_str and bt_str not in seen:
                seen.add(bt_str)
                business_types.append(bt_str)

    legacy_bt = query_params.get("businessType")
    legacy_bt_str = str(legacy_bt).strip() if legacy_bt is not None else ""
    if legacy_bt_str and legacy_bt_str not in seen:
        seen.add(legacy_bt_str)
        business_types.append(legacy_bt_str)

    return business_types


def _build_business_type_or_clause(business_types: list[str], bind_prefix: str = "bt") -> tuple[str, Dict[str, Any]]:
    params: Dict[str, Any] = {}
    conditions: list[str] = []

    for i, business_type in enumerate(business_types):
        key = f"{bind_prefix}_{i}"
        params[key] = business_type
        conditions.append(f":{key} = ANY(string_to_array(hpp.business_type, ','))")

    return "(" + " OR ".join(conditions) + ")", params


def _build_distance_conditions(spatial_params: Dict[str, Any]) -> tuple[list[str], Dict[str, Any]]:
    """
    Build index-friendly distance conditions.

    Strategy:
      - Use ST_DWithin(max_distance) for GiST index pruning.
      - Add ST_Distance >= min_distance when lower bound exists.
    """
    conditions: list[str] = []
    params: Dict[str, Any] = {}

    max_distance = spatial_params.get("distance_max_meters")
    if max_distance is None:
        max_distance = spatial_params.get("radius_meters")

    min_distance = spatial_params.get("distance_min_meters")

    if max_distance is not None:
        try:
            max_m = int(float(max_distance))
        except (TypeError, ValueError):
            max_m = 0
        if max_m > 0:
            params["radius_m"] = max_m
            conditions.append(_ST_DWITHIN.strip())

    if min_distance is not None:
        try:
            min_m = float(min_distance)
        except (TypeError, ValueError):
            min_m = 0.0
        if min_m > 0:
            params["distance_min_m"] = min_m
            conditions.append(_ST_DISTANCE_GTE.strip())

    return conditions, params


def _build_match_confidence_expression(
    business_types: list[str],
    bind_prefix: str = "score_bt",
) -> tuple[str, Dict[str, Any]]:
    """Build SQL expression for confidence score in range [0, 1]."""
    if not business_types:
        return "0.0", {}

    params: Dict[str, Any] = {}
    score_terms: list[str] = []

    for i, business_type in enumerate(business_types):
        key = f"{bind_prefix}_{i}"
        params[key] = business_type
        score_terms.append(
            f"CASE WHEN :{key} = ANY(string_to_array(COALESCE(hpp.business_type, ''), ',')) THEN 1 ELSE 0 END"
        )

    count_key = f"{bind_prefix}_count"
    params[count_key] = len(business_types)
    expression = "(" + " + ".join(score_terms) + f")::float / :{count_key}"
    return expression, params


def _compute_match_confidence(service_business_types: list[str], target_business_types: list[str]) -> float:
    if not target_business_types:
        return 0.0

    target_set = {bt for bt in target_business_types if bt}
    if not target_set:
        return 0.0

    service_set = {bt for bt in service_business_types if bt}
    if not service_set:
        return 0.0

    overlap = len(target_set.intersection(service_set))
    return round(overlap / len(target_set), 4)


def _parse_service_business_types(raw_business_types: Any) -> list[str]:
    if raw_business_types is None:
        return []
    if isinstance(raw_business_types, str):
        return [part.strip() for part in raw_business_types.split(",") if part and part.strip()]
    if isinstance(raw_business_types, list):
        return [str(part).strip() for part in raw_business_types if part is not None and str(part).strip()]
    return []


# ─── Main function ────────────────────────────────────────────────────────────

async def fetch_candidates_from_db(
    query_params: Dict[str, Any],
    use_postgis: bool = False,
) -> List[ServiceCandidate]:
    """
    Fetch service candidates from PostgreSQL.
    Routes to one of 3 spatial strategies or text-only based on spatial_params.
    """
    limit = query_params.get("limit", 50)

    # ── Determine spatial case ────────────────────────────────────────────────
    spatial_case = _resolve_spatial_case(query_params, use_postgis)
    logger.info(f"[DBFetcher] spatial_case={spatial_case}")

    # ── Build SQL ─────────────────────────────────────────────────────────────
    business_types = _extract_business_types(query_params)
    confidence_expr, confidence_params = _build_match_confidence_expression(business_types)

    has_distance_col = spatial_case in ("TH1", "TH3")

    select_sql = _SELECT_BASE + f",\n        {confidence_expr} AS match_confidence" + (_SELECT_DISTANCE if has_distance_col else "")
    sql = select_sql + _FROM_JOINS

    if spatial_case in ("TH1", "TH3"):
        sql += _WHERE_LOCATION_NOT_NULL

    conditions: list[str] = []
    params: Dict[str, Any] = dict(confidence_params)

    # ── Spatial WHERE conditions ───────────────────────────────────────────────
    if spatial_case in ("TH1", "TH3"):
        sp = query_params["spatial_params"]
        params["center_lat"] = sp["center_lat"]
        params["center_lng"] = sp["center_lng"]
        distance_conditions, distance_params = _build_distance_conditions(sp)
        conditions.extend(distance_conditions)
        params.update(distance_params)

    # ── Business Type ─────────────────────────────────────────────────────────
    if business_types:
        bt_clause, bt_params = _build_business_type_or_clause(business_types, bind_prefix="bt")
        conditions.append(bt_clause)
        params.update(bt_params)

    # ── Location Code ─────────────────────────────────────────────────────────
    # TH2 only: apply admin boundary as the primary filter.
    # TH1/TH3: ST_DWithin handles locality — no admin boundary restriction.
    loc_code = query_params.get("locationCode")
    if loc_code and spatial_case == "TH2":
        conditions.append("(loc_d.code = :loc_code OR loc_p.code = :loc_code)")
        params["loc_code"] = loc_code
    elif loc_code and spatial_case is None:
        # Text-only: still apply location filter
        conditions.append("(loc_d.code = :loc_code OR loc_p.code = :loc_code)")
        params["loc_code"] = loc_code

    # ── Price ─────────────────────────────────────────────────────────────────
    min_p = query_params.get("minPrice")
    max_p = query_params.get("maxPrice")
    if min_p is not None:
        conditions.append("COALESCE(p.sale_price, p.base_price) >= :min_p")
        params["min_p"] = min_p
    if max_p is not None:
        conditions.append("COALESCE(p.sale_price, p.base_price) <= :max_p")
        params["max_p"] = max_p

    if conditions:
        sql += " AND " + " AND ".join(conditions)

    # ── ORDER BY ──────────────────────────────────────────────────────────────
    if spatial_case in ("TH1", "TH3"):
        sql += " ORDER BY match_confidence DESC, avg_rating DESC, distance_meters ASC"
    elif spatial_case == "TH2":
        sql += " ORDER BY match_confidence DESC, avg_rating DESC"
    else:
        sql += " ORDER BY match_confidence DESC, avg_rating DESC, p.created_at DESC"

    sql += " LIMIT :limit"
    params["limit"] = limit

    # ── Execute ───────────────────────────────────────────────────────────────
    candidates: List[ServiceCandidate] = []
    db_error: Optional[Exception] = None

    async def _execute_query(sql_text: str, sql_params: Dict[str, Any]) -> List[ServiceCandidate]:
        rows_out = []
        async with async_session() as session:
            result = await session.execute(text(sql_text), sql_params)
            rows = result.fetchall()
            for row in rows:
                rows_out.append(_row_to_candidate(row, has_distance_col))
        return rows_out

    try:
        candidates = await _execute_query(sql, params)

    except Exception as e:
        db_error = e
        logger.error(f"[DBFetcher] Query failed (case={spatial_case}): {e}")

    # ── Progressive relaxation for sparse data (non-spatial only) ───────────
    # Keep businessTypes as strongest signal; relax location if needed.
    if not candidates and db_error is None and spatial_case is None:
        bt_list = _extract_business_types(query_params)
        loc_code = query_params.get("locationCode")

        relax_plans: list[tuple[str, Dict[str, Any]]] = []
        if bt_list and loc_code:
            relax_plans.append(("drop_location", {**query_params, "locationCode": None}))
        if bt_list and loc_code:
            relax_plans.append((
                "bt_only",
                {
                    **query_params,
                    "locationCode": None,
                },
            ))

        for plan_name, relaxed_params in relax_plans:
            try:
                relaxed_conditions: list[str] = []
                relaxed_bt_list = _extract_business_types(relaxed_params)
                relaxed_conf_expr, relaxed_conf_bind = _build_match_confidence_expression(
                    relaxed_bt_list,
                    bind_prefix="rscore_bt",
                )
                relaxed_bind: Dict[str, Any] = {"limit": limit, **relaxed_conf_bind}

                relaxed_sql = _SELECT_BASE + f",\n        {relaxed_conf_expr} AS match_confidence" + _FROM_JOINS

                if relaxed_bt_list:
                    bt_clause, bt_params = _build_business_type_or_clause(relaxed_bt_list, bind_prefix="rbt")
                    relaxed_conditions.append(bt_clause)
                    relaxed_bind.update(bt_params)

                relaxed_loc = relaxed_params.get("locationCode")
                if relaxed_loc:
                    relaxed_conditions.append("(loc_d.code = :loc_code OR loc_p.code = :loc_code)")
                    relaxed_bind["loc_code"] = relaxed_loc

                if relaxed_conditions:
                    relaxed_sql += " AND " + " AND ".join(relaxed_conditions)
                relaxed_sql += " ORDER BY match_confidence DESC, avg_rating DESC, p.created_at DESC LIMIT :limit"

                relaxed_candidates = await _execute_query(relaxed_sql, relaxed_bind)
                if relaxed_candidates:
                    logger.info(
                        "[DBFetcher] Relaxation hit (%s): %s candidates",
                        plan_name,
                        len(relaxed_candidates),
                    )
                    candidates = relaxed_candidates
                    break
                logger.info("[DBFetcher] Relaxation miss (%s)", plan_name)
            except Exception as relax_exc:
                logger.warning("[DBFetcher] Relaxation failed (%s): %s", plan_name, relax_exc)

   
    return candidates


# ─── Helpers ─────────────────────────────────────────────────────────────────

def _resolve_spatial_case(query_params: Dict[str, Any], use_postgis: bool) -> Optional[str]:
    """
    Determine spatial routing case.

    Returns:
      "TH1" — real GPS coords provided (fallback_used=False)
      "TH2" — province-level fallback (fallback_used=True, level=PROVINCE)
      "TH3" — district/ward fallback (fallback_used=True, level=DISTRICT|WARD)
      None  — no spatial context, text-only query
    """
    if not use_postgis or "spatial_params" not in query_params:
        return None

    sp = query_params["spatial_params"]
    fallback_used = sp.get("fallback_used", False)
    location_level = sp.get("location_level")  # PROVINCE / DISTRICT / WARD / None

    if not fallback_used:
        return "TH1"  # Real GPS — full ST_DWithin, no admin boundary

    if location_level == "PROVINCE":
        return "TH2"  # Province fallback — admin boundary only, no radius query

    # DISTRICT, WARD, or unknown with fallback → district-level radius query
    return "TH3"


def _row_to_candidate(row, has_distance_col: bool) -> ServiceCandidate:
    """Map a DB row to ServiceCandidate (ServiceDetail format)."""
    if has_distance_col:
        (
            pid, name, slug, base_price, sale_price, ptype, vendor,
            created_at, cat_name, duration, image_url, partner_brand,
            dist_name, prov_name, rating, confidence, distance_m
        ) = row
    else:
        (
            pid, name, slug, base_price, sale_price, ptype, vendor,
            created_at, cat_name, duration, image_url, partner_brand,
            dist_name, prov_name, rating, confidence
        ) = row
        distance_m = None

    final_price = sale_price if sale_price is not None else base_price

    return ServiceCandidate(
        service_id=str(pid),
        name=name,
        image_url=image_url,
        badge=None,
        booked_count=None,
        price=PriceInfo(amount=int(final_price), currency="VND") if final_price else None,
        staff_name=vendor or partner_brand or "Healytics Partner",
        rating=RatingInfo(average=round(float(rating), 1) if rating else 0.0, total_reviews=0),
        location=LocationInfo(
            address="",
            district=dist_name or "",
            city=prov_name or "",
        ),
        slots=[],
        confidence=round(float(confidence), 4) if confidence is not None else 0.0,
        distance_meters=float(distance_m) if distance_m is not None else None,
    )
