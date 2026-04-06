import asyncio
import asyncpg
import uuid
import json
import random
from faker import Faker
from datetime import datetime

fake = Faker(['en_US', 'vi_VN'])
Faker.seed(42)

# ====================== CẤU HÌNH ======================
DB_CONFIG = {
    "host": "healytics.postgres.database.azure.com",
    "port": 5432,
    "user": "healytics",
    "password": "abcd@1234",
    "database": "postgres",
    "ssl": "require"
}

TABLE_NAME = "products"

async def get_existing_ids(conn):
    """Lấy category_id và partner_id thực tế từ database"""
    # Lấy category_id
    categories = await conn.fetch("SELECT id FROM categories WHERE deleted_at IS NULL")
    category_ids = [row['id'] for row in categories]
    
    # Lấy partner_id
    partners = await conn.fetch("SELECT id FROM health_partner_profile WHERE deleted_at IS NULL")
    partner_ids = [row['id'] for row in partners]

    print(f"✅ Tìm thấy {len(category_ids)} category_id và {len(partner_ids)} partner_id hợp lệ.")

    if not category_ids:
        raise Exception("❌ Không tìm thấy category nào trong bảng 'categories'!")
    if not partner_ids:
        raise Exception("❌ Không tìm thấy partner nào trong bảng 'health_partner_profile'!")

    return category_ids, partner_ids


async def insert_products():
    conn = await asyncpg.connect(**DB_CONFIG)
    print("✅ Kết nối thành công với Azure PostgreSQL!")

    category_ids, partner_ids = await get_existing_ids(conn)

    products = []
    for _ in range(100):
        product_id = str(uuid.uuid4())

        name = fake.catch_phrase().title()
        slug = name.lower().replace(" ", "-").replace(".", "").replace(",", "").replace("&", "and")
        description = fake.paragraph(nb_sentences=random.randint(4, 7))

        base_price = random.randint(250000, 2500000)
        sale_price = base_price - random.randint(30000, int(base_price * 0.35)) if random.random() > 0.4 else None

        now = datetime.utcnow()

        metadata = {
            "serviceRules": [
                {"title": fake.sentence(nb_words=4).strip("."), 
                 "iconSlug": random.choice(["no-eating", "hydrate", "arrive-early", "no-heat"]), 
                 "description": fake.sentence(nb_words=10)}
                for _ in range(random.randint(2, 4))
            ],
            "procedureSteps": [
                {"title": fake.sentence(nb_words=3).strip("."), 
                 "stepNumber": i + 1, 
                 "description": fake.sentence(nb_words=12)}
                for i in range(random.randint(3, 6))
            ],
            "preServiceGuidelines": [fake.sentence(nb_words=8) for _ in range(random.randint(2, 5))]
        }

        products.append((
            product_id,                          # id
            random.choice(category_ids),         # category_id (thật)
            name,                                # name
            slug,                                # slug
            description,                         # description
            "service",                           # type
            float(base_price),                   # base_price
            float(sale_price) if sale_price else None,  # sale_price
            "VND",                               # currency
            "active",                            # status
            True,                                # is_visible_online
            fake.company(),                      # vendor_name
            now,                                 # created_at
            now,                                 # updated_at
            None,                                # deleted_at
            json.dumps(metadata, ensure_ascii=False),  # service_manual
            random.choice(partner_ids)           # partner_id (thật)
        ))

    query = f"""
        INSERT INTO {TABLE_NAME} 
        (id, category_id, name, slug, description, type, base_price, sale_price, currency,
         status, is_visible_online, vendor_name, created_at, updated_at, deleted_at, 
         service_manual, partner_id)
        VALUES 
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
    """

    try:
        await conn.executemany(query, products)
        print(f"🎉 Đã insert thành công **100 products** vào bảng '{TABLE_NAME}'!")
    except Exception as e:
        print(f"❌ Lỗi khi insert: {e}")
    finally:
        await conn.close()


if __name__ == "__main__":
    asyncio.run(insert_products())