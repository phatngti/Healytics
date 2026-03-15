"""
PostGIS query builder for spatial distance queries.

Converts query parameters with spatial context → SQL for health_partner_profile
with distance filtering and sorting.
"""

import logging
from typing import Dict, Any, Tuple, Optional

logger = logging.getLogger(__name__)


# ============================================================================
# PostGIS SQL Utilities
# ============================================================================

def st_make_point_geography(lng: float, lat: float) -> str:
    """Generate PostGIS point geography expression."""
    return f"ST_SetSRID(ST_MakePoint({lng}, {lat}), 4326)::geography"


def st_dwithin_clause(center_lng: float, center_lat: float, radius_m: int) -> str:
    """Generate ST_DWithin WHERE clause for distance filtering."""
    point_expr = st_make_point_geography(center_lng, center_lat)
    return f"ST_DWithin(hpp.location, {point_expr}, {radius_m})"


def st_distance_expression(center_lng: float, center_lat: float) -> str:
    """Generate ST_Distance SELECT expression for distance calculation."""
    point_expr = st_make_point_geography(center_lng, center_lat)
    return f"ST_Distance(hpp.location, {point_expr}) as distance_meters"


def distance_order_by(center_lng: float, center_lat: float, with_rating_tiebreaker: bool = True) -> str:
    """Generate ORDER BY clause for distance-based sorting."""
    if with_rating_tiebreaker:
        return f"ORDER BY distance_meters ASC, COALESCE(avg_rating, 0) DESC"
    else:
        return "ORDER BY distance_meters ASC"


# ============================================================================
# Build PostGIS Query Dict
# ============================================================================

def build_postgis_query(
    entities: list,
    spatial_context: Optional[Any] = None,
    limit: int = 50
) -> Dict[str, Any]:
    """
    Convert entities + spatial context → query dict with PostGIS parameters.

    Returns dict with:
      - use_postgis: bool (True if spatial filtering needed)
      - spatial_params: {center_lat, center_lng, radius_meters}
      - distance_sort: bool (True if sorting by distance)
      - Traditional filters (businessType, categorySlug, etc.)
    """

    query = {
        "limit": limit,
        "use_postgis": False,
        "distance_sort": False,
    }

    # If no spatial context, return basic query
    if not spatial_context:
        return query

    # Add spatial parameters
    query["spatial_params"] = {
        "center_lat": spatial_context.center_lat,
        "center_lng": spatial_context.center_lng,
        "radius_meters": spatial_context.radius_meters,
    }
    query["use_postgis"] = True
    query["distance_sort"] = True
    query["fallback_used"] = spatial_context.fallback_used

    logger.info(
        f"[PostGISBuilder] Building spatial query: "
        f"center=({spatial_context.center_lat}, {spatial_context.center_lng}), "
        f"radius={spatial_context.radius_meters}m"
    )

    return query


# ============================================================================
# Build PostGIS SQL
# ============================================================================

def build_postgis_sql(query_dict: Dict[str, Any]) -> Tuple[str, Dict[str, Any]]:
    """
    Convert query dict → SQL + params for health_partner_profile PostGIS query.

    Returns: (sql_string, sql_params_dict)
    """

    if not query_dict.get("use_postgis") or "spatial_params" not in query_dict:
        raise ValueError("Query dict must contain spatial_params for PostGIS query")

    spatial_params = query_dict["spatial_params"]
    center_lat = spatial_params["center_lat"]
    center_lng = spatial_params["center_lng"]
    radius_m = spatial_params["radius_meters"]
    limit = query_dict.get("limit", 50)

    # Base SQL with all necessary JOINs
    sql_parts = [
        """
        SELECT DISTINCT
            p.id,
            p.name,
            p.slug,
            p.base_price,
            p.sale_price,
            p.type,
            p.vendor_name,
            c.name as category_name,
            pd.duration_minutes,
            pm.url as image_url,
            hpp.brand_name as partner_brand,
            loc_d.full_name as district_name,
            loc_p.full_name as province_name,
            COALESCE(
                (SELECT AVG(pr.rating) FROM product_reviews pr WHERE pr.product_id = p.id),
                0
            ) as avg_rating,
            ST_Distance(
                hpp.location,
                ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography
            ) as distance_meters
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN product_definitions pd ON p.id = pd.product_id
        LEFT JOIN product_media pm ON p.id = pm.product_id AND pm.is_thumbnail = true
        LEFT JOIN product_employee_eligibility pee ON p.id = pee.product_id
        LEFT JOIN employees e ON pee.employee_id = e.id
        LEFT JOIN health_partner_profile hpp ON e.partner_id = hpp.id
        LEFT JOIN location loc_d ON hpp.district_id = loc_d.id
        LEFT JOIN location loc_p ON hpp.province_id = loc_p.id
        WHERE p.status = 'ACTIVE' AND p.is_visible_online = true
            AND hpp.location IS NOT NULL
            AND ST_DWithin(
                hpp.location,
                ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography,
                :radius_m
            )
        """
    ]

    # Add traditional filters if present
    if "businessType" in query_dict:
        sql_parts.append("AND :businessType = ANY(string_to_array(hpp.business_type, ','))")

    if "categorySlug" in query_dict:
        sql_parts.append("AND c.slug = :categorySlug")

    if "minPrice" in query_dict:
        sql_parts.append("AND COALESCE(p.sale_price, p.base_price) >= :minPrice")

    if "maxPrice" in query_dict:
        sql_parts.append("AND COALESCE(p.sale_price, p.base_price) <= :maxPrice")

    if "minRating" in query_dict:
        sql_parts.append("""
            AND (
                SELECT AVG(pr.rating) FROM product_reviews pr WHERE pr.product_id = p.id
            ) >= :minRating
        """)

    # Use <-> (KNN) operator: leverages GiST index for efficient ordering,
    # avoids computing ST_Distance on all rows before sorting
    sql_parts.append(
        "ORDER BY hpp.location <-> ST_SetSRID(ST_MakePoint(:center_lng, :center_lat), 4326)::geography ASC, avg_rating DESC"
    )
    sql_parts.append("LIMIT :limit")
    params["limit"] = limit

    sql = " ".join(sql_parts)

    # Build parameters dict
    params = {
        "center_lat": center_lat,
        "center_lng": center_lng,
        "radius_m": radius_m,
    }

    # Add traditional filter params
    if "businessType" in query_dict:
        params["businessType"] = f"%{query_dict['businessType']}%"
    if "categorySlug" in query_dict:
        params["categorySlug"] = query_dict["categorySlug"]
    if "minPrice" in query_dict:
        params["minPrice"] = query_dict["minPrice"]
    if "maxPrice" in query_dict:
        params["maxPrice"] = query_dict["maxPrice"]
    if "minRating" in query_dict:
        params["minRating"] = query_dict["minRating"]

    logger.info(f"[PostGISBuilder] Generated SQL with {len(params)} parameters")

    return sql, params


# ============================================================================
# Fallback Distance Calculation (Haversine)
# ============================================================================

def calculate_distance_meters(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """
    Calculate distance between two points using Haversine formula.

    Returns distance in meters.
    Used as fallback if PostGIS fails.
    """

    import math

    R = 6371000  # Earth radius in meters

    lat1_rad = math.radians(lat1)
    lat2_rad = math.radians(lat2)
    delta_lat = math.radians(lat2 - lat1)
    delta_lng = math.radians(lng2 - lng1)

    a = math.sin(delta_lat / 2) ** 2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(delta_lng / 2) ** 2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    distance = R * c
    return distance
