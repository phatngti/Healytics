"""
Sync handler để handle các event từ Redis
"""
from src.recommender.vector_store import Vector_Database
from src.recommender.embedding_model import Embedding_Model
from config.settings import DATABASE_NAME
from config.database import async_session
from sqlalchemy import text

async def handle_sync_event(channel: str, data: dict):
    service_id = data.get("service_id")

    if not service_id:
        return
    
    # Treat "new_service_created" as an upsert (insert/update) into vector DB.
    if channel in ("new_service_created", "service:updated"):
        # Fetch service/product data from Azure PostgreSQL then upsert to vector store.
        # We try to be schema-tolerant: if table has a "service_id" column (string code),
        # use it; otherwise fall back to id::text.
        async with async_session() as session:
            # Detect whether products has service_id column
            col_sql = text("""
                SELECT 1
                FROM information_schema.columns
                WHERE table_schema = 'public'
                  AND table_name = 'products'
                  AND column_name = 'service_id'
                LIMIT 1
            """)
            has_service_id = (await session.execute(col_sql)).first() is not None

            if has_service_id:
                svc_key_expr = "p.service_id"
                svc_where_expr = "p.id::text = :sid OR p.service_id = :sid"
            else:
                svc_key_expr = "p.id::text"
                svc_where_expr = "p.id::text = :sid"

            sql = text(f"""
                SELECT
                    {svc_key_expr} AS service_key,
                    p.name AS name,
                    COALESCE(p.description, '') AS description,
                    COALESCE(c.slug, c.name, '') AS category
                FROM products p
                LEFT JOIN categories c ON p.category_id = c.id
                WHERE p.status = 'active'
                  AND p.is_visible_online = true
                  AND ({svc_where_expr})
                LIMIT 1
            """)
            row = (await session.execute(sql, {"sid": str(service_id)})).mappings().first()

        if not row:
            # If product not found (deleted/hidden), make sure vector db doesn't keep stale record.
            print(
                f"[SyncHandler] Not found/hidden: service_id={service_id!r}. "
                f"Will delete from vector DB if exists."
            )
            vector_db = Vector_Database(DATABASE_NAME)
            vector_db.delete_service(str(service_id))
            return

        service_key = str(row["service_key"])
        name = row["name"] or ""
        description = row["description"] or ""
        category = row["category"] or ""

        embedder = Embedding_Model()
        embedding = embedder.encode(f"{name} {description}")

        vector_db = Vector_Database(DATABASE_NAME)
        vector_db.upsert_service(
            service_id=service_key,
            name=name,
            description=description,
            category=category,
            embedding=embedding,
        )
        print(f"[SyncHandler] Upserted: {service_key}")
        
    elif channel == "service:deleted":
        vector_db = Vector_Database(DATABASE_NAME)
        vector_db.delete_service(str(service_id))