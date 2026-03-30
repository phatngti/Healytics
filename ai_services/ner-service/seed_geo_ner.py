#!/usr/bin/env python3
"""
seed_geo_ner.py

Seed bộ dữ liệu lớn để test NER location extraction + prefilter/search theo địa lý.

Mục tiêu:
- Tạo nhiều service theo nhiều tỉnh/thành + quận.
- Dữ liệu idempotent (chạy nhiều lần không nhân bản).
- Không phụ thuộc migration mới; dùng các bảng hiện có trong dự án.

Usage:
    python seed_geo_ner.py
    python seed_geo_ner.py --clean

Yêu cầu:
- DATABASE_URL trong .env (hoặc env runtime)
"""

import argparse
import asyncio
import os
import sys
import uuid
from dataclasses import dataclass
from datetime import datetime, timezone
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

import asyncpg
from dotenv import load_dotenv

NOW = datetime.now(timezone.utc)
SEED_NAMESPACE = uuid.UUID("8bdb0f39-2dd6-44f6-bd85-3a2fce7d6df0")


def _normalize_asyncpg_url(url: str) -> str:
    if url.startswith("postgresql+asyncpg://"):
        return "postgresql://" + url[len("postgresql+asyncpg://") :]
    if url.startswith("postgres+asyncpg://"):
        return "postgresql://" + url[len("postgres+asyncpg://") :]
    return url


def _build_connect_args(raw_url: str) -> tuple[str, dict]:
    db_url = _normalize_asyncpg_url(raw_url.strip())
    parts = urlsplit(db_url)
    query_pairs = parse_qsl(parts.query, keep_blank_values=True)
    query_map = {k: v for k, v in query_pairs}
    ssl_raw = (query_map.get("ssl") or query_map.get("sslmode") or "").strip().lower()
    connect_kwargs = {}
    if ssl_raw in {"", "1", "true", "yes", "require", "verify-ca", "verify-full"}:
        if "ssl" in query_map or "sslmode" in query_map:
            connect_kwargs["ssl"] = True
    cleaned_pairs = [(k, v) for k, v in query_pairs if k not in {"ssl", "sslmode"}]
    cleaned_query = urlencode(cleaned_pairs, doseq=True)
    cleaned_url = urlunsplit((parts.scheme, parts.netloc, parts.path, cleaned_query, parts.fragment))
    return cleaned_url, connect_kwargs


def _uid(key: str) -> str:
    return str(uuid.uuid5(SEED_NAMESPACE, key))


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
    CityDistrict("01", "Hà Nội", "007", "Đống Đa", 21.0180, 105.8292),
    CityDistrict("01", "Hà Nội", "008", "Hai Bà Trưng", 21.0058, 105.8576),
    CityDistrict("01", "Hà Nội", "019", "Cầu Giấy", 21.0362, 105.7906),
    CityDistrict("01", "Hà Nội", "020", "Thanh Xuân", 20.9949, 105.8093),
    # TP.HCM
    CityDistrict("79", "Hồ Chí Minh", "760", "Quận 1", 10.7769, 106.7009),
    CityDistrict("79", "Hồ Chí Minh", "770", "Quận 3", 10.7828, 106.6866),
    CityDistrict("79", "Hồ Chí Minh", "771", "Quận 10", 10.7731, 106.6676),
    CityDistrict("79", "Hồ Chí Minh", "774", "Quận 5", 10.7540, 106.6634),
    CityDistrict("79", "Hồ Chí Minh", "761", "Quận 12", 10.8615, 106.6544),
    CityDistrict("79", "Hồ Chí Minh", "769", "Bình Thạnh", 10.8038, 106.7108),
    # Đà Nẵng
    CityDistrict("48", "Đà Nẵng", "490", "Hải Châu", 16.0471, 108.2068),
    CityDistrict("48", "Đà Nẵng", "491", "Thanh Khê", 16.0708, 108.1910),
    CityDistrict("48", "Đà Nẵng", "492", "Sơn Trà", 16.1139, 108.2516),
    CityDistrict("48", "Đà Nẵng", "493", "Ngũ Hành Sơn", 16.0002, 108.2637),
]


CATEGORIES = [
    ("massage", "Massage trị liệu"),
    ("spa-beauty", "Spa làm đẹp"),
    ("tam-ly", "Tâm lý"),
    ("vat-ly-tri-lieu", "Vật lý trị liệu"),
    ("nha-khoa", "Nha khoa"),
]


SERVICE_TEMPLATES = [
    ("Massage cổ vai gáy chuyên sâu", "Giảm đau cổ vai gáy, phù hợp dân văn phòng.", "massage", "MASSAGE_REHABILITATION", 220000, 180000),
    ("Massage đá nóng thư giãn", "Thư giãn sâu, giảm stress và cải thiện giấc ngủ.", "massage", "MASSAGE_THERAPY", 320000, 289000),
    ("Gội đầu dưỡng sinh", "Gội đầu kết hợp bấm huyệt giúp thư giãn.", "spa-beauty", "SPA_BEAUTY", 250000, 219000),
    ("Tư vấn tâm lý stress", "Tư vấn 1-1 cho stress, lo âu và mất ngủ.", "tam-ly", "PSYCHOLOGY", 450000, 390000),
    ("Vật lý trị liệu đau lưng", "Phục hồi chức năng cho đau lưng và thoát vị nhẹ.", "vat-ly-tri-lieu", "MASSAGE_REHABILITATION", 550000, 490000),
    ("Khám nha khoa tổng quát", "Khám răng miệng, vệ sinh và tư vấn điều trị.", "nha-khoa", "DENTAL", 300000, None),
]


def _district_partner_brand(d: CityDistrict) -> str:
    return f"Trung tâm Sức khỏe {d.district_name} {d.province_name}"


def _street_for(d: CityDistrict) -> str:
    return f"{100 + int(d.district_code) % 50} Đường Trung Tâm, {d.district_name}"


async def _ensure_locations(conn: asyncpg.Connection):
    # Provinces
    province_seen = set()
    for d in DISTRICTS:
        if d.province_code in province_seen:
            continue
        province_seen.add(d.province_code)
        await conn.execute(
            """
            INSERT INTO location (id, code, name, full_name, level)
            VALUES ($1, $2, $3, $4, 'PROVINCE'::location_level_enum)
            ON CONFLICT (code) DO NOTHING
            """,
            _uid(f"loc-province-{d.province_code}"),
            d.province_code,
            d.province_name,
            f"Thành phố {d.province_name}" if d.province_name != "Hồ Chí Minh" else "Thành phố Hồ Chí Minh",
        )

    # Districts
    for d in DISTRICTS:
        parent = await conn.fetchrow("SELECT id FROM location WHERE code = $1", d.province_code)
        if not parent:
            raise RuntimeError(f"Province not found for code={d.province_code}")
        await conn.execute(
            """
            INSERT INTO location (id, code, name, full_name, level, parent_id)
            VALUES ($1, $2, $3, $4, 'DISTRICT'::location_level_enum, $5)
            ON CONFLICT (code) DO NOTHING
            """,
            _uid(f"loc-district-{d.province_code}-{d.district_code}"),
            d.district_code,
            d.district_name,
            d.district_name,
            str(parent["id"]),
        )


async def _ensure_categories(conn: asyncpg.Connection):
    for slug, name in CATEGORIES:
        await conn.execute(
            """
            INSERT INTO categories (id, name, slug, is_active, created_at, updated_at)
            VALUES ($1, $2, $3, true, $4, $4)
            ON CONFLICT (slug) DO NOTHING
            """,
            _uid(f"cat-{slug}"),
            name,
            slug,
            NOW,
        )


async def _ensure_partner_account(conn: asyncpg.Connection, d: CityDistrict) -> str:
    """
    DB constraint UQ_PARTNER_ACCOUNT_ID: 1 account_id chỉ gắn được cho 1 partner profile.
    Vì vậy cần tạo 1 account riêng cho mỗi quận/huyện.
    """
    acc_id = _uid(f"acc-{d.province_code}-{d.district_code}")
    email = f"geo-ner-{d.province_code}-{d.district_code}@healytics.test"
    username = f"geo_ner_{d.province_code}_{d.district_code}"
    await conn.execute(
        """
        INSERT INTO account (id, email, username, role, is_active, created_at, updated_at)
        VALUES ($1, $2, $3, 'health_partner'::account_role_enum, true, $4, $4)
        ON CONFLICT (id) DO NOTHING
        """,
        acc_id,
        email,
        username,
        NOW,
    )
    return acc_id


async def _seed_partner_service_data(conn: asyncpg.Connection):
    created_products = 0
    for d in DISTRICTS:
        province = await conn.fetchrow("SELECT id FROM location WHERE code = $1", d.province_code)
        district = await conn.fetchrow("SELECT id FROM location WHERE code = $1", d.district_code)
        if not province or not district:
            continue

        partner_id = _uid(f"partner-{d.province_code}-{d.district_code}")
        partner_tax = f"GEO-NER-{d.province_code}-{d.district_code}"
        partner_brand = _district_partner_brand(d)
        street = _street_for(d)
        account_id = await _ensure_partner_account(conn, d)

        # Union business types from templates
        btypes = sorted({tpl[3] for tpl in SERVICE_TEMPLATES})
        business_type = ",".join(btypes)

        await conn.execute(
            """
            INSERT INTO health_partner_profile (
                id, tax_code, legal_name, brand_name, business_type,
                province_id, district_id, street_address, account_id, verification_status,
                coordinates, location, created_at, updated_at
            )
            VALUES (
                $1, $2, $3, $4, $5,
                $6, $7, $8, $9, 'APPROVED',
                $10,
                ST_SetSRID(ST_MakePoint($12, $11), 4326)::geography,
                $13, $13
            )
            ON CONFLICT (id) DO NOTHING
            """,
            partner_id,
            partner_tax,
            f"Công ty TNHH {partner_brand}",
            partner_brand,
            business_type,
            str(province["id"]),
            str(district["id"]),
            street,
            account_id,
            f"{d.lat},{d.lng}",
            d.lat,
            d.lng,
            NOW,
        )

        employee_id = _uid(f"employee-{d.province_code}-{d.district_code}")
        await conn.execute(
            """
            INSERT INTO employees (
                id, employee_code, full_name, email, role, status, partner_id, created_at, updated_at
            )
            VALUES ($1, $2, $3, $4, 'THERAPIST'::employees_role_enum, 'ACTIVE'::employees_status_enum, $5, $6, $6)
            ON CONFLICT (id) DO NOTHING
            """,
            employee_id,
            f"EMP-GEO-{d.province_code}-{d.district_code}",
            f"Chuyên viên {d.district_name}",
            f"geo-{d.province_code}-{d.district_code}@healytics.test",
            partner_id,
            NOW,
        )

        for idx, (base_name, base_desc, category_slug, _business_type, base_price, sale_price) in enumerate(SERVICE_TEMPLATES, start=1):
            product_id = _uid(f"product-{d.province_code}-{d.district_code}-{idx}")
            category = await conn.fetchrow("SELECT id FROM categories WHERE slug = $1", category_slug)
            if not category:
                continue

            service_name = f"{base_name} - {d.district_name} {d.province_name}"
            service_slug = f"geo-{d.province_code}-{d.district_code}-{idx}"
            service_desc = (
                f"{base_desc} Cơ sở tại {d.district_name}, {d.province_name}. "
                f"Phù hợp người cần tìm dịch vụ gần khu vực {d.district_name}."
            )

            await conn.execute(
                """
                INSERT INTO products (
                    id, category_id, name, slug, type,
                    base_price, sale_price, description,
                    status, is_visible_online, currency,
                    created_at, updated_at
                )
                VALUES (
                    $1, $2, $3, $4, 'service',
                    $5, $6, $7,
                    'active', true, 'VND',
                    $8, $8
                )
                ON CONFLICT (id) DO NOTHING
                """,
                product_id,
                str(category["id"]),
                service_name,
                service_slug,
                base_price,
                sale_price,
                service_desc,
                NOW,
            )

            await conn.execute(
                """
                INSERT INTO product_definitions (product_id, duration_minutes, buffer_minutes)
                VALUES ($1, 60, 10)
                ON CONFLICT (product_id) DO NOTHING
                """,
                product_id,
            )

            await conn.execute(
                """
                INSERT INTO product_media (product_id, url, media_type, is_thumbnail, sort_order)
                SELECT $1, $2, 'image', true, 0
                WHERE NOT EXISTS (
                    SELECT 1 FROM product_media WHERE product_id = $1 AND is_thumbnail = true
                )
                """,
                product_id,
                "https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600&h=400&fit=crop",
            )

            await conn.execute(
                """
                INSERT INTO product_employee_eligibility (product_id, employee_id, is_primary)
                VALUES ($1, $2, true)
                ON CONFLICT (product_id, employee_id) DO NOTHING
                """,
                product_id,
                employee_id,
            )

            # Một ít review để ranking/rating có ý nghĩa
            review_id = _uid(f"review-{product_id}")
            await conn.execute(
                """
                INSERT INTO product_reviews (
                    id, product_id, reviewer_name, rating, text, status, date, image_urls, created_at
                )
                VALUES ($1, $2, $3, 5, $4, 'Completed', $5, '[]'::jsonb, $5)
                ON CONFLICT (id) DO NOTHING
                """,
                review_id,
                product_id,
                f"Khách hàng {d.district_name}",
                f"Dịch vụ tốt tại {d.district_name}, {d.province_name}.",
                NOW,
            )
            created_products += 1

    print(f"✅ Seeded geo test data. products_processed={created_products}")


async def _clean(conn: asyncpg.Connection):
    # Chỉ xóa data do script này tạo (theo UUID namespace)
    # Dùng slug prefix "geo-" cho products + employee_code "EMP-GEO-" + tax_code "GEO-NER-"
    await conn.execute("DELETE FROM product_reviews WHERE product_id IN (SELECT id FROM products WHERE slug LIKE 'geo-%')")
    await conn.execute("DELETE FROM product_media WHERE product_id IN (SELECT id FROM products WHERE slug LIKE 'geo-%')")
    await conn.execute("DELETE FROM product_definitions WHERE product_id IN (SELECT id FROM products WHERE slug LIKE 'geo-%')")
    await conn.execute("DELETE FROM product_employee_eligibility WHERE product_id IN (SELECT id FROM products WHERE slug LIKE 'geo-%')")
    await conn.execute("DELETE FROM products WHERE slug LIKE 'geo-%'")
    await conn.execute("DELETE FROM employees WHERE employee_code LIKE 'EMP-GEO-%'")
    await conn.execute("DELETE FROM health_partner_profile WHERE tax_code LIKE 'GEO-NER-%'")
    await conn.execute("DELETE FROM account WHERE email LIKE 'geo-ner-%@healytics.test'")
    print("🧹 Cleaned geo test data.")


async def main(do_clean: bool):
    load_dotenv(dotenv_path=os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env"))
    db_url = os.environ.get("DATABASE_URL", "").strip()
    if not db_url:
        print("❌ DATABASE_URL is not set")
        sys.exit(1)
    dsn, kwargs = _build_connect_args(db_url)
    try:
        conn = await asyncpg.connect(dsn=dsn, **kwargs)
    except Exception as e:
        print(f"❌ Cannot connect DB: {e}")
        sys.exit(1)

    try:
        if do_clean:
            await _clean(conn)
        await _ensure_locations(conn)
        await _ensure_categories(conn)
        await _seed_partner_service_data(conn)

        print("\n=== Suggested NER location test queries ===")
        tests = [
            "Tìm massage cổ vai gáy ở Cầu Giấy Hà Nội giá dưới 300k",
            "Gội đầu dưỡng sinh gần Quận 1 Hồ Chí Minh",
            "Tư vấn tâm lý ở Thanh Xuân Hà Nội",
            "Vật lý trị liệu đau lưng tại Hải Châu Đà Nẵng",
            "Nha khoa tổng quát ở Ba Đình Hà Nội",
            "Massage đá nóng ở Quận 10 TP.HCM",
        ]
        for i, q in enumerate(tests, 1):
            print(f"{i}. {q}")
    finally:
        await conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--clean", action="store_true")
    args = parser.parse_args()
    asyncio.run(main(args.clean))

