"""
ai_services/ner-service/app/ner/cache.py

In-memory cache with TTL for Location and Category lookups.
Loads all data at startup; refreshes automatically when TTL expires.
Supports force_refresh() via /internal/clear-cache endpoint.
"""

import logging
import time
from typing import Optional

from app.core.config import settings

logger = logging.getLogger(__name__)


# ============================================================================
# Hardcoded fallback list in case backend is unreachable so NER still works
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
    "tphcm": {"code": "79", "level": "PROVINCE"},
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

_DISTRICT_FALLBACK: dict[str, dict] = {
    "cầu giấy": {"code": "005", "level": "DISTRICT"},
    "đống đa": {"code": "006", "level": "DISTRICT"},
    "ba đình": {"code": "001", "level": "DISTRICT"},
    "hai bà trưng": {"code": "007", "level": "DISTRICT"},
    "hoàng mai": {"code": "008", "level": "DISTRICT"},
    "thanh xuân": {"code": "009", "level": "DISTRICT"},
    "tây hồ": {"code": "003", "level": "DISTRICT"},
    "hoàn kiếm": {"code": "002", "level": "DISTRICT"},
    "hà đông": {"code": "017", "level": "DISTRICT"},
    "đông anh": {"code": "017", "level": "DISTRICT"},
    "gian lâm": {"code": "018", "level": "DISTRICT"},
    "nam từ liêm": {"code": "019", "level": "DISTRICT"},
    "bắc từ liêm": {"code": "021", "level": "DISTRICT"},
    "sóc sơn": {"code": "016", "level": "DISTRICT"},
    "quận 1": {"code": "760", "level": "DISTRICT"},
    "q1": {"code": "760", "level": "DISTRICT"},
    "quận 2": {"code": "769", "level": "DISTRICT"},
    "quận 3": {"code": "770", "level": "DISTRICT"},
    "q3": {"code": "770", "level": "DISTRICT"},
    "quận 4": {"code": "771", "level": "DISTRICT"},
    "quận 5": {"code": "772", "level": "DISTRICT"},
    "quận 6": {"code": "773", "level": "DISTRICT"},
    "quận 7": {"code": "774", "level": "DISTRICT"},
    "quận 8": {"code": "775", "level": "DISTRICT"},
    "quận 9": {"code": "763", "level": "DISTRICT"},
    "quận 10": {"code": "776", "level": "DISTRICT"},
    "quận 11": {"code": "777", "level": "DISTRICT"},
    "quận 12": {"code": "761", "level": "DISTRICT"},
    "bình thạnh": {"code": "765", "level": "DISTRICT"},
    "gò vấp": {"code": "764", "level": "DISTRICT"},
    "tân bình": {"code": "766", "level": "DISTRICT"},
    "tân phú": {"code": "767", "level": "DISTRICT"},
    "phú nhuận": {"code": "768", "level": "DISTRICT"},
    "thủ đức": {"code": "762", "level": "DISTRICT"},
    "bình tân": {"code": "778", "level": "DISTRICT"},
    "hóc môn": {"code": "784", "level": "DISTRICT"},
    "nhà bè": {"code": "786", "level": "DISTRICT"},
}


import re
from rapidfuzz import process, fuzz

def remove_accents(s: str) -> str:
    if not s:
        return ""
    s = re.sub(r'[àáạảãâầấậẩẫăằắặẳẵ]', 'a', s)
    s = re.sub(r'[èéẹẻẽêềếệểễ]', 'e', s)
    s = re.sub(r'[ìíịỉĩ]', 'i', s)
    s = re.sub(r'[òóọỏõôồốộổỗơờớợởỡ]', 'o', s)
    s = re.sub(r'[ùúụủũưừứựửữ]', 'u', s)
    s = re.sub(r'[ỳýỵỷỹ]', 'y', s)
    s = re.sub(r'đ', 'd', s)
    s = re.sub(r'[ÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴ]', 'A', s)
    s = re.sub(r'[ÈÉẸẺẼÊỀẾỆỂỄ]', 'E', s)
    s = re.sub(r'[ÌÍỊỈĨ]', 'I', s)
    s = re.sub(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]', 'O', s)
    s = re.sub(r'[ÙÚỤỦŨƯỪỨỰỬỮ]', 'U', s)
    s = re.sub(r'[ỲÝỴỶỸ]', 'Y', s)
    s = re.sub(r'Đ', 'D', s)
    return s

# Globals
_location_cache: dict[str, dict] = {}       # keyword -> {"code": "...", "level": "..."}
_unaccented_location_cache: dict[str, str] = {} # unaccented_key -> original_key
_location_keywords_sorted: tuple[str, ...] = ()
_unaccented_keywords_sorted: tuple[str, ...] = ()

_category_cache: list[dict] = []            # list of {"slug": "...", "name": "..."}
_feature_tags_cache: list[dict] = []        # list of {"id": "...", "name": "...", "description": "..."}
_location_loaded_at: float = 0.0
_category_loaded_at: float = 0.0
_feature_tags_loaded_at: float = 0.0

# ── Single-char prefix support ────────────────────────────────────────────────
# Prefix 1 ký tự (q/p/h/x): KHÔNG strip trong to_canonical + expand exact (100%, không fuzzy)
_SINGLE_CHAR_PREFIX_CHARS: frozenset[str] = frozenset({"q", "p", "h", "x"})
_SINGLE_CHAR_PREFIX_EXPAND: dict[str, str] = {
    "q": "quận",
    "p": "phường",
    "h": "huyện",
    "x": "xã",
}

def to_canonical(text: str) -> str:
    """
    Chuẩn hóa chuỗi về dạng 'Canonical':
    lowercase → xóa dấu → xóa tiền tố hành chính nếu tên sau prefix có ≥ 2 từ.

    Quy tắc "tên 1 từ → không strip prefix, không xóa dấu":
      - "thị trấn Chợ"   → "thị trấn chợ"   (giữ dấu, giữ prefix)
      - "quận 1"         → "quận 1"          (giữ dấu, giữ prefix)
      - "xã An"          → "xã an"           (giữ dấu, giữ prefix)
      - "quận Bình Thạnh"→ "binh thanh"      (2 từ → strip + xóa dấu bình thường)

    Prefix 1 ký tự (q/p/h/x như "q1", "q 1"):
      → giữ nguyên no-accent — match exact qua _DISTRICT_FALLBACK.
    """
    if not text:
        return ""

    # 1. Lowercase giữ dấu
    s_lower = text.strip().lower()

    # 2. Xóa dấu (dùng để detect prefix)
    s = remove_accents(s_lower)

    # 3. Prefix đúng 1 ký tự (q/p/h/x) → giữ no-accent, không expand
    if len(s) >= 2 and s[0] in _SINGLE_CHAR_PREFIX_CHARS and (s[1].isdigit() or s[1] == " "):
        return s

    # 4. Tiền tố hành chính nhiều ký tự (ưu tiên cụm dài trước)
    prefixes = [
        "thanh pho ", "thi xa ", "thi tran ",
        "quan ", "huyen ", "tinh ", "xa ", "phuong "
    ]
    for p in prefixes:
        if s.startswith(p):
            remainder = s[len(p):].strip()
            if " " not in remainder:
                # Tên sau prefix chỉ 1 từ → giữ nguyên dấu, giữ prefix
                # "thị trấn Chợ" → "thị trấn chợ" (KHÔNG "thi tran cho")
                return s_lower
            # 2+ từ → strip prefix, xóa dấu bình thường
            s = remainder
            break

    return s


def _expand_single_char_prefix(text_lower: str) -> Optional[str]:
    """
    Expand single-char admin prefix thành full prefix để tra exact.
    "q 1" → "quận 1", "q1" → "quận 1", "p 5" → "phường 5"
    Chỉ dành cho pattern: [q|p|h|x] + (space?) + (số hoặc tên).
    Không fuzzy — chỉ dùng làm exact lookup key.
    """
    m = re.match(r'^([qphx])\s*(\d+|\w.+)$', text_lower.strip())
    if not m:
        return None
    full_prefix = _SINGLE_CHAR_PREFIX_EXPAND.get(m.group(1))
    if not full_prefix:
        return None
    return f"{full_prefix} {m.group(2).strip()}"

def find_location(text: str) -> Optional[dict]:
    """
    Tra cứu location từ text qua chuẩn hóa Canonical.
    Fallback: direct lowercase match for entries like "quận 1" where
    to_canonical strips the number, making the canonical key too short.
    """
    if not text:
        return None

    # Chuẩn hóa input
    key = to_canonical(text)
    text_lower = text.strip().lower()

    _maybe_refresh_location()

    # 1. Curated fallback maps first for deterministic disambiguation.
    # Prefer district fallback over DB cache for ambiguous keys (e.g., "binh thanh").
    if key in _DISTRICT_FALLBACK:
        return _DISTRICT_FALLBACK[key]
    if text_lower in _DISTRICT_FALLBACK:
        return _DISTRICT_FALLBACK[text_lower]
    for district_name, district_info in _DISTRICT_FALLBACK.items():
        if remove_accents(district_name) == key:
            return district_info

    # 2. Check PROVINCE_MAP (canonical key)
    if key in PROVINCE_MAP:
        return PROVINCE_MAP[key]

    # 3. Check DB cache (canonical key)
    if key in _location_cache:
        return _location_cache[key]

    # 4. Direct lowercase match — handles "quận 1", "phường X", etc.
    if text_lower in _DISTRICT_FALLBACK:
        return _DISTRICT_FALLBACK[text_lower]
    if text_lower in PROVINCE_MAP:
        return PROVINCE_MAP[text_lower]

    # 5. Single-char prefix expansion — exact match only (100%), không fuzzy
    # "q 1" / "q1" → "quận 1", "p 5" → "phường 5"
    text_no_accent = remove_accents(text_lower)
    expanded = _expand_single_char_prefix(text_no_accent)
    if expanded:
        if expanded in _DISTRICT_FALLBACK:
            return _DISTRICT_FALLBACK[expanded]
        # Thử canonical của expanded (VD: "quận 1" → "quan 1" → _location_cache)
        expanded_can = to_canonical(expanded)
        if expanded_can in _location_cache:
            return _location_cache[expanded_can]

    return None

def get_category_list() -> list[dict]:
    _maybe_refresh_categories()
    return _category_cache

def get_feature_tags() -> list[dict]:
    _maybe_refresh_feature_tags()
    return _feature_tags_cache

async def force_refresh() -> dict:
    d_count = 0
    c_count = 0
    t_count = 0
    try:
        d_count = await _do_load_location_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Force refresh location failed: {e}")
    try:
        c_count = await _do_load_categories_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Force refresh categories failed: {e}")
    try:
        t_count = await _do_load_feature_tags_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Force refresh feature_tags failed: {e}")
    return {"location_entries": d_count, "category_entries": c_count, "feature_tag_entries": t_count}

async def startup_load():
    logger.info("[Cache] Loading location + category + feature_tags caches at startup...")
    try:
        await _do_load_location_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Failed to load location cache: {e}")
    try:
        await _do_load_categories_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Failed to load category cache: {e}")
    try:
        await _do_load_feature_tags_from_db()
    except Exception as e:
        logger.warning(f"[Cache] Failed to load feature_tags cache: {e}")
    logger.info(
        f"[Cache] Loaded {len(_location_cache)} locations, "
        f"{len(_category_cache)} categories, "
        f"{len(_feature_tags_cache)} feature_tags"
    )

def _maybe_refresh_location():
    global _location_loaded_at
    if time.time() - _location_loaded_at > settings.LOCATION_CACHE_TTL:
        try:
            _load_location_sync_wrapper()
        except Exception as e:
            logger.warning(f"[Cache] Location refresh failed, keeping stale: {e}")

def _maybe_refresh_feature_tags():
    global _feature_tags_loaded_at
    if time.time() - _feature_tags_loaded_at > settings.CATEGORY_CACHE_TTL:
        try:
            _load_feature_tags_sync_wrapper()
        except Exception as e:
            logger.warning(f"[Cache] Feature tags refresh failed, keeping stale: {e}")

def _load_feature_tags_sync_wrapper() -> int:
    try:
        loop = asyncio.get_running_loop()
        loop.create_task(_do_load_feature_tags_from_db())
        return 0
    except RuntimeError:
        return asyncio.run(_do_load_feature_tags_from_db())


def _maybe_refresh_categories():
    global _category_loaded_at
    if time.time() - _category_loaded_at > settings.CATEGORY_CACHE_TTL:
        try:
            _load_categories_sync_wrapper()
        except Exception as e:
            logger.warning(f"[Cache] Category refresh failed, keeping stale: {e}")

import asyncio
from sqlalchemy import text
from app.core.database import async_session

async def _do_load_location_from_db() -> int:
    global _location_cache, _location_loaded_at
    global _location_keywords_sorted
    
    # Đảm bảo flush sạch cache cũ trước khi load mới (theo yêu cầu user)
    _location_cache.clear()
    
    try:
        async with async_session() as session:
            result = await session.execute(
                text("SELECT code, name, code_name, level FROM location WHERE level IN ('PROVINCE', 'DISTRICT', 'WARD')")
            )
            rows = result.fetchall()
            logger.info(f"[Cache] Fetched {len(rows)} rows from DB")
    except Exception as e:
        _location_loaded_at = time.time()
        logger.warning(f"[Cache] Direct DB fetch failed for locations: {e}")
        raise

    new_cache: dict[str, dict] = {}

    def add_to_cache(key: str, val: dict):
        if not key or len(key) < 2:
            return
        if key not in new_cache:
            new_cache[key] = val

    for row in rows:
        code, name_raw, code_name_raw, level = row
        entry = {"code": code, "level": level}

        # 1. Tên chuẩn hóa (Canonical)
        can_name = to_canonical(name_raw)
        add_to_cache(can_name, entry)
        
        if code_name_raw:
            can_code_name = to_canonical(code_name_raw)
            add_to_cache(can_code_name, entry)
            
        # 2. Hardcoded aliases cho các thành phố lớn
        if level == "PROVINCE":
            name_l = name_raw.lower() if name_raw else ""
            if "hồ chí minh" in name_l:
                for s in ["hcm", "tp hcm", "tp.hcm", "sài gòn", "sai gon", "sg"]:
                    add_to_cache(s, entry)
            elif "hà nội" in name_l:
                add_to_cache("hn", entry)
            elif "đà nẵng" in name_l:
                add_to_cache("dn", entry)
            elif "hải phòng" in name_l:
                add_to_cache("hp", entry)

    # Gán ngược lại global
    _location_cache.update(new_cache)
    _location_loaded_at = time.time()
    
    # Update keyword list cho extractor (sorted by length desc)
    keys = list(_location_cache.keys())
    keys.sort(key=len, reverse=True)
    _location_keywords_sorted = tuple(keys)
    
    return len(_location_cache)

def get_location_keywords() -> tuple[str, ...]:
    """Trả về list các keywords (đa phần là canonical) để extractor scan."""
    _maybe_refresh_location()
    return _location_keywords_sorted


def _load_location_sync_wrapper() -> int:
    """Wrapper đồng bộ cho logic load location."""
    try:
        loop = asyncio.get_running_loop()
        task = loop.create_task(_do_load_location_from_db())
        return 0 
    except RuntimeError:
        return asyncio.run(_do_load_location_from_db())

async def _do_load_categories_from_db() -> int:
    global _category_cache, _category_loaded_at
    try:
        async with async_session() as session:
            result = await session.execute(
                text("SELECT slug, name FROM categories WHERE is_active = true")
            )
            rows = result.fetchall()
    except Exception as e:
        _category_loaded_at = time.time()
        logger.warning(f"[Cache] Direct DB fetch failed for categories: {e}")
        raise

    _category_cache = [
        {"slug": row[0], "name": row[1]}
        for row in rows
        if row[0] and row[1]
    ]
    _category_loaded_at = time.time()
    return len(_category_cache)

def _load_categories_sync_wrapper() -> int:
    """Wrapper đồng bộ cho logic load category."""
    try:
        loop = asyncio.get_running_loop()
        task = loop.create_task(_do_load_categories_from_db())
        return 0
    except RuntimeError:
        return asyncio.run(_do_load_categories_from_db())


async def _do_load_feature_tags_from_db() -> int:
    global _feature_tags_cache, _feature_tags_loaded_at
    try:
        async with async_session() as session:
            result = await session.execute(
                text(
                    "SELECT id, name, description FROM product_feature_tags "
                    "WHERE is_active = true AND deleted_at IS NULL"
                )
            )
            rows = result.fetchall()
    except Exception as e:
        _feature_tags_loaded_at = time.time()
        logger.warning(f"[Cache] Direct DB fetch failed for feature_tags: {e}")
        raise

    _feature_tags_cache = [
        {"id": str(row[0]), "name": row[1], "description": row[2] or ""}
        for row in rows
        if row[0] and row[1]
    ]
    _feature_tags_loaded_at = time.time()
    return len(_feature_tags_cache)
