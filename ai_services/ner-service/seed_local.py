#!/usr/bin/env python3
"""
seed_local.py — Seed local PostgreSQL với test data cho prefilter endpoint.

Usage:
    python seed_local.py              # seed (idempotent — chạy nhiều lần vẫn OK)
    python seed_local.py --clean      # xóa seed data trước rồi mới insert lại

DB URL đọc từ .env hoặc dùng default.
"""

import asyncio
import asyncpg
import argparse
import sys
from datetime import datetime, timezone

# ── DB connection ─────────────────────────────────────────────────────────────
DATABASE_URL = "postgresql://admin:admin%40123@localhost:5432/mydb"

# ── Hardcoded UUIDs (dễ nhận biết, idempotent) ───────────────────────────────
IDS = {
    # Accounts
    "acc_1": "a1000001-0000-0000-0000-000000000001",
    "acc_2": "a1000001-0000-0000-0000-000000000002",
    "acc_3": "a1000001-0000-0000-0000-000000000003",

    # Locations — Province
    "loc_hcm":  "b0000001-0000-0000-0000-000000000001",
    "loc_hn":   "b0000001-0000-0000-0000-000000000002",
    "loc_dn":   "b0000001-0000-0000-0000-000000000003",
    # Locations — District
    "loc_q1":   "b0000002-0000-0000-0000-000000000001",  # Quận 1, HCM
    "loc_q3":   "b0000002-0000-0000-0000-000000000002",  # Quận 3, HCM
    "loc_hk":   "b0000002-0000-0000-0000-000000000003",  # Hoàn Kiếm, HN

    # Categories
    "cat_tim_mach":   "c0000001-0000-0000-0000-000000000001",
    "cat_vltl":       "c0000001-0000-0000-0000-000000000002",
    "cat_dong_y":     "c0000001-0000-0000-0000-000000000003",
    "cat_tam_ly":     "c0000001-0000-0000-0000-000000000004",
    "cat_nha_khoa":   "c0000001-0000-0000-0000-000000000005",

    # Partners (health_partner_profile)
    "hpp_1": "d0000001-0000-0000-0000-000000000001",  # Phòng khám Q1 HCM
    "hpp_2": "d0000001-0000-0000-0000-000000000002",  # Trung tâm VLTL Q3 HCM
    "hpp_3": "d0000001-0000-0000-0000-000000000003",  # Đông y Hà Nội

    # Employees
    "emp_1": "e0000001-0000-0000-0000-000000000001",
    "emp_2": "e0000001-0000-0000-0000-000000000002",
    "emp_3": "e0000001-0000-0000-0000-000000000003",

    # Products
    "pro_1": "f0000001-0000-0000-0000-000000000001",  # Tư vấn tim mạch
    "pro_2": "f0000001-0000-0000-0000-000000000002",  # Vật lý trị liệu
    "pro_3": "f0000001-0000-0000-0000-000000000003",  # Châm cứu bấm huyệt
    "pro_4": "f0000001-0000-0000-0000-000000000004",  # Tư vấn tâm lý
    "pro_5": "f0000001-0000-0000-0000-000000000005",  # Làm sạch răng

    # Feature Tags
    "tag_co_vai_gay": "aa000001-0000-0000-0000-000000000001",  # Đau cổ vai gáy
    "tag_thoat_vi":   "aa000001-0000-0000-0000-000000000002",  # Thoát vị đĩa đệm
    "tag_thu_gian":   "aa000001-0000-0000-0000-000000000003",  # Thư giãn sâu
    "tag_da_nong":    "aa000001-0000-0000-0000-000000000004",  # Đá nóng
    "tag_bam_huyet":  "aa000001-0000-0000-0000-000000000005",  # Bấm huyệt
    "tag_rang_su":    "aa000001-0000-0000-0000-000000000006",  # Răng sứ thẩm mỹ
    "tag_stress":     "aa000001-0000-0000-0000-000000000007",  # Căng thẳng lo âu
    "tag_tim_mach":   "aa000001-0000-0000-0000-000000000008",  # Bệnh tim mạch
}

NOW = datetime.now(timezone.utc)


# ── Seed data ─────────────────────────────────────────────────────────────────

async def clean(conn: asyncpg.Connection):
    print("🗑  Cleaning seed data...")
    product_ids = [
        IDS[k] for k in ("pro_1", "pro_2", "pro_3", "pro_4", "pro_5")
    ]
    tag_ids = [
        IDS[k] for k in (
            "tag_co_vai_gay", "tag_thoat_vi", "tag_thu_gian", "tag_da_nong",
            "tag_bam_huyet", "tag_rang_su", "tag_stress", "tag_tim_mach",
        )
    ]
    partner_tax_codes = ["TAX001SEED", "TAX002SEED", "TAX003SEED"]
    employee_codes = ["EMP001SEED", "EMP002SEED", "EMP003SEED"]
    category_slugs = ["tim-mach", "vat-ly-tri-lieu", "dong-y", "tam-ly", "nha-khoa"]
    account_emails = [
        "partner1@healytics.test",
        "partner2@healytics.test",
        "partner3@healytics.test",
    ]

    # Junction and dependent tables keyed by product_id.
    await conn.execute(
        "DELETE FROM product_tags WHERE product_id = ANY($1::uuid[])", product_ids
    )
    await conn.execute(
        "DELETE FROM product_employee_eligibility WHERE product_id = ANY($1::uuid[])", product_ids
    )

    await conn.execute(
        "DELETE FROM product_reviews WHERE product_id = ANY($1::uuid[])", product_ids
    )
    await conn.execute(
        "DELETE FROM product_media WHERE product_id = ANY($1::uuid[])", product_ids
    )
    await conn.execute(
        "DELETE FROM product_definitions WHERE product_id = ANY($1::uuid[])", product_ids
    )
    await conn.execute(
        "DELETE FROM products WHERE id = ANY($1::uuid[])", product_ids
    )

    await conn.execute(
        "DELETE FROM product_feature_tags WHERE id = ANY($1::uuid[])", tag_ids
    )
    await conn.execute(
        "DELETE FROM employees WHERE employee_code = ANY($1::text[])", employee_codes
    )
    await conn.execute(
        "DELETE FROM health_partner_profile WHERE tax_code = ANY($1::text[])", partner_tax_codes
    )
    await conn.execute(
        "DELETE FROM categories WHERE slug = ANY($1::text[])", category_slugs
    )
    await conn.execute(
        "DELETE FROM account WHERE email = ANY($1::text[])", account_emails
    )
    print("   Done.\n")


async def seed_accounts(conn: asyncpg.Connection):
    print("👤 Seeding accounts...")
    rows = [
        (IDS["acc_1"], "partner1@healytics.test", "partner1", "health_partner"),
        (IDS["acc_2"], "partner2@healytics.test", "partner2", "health_partner"),
        (IDS["acc_3"], "partner3@healytics.test", "partner3", "health_partner"),
    ]
    for id_, email, username, role in rows:
        await conn.execute("""
            INSERT INTO account (id, email, username, role, is_active, created_at, updated_at)
            VALUES ($1, $2, $3, $4::account_role_enum, true, $5, $5)
            ON CONFLICT (id) DO NOTHING
        """, id_, email, username, role, NOW)
    print(f"   {len(rows)} accounts.\n")


async def seed_locations(conn: asyncpg.Connection):
    print("📍 Seeding locations...")

    # Provinces — keyed by IDS key, not pre-resolved UUID
    provinces = [
        ("loc_hcm", "79",  "Hồ Chí Minh",  "Thành phố Hồ Chí Minh",  "PROVINCE"),
        ("loc_hn",  "01",  "Hà Nội",        "Thành phố Hà Nội",        "PROVINCE"),
        ("loc_dn",  "48",  "Đà Nẵng",       "Thành phố Đà Nẵng",       "PROVINCE"),
    ]
    # Districts — parent referenced by IDS key
    districts = [
        ("loc_q1", "760", "Quận 1",      "Quận 1",           "DISTRICT", "loc_hcm"),
        ("loc_q3", "770", "Quận 3",      "Quận 3",           "DISTRICT", "loc_hcm"),
        ("loc_hk", "001", "Hoàn Kiếm",   "Quận Hoàn Kiếm",  "DISTRICT", "loc_hn"),
    ]

    for key, code, name, full_name, level in provinces:
        await conn.execute("""
            INSERT INTO location (id, code, name, full_name, level)
            VALUES ($1, $2, $3, $4, $5::location_level_enum)
            ON CONFLICT DO NOTHING
        """, IDS[key], code, name, full_name, level)
        # Resolve the real ID in case the row already existed with a different UUID
        row = await conn.fetchrow("SELECT id FROM location WHERE code = $1", code)
        IDS[key] = str(row["id"])

    for key, code, name, full_name, level, parent_key in districts:
        await conn.execute("""
            INSERT INTO location (id, code, name, full_name, level, parent_id)
            VALUES ($1, $2, $3, $4, $5::location_level_enum, $6)
            ON CONFLICT DO NOTHING
        """, IDS[key], code, name, full_name, level, IDS[parent_key])
        row = await conn.fetchrow("SELECT id FROM location WHERE code = $1", code)
        IDS[key] = str(row["id"])

    print(f"   {len(provinces)} provinces + {len(districts)} districts.\n")


async def seed_categories(conn: asyncpg.Connection):
    print("🏷  Seeding categories...")
    rows = [
        (IDS["cat_tim_mach"],  "Tim mạch",          "tim-mach"),
        (IDS["cat_vltl"],      "Vật lý trị liệu",   "vat-ly-tri-lieu"),
        (IDS["cat_dong_y"],    "Đông y",             "dong-y"),
        (IDS["cat_tam_ly"],    "Tâm lý",             "tam-ly"),
        (IDS["cat_nha_khoa"],  "Nha khoa",           "nha-khoa"),
    ]
    for id_, name, slug in rows:
        await conn.execute("""
            INSERT INTO categories (id, name, slug, is_active, created_at, updated_at)
            VALUES ($1, $2, $3, true, $4, $4)
            ON CONFLICT (id) DO NOTHING
        """, id_, name, slug, NOW)
    print(f"   {len(rows)} categories.\n")


async def seed_partners(conn: asyncpg.Connection):
    print("🏥 Seeding health_partner_profile...")

    # (id, tax_code, legal_name, brand_name, business_type,
    #  province_id, district_id, street_address, account_id,
    #  lat, lng)
    partners = [
        (
            IDS["hpp_1"],
            "TAX001SEED",
            "Công ty TNHH Phòng khám Đa khoa Quốc tế",
            "Phòng khám Đa khoa Quốc tế",
            "DENTAL,TRADITIONAL_MEDICINE",        # pro_5 nha khoa + pro_1 tim mạch
            IDS["loc_hcm"], IDS["loc_q1"],
            "123 Nguyễn Huệ",
            IDS["acc_1"],
            10.7769, 106.7009,
        ),
        (
            IDS["hpp_2"],
            "TAX002SEED",
            "Công ty TNHH Trung tâm Vật lý trị liệu Bình Minh",
            "Trung tâm Vật lý trị liệu Bình Minh",
            "MASSAGE_REHABILITATION,PSYCHOLOGY",  # pro_2 vật lý trị liệu + pro_4 tâm lý
            IDS["loc_hcm"], IDS["loc_q3"],
            "45 Võ Thị Sáu",
            IDS["acc_2"],
            10.7760, 106.6916,
        ),
        (
            IDS["hpp_3"],
            "TAX003SEED",
            "Hộ kinh doanh Đông y Gia truyền Hà Nội",
            "Đông y Gia truyền Hà Nội",
            "TRADITIONAL_MEDICINE",               # pro_3 châm cứu bấm huyệt
            IDS["loc_hn"], IDS["loc_hk"],
            "88 Hàng Bông",
            IDS["acc_3"],
            21.0315, 105.8487,
        ),
    ]

    for (
        id_, tax, legal, brand, btype,
        prov_id, dist_id, street, acc_id,
        lat, lng
    ) in partners:
        await conn.execute("""
            INSERT INTO health_partner_profile (
                id, tax_code, legal_name, brand_name, business_type,
                province_id, district_id, street_address,
                account_id, verification_status,
                coordinates, location,
                created_at, updated_at
            )
            VALUES (
                $1, $2, $3, $4, $5,
                $6, $7, $8,
                $9, 'APPROVED',
                $10,
                ST_SetSRID(ST_MakePoint($12, $11), 4326)::geography,
                $13, $13
            )
            ON CONFLICT (id) DO NOTHING
        """, id_, tax, legal, brand, btype,
             prov_id, dist_id, street,
             acc_id,
             f"{lat},{lng}",   # coordinates text
             lat, lng,         # ST_MakePoint(lng, lat)
             NOW)

    print(f"   {len(partners)} partners.\n")


async def seed_employees(conn: asyncpg.Connection):
    print("👩‍⚕️ Seeding employees...")
    rows = [
        (
            IDS["emp_1"], "EMP001SEED", "Nguyễn Văn An",
            "emp1seed@healytics.test", "DOCTOR", "ACTIVE", IDS["hpp_1"],
        ),
        (
            IDS["emp_2"], "EMP002SEED", "Trần Thị Bình",
            "emp2seed@healytics.test", "THERAPIST", "ACTIVE", IDS["hpp_2"],
        ),
        (
            IDS["emp_3"], "EMP003SEED", "Lê Văn Cường",
            "emp3seed@healytics.test", "DOCTOR", "ACTIVE", IDS["hpp_3"],
        ),
    ]
    for id_, code, full_name, email, role, status, partner_id in rows:
        await conn.execute("""
            INSERT INTO employees (
                id, employee_code, full_name, email, role, status,
                partner_id, created_at, updated_at
            )
            VALUES ($1, $2, $3, $4, $5::employees_role_enum, $6::employees_status_enum, $7, $8, $8)
            ON CONFLICT (id) DO NOTHING
        """, id_, code, full_name, email, role, status, partner_id, NOW)
    print(f"   {len(rows)} employees.\n")


async def seed_products(conn: asyncpg.Connection):
    print("📦 Seeding products...")

    products = [
        (
            IDS["pro_1"], IDS["cat_tim_mach"],
            "Tư vấn tim mạch trực tuyến", "tu-van-tim-mach-truc-tuyen",
            "service", 350000, None, "Tư vấn và đánh giá sức khỏe tim mạch qua video call với bác sĩ chuyên khoa.",
        ),
        (
            IDS["pro_2"], IDS["cat_vltl"],
            "Vật lý trị liệu thoát vị đĩa đệm", "vat-ly-tri-lieu-thoat-vi-dia-dem",
            "physical", 800000, 720000, "Chương trình phục hồi chuyên sâu cho bệnh nhân thoát vị đĩa đệm.",
        ),
        (
            IDS["pro_3"], IDS["cat_dong_y"],
            "Châm cứu bấm huyệt tại gia", "cham-cuu-bam-huyet-tai-gia",
            "service", 500000, None, "Dịch vụ châm cứu và bấm huyệt tại nhà bởi lương y có kinh nghiệm.",
        ),
        (
            IDS["pro_4"], IDS["cat_tam_ly"],
            "Tư vấn tâm lý trị liệu", "tu-van-tam-ly-tri-lieu",
            "service", 400000, 350000, "Buổi tư vấn tâm lý 1-1 với chuyên gia trị liệu tâm lý.",
        ),
        (
            IDS["pro_5"], IDS["cat_nha_khoa"],
            "Làm sạch răng chuyên sâu", "lam-sach-rang-chuyen-sau",
            "physical", 300000, None, "Vệ sinh răng miệng chuyên sâu, loại bỏ cao răng và làm trắng nhẹ.",
        ),
    ]

    for id_, cat_id, name, slug, ptype, base_price, sale_price, desc in products:
        await conn.execute("""
            INSERT INTO products (
                id, category_id, name, slug, type,
                base_price, sale_price, description,
                status, is_visible_online, currency,
                created_at, updated_at
            )
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,'active',true,'VND',$9,$9)
            ON CONFLICT (id) DO NOTHING
        """, id_, cat_id, name, slug, ptype,
             base_price, sale_price, desc, NOW)

    print(f"   {len(products)} products.\n")


async def seed_product_definitions(conn: asyncpg.Connection):
    print("⏱  Seeding product_definitions...")
    rows = [
        (IDS["pro_1"], 45),
        (IDS["pro_2"], 60),
        (IDS["pro_3"], 90),
        (IDS["pro_4"], 50),
        (IDS["pro_5"], 30),
    ]
    for product_id, duration in rows:
        await conn.execute("""
            INSERT INTO product_definitions (product_id, duration_minutes, buffer_minutes)
            VALUES ($1, $2, 10)
            ON CONFLICT (product_id) DO NOTHING
        """, product_id, duration)
    print(f"   {len(rows)} definitions.\n")


async def seed_product_media(conn: asyncpg.Connection):
    print("🖼  Seeding product_media...")
    images = [
        (IDS["pro_1"], "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop"),
        (IDS["pro_2"], "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop"),
        (IDS["pro_3"], "https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?w=400&h=300&fit=crop"),
        (IDS["pro_4"], "https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=400&h=300&fit=crop"),
        (IDS["pro_5"], "https://images.unsplash.com/photo-1606811971618-4486d14f3f99?w=400&h=300&fit=crop"),
    ]
    for product_id, url in images:
        await conn.execute("""
            INSERT INTO product_media (product_id, url, media_type, is_thumbnail, sort_order)
            SELECT $1, $2, 'image', true, 0
            WHERE NOT EXISTS (
                SELECT 1 FROM product_media WHERE product_id = $1 AND is_thumbnail = true
            )
        """, product_id, url)
    print(f"   {len(images)} thumbnails.\n")


async def seed_eligibility(conn: asyncpg.Connection):
    print("🔗 Seeding product_employee_eligibility...")
    # pro_1,2 → emp_1 (hpp_1 / Q1 HCM)
    # pro_3   → emp_3 (hpp_3 / HN)
    # pro_4   → emp_2 (hpp_2 / Q3 HCM)
    # pro_5   → emp_1 (hpp_1 / Q1 HCM)
    rows = [
        (IDS["pro_1"], IDS["emp_1"], True),
        (IDS["pro_2"], IDS["emp_2"], True),
        (IDS["pro_3"], IDS["emp_3"], True),
        (IDS["pro_4"], IDS["emp_2"], True),
        (IDS["pro_5"], IDS["emp_1"], True),
    ]
    for prod_id, emp_id, is_primary in rows:
        await conn.execute("""
            INSERT INTO product_employee_eligibility (product_id, employee_id, is_primary)
            VALUES ($1, $2, $3)
            ON CONFLICT (product_id, employee_id) DO NOTHING
        """, prod_id, emp_id, is_primary)
    print(f"   {len(rows)} eligibilities.\n")


async def seed_reviews(conn: asyncpg.Connection):
    print("⭐ Seeding product_reviews...")
    reviews = [
        # pro_1 — tim mach
        (IDS["pro_1"], "Nguyễn Thị Mai",    5, "Bác sĩ rất tận tâm, tư vấn chi tiết và dễ hiểu."),
        (IDS["pro_1"], "Trần Văn Hùng",     4, "Dịch vụ tốt, đặt lịch nhanh, chờ không lâu."),
        (IDS["pro_1"], "Lê Thị Thu",        5, "Rất hài lòng, sẽ giới thiệu cho bạn bè."),
        # pro_2 — vat ly tri lieu
        (IDS["pro_2"], "Phạm Văn Đức",      5, "Phục hồi nhanh sau 5 buổi trị liệu, tuyệt vời!"),
        (IDS["pro_2"], "Hoàng Thị Lan",     5, "Chuyên viên rất giỏi, tư vấn kỹ từng bài tập."),
        (IDS["pro_2"], "Nguyễn Minh Tuấn",  4, "Hiệu quả, nhưng giá hơi cao."),
        # pro_3 — cham cuu
        (IDS["pro_3"], "Bùi Thị Hà",        5, "Lương y rất kinh nghiệm, đau lưng giảm hẳn."),
        (IDS["pro_3"], "Vũ Văn Nam",         4, "Dịch vụ tại nhà tiện lợi, sẽ đặt lại."),
        # pro_4 — tam ly
        (IDS["pro_4"], "Đặng Thị Linh",     5, "Chuyên gia lắng nghe rất tốt, cảm thấy nhẹ nhàng hơn nhiều."),
        (IDS["pro_4"], "Phan Văn Khoa",      4, "Buổi đầu khá hữu ích, cần thêm thời gian."),
        # pro_5 — nha khoa
        (IDS["pro_5"], "Cao Thị Thúy",       5, "Sạch bóng, không đau, nhân viên thân thiện."),
        (IDS["pro_5"], "Lý Văn Phú",         4, "Nhanh và sạch, sẽ quay lại."),
    ]
    import uuid
    for prod_id, reviewer, rating, text in reviews:
        await conn.execute("""
            INSERT INTO product_reviews (
                id, product_id, reviewer_name, rating, text, status, date, image_urls, created_at
            )
            VALUES ($1,$2,$3,$4,$5,'Completed',$6,'[]'::jsonb,$6)
            ON CONFLICT (id) DO NOTHING
        """, str(uuid.uuid4()), prod_id, reviewer, rating, text, NOW)
    print(f"   {len(reviews)} reviews.\n")


async def seed_feature_tags(conn: asyncpg.Connection):
    print("🏷  Seeding product_feature_tags...")
    # (id_key, name, description)
    tags = [
        ("tag_co_vai_gay", "Đau cổ vai gáy",      "Trị liệu cổ, vai, gáy; giải phóng cơ bắp căng cứng vùng vai gáy"),
        ("tag_thoat_vi",   "Thoát vị đĩa đệm",    "Phục hồi chức năng cho bệnh nhân thoát vị đĩa đệm cột sống"),
        ("tag_thu_gian",   "Thư giãn sâu",         "Liệu pháp thư giãn toàn thân, giảm stress và căng cơ"),
        ("tag_da_nong",    "Đá nóng",              "Sử dụng đá nóng nhiệt để thư giãn cơ và tăng tuần hoàn máu"),
        ("tag_bam_huyet",  "Bấm huyệt",            "Kỹ thuật bấm huyệt đạo theo y học cổ truyền"),
        ("tag_rang_su",    "Răng sứ thẩm mỹ",      "Bọc răng sứ, làm trắng răng, phục hình thẩm mỹ"),
        ("tag_stress",     "Căng thẳng lo âu",     "Tư vấn và trị liệu cho người bị stress, lo âu, trầm cảm"),
        ("tag_tim_mach",   "Bệnh tim mạch",         "Tư vấn và xét nghiệm bệnh lý về tim, huyết áp, mạch máu"),
    ]
    for key, name, desc in tags:
        await conn.execute("""
            INSERT INTO product_feature_tags (
                id, user_id, name, description, is_active,
                usage, sort_order, created_at, updated_at
            )
            VALUES ($1, $2, $3, $4, true, 0, 0, $5, $5)
            ON CONFLICT (id) DO NOTHING
        """, IDS[key], IDS["acc_1"], name, desc, NOW)
    print(f"   {len(tags)} feature tags.\n")


async def seed_product_tags(conn: asyncpg.Connection):
    print("🔗 Seeding product_tags (product ↔ feature tag)...")
    # (product_key, tag_key)
    rows = [
        # pro_1 — Tư vấn tim mạch
        ("pro_1", "tag_tim_mach"),
        # pro_2 — Vật lý trị liệu thoát vị đĩa đệm
        ("pro_2", "tag_co_vai_gay"),
        ("pro_2", "tag_thoat_vi"),
        ("pro_2", "tag_thu_gian"),
        # pro_3 — Châm cứu bấm huyệt
        ("pro_3", "tag_bam_huyet"),
        ("pro_3", "tag_da_nong"),
        ("pro_3", "tag_co_vai_gay"),
        # pro_4 — Tư vấn tâm lý
        ("pro_4", "tag_stress"),
        ("pro_4", "tag_thu_gian"),
        # pro_5 — Làm sạch răng
        ("pro_5", "tag_rang_su"),
    ]
    for prod_key, tag_key in rows:
        await conn.execute("""
            INSERT INTO product_tags (product_id, tag_id, created_at)
            VALUES ($1, $2, $3)
            ON CONFLICT (product_id, tag_id) DO NOTHING
        """, IDS[prod_key], IDS[tag_key], NOW)
    print(f"   {len(rows)} product_tags.\n")


# ── Main ──────────────────────────────────────────────────────────────────────

async def main(do_clean: bool):
    try:
        conn = await asyncpg.connect(DATABASE_URL)
    except Exception as e:
        print(f"❌ Cannot connect to DB: {e}")
        print(f"   URL: {DATABASE_URL}")
        sys.exit(1)

    print(f"\n✅ Connected to DB\n")

    try:
        if do_clean:
            await clean(conn)

        await seed_accounts(conn)
        await seed_locations(conn)
        await seed_categories(conn)
        await seed_partners(conn)
        await seed_employees(conn)
        await seed_products(conn)
        await seed_product_definitions(conn)
        await seed_product_media(conn)
        await seed_eligibility(conn)
        await seed_reviews(conn)
        await seed_feature_tags(conn)
        await seed_product_tags(conn)

        print("🎉 Seed complete! Test với:")
        print('   POST http://localhost:8001/prefilter/search')
        print('   {"text": "vật lý trị liệu đau cổ vai gáy"}')
        print('   {"text": "châm cứu đá nóng hoặc bấm huyệt"}')
        print('   {"text": "trị liệu đá nóng và thư giãn"}')

    except Exception as e:
        print(f"❌ Seed error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await conn.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--clean", action="store_true", help="Xóa seed data cũ trước khi insert")
    args = parser.parse_args()
    asyncio.run(main(args.clean))
