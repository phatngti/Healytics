"""
Spatial context resolution and fallback logic for NER service.

Handles:
  1. Determining center point for spatial queries
  2. Fallback logic when spatial context is incomplete
  3. Resolving registered addresses to coordinates
"""

import logging
from typing import Optional, Tuple, List
from dataclasses import dataclass

from app.schemas.ner_schema import NerEntity
from app.ner.cache import PROVINCE_MAP, to_canonical  # reuse cache's canonical function
from app.core.config import settings

logger = logging.getLogger(__name__)


# ============================================================================
# SpatialContext Dataclass
# ============================================================================

@dataclass
class SpatialContext:
    """Resolved spatial context for queries."""

    center_lat: float
    center_lng: float
    radius_meters: int
    fallback_used: bool = False       # True if coordinates came from fallback (registered_address or location_code)
    location_level: Optional[str] = None  # PROVINCE / DISTRICT / WARD — set when fallback_used=True


# ============================================================================
# Spatial Context Resolution
# ============================================================================

def resolve_spatial_context(
    entities: List[NerEntity],
    current_lat: Optional[float],
    current_lng: Optional[float],
    user_registered_address: Optional[str],
) -> Optional[SpatialContext]:
    """
    Determine center point and radius for spatial query.

    Priority logic:
      1. If DISTANCE entity exists + current_lat/lng provided → use provided coordinates
      2. If DISTANCE entity exists + NO coordinates → try user_registered_address
      3. If DISTANCE entity exists + NO address → try LOCATION entity's location_code
      4. Else → return None (no spatial context)

    Returns: SpatialContext object or None
    """

    # Check if any DISTANCE entity exists
    distance_entity = next((e for e in entities if e.type == "DISTANCE"), None)
    if not distance_entity:
        logger.info("[SpatialContext] No DISTANCE entity found, no spatial context")
        return None

    radius_meters = distance_entity.radius_meters or settings.DEFAULT_PROXIMITY_RADIUS_M

    # Priority 1: Use provided current coordinates (real GPS — no boundary restriction)
    if current_lat is not None and current_lng is not None:
        logger.info(f"[SpatialContext] Using provided coordinates: ({current_lat}, {current_lng})")
        return SpatialContext(
            center_lat=current_lat,
            center_lng=current_lng,
            radius_meters=radius_meters,
            fallback_used=False,
            location_level=None,  # TH1: GPS — boundary logic not needed
        )

    # Priority 2: Try registered address
    if user_registered_address:
        resolved = resolve_registered_address(user_registered_address)
        if resolved:
            lat, lng = resolved
            logger.info(f"[SpatialContext] Resolved registered address: ({lat}, {lng})")
            return SpatialContext(
                center_lat=lat,
                center_lng=lng,
                radius_meters=radius_meters,
                fallback_used=True,
                location_level="PROVINCE",  # Registered address resolves to province center
            )

    # Priority 3: Try LOCATION entity (district/province center)
    location_entity = next((e for e in entities if e.type == "LOCATION"), None)
    if location_entity and location_entity.location_code:
        resolved = resolve_location_code_to_coordinates(location_entity.location_code)
        if resolved:
            lat, lng = resolved
            level = location_entity.location_level or "PROVINCE"
            logger.info(f"[SpatialContext] Resolved location_code {location_entity.location_code} ({level}): ({lat}, {lng})")
            return SpatialContext(
                center_lat=lat,
                center_lng=lng,
                radius_meters=radius_meters,
                fallback_used=True,
                location_level=level,  # TH2=PROVINCE, TH3=DISTRICT/WARD
            )

    logger.info("[SpatialContext] Could not resolve spatial context, falling back to text-only query")
    return None


# ============================================================================
# Address Resolution Helpers
# ============================================================================

def resolve_registered_address(address: str) -> Optional[Tuple[float, float]]:
    """Resolve address string → (lat, lng) using cache's to_canonical for matching."""
    if not address:
        return None

    canonical_address = to_canonical(address)

    for province_name, province_info in PROVINCE_MAP.items():
        if to_canonical(province_name) == canonical_address:
            coords = _get_province_center_coordinates(province_info.get("code", ""))
            if coords:
                return coords

    logger.warning(f"[SpatialContext] Could not resolve address: {address}")
    return None


def resolve_location_code_to_coordinates(location_code: str) -> Optional[Tuple[float, float]]:
    """Resolve province code → (lat, lng) center coordinates."""
    if not location_code:
        return None

    coords = _get_province_center_coordinates(location_code)
    if coords:
        return coords

    logger.warning(f"[SpatialContext] No center coords for location_code: {location_code}")
    return None


# ============================================================================
# Helper Functions
# ============================================================================

def _get_province_center_coordinates(province_code: str) -> Optional[Tuple[float, float]]:
    """Approximate center coordinates for Vietnam provinces (WGS84 lat, lng)."""
    PROVINCE_CENTERS: dict[str, Tuple[float, float]] = {
        # Miền Bắc
        "01": (21.0285, 105.8542),  # Hà Nội
        "02": (22.8026, 104.9784),  # Hà Giang
        "04": (22.6657, 106.2522),  # Cao Bằng
        "06": (22.1473, 105.8348),  # Bắc Kạn
        "08": (21.8231, 105.2140),  # Tuyên Quang
        "10": (22.4810, 103.9753),  # Lào Cai
        "11": (21.3860, 103.0233),  # Điện Biên
        "12": (22.3964, 103.4580),  # Lai Châu
        "14": (21.3274, 103.9144),  # Sơn La
        "15": (21.7229, 104.9113),  # Yên Bái
        "17": (20.8135, 105.3383),  # Hòa Bình
        "19": (21.5942, 105.8482),  # Thái Nguyên
        "20": (21.8537, 106.7615),  # Lạng Sơn
        "22": (21.0064, 107.2925),  # Quảng Ninh
        "24": (21.2820, 106.1975),  # Bắc Giang
        "25": (21.3450, 105.2378),  # Phú Thọ
        "26": (21.3608, 105.5474),  # Vĩnh Phúc
        "27": (21.1861, 106.0763),  # Bắc Ninh
        "30": (20.9373, 106.3306),  # Hải Dương
        "31": (20.8449, 106.6881),  # Hải Phòng
        "33": (20.6464, 106.0508),  # Hưng Yên
        "34": (20.4463, 106.3365),  # Thái Bình
        "35": (20.5835, 105.9230),  # Hà Nam
        "36": (20.4338, 106.1621),  # Nam Định
        "37": (20.2539, 105.9745),  # Ninh Bình
        # Miền Trung
        "38": (19.8077, 105.7764),  # Thanh Hóa
        "40": (18.6717, 105.6924),  # Nghệ An
        "42": (18.3559, 105.8877),  # Hà Tĩnh
        "44": (17.4816, 106.5988),  # Quảng Bình
        "45": (16.7943, 107.1020),  # Quảng Trị
        "46": (16.4637, 107.5909),  # Thừa Thiên Huế
        "48": (16.0544, 108.2022),  # Đà Nẵng
        "49": (15.5393, 108.0191),  # Quảng Nam  ← code 49 = Quảng Nam (not Bình Định)
        "51": (15.1213, 108.8048),  # Quảng Ngãi
        "52": (13.7765, 109.2233),  # Bình Định
        "54": (13.0882, 109.0929),  # Phú Yên
        "56": (12.2381, 109.1967),  # Khánh Hòa (Nha Trang)
        "58": (11.5646, 108.9882),  # Ninh Thuận
        "60": (10.9282, 108.1119),  # Bình Thuận
        # Tây Nguyên
        "62": (14.3497, 107.9975),  # Kon Tum
        "64": (13.9749, 108.2378),  # Gia Lai
        "66": (12.6600, 108.0500),  # Đắk Lắk
        "67": (12.0046, 107.6876),  # Đắk Nông
        "68": (11.9230, 108.4420),  # Lâm Đồng
        # Miền Nam
        "70": (11.7511, 106.7234),  # Bình Phước
        "72": (11.3102, 106.0986),  # Tây Ninh
        "74": (11.3254, 106.4770),  # Bình Dương
        "75": (10.9452, 107.1689),  # Đồng Nai
        "77": (10.5417, 107.2429),  # Bà Rịa - Vũng Tàu
        "79": (10.7769, 106.7009),  # TP. Hồ Chí Minh
        "80": (10.5354, 106.4120),  # Long An
        "82": (10.3600, 106.3523),  # Tiền Giang
        "83": (10.2417, 106.3756),  # Bến Tre
        "84": (9.9347, 106.3452),   # Trà Vinh
        "86": (10.2560, 105.9722),  # Vĩnh Long
        "87": (10.4933, 105.6882),  # Đồng Tháp
        "89": (10.3897, 105.4356),  # An Giang
        "91": (10.0046, 105.0809),  # Kiên Giang
        "92": (10.0341, 105.7880),  # Cần Thơ
        "93": (9.7579,  105.6413),  # Hậu Giang
        "94": (9.6026,  105.9739),  # Sóc Trăng
        "95": (9.2840,  105.7278),  # Bạc Liêu
        "96": (9.1769,  105.1524),  # Cà Mau
    }
    return PROVINCE_CENTERS.get(province_code)
