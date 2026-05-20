#!/usr/bin/env python3
"""
seed_azure_add_100_services.py

Mục tiêu
- Thêm ~100 dịch vụ (products) vào Azure PostgreSQL để test NER / prefilter theo Location.
- TUYỆT ĐỐI AN TOÀN cho production DB:
  - KHÔNG DELETE / TRUNCATE / UPDATE dữ liệu cũ.
  - Chỉ INSERT mới; idempotent (chạy nhiều lần không tạo duplicate).
  - Không giả định schema/constraint bừa: script sẽ đọc schema + unique constraints trước.

Cách chạy
  python seed_azure_add_100_services.py

Ghi chú
- Script này cố gắng "fill" đầy đủ các trường cơ bản nhất theo schema hiện có trong repo
  (account, location, categories, health_partner_profile, employees, products, product_definitions,
   product_media, product_employee_eligibility).
- Nếu DB của bạn khác schema (thiếu bảng/cột), script sẽ log rõ phần mismatch và dừng an toàn.
"""

from __future__ import annotations

import asyncio
import os
import random
import sys
import time
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Iterable
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

import asyncpg


# ---------------------------------------------------------------------
# Connection (as requested)
# ---------------------------------------------------------------------

DATABASE_URL = "postgresql+asyncpg://healytics:abcd%401234@healytics.postgres.database.azure.com:5432/postgres?ssl=require"


# ---------------------------------------------------------------------
# Deterministic IDs (idempotent inserts without relying on existing IDs)
# ---------------------------------------------------------------------

NOW = datetime.now(timezone.utc)
SEED_NAMESPACE = uuid.UUID("2b4b7b0f-36fd-4a1e-b4a2-2c9b7e0f9d3a")


def uid(key: str) -> str:
    return str(uuid.uuid5(SEED_NAMESPACE, key))


def normalize_asyncpg_url(url: str) -> str:
    if url.startswith("postgresql+asyncpg://"):
        return "postgresql://" + url[len("postgresql+asyncpg://") :]
    if url.startswith("postgres+asyncpg://"):
        return "postgresql://" + url[len("postgres+asyncpg://") :]
    return url


def build_connect_args(raw_url: str) -> tuple[str, dict[str, Any]]:
    """
    Convert SQLAlchemy-style URL into asyncpg connect args.
    Supports query variants:
      - ?ssl=require
      - ?ssl=true
      - ?sslmode=require
    """
    db_url = normalize_asyncpg_url(raw_url.strip())
    parts = urlsplit(db_url)
    query_pairs = parse_qsl(parts.query, keep_blank_values=True)
    query_map: dict[str, str] = {k: v for k, v in query_pairs}

    ssl_raw = (query_map.get("ssl") or query_map.get("sslmode") or "").strip().lower()
    connect_kwargs: dict[str, Any] = {}
    if ssl_raw in {"", "1", "true", "yes", "require", "verify-ca", "verify-full"}:
        if "ssl" in query_map or "sslmode" in query_map:
            connect_kwargs["ssl"] = True

    cleaned_pairs = [(k, v) for k, v in query_pairs if k not in {"ssl", "sslmode"}]
    cleaned_query = urlencode(cleaned_pairs, doseq=True)
    cleaned_url = urlunsplit((parts.scheme, parts.netloc, parts.path, cleaned_query, parts.fragment))
    return cleaned_url, connect_kwargs


# ---------------------------------------------------------------------
# Seed data definitions (professional, non-placeholder)
# ---------------------------------------------------------------------


@dataclass(frozen=True)
class CityDistrict:
    province_code: str
    province_name: str
    district_code: str
    district_name: str
    lat: float
    lng: float


DISTRICTS: list[CityDistrict] = [
    # Hà Nội
    CityDistrict("01", "Hà Nội", "001", "Hoàn Kiếm", 21.0285, 105.8542),
    CityDistrict("01", "Hà Nội", "005", "Ba Đình", 21.0356, 105.8142),
    CityDistrict("01", "Hà Nội", "006", "Đống Đa", 21.0180, 105.8292),
    CityDistrict("01", "Hà Nội", "007", "Hai Bà Trưng", 21.0058, 105.8576),
    CityDistrict("01", "Hà Nội", "019", "Cầu Giấy", 21.0362, 105.7906),
    CityDistrict("01", "Hà Nội", "020", "Thanh Xuân", 20.9949, 105.8093),
    # TP.HCM
    CityDistrict("79", "Hồ Chí Minh", "760", "Quận 1", 10.7769, 106.7009),
    CityDistrict("79", "Hồ Chí Minh", "770", "Quận 3", 10.7828, 106.6866),
    CityDistrict("79", "Hồ Chí Minh", "771", "Quận 10", 10.7731, 106.6676),
    CityDistrict("79", "Hồ Chí Minh", "774", "Quận 5", 10.7540, 106.6634),
    CityDistrict("79", "Hồ Chí Minh", "769", "Bình Thạnh", 10.8038, 106.7108),
    CityDistrict("79", "Hồ Chí Minh", "766", "Tân Bình", 10.8016, 106.6522),
    # Đà Nẵng
    CityDistrict("48", "Đà Nẵng", "490", "Hải Châu", 16.0471, 108.2068),
    CityDistrict("48", "Đà Nẵng", "491", "Thanh Khê", 16.0708, 108.1910),
    CityDistrict("48", "Đà Nẵng", "492", "Sơn Trà", 16.1139, 108.2516),
    CityDistrict("48", "Đà Nẵng", "493", "Ngũ Hành Sơn", 16.0002, 108.2637),
    # Gia Lai (tỉnh) + Pleiku (thành phố) — dùng code tỉnh phổ biến 64, district code seed-local (mang tính test)
    CityDistrict("64", "Gia Lai", "622", "Pleiku", 13.9718, 108.0151),
    CityDistrict("68", "Lâm Đồng", "672", "Đà Lạt", 11.9404, 108.4583),
    CityDistrict("56", "Khánh Hòa", "568", "Nha Trang", 12.2388, 109.1967),
    CityDistrict("31", "Hải Phòng", "303", "Ngô Quyền", 20.8561, 106.6822),
    CityDistrict("92", "Cần Thơ", "916", "Ninh Kiều", 10.0342, 105.7790),
]


# Categories: keep slugs aligned with existing ones if already present.
CATEGORIES: list[tuple[str, str]] = [
    ("massage", "Massage trị liệu"),
    ("spa-beauty", "Spa làm đẹp"),
    ("nha-khoa", "Nha khoa"),
    ("vat-ly-tri-lieu", "Vật lý trị liệu"),
    ("dong-y", "Đông y"),
    ("tam-ly", "Tâm lý"),
    ("dinh-duong", "Dinh dưỡng"),
    ("da-lieu", "Da liễu & thẩm mỹ"),
    ("kham-tong-quat", "Khám sức khỏe tổng quát"),
]


@dataclass(frozen=True)
class ServiceTemplate:
    name: str
    description: str
    category_slug: str
    partner_business_type: str  # stored on health_partner_profile.business_type (csv enums)
    base_price: int
    sale_price: int | None
    duration_minutes: int
    image_url: str


SERVICE_TEMPLATES: list[ServiceTemplate] = [
    ServiceTemplate(
        name="Massage cổ vai gáy chuyên sâu",
        description="Liệu trình giảm đau mỏi cổ vai gáy, phù hợp người làm việc văn phòng và ngồi nhiều.",
        category_slug="massage",
        partner_business_type="MASSAGE_REHABILITATION",
        base_price=320_000,
        sale_price=269_000,
        duration_minutes=60,
        image_url="https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Massage đá nóng thư giãn toàn thân",
        description="Massage kết hợp đá nóng giúp thư giãn sâu, cải thiện giấc ngủ và giảm căng cơ.",
        category_slug="massage",
        partner_business_type="MASSAGE_THERAPY",
        base_price=420_000,
        sale_price=349_000,
        duration_minutes=70,
        image_url="https://images.unsplash.com/photo-1600334129128-685c5582fd0d?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Gội đầu dưỡng sinh kết hợp bấm huyệt",
        description="Gội đầu dưỡng sinh kết hợp bấm huyệt đầu – vai – gáy, giúp giảm stress và thư giãn.",
        category_slug="spa-beauty",
        partner_business_type="SPA_BEAUTY",
        base_price=260_000,
        sale_price=219_000,
        duration_minutes=60,
        image_url="https://images.unsplash.com/photo-1515377905703-c4788e51af15?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Facial làm sạch sâu & phục hồi da",
        description="Chăm sóc da chuyên sâu: làm sạch, tẩy tế bào chết, cấp ẩm và phục hồi hàng rào bảo vệ da.",
        category_slug="da-lieu",
        partner_business_type="DERMATOLOGY",
        base_price=690_000,
        sale_price=590_000,
        duration_minutes=75,
        image_url="https://images.unsplash.com/photo-1522337660859-02fbefca4702?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Triệt lông công nghệ cao",
        description="Liệu trình triệt lông an toàn với công nghệ hiện đại, giảm kích ứng và hạn chế mọc lại.",
        category_slug="da-lieu",
        partner_business_type="DERMATOLOGY",
        base_price=1_200_000,
        sale_price=990_000,
        duration_minutes=50,
        image_url="https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Khám nha khoa tổng quát & tư vấn điều trị",
        description="Khám răng miệng tổng quát, cạo vôi, đánh bóng và tư vấn kế hoạch điều trị phù hợp.",
        category_slug="nha-khoa",
        partner_business_type="DENTAL",
        base_price=320_000,
        sale_price=None,
        duration_minutes=45,
        image_url="https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Tẩy trắng răng tại phòng khám",
        description="Tẩy trắng răng với ánh sáng chuyên dụng, an toàn và theo dõi bởi bác sĩ nha khoa.",
        category_slug="nha-khoa",
        partner_business_type="DENTAL",
        base_price=1_800_000,
        sale_price=1_490_000,
        duration_minutes=60,
        image_url="https://images.unsplash.com/photo-1609840114035-3c981b782dfe?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Vật lý trị liệu phục hồi chức năng đau lưng",
        description="Phục hồi chức năng cho đau lưng và thoát vị nhẹ: đánh giá, hướng dẫn bài tập và trị liệu.",
        category_slug="vat-ly-tri-lieu",
        partner_business_type="MASSAGE_REHABILITATION",
        base_price=650_000,
        sale_price=550_000,
        duration_minutes=60,
        image_url="https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Châm cứu hỗ trợ giảm đau cơ xương khớp",
        description="Châm cứu theo y học cổ truyền giúp giảm đau, tăng tuần hoàn và thư giãn cơ.",
        category_slug="dong-y",
        partner_business_type="TRADITIONAL_MEDICINE",
        base_price=520_000,
        sale_price=450_000,
        duration_minutes=70,
        image_url="https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Tư vấn dinh dưỡng cá nhân hoá (giảm cân an toàn)",
        description="Tư vấn dinh dưỡng theo mục tiêu giảm cân an toàn, theo dõi thói quen ăn uống và gợi ý thực đơn.",
        category_slug="dinh-duong",
        partner_business_type="NUTRITION",
        base_price=650_000,
        sale_price=590_000,
        duration_minutes=50,
        image_url="https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Tư vấn tâm lý giảm stress & cải thiện giấc ngủ",
        description="Buổi tư vấn 1-1, giúp nhận diện nguyên nhân stress, hướng dẫn kỹ thuật thư giãn và ngủ tốt hơn.",
        category_slug="tam-ly",
        partner_business_type="PSYCHOLOGY",
        base_price=520_000,
        sale_price=450_000,
        duration_minutes=55,
        image_url="https://images.unsplash.com/photo-1527137342181-19aab11a8ee8?w=600&h=400&fit=crop",
    ),
    ServiceTemplate(
        name="Khám sức khỏe tổng quát tiêu chuẩn",
        description="Gói khám sức khỏe tổng quát: xét nghiệm cơ bản, tư vấn chỉ số và kế hoạch theo dõi sức khỏe.",
        category_slug="kham-tong-quat",
        partner_business_type="TRADITIONAL_MEDICINE",
        base_price=1_200_000,
        sale_price=990_000,
        duration_minutes=90,
        image_url="https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&h=400&fit=crop",
    ),
]


def partner_brand_for(d: CityDistrict) -> str:
    return f"Trung tâm Chăm sóc Sức khỏe {d.district_name} - {d.province_name}"


def street_for(d: CityDistrict) -> str:
    # deterministic-ish number, but still looks realistic
    n = 20 + (int(d.district_code) % 80)
    return f"{n} Đường {d.district_name}, {d.district_name}"


# ---------------------------------------------------------------------
# Schema inspection helpers
# ---------------------------------------------------------------------


async def fetch_table_columns(conn: asyncpg.Connection, table: str) -> list[dict[str, Any]]:
    sql = """
        SELECT
            column_name,
            data_type,
            is_nullable,
            column_default
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = $1
        ORDER BY ordinal_position
    """
    rows = await conn.fetch(sql, table)
    return [dict(r) for r in rows]


async def fetch_unique_constraints(conn: asyncpg.Connection, table: str) -> list[dict[str, Any]]:
    """
    Return unique constraints (including PK) + their columns.
    """
    sql = """
        SELECT
            tc.constraint_name,
            tc.constraint_type,
            array_agg(kcu.column_name ORDER BY kcu.ordinal_position) AS columns
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
         AND tc.table_schema = kcu.table_schema
         AND tc.table_name = kcu.table_name
        WHERE tc.table_schema = 'public'
          AND tc.table_name = $1
          AND tc.constraint_type IN ('PRIMARY KEY', 'UNIQUE')
        GROUP BY tc.constraint_name, tc.constraint_type
        ORDER BY tc.constraint_type DESC, tc.constraint_name
    """
    rows = await conn.fetch(sql, table)
    return [dict(r) for r in rows]


def _print_schema(table: str, cols: list[dict[str, Any]], uqs: list[dict[str, Any]]) -> None:
    print(f"\n=== Schema: {table} ===")
    for c in cols:
        nn = "NOT NULL" if c["is_nullable"] == "NO" else "NULL"
        default = c["column_default"]
        default_txt = f" default={default}" if default is not None else ""
        print(f"- {c['column_name']}: {c['data_type']} {nn}{default_txt}")
    if uqs:
        print("Unique/PK constraints:")
        for u in uqs:
            print(f"  - {u['constraint_type']}: {u['constraint_name']}({', '.join(u['columns'])})")
    else:
        print("Unique/PK constraints: (none detected via information_schema)")


# ---------------------------------------------------------------------
# Insert helpers (NO DELETE/UPDATE) — idempotent via WHERE NOT EXISTS or ON CONFLICT
# ---------------------------------------------------------------------


async def exec_with_retry(
    conn: asyncpg.Connection,
    sql: str,
    *args,
    retries: int = 2,
    base_backoff: float = 0.35,
) -> str:
    last_exc: Exception | None = None
    for attempt in range(retries + 1):
        try:
            return await conn.execute(sql, *args)
        except Exception as exc:
            last_exc = exc
            if attempt >= retries:
                raise
            sleep_s = base_backoff * (2**attempt)
            print(f"[retry] attempt={attempt+1}/{retries+1} sleep={sleep_s:.2f}s error={exc}")
            await asyncio.sleep(sleep_s)
    raise last_exc or RuntimeError("unknown error")


async def ensure_location(conn: asyncpg.Connection, *, code: str, name: str, full_name: str, level: str, parent_code: str | None = None) -> str:
    """
    Ensure a location row exists. Returns location.id.
    Uses code as the natural key (no update).
    """
    parent_id = None
    if parent_code:
        parent = await conn.fetchrow("SELECT id FROM location WHERE code = $1", parent_code)
        if not parent:
            raise RuntimeError(f"Parent location not found for code={parent_code}")
        parent_id = str(parent["id"])

    # Insert only if code does not exist
    loc_id = uid(f"loc-{level.lower()}-{code}")
    await exec_with_retry(
        conn,
        """
        INSERT INTO location (id, code, name, full_name, level, parent_id)
        SELECT
            $1::uuid,
            $2::varchar,
            $3::varchar,
            $4::varchar,
            $5::location_level_enum,
            $6::uuid
        WHERE NOT EXISTS (SELECT 1 FROM location WHERE code = $2::varchar)
        """,
        loc_id,
        code,
        name,
        full_name,
        level,
        parent_id,
    )

    row = await conn.fetchrow("SELECT id FROM location WHERE code = $1", code)
    if not row:
        raise RuntimeError(f"Failed to ensure location code={code}")
    return str(row["id"])


async def ensure_category(conn: asyncpg.Connection, *, slug: str, name: str) -> str:
    cat_id = uid(f"cat-{slug}")
    await exec_with_retry(
        conn,
        """
        INSERT INTO categories (id, name, slug, is_active, created_at, updated_at)
        SELECT $1::uuid, $2::varchar, $3::varchar, true, $4::timestamptz, $4::timestamptz
        WHERE NOT EXISTS (SELECT 1 FROM categories WHERE slug = $3::varchar)
        """,
        cat_id,
        name,
        slug,
        NOW,
    )
    row = await conn.fetchrow("SELECT id FROM categories WHERE slug = $1", slug)
    if not row:
        raise RuntimeError(f"Failed to ensure category slug={slug}")
    return str(row["id"])


async def ensure_account(conn: asyncpg.Connection, *, email: str, username: str) -> str:
    acc_id = uid(f"acc-{email.lower().strip()}")
    await exec_with_retry(
        conn,
        """
        INSERT INTO account (id, email, username, role, is_active, created_at, updated_at)
        SELECT $1::uuid, $2::varchar, $3::varchar, 'health_partner'::account_role_enum, true, $4::timestamptz, $4::timestamptz
        WHERE NOT EXISTS (SELECT 1 FROM account WHERE id = $1::uuid OR email = $2::varchar)
        """,
        acc_id,
        email,
        username,
        NOW,
    )
    row = await conn.fetchrow("SELECT id FROM account WHERE email = $1", email)
    if not row:
        row = await conn.fetchrow("SELECT id FROM account WHERE id = $1", acc_id)
    if not row:
        raise RuntimeError(f"Failed to ensure account email={email}")
    return str(row["id"])


async def ensure_partner(
    conn: asyncpg.Connection,
    *,
    tax_code: str,
    legal_name: str,
    brand_name: str,
    business_types_csv: str,
    province_id: str,
    district_id: str,
    street_address: str,
    account_id: str,
    lat: float,
    lng: float,
) -> str:
    """
    Ensure partner exists via tax_code (natural key) OR deterministic id.
    No UPDATE.
    """
    partner_id = uid(f"partner-{tax_code}")
    coordinates_txt = f"{lat},{lng}"
    await exec_with_retry(
        conn,
        """
        INSERT INTO health_partner_profile (
            id, tax_code, legal_name, brand_name, business_type,
            province_id, district_id, street_address,
            account_id, verification_status,
            coordinates, location,
            created_at, updated_at
        )
        SELECT
            $1::uuid, $2::varchar, $3::varchar, $4::varchar, $5::varchar,
            $6::uuid, $7::uuid, $8::varchar,
            $9::uuid, 'APPROVED',
            $10::text,
            ST_SetSRID(ST_MakePoint($12::double precision, $11::double precision), 4326)::geography,
            $13::timestamptz, $13::timestamptz
        WHERE NOT EXISTS (
            SELECT 1 FROM health_partner_profile WHERE tax_code = $2::varchar OR id = $1::uuid
        )
        """,
        partner_id,
        tax_code,
        legal_name,
        brand_name,
        business_types_csv,
        province_id,
        district_id,
        street_address,
        account_id,
        coordinates_txt,
        lat,
        lng,
        NOW,
    )
    row = await conn.fetchrow("SELECT id FROM health_partner_profile WHERE tax_code = $1", tax_code)
    if not row:
        row = await conn.fetchrow("SELECT id FROM health_partner_profile WHERE id = $1", partner_id)
    if not row:
        raise RuntimeError(f"Failed to ensure partner tax_code={tax_code}")
    return str(row["id"])


async def ensure_employee(conn: asyncpg.Connection, *, partner_id: str, employee_code: str, full_name: str, email: str) -> str:
    emp_id = uid(f"emp-{employee_code}")
    await exec_with_retry(
        conn,
        """
        INSERT INTO employees (
            id, employee_code, full_name, email, role, status,
            partner_id, created_at, updated_at
        )
        SELECT
            $1::uuid, $2::varchar, $3::varchar, $4::varchar, 'THERAPIST'::employees_role_enum, 'ACTIVE'::employees_status_enum,
            $5::uuid, $6::timestamptz, $6::timestamptz
        WHERE NOT EXISTS (
            SELECT 1 FROM employees WHERE id = $1::uuid OR employee_code = $2::varchar
        )
        """,
        emp_id,
        employee_code,
        full_name,
        email,
        partner_id,
        NOW,
    )
    row = await conn.fetchrow("SELECT id FROM employees WHERE employee_code = $1", employee_code)
    if not row:
        row = await conn.fetchrow("SELECT id FROM employees WHERE id = $1", emp_id)
    if not row:
        raise RuntimeError(f"Failed to ensure employee code={employee_code}")
    return str(row["id"])


async def ensure_product(
    conn: asyncpg.Connection,
    *,
    product_id: str,
    category_id: str,
    name: str,
    slug: str,
    description: str,
    base_price: int,
    sale_price: int | None,
) -> str:
    await exec_with_retry(
        conn,
        """
        INSERT INTO products (
            id, category_id, name, slug, type,
            base_price, sale_price, description,
            status, is_visible_online, currency,
            created_at, updated_at
        )
        SELECT
            $1::uuid, $2::uuid, $3::varchar, $4::varchar, 'service',
            $5::numeric, $6::numeric, $7::text,
            'active', true, 'VND',
            $8::timestamptz, $8::timestamptz
        WHERE NOT EXISTS (
            SELECT 1 FROM products WHERE id = $1::uuid OR slug = $4::varchar
        )
        """,
        product_id,
        category_id,
        name,
        slug,
        base_price,
        sale_price,
        description,
        NOW,
    )
    return product_id


async def ensure_product_definition(conn: asyncpg.Connection, *, product_id: str, duration_minutes: int) -> None:
    await exec_with_retry(
        conn,
        """
        INSERT INTO product_definitions (product_id, duration_minutes, buffer_minutes)
        SELECT $1::uuid, $2::int, 10
        WHERE NOT EXISTS (SELECT 1 FROM product_definitions WHERE product_id = $1::uuid)
        """,
        product_id,
        duration_minutes,
    )


async def ensure_product_media(conn: asyncpg.Connection, *, product_id: str, url: str) -> None:
    await exec_with_retry(
        conn,
        """
        INSERT INTO product_media (product_id, url, media_type, is_thumbnail, sort_order)
        SELECT $1::uuid, $2::text, 'image', true, 0
        WHERE NOT EXISTS (
            SELECT 1 FROM product_media WHERE product_id = $1::uuid AND is_thumbnail = true
        )
        """,
        product_id,
        url,
    )


async def ensure_eligibility(conn: asyncpg.Connection, *, product_id: str, employee_id: str) -> None:
    await exec_with_retry(
        conn,
        """
        INSERT INTO product_employee_eligibility (product_id, employee_id, is_primary)
        SELECT $1::uuid, $2::uuid, true
        WHERE NOT EXISTS (
            SELECT 1 FROM product_employee_eligibility WHERE product_id = $1::uuid AND employee_id = $2::uuid
        )
        """,
        product_id,
        employee_id,
    )


# ---------------------------------------------------------------------
# Main seeding routine
# ---------------------------------------------------------------------


def _compute_target_count() -> int:
    # Aim ~100 products: (districts * templates) but cap to ~100.
    return 100


async def main() -> None:
    dsn, kwargs = build_connect_args(os.environ.get("DATABASE_URL", DATABASE_URL))
    conn = await asyncpg.connect(dsn=dsn, **kwargs)

    try:
        print("✅ Connected to Azure PostgreSQL")

        # 1) Inspect schema (requested)
        tables = ["products", "categories", "health_partner_profile", "location"]
        for t in tables:
            cols = await fetch_table_columns(conn, t)
            uqs = await fetch_unique_constraints(conn, t)
            if not cols:
                raise RuntimeError(f"Table not found or no columns introspected: {t}")
            _print_schema(t, cols, uqs)

        # 2) Ensure base lookup data (locations + categories)
        print("\n=== Ensuring locations (province/district) ===")
        for d in DISTRICTS:
            province_full = (
                "Thành phố Hồ Chí Minh"
                if d.province_name == "Hồ Chí Minh"
                else f"Thành phố {d.province_name}"
            )
            await ensure_location(
                conn,
                code=d.province_code,
                name=d.province_name,
                full_name=province_full,
                level="PROVINCE",
                parent_code=None,
            )
            await ensure_location(
                conn,
                code=d.district_code,
                name=d.district_name,
                full_name=f"Quận {d.district_name}" if d.province_code in {"01", "79"} else d.district_name,
                level="DISTRICT",
                parent_code=d.province_code,
            )
        print(f"✅ Locations ensured. provinces/districts={len(DISTRICTS)}")

        print("\n=== Ensuring categories ===")
        for slug, name in CATEGORIES:
            await ensure_category(conn, slug=slug, name=name)
        print(f"✅ Categories ensured. total={len(CATEGORIES)}")

        # 3) Seed partners + employees + products
        # Build mapping slug->id for speed
        cat_rows = await conn.fetch("SELECT id, slug FROM categories WHERE slug = ANY($1::text[])", [s for s, _ in CATEGORIES])
        cat_by_slug = {r["slug"]: str(r["id"]) for r in cat_rows}

        target_total = _compute_target_count()
        created_products = 0
        processed_products = 0

        print("\n=== Seeding partners + services (INSERT-only, idempotent) ===")
        # Randomize a little to diversify but deterministic enough
        rng = random.Random(20260406)
        districts = list(DISTRICTS)
        rng.shuffle(districts)

        # Choose templates per district so total ~100
        # e.g. 10 districts * 10 templates = 100; we have more districts, so we sample.
        templates = list(SERVICE_TEMPLATES)
        rng.shuffle(templates)

        # We create 1 partner per district, with union business types across templates used in that district.
        # To preserve "professional" naming, products incorporate district + province.
        per_district_templates = max(1, min(len(templates), (target_total + len(districts) - 1) // len(districts)))

        for d in districts:
            if processed_products >= target_total:
                break

            province = await conn.fetchrow("SELECT id FROM location WHERE code = $1", d.province_code)
            district = await conn.fetchrow("SELECT id FROM location WHERE code = $1", d.district_code)
            if not province or not district:
                raise RuntimeError(f"Location not found for {d.province_code}/{d.district_code}")

            # account unique per district
            email = f"partner-{d.province_code}-{d.district_code}@healytics.me"
            username = f"partner_{d.province_code}_{d.district_code}"
            account_id = await ensure_account(conn, email=email, username=username)

            # partner has a broad business_type set to allow prefilter by businessTypes.
            brand = partner_brand_for(d)
            tax_code = f"HLT-SEED-{d.province_code}-{d.district_code}"
            legal = f"Công ty TNHH {brand}"

            # union btypes for templates to ensure partner qualifies for multiple types
            chosen_templates = templates[:per_district_templates]
            btypes = sorted({t.partner_business_type for t in chosen_templates})
            business_csv = ",".join(btypes)

            partner_id = await ensure_partner(
                conn,
                tax_code=tax_code,
                legal_name=legal,
                brand_name=brand,
                business_types_csv=business_csv,
                province_id=str(province["id"]),
                district_id=str(district["id"]),
                street_address=street_for(d),
                account_id=account_id,
                lat=d.lat,
                lng=d.lng,
            )

            employee_code = f"EMP-SEED-{d.province_code}-{d.district_code}"
            employee_id = await ensure_employee(
                conn,
                partner_id=partner_id,
                employee_code=employee_code,
                full_name=f"Chuyên viên {d.district_name} ({d.province_name})",
                email=f"staff-{d.province_code}-{d.district_code}@healytics.me",
            )

            for idx, tpl in enumerate(chosen_templates, start=1):
                if processed_products >= target_total:
                    break

                category_id = cat_by_slug.get(tpl.category_slug)
                if not category_id:
                    # This should not happen due to ensure_category above.
                    raise RuntimeError(f"Missing category for slug={tpl.category_slug}")

                product_id = uid(f"product-{d.province_code}-{d.district_code}-{tpl.category_slug}-{idx}")
                slug = f"seed-{d.province_code}-{d.district_code}-{tpl.category_slug}-{idx}"
                name = f"{tpl.name} - {d.district_name}, {d.province_name}"
                desc = (
                    f"{tpl.description} "
                    f"Cơ sở tại {d.district_name}, {d.province_name}. "
                    f"Phù hợp cho người cần dịch vụ trong khu vực {d.district_name}."
                )

                # Insert product (idempotent)
                before = await conn.fetchval("SELECT 1 FROM products WHERE id=$1 OR slug=$2", product_id, slug)
                await ensure_product(
                    conn,
                    product_id=product_id,
                    category_id=category_id,
                    name=name,
                    slug=slug,
                    description=desc,
                    base_price=tpl.base_price,
                    sale_price=tpl.sale_price,
                )
                after = await conn.fetchval("SELECT 1 FROM products WHERE id=$1", product_id)
                processed_products += 1
                if not before and after:
                    created_products += 1

                await ensure_product_definition(conn, product_id=product_id, duration_minutes=tpl.duration_minutes)
                await ensure_product_media(conn, product_id=product_id, url=tpl.image_url)
                await ensure_eligibility(conn, product_id=product_id, employee_id=employee_id)

        print(f"✅ Done. products_created={created_products} / target={target_total} (processed={processed_products})")

        # 4) Quick verification queries (requested)
        print("\n=== Verification ===")
        # Count products created by this script (slug prefix)
        total_seed = await conn.fetchval("SELECT COUNT(*) FROM products WHERE slug LIKE 'seed-%'")
        print(f"- Total seeded products (slug LIKE 'seed-%'): {total_seed}")

        # Sample by city/province (based on partner province)
        async def sample_for(code: str, label: str) -> None:
            rows = await conn.fetch(
                """
                SELECT p.id::text, p.name, loc_p.full_name AS province, loc_d.full_name AS district
                FROM products p
                JOIN product_employee_eligibility pee ON p.id = pee.product_id
                JOIN employees e ON pee.employee_id = e.id
                JOIN health_partner_profile hpp ON e.partner_id = hpp.id
                JOIN location loc_p ON hpp.province_id = loc_p.id
                JOIN location loc_d ON hpp.district_id = loc_d.id
                WHERE p.slug LIKE 'seed-%'
                  AND loc_p.code = $1
                ORDER BY p.created_at DESC
                LIMIT 5
                """,
                code,
            )
            print(f"\n- Sample {label} (province_code={code}) count={len(rows)}:")
            for r in rows:
                print(f"  • {r['name']} | {r['district']} | {r['province']} | id={r['id']}")

        await sample_for("79", "TP.HCM")
        await sample_for("01", "Hà Nội")
        await sample_for("48", "Đà Nẵng")
        await sample_for("64", "Gia Lai")

        # Ensure location not null for seeded services
        missing_loc = await conn.fetchval(
            """
            SELECT COUNT(*)
            FROM products p
            JOIN product_employee_eligibility pee ON p.id = pee.product_id
            JOIN employees e ON pee.employee_id = e.id
            JOIN health_partner_profile hpp ON e.partner_id = hpp.id
            WHERE p.slug LIKE 'seed-%'
              AND (hpp.province_id IS NULL OR hpp.district_id IS NULL OR hpp.location IS NULL)
            """
        )
        print(f"\n- Seeded services missing partner location fields: {missing_loc}")

    finally:
        await conn.close()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("Interrupted.")
        sys.exit(130)
