"""
ai_services/ner-service/app/utils/db_fetcher.py

Fetch service candidates from PostgreSQL with 3-case spatial routing:

  TH1 — Có GPS thật (fallback_used=False):
    - ST_DWithin(user_coords, radius) — vẽ vòng tròn bất chấp ranh giới hành chính
    - ORDER BY distance_meters ASC, avg_rating DESC
    - Không áp locationCode (GPS đã đủ chính xác)

  TH2 — Fallback Province (fallback_used=True, level=PROVINCE):
    - Không dùng ST_DWithin (quét domain quá lớn, tâm tỉnh không đại diện được)
    - Áp ranh giới hành chính: loc_p.code = :loc_code
    - ORDER BY avg_rating DESC

  TH3 — Fallback District/Ward (fallback_used=True, level=DISTRICT/WARD):
    - ST_DWithin(district_center, radius) — cho phép vượt ranh giới quận
    - Không áp loc_d.code (mở rộng sang quận giáp ranh)
    - ORDER BY distance_meters ASC, avg_rating DESC

  Không có spatial:
    - Text-only query + optional filters
    - ORDER BY p.created_at DESC
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

_SELECT_DISTANCE = """,
        ST_Distance(
            hpp.location,
            ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography
        ) AS distance_meters"""

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
    has_distance_col = spatial_case in ("TH1", "TH3")

    select_sql = _SELECT_BASE + (_SELECT_DISTANCE if has_distance_col else "")
    sql = select_sql + _FROM_JOINS

    if spatial_case in ("TH1", "TH3"):
        sql += _WHERE_LOCATION_NOT_NULL

    conditions: list[str] = []
    params: Dict[str, Any] = {}

    # ── Spatial WHERE conditions ───────────────────────────────────────────────
    if spatial_case in ("TH1", "TH3"):
        sp = query_params["spatial_params"]
        params["center_lat"] = sp["center_lat"]
        params["center_lng"] = sp["center_lng"]
        params["radius_m"] = sp["radius_meters"]
        conditions.append(_ST_DWITHIN.strip())

    # ── Business Type ─────────────────────────────────────────────────────────
    bt = query_params.get("businessType")
    if bt:
        conditions.append(":bt = ANY(string_to_array(hpp.business_type, ','))")
        params["bt"] = bt

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

    # ── Category ──────────────────────────────────────────────────────────────
    # Hard AND — category PHẢI match (dù detect bởi NER hay semantic fallback).
    # Logic: businessType=X AND c.slug=Y AND (tag_A OR tag_B)
    cat_slug = query_params.get("categorySlug")
    if cat_slug:
        conditions.append("c.slug = :cat_slug")
        params["cat_slug"] = cat_slug

    # ── Price ─────────────────────────────────────────────────────────────────
    min_p = query_params.get("minPrice")
    max_p = query_params.get("maxPrice")
    if min_p is not None:
        conditions.append("COALESCE(p.sale_price, p.base_price) >= :min_p")
        params["min_p"] = min_p
    if max_p is not None:
        conditions.append("COALESCE(p.sale_price, p.base_price) <= :max_p")
        params["max_p"] = max_p

    # ── Rating ────────────────────────────────────────────────────────────────
    min_r = query_params.get("minRating")
    if min_r is not None:
        conditions.append(
            "(SELECT AVG(rating) FROM product_reviews WHERE product_id = p.id) >= :min_r"
        )
        params["min_r"] = min_r

    # ── Feature Tag Filters ────────────────────────────────────────────────────
    # tagFilters: [{ids:[...], op:"OR"}, {ids:[...], op:"AND"}, {ids:[...], op:"NOT"}, ...]
    #   OR group  → EXISTS (...tag_id IN (:t0, :t1))  — product cần ít nhất 1 tag trong list
    #   AND group → EXISTS (...tag_id = :t) per tag   — product phải có TẤT CẢ tags
    #   NOT group → NOT EXISTS (...tag_id IN (...))   — product KHÔNG được chứa các tags này
    # Tất cả groups được AND nhau trong WHERE:
    #   WHERE ... AND c.slug=:cat AND (EXISTS tag_A OR EXISTS tag_B) AND EXISTS tag_C
    tag_filters = query_params.get("tagFilters", [])
    for i, tf in enumerate(tag_filters):
        op   = tf.get("op", "OR")
        tids = tf.get("ids", [])
        if not tids:
            continue
        if op == "OR":
            placeholders = ", ".join(f":tf_{i}_{j}" for j in range(len(tids)))
            conditions.append(
                f"EXISTS (SELECT 1 FROM product_tags pt "
                f"WHERE pt.product_id = p.id AND pt.tag_id::text IN ({placeholders}))"
            )
            for j, tid in enumerate(tids):
                params[f"tf_{i}_{j}"] = tid
        elif op == "NOT":
            placeholders = ", ".join(f":tf_{i}_{j}" for j in range(len(tids)))
            conditions.append(
                f"NOT EXISTS (SELECT 1 FROM product_tags pt "
                f"WHERE pt.product_id = p.id AND pt.tag_id::text IN ({placeholders}))"
            )
            for j, tid in enumerate(tids):
                params[f"tf_{i}_{j}"] = tid
        else:  # AND — một EXISTS cho mỗi tag
            for j, tid in enumerate(tids):
                pkey = f"tf_{i}_{j}"
                conditions.append(
                    f"EXISTS (SELECT 1 FROM product_tags pt "
                    f"WHERE pt.product_id = p.id AND pt.tag_id::text = :{pkey})"
                )
                params[pkey] = tid

    if conditions:
        sql += " AND " + " AND ".join(conditions)

    # ── ORDER BY ──────────────────────────────────────────────────────────────
    if spatial_case in ("TH1", "TH3"):
        sql += " ORDER BY distance_meters ASC, avg_rating DESC"
    elif spatial_case == "TH2":
        sql += " ORDER BY avg_rating DESC"
    else:
        sql += " ORDER BY p.created_at DESC"

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
    # Keep businessType as strongest signal; relax category/location gradually.
    if not candidates and db_error is None and spatial_case is None:
        bt = query_params.get("businessType")
        cat_slug = query_params.get("categorySlug")
        loc_code = query_params.get("locationCode")
        tag_filters = query_params.get("tagFilters")

        relax_plans: list[tuple[str, Dict[str, Any]]] = []
        if bt and cat_slug:
            relax_plans.append(("drop_category", {**query_params, "categorySlug": None}))
        if bt and loc_code:
            relax_plans.append(("drop_location", {**query_params, "locationCode": None}))
        if bt and (cat_slug or loc_code or tag_filters):
            relax_plans.append((
                "bt_only",
                {
                    **query_params,
                    "categorySlug": None,
                    "locationCode": None,
                    "tagFilters": [],
                },
            ))

        for plan_name, relaxed_params in relax_plans:
            try:
                relaxed_conditions: list[str] = []
                relaxed_bind: Dict[str, Any] = {"limit": limit}

                relaxed_sql = _SELECT_BASE + _FROM_JOINS

                relaxed_bt = relaxed_params.get("businessType")
                if relaxed_bt:
                    relaxed_conditions.append(":bt = ANY(string_to_array(hpp.business_type, ','))")
                    relaxed_bind["bt"] = relaxed_bt

                relaxed_loc = relaxed_params.get("locationCode")
                if relaxed_loc:
                    relaxed_conditions.append("(loc_d.code = :loc_code OR loc_p.code = :loc_code)")
                    relaxed_bind["loc_code"] = relaxed_loc

                relaxed_cat = relaxed_params.get("categorySlug")
                if relaxed_cat:
                    relaxed_conditions.append("c.slug = :cat_slug")
                    relaxed_bind["cat_slug"] = relaxed_cat

                for i, tf in enumerate(relaxed_params.get("tagFilters", [])):
                    op = tf.get("op", "OR")
                    tids = tf.get("ids", [])
                    if not tids:
                        continue
                    if op == "OR":
                        placeholders = ", ".join(f":tf_{i}_{j}" for j in range(len(tids)))
                        relaxed_conditions.append(
                            f"EXISTS (SELECT 1 FROM product_tags pt "
                            f"WHERE pt.product_id = p.id AND pt.tag_id::text IN ({placeholders}))"
                        )
                        for j, tid in enumerate(tids):
                            relaxed_bind[f"tf_{i}_{j}"] = tid
                    else:
                        for j, tid in enumerate(tids):
                            pkey = f"tf_{i}_{j}"
                            relaxed_conditions.append(
                                f"EXISTS (SELECT 1 FROM product_tags pt "
                                f"WHERE pt.product_id = p.id AND pt.tag_id::text = :{pkey})"
                            )
                            relaxed_bind[pkey] = tid

                if relaxed_conditions:
                    relaxed_sql += " AND " + " AND ".join(relaxed_conditions)
                relaxed_sql += " ORDER BY p.created_at DESC LIMIT :limit"

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

    # ── Mock fallback khi DB lỗi hoặc chưa có data ────────────────────────────
    if not candidates:
        from app.utils.query_builder import filter_mock_services
        reason = f"DB error: {db_error}" if db_error else "DB returned empty — using mock"
        logger.warning(f"[DBFetcher] Falling back to mock services. Reason: {reason}")

        mock_results = filter_mock_services(query_params)
        for svc in mock_results:
            internal = svc.get("_internal", {})
            base_price = internal.get("basePrice")
            rating_val = internal.get("ratingValue", 0.0)
            total_reviews = internal.get("totalReviews", 0)
            loc = svc.get("location", {})

            candidates.append(ServiceCandidate(
                service_id=svc["service_id"],
                name=svc["name"],
                image_url=svc.get("image_url"),
                badge=svc.get("badge"),
                booked_count=svc.get("booked_count"),
                price=PriceInfo(amount=int(base_price), currency="VND") if base_price else None,
                staff_name=svc.get("staff_name"),
                rating=RatingInfo(average=float(rating_val), total_reviews=total_reviews),
                location=LocationInfo(
                    address=loc.get("address", ""),
                    district=loc.get("district", ""),
                    city=loc.get("city", ""),
                ),
                slots=svc.get("slots", []),
                distance_meters=None,
            ))

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
            dist_name, prov_name, rating, distance_m
        ) = row
    else:
        (
            pid, name, slug, base_price, sale_price, ptype, vendor,
            created_at, cat_name, duration, image_url, partner_brand,
            dist_name, prov_name, rating
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
        distance_meters=float(distance_m) if distance_m is not None else None,
    )
