"""
ai_services/ner-service/app/ner/cache.py

In-memory cache with TTL for Location and Category lookups.
Loads all data at startup; refreshes automatically when TTL expires.
Supports force_refresh() via /internal/clear-cache endpoint.
"""

import logging
import time
from typing import Optional

import httpx

from app.core.config import settings

logger = logging.getLogger(__name__)


# ============================================================================
# Province Data — Hardcode 63 tỉnh/thành phố + aliases (cấp PROVINCE)
# Dùng administrative code theo chuẩn của backend location table.
# District/Ward sẽ được load từ backend API vào RAM cache.
# ============================================================================
PROVINCE_MAP: dict[str, dict] = {
    # --- Miền Bắc ---
    "hà nội": {"code": "01", "level": "PROVINCE"},
    "hn": {"code": "01", "level": "PROVINCE"},
    "hà giang": {"code": "02", "level": "PROVINCE"},
    "cao bằng": {"code": "04", "level": "PROVINCE"},
    "bắc kạn": {"code": "06", "level": "PROVINCE"},
    "tuyên quang": {"code": "08", "level": "PROVINCE"},
    "lào cai": {"code": "10", "level": "PROVINCE"},
    "điện biên": {"code": "11", "level": "PROVINCE"},
    "lai châu": {"code": "12", "level": "PROVINCE"},
    "sơn la": {"code": "14", "level": "PROVINCE"},
    "yên bái": {"code": "15", "level": "PROVINCE"},
    "hòa bình": {"code": "17", "level": "PROVINCE"},
    "thái nguyên": {"code": "19", "level": "PROVINCE"},
    "lạng sơn": {"code": "20", "level": "PROVINCE"},
    "quảng ninh": {"code": "22", "level": "PROVINCE"},
    "bắc giang": {"code": "24", "level": "PROVINCE"},
    "phú thọ": {"code": "25", "level": "PROVINCE"},
    "vĩnh phúc": {"code": "26", "level": "PROVINCE"},
    "bắc ninh": {"code": "27", "level": "PROVINCE"},
    "hải dương": {"code": "30", "level": "PROVINCE"},
    "hải phòng": {"code": "31", "level": "PROVINCE"},
    "hp": {"code": "31", "level": "PROVINCE"},
    "hưng yên": {"code": "33", "level": "PROVINCE"},
    "thái bình": {"code": "34", "level": "PROVINCE"},
    "hà nam": {"code": "35", "level": "PROVINCE"},
    "nam định": {"code": "36", "level": "PROVINCE"},
    "ninh bình": {"code": "37", "level": "PROVINCE"},
    # --- Miền Trung ---
    "thanh hóa": {"code": "38", "level": "PROVINCE"},
    "nghệ an": {"code": "40", "level": "PROVINCE"},
    "hà tĩnh": {"code": "42", "level": "PROVINCE"},
    "quảng bình": {"code": "44", "level": "PROVINCE"},
    "quảng trị": {"code": "45", "level": "PROVINCE"},
    "thừa thiên huế": {"code": "46", "level": "PROVINCE"},
    "huế": {"code": "46", "level": "PROVINCE"},
    "đà nẵng": {"code": "48", "level": "PROVINCE"},
    "đn": {"code": "48", "level": "PROVINCE"},
    "quảng nam": {"code": "49", "level": "PROVINCE"},
    "quảng ngãi": {"code": "51", "level": "PROVINCE"},
    "bình định": {"code": "52", "level": "PROVINCE"},
    "phú yên": {"code": "54", "level": "PROVINCE"},
    "khánh hòa": {"code": "56", "level": "PROVINCE"},
    "nha trang": {"code": "56", "level": "PROVINCE"},
    "ninh thuận": {"code": "58", "level": "PROVINCE"},
    "bình thuận": {"code": "60", "level": "PROVINCE"},
    # --- Tây Nguyên ---
    "kon tum": {"code": "62", "level": "PROVINCE"},
    "gia lai": {"code": "64", "level": "PROVINCE"},
    "đắk lắk": {"code": "66", "level": "PROVINCE"},
    "đắk nông": {"code": "67", "level": "PROVINCE"},
    "lâm đồng": {"code": "68", "level": "PROVINCE"},
    "đà lạt": {"code": "68", "level": "PROVINCE"},
    # --- Miền Nam ---
    "hồ chí minh": {"code": "79", "level": "PROVINCE"},
    "hcm": {"code": "79", "level": "PROVINCE"},
    "tp hcm": {"code": "79", "level": "PROVINCE"},
    "tp.hcm": {"code": "79", "level": "PROVINCE"},
    "sài gòn": {"code": "79", "level": "PROVINCE"},
    "sg": {"code": "79", "level": "PROVINCE"},
    "bình phước": {"code": "70", "level": "PROVINCE"},
    "tây ninh": {"code": "72", "level": "PROVINCE"},
    "bình dương": {"code": "74", "level": "PROVINCE"},
    "đồng nai": {"code": "75", "level": "PROVINCE"},
    "bà rịa - vũng tàu": {"code": "77", "level": "PROVINCE"},
    "bà rịa vũng tàu": {"code": "77", "level": "PROVINCE"},
    "vũng tàu": {"code": "77", "level": "PROVINCE"},
    "long an": {"code": "80", "level": "PROVINCE"},
    "tiền giang": {"code": "82", "level": "PROVINCE"},
    "bến tre": {"code": "83", "level": "PROVINCE"},
    "trà vinh": {"code": "84", "level": "PROVINCE"},
    "vĩnh long": {"code": "86", "level": "PROVINCE"},
    "đồng tháp": {"code": "87", "level": "PROVINCE"},
    "an giang": {"code": "89", "level": "PROVINCE"},
    "kiên giang": {"code": "91", "level": "PROVINCE"},
    "phú quốc": {"code": "91", "level": "PROVINCE"},
    "cần thơ": {"code": "92", "level": "PROVINCE"},
    "hậu giang": {"code": "93", "level": "PROVINCE"},
    "sóc trăng": {"code": "94", "level": "PROVINCE"},
    "bạc liêu": {"code": "95", "level": "PROVINCE"},
    "cà mau": {"code": "96", "level": "PROVINCE"},
}


# ============================================================================
# Dynamic Cache — District/Ward từ backend
# ============================================================================
_district_ward_cache: dict[str, dict] = {}
_district_ward_loaded_at: float = 0.0

# ============================================================================
# Dynamic Cache — Categories từ backend
# ============================================================================
_category_cache: list[dict] = []        # [{"slug": "yoga-therapy", "name": "Yoga trị liệu"}]
_category_loaded_at: float = 0.0


# ============================================================================
# PUBLIC API
# ============================================================================

def find_location(text: str) -> Optional[dict]:
    """
    Tra cứu location từ text.
    1. Thử PROVINCE_MAP (hardcoded, O(1))
    2. Thử district/ward cache (from backend)
    Returns dict {"code": ..., "level": ...} or None.
    """
    key = text.strip().lower()

    # 1. Province (instant)
    if key in PROVINCE_MAP:
        return PROVINCE_MAP[key]

    # 2. District/Ward cache
    _maybe_refresh_district_ward()
    if key in _district_ward_cache:
        return _district_ward_cache[key]

    return None


def get_category_list() -> list[dict]:
    """Trả về danh sách categories hiện tại cho fuzzy matching."""
    _maybe_refresh_categories()
    return _category_cache


def force_refresh() -> dict:
    """Force reload all caches. Gọi từ /internal/clear-cache."""
    d_count = 0
    c_count = 0

    try:
        d_count = _load_district_ward_from_backend()
    except Exception as e:
        logger.warning(f"[Cache] Force refresh district/ward failed: {e}")

    try:
        c_count = _load_categories_from_backend()
    except Exception as e:
        logger.warning(f"[Cache] Force refresh categories failed: {e}")

    return {
        "district_ward_entries": d_count,
        "category_entries": c_count,
    }


async def startup_load():
    """Load caches lúc app startup. Non-blocking nếu backend chưa sẵn sàng."""
    logger.info("[Cache] Loading location + category caches at startup...")
    try:
        _load_district_ward_from_backend()
    except Exception as e:
        logger.warning(f"[Cache] Failed to load district/ward cache: {e}")

    try:
        _load_categories_from_backend()
    except Exception as e:
        logger.warning(f"[Cache] Failed to load category cache: {e}")

    logger.info(
        f"[Cache] Loaded {len(_district_ward_cache)} district/ward entries, "
        f"{len(_category_cache)} categories"
    )


# ============================================================================
# PRIVATE — Refresh logic
# ============================================================================

def _maybe_refresh_district_ward():
    global _district_ward_loaded_at
    if time.time() - _district_ward_loaded_at > settings.LOCATION_CACHE_TTL:
        try:
            _load_district_ward_from_backend()
        except Exception as e:
            logger.warning(f"[Cache] District/ward refresh failed, keeping stale: {e}")


def _maybe_refresh_categories():
    global _category_loaded_at
    if time.time() - _category_loaded_at > settings.CATEGORY_CACHE_TTL:
        try:
            _load_categories_from_backend()
        except Exception as e:
            logger.warning(f"[Cache] Category refresh failed, keeping stale: {e}")


def _load_district_ward_from_backend() -> int:
    """
    Load district + ward từ backend API vào RAM cache.
    Endpoint mong đợi: GET {BACKEND_API_URL}/locations?level=DISTRICT,WARD
    Trả về list: [{"code": "001", "name": "Ba Đình", "level": "DISTRICT", "codeName": "ba dinh"}]

    Nếu backend chưa có endpoint này, cache rỗng (chỉ dùng PROVINCE_MAP).
    """
    global _district_ward_cache, _district_ward_loaded_at

    try:
        with httpx.Client(timeout=10.0) as client:
            response = client.get(
                f"{settings.BACKEND_API_URL}/locations",
                params={"level": "DISTRICT,WARD"},
            )
            response.raise_for_status()
            data = response.json()
    except Exception:
        # Backend chưa sẵn sàng → giữ cache cũ
        _district_ward_loaded_at = time.time()
        raise

    new_cache: dict[str, dict] = {}
    for item in data:
        name = item.get("name", "").strip().lower()
        code_name = item.get("codeName", "").strip().lower()
        code = item.get("code", "")
        level = item.get("level", "DISTRICT")
        entry = {"code": code, "level": level}

        if name:
            new_cache[name] = entry
        if code_name and code_name != name:
            new_cache[code_name] = entry

    _district_ward_cache = new_cache
    _district_ward_loaded_at = time.time()
    return len(new_cache)


def _load_categories_from_backend() -> int:
    """
    Load categories từ backend API vào RAM cache.
    Endpoint mong đợi: GET {BACKEND_API_URL}/categories?isActive=true
    Trả về list: [{"slug": "yoga-therapy", "name": "Yoga trị liệu"}]

    Nếu backend chưa có endpoint này, cache rỗng.
    """
    global _category_cache, _category_loaded_at

    try:
        with httpx.Client(timeout=10.0) as client:
            response = client.get(
                f"{settings.BACKEND_API_URL}/categories",
                params={"isActive": "true"},
            )
            response.raise_for_status()
            data = response.json()
    except Exception:
        _category_loaded_at = time.time()
        raise

    _category_cache = [
        {"slug": item.get("slug", ""), "name": item.get("name", "")}
        for item in data
        if item.get("slug") and item.get("name")
    ]
    _category_loaded_at = time.time()
    return len(_category_cache)
