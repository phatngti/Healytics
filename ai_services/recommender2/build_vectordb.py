"""
Script để build vector database từ DB
"""
from src.recommender.vector_store import Vector_Database
from src.recommender.embedding_model import Embedding_Model
from config.settings import DATABASE_NAME
from config.database import async_session
from sqlalchemy import text
import shutil
import os
from config import settings

async def _fetch_services_from_db(limit: int | None = None) -> list[dict]:
    async with async_session() as session:
        col_sql = text("""
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'public'
              AND table_name = 'products'
              AND column_name = 'service_id'
            LIMIT 1
        """)
        has_service_id = (await session.execute(col_sql)).first() is not None

        svc_key_expr = "p.service_id" if has_service_id else "p.id::text"

        limit_sql = "LIMIT :limit" if limit else ""
        sql = text(f"""
            SELECT
                {svc_key_expr} AS id,
                p.name AS name,
                COALESCE(p.description, '') AS description,
                COALESCE(c.slug, c.name, '') AS category
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            WHERE p.status = 'active'
              AND p.is_visible_online = true
            ORDER BY p.created_at DESC
            {limit_sql}
        """)
        params = {"limit": limit} if limit else {}
        rows = (await session.execute(sql, params)).mappings().all()
        return [dict(r) for r in rows]


def _reset_chroma_persist_dir():
    # Remove existing persistent vector db for clean rebuild
    vectordb_path = os.path.join(settings.PROCESSED_DATA_DIR, "vectordb")
    if os.path.exists(vectordb_path):
        shutil.rmtree(vectordb_path, ignore_errors=True)

async def build_vector_database(vector_database_name: str = DATABASE_NAME, clean: bool = False, limit: int | None = None):
    if clean:
        _reset_chroma_persist_dir()

    vector_database = Vector_Database(db_name=vector_database_name)
    services_data = await _fetch_services_from_db(limit=limit)
    embedding_model = Embedding_Model()

    for service in services_data:
        service_document = f"{service.get('name','')} {service.get('description','')}"
        service_embedding = embedding_model.encode(service_document)
        vector_database.upsert_service(
            service_id=str(service["id"]),
            name=service.get("name", ""),
            description=service.get("description", ""),
            category=service.get("category", ""),
            embedding=service_embedding,
        )
    print(f"Vector Database has been built successfully. total={len(services_data)}")
    
if __name__ == "__main__":
    import argparse
    import asyncio

    parser = argparse.ArgumentParser()
    parser.add_argument("--clean", action="store_true", help="Xóa vectordb cũ rồi build lại từ DB")
    parser.add_argument("--limit", type=int, default=None, help="Giới hạn số services để build (debug)")
    args = parser.parse_args()

    asyncio.run(build_vector_database(clean=args.clean, limit=args.limit))