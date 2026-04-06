#!/usr/bin/env python3
"""
seed_azure.py — Seed Azure PostgreSQL with test data for NER /prefilter/search.

This is a DB-only helper. It does NOT touch vector DB.

Usage:
  export DATABASE_URL="postgresql+asyncpg://...azure...?ssl=require"
  python seed_azure.py               # seed (idempotent)
  python seed_azure.py --clean       # delete seed rows then re-seed

Notes:
  - We reuse the same seed logic from seed_local.py but read DATABASE_URL from env.
  - For asyncpg, we convert "postgresql+asyncpg://" -> "postgresql://".
"""

import argparse
import asyncio
import os
import sys
from urllib.parse import parse_qsl, urlencode, urlsplit, urlunsplit

import asyncpg
from dotenv import load_dotenv

# Reuse functions + data from seed_local
from seed_local import (  # type: ignore
    clean,
    seed_accounts,
    seed_locations,
    seed_categories,
    seed_partners,
    seed_employees,
    seed_products,
    seed_product_definitions,
    seed_product_media,
    seed_eligibility,
    seed_reviews,
    seed_feature_tags,
    seed_product_tags,
)


def _normalize_asyncpg_url(url: str) -> str:
    # SQLAlchemy async URL -> asyncpg URL
    if url.startswith("postgresql+asyncpg://"):
        return "postgresql://" + url[len("postgresql+asyncpg://") :]
    if url.startswith("postgres+asyncpg://"):
        return "postgresql://" + url[len("postgres+asyncpg://") :]
    return url


def _build_connect_args(raw_url: str) -> tuple[str, dict]:
    """
    Convert SQLAlchemy-style URL into asyncpg connect args.
    Supports query variants:
      - ?ssl=require
      - ?ssl=true
      - ?sslmode=require
      - ?ssl   (flag-style; treated as require)
    """
    db_url = _normalize_asyncpg_url(raw_url.strip())
    parts = urlsplit(db_url)

    # Parse query safely, including "flag" params like "?ssl"
    query_pairs = parse_qsl(parts.query, keep_blank_values=True)
    query_map: dict[str, str] = {k: v for k, v in query_pairs}

    ssl_raw = (query_map.get("ssl") or query_map.get("sslmode") or "").strip().lower()
    connect_kwargs: dict = {}
    if ssl_raw in {"", "1", "true", "yes", "require", "verify-ca", "verify-full"}:
        # asyncpg accepts bool/SSLContext/keywords; True is sufficient for Azure require TLS.
        if "ssl" in query_map or "sslmode" in query_map:
            connect_kwargs["ssl"] = True

    # Remove unsupported query fields for asyncpg DSN parser.
    cleaned_pairs = [(k, v) for k, v in query_pairs if k not in {"ssl", "sslmode"}]
    cleaned_query = urlencode(cleaned_pairs, doseq=True)
    cleaned_url = urlunsplit((parts.scheme, parts.netloc, parts.path, cleaned_query, parts.fragment))
    return cleaned_url, connect_kwargs


async def main(do_clean: bool):
    # Allow using ner-service/.env directly without exporting manually.
    load_dotenv(dotenv_path=os.path.join(os.path.dirname(os.path.abspath(__file__)), ".env"))

    db_url = os.environ.get("DATABASE_URL", "").strip()
    if not db_url:
        print("❌ DATABASE_URL is not set.")
        sys.exit(1)

    db_url, connect_kwargs = _build_connect_args(db_url)

    try:
        conn = await asyncpg.connect(dsn=db_url, **connect_kwargs)
    except Exception as e:
        print(f"❌ Cannot connect to DB: {e}")
        print(f"   URL: {db_url}")
        if connect_kwargs:
            print(f"   connect_kwargs: {connect_kwargs}")
        sys.exit(1)

    print("\n✅ Connected to Azure DB\n")
    try:
        if do_clean:
            await clean(conn)

        print("Starting seeding...")

        await seed_accounts(conn)
        await seed_locations(conn)
        await seed_categories(conn)
        await seed_partners(conn)
        await seed_employees(conn)
        await seed_products(conn)
        await seed_product_definitions(conn)
        await seed_product_media(conn)
        await seed_eligibility(conn)
        # await seed_reviews(conn)           # ← Bỏ tạm vì bảng chưa có
        await seed_feature_tags(conn)
        await seed_product_tags(conn)

        print("🎉 Seed Azure completed successfully!")
        
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

