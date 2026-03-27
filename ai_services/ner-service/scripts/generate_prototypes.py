import argparse
import asyncio
import json
import logging
import re
from typing import Any

import httpx
from sqlalchemy import text

from app.core.config import settings
from app.core.database import async_session

logger = logging.getLogger("prototype-generator")
logging.basicConfig(level=logging.INFO, format="%(asctime)s | %(levelname)s | %(message)s")


def _strip_code_fence(raw: str) -> str:
    raw = raw.strip()
    if raw.startswith("```"):
        raw = re.sub(r"^```[a-zA-Z]*", "", raw).strip()
        raw = re.sub(r"```$", "", raw).strip()
    return raw


def _build_prompt(tag_name: str, tag_description: str) -> str:
    return (
        "Ban la mot chuyen gia ve hanh vi tim kiem (Search Intent) cua nguoi dung Viet Nam "
        "trong linh vuc y te, lam dep va suc khoe. "
        f"Cho mot Feature Tag co ten la: '{tag_name}' va mo ta: '{tag_description}'. "
        "Hay sinh ra 5 cum tu tim kiem (search queries) NGAN GON (2-5 tu) ma mot nguoi binh thuong "
        "se go vao thanh tim kiem khi ho muon tim dich vu co chua tag nay.\n"
        "Yeu cau:\n"
        "- Dung ngon ngu tu nhien, co the bao gom tieng long hoac cach goi binh dan.\n"
        "- Tra ve ket qua DUNG CHUAN JSON array chua cac chuoi string, khong kem text nao khac.\n"
        "Vi du: [\"tri tham mat\", \"xoa quang tham\", \"chua mat tham\"]"
    )


async def _generate_prototypes(client: httpx.AsyncClient, tag_name: str, tag_description: str) -> list[str]:
    prompt = _build_prompt(tag_name, tag_description)
    url = f"{settings.GEMINI_API_BASE_URL}/models/{settings.GEMINI_MODEL}:generateContent"

    body = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.2,
            "response_mime_type": "application/json",
        },
    }

    response = await client.post(url, params={"key": settings.GEMINI_API_KEY.strip()}, json=body)
    response.raise_for_status()

    payload = response.json()
    raw_text = payload["candidates"][0]["content"]["parts"][0].get("text", "[]")
    raw_text = _strip_code_fence(raw_text)

    parsed = json.loads(raw_text)
    if not isinstance(parsed, list):
        raise ValueError("Gemini output is not a JSON array")

    cleaned = []
    for item in parsed:
        phrase = str(item).strip()
        if not phrase:
            continue
        token_count = len(re.findall(r"\w+", phrase, flags=re.UNICODE))
        if 2 <= token_count <= 8:
            cleaned.append(phrase)

    # Keep unique order and max 10 prototypes
    result = []
    seen = set()
    for p in cleaned:
        k = p.lower()
        if k in seen:
            continue
        seen.add(k)
        result.append(p)
        if len(result) >= 10:
            break

    return result


async def _fetch_target_tags(limit: int) -> list[dict[str, Any]]:
    query = text(
        "SELECT id, name, COALESCE(description, '') AS description "
        "FROM product_feature_tags "
        "WHERE is_active = true AND deleted_at IS NULL "
        "AND (search_prototypes IS NULL OR jsonb_array_length(search_prototypes) = 0) "
        "ORDER BY id "
        "LIMIT :limit"
    )

    async with async_session() as session:
        rows = (await session.execute(query, {"limit": limit})).fetchall()

    return [
        {"id": str(r[0]), "name": str(r[1]), "description": str(r[2] or "")}
        for r in rows
    ]


async def _save_prototypes(tag_id: str, prototypes: list[str]) -> None:
    update_sql = text(
        "UPDATE product_feature_tags "
        "SET search_prototypes = CAST(:prototypes AS jsonb) "
        "WHERE id = CAST(:tag_id AS uuid)"
    )
    async with async_session() as session:
        await session.execute(update_sql, {"prototypes": json.dumps(prototypes, ensure_ascii=False), "tag_id": tag_id})
        await session.commit()


async def main() -> None:
    parser = argparse.ArgumentParser(description="Generate feature tag search prototypes using Gemini.")
    parser.add_argument("--limit", type=int, default=200, help="Maximum number of tags to process")
    parser.add_argument("--sleep-ms", type=int, default=150, help="Delay between API calls in milliseconds")
    args = parser.parse_args()

    if not settings.GEMINI_API_KEY.strip():
        raise RuntimeError("GEMINI_API_KEY is missing. Set it in .env before running this script.")

    try:
        tags = await _fetch_target_tags(args.limit)
    except Exception as exc:
        logger.error("Failed to fetch target tags. Ensure search_prototypes column exists. error=%s", exc)
        raise

    if not tags:
        logger.info("No feature tags pending prototype generation.")
        return

    logger.info("Generating prototypes for %s tags...", len(tags))

    timeout_sec = max(1.0, settings.GEMINI_TIMEOUT_MS / 1000.0)
    success = 0
    failed = 0

    async with httpx.AsyncClient(timeout=timeout_sec) as client:
        for idx, tag in enumerate(tags, start=1):
            try:
                prototypes = await _generate_prototypes(client, tag["name"], tag["description"])
                if not prototypes:
                    raise ValueError("empty prototype list")
                await _save_prototypes(tag["id"], prototypes)
                success += 1
                logger.info("[%s/%s] Updated tag=%s prototypes=%s", idx, len(tags), tag["name"], prototypes)
            except Exception as exc:
                failed += 1
                logger.warning("[%s/%s] Failed tag=%s error=%s", idx, len(tags), tag["name"], exc)

            await asyncio.sleep(max(0, args.sleep_ms) / 1000.0)

    logger.info("Done. success=%s failed=%s total=%s", success, failed, len(tags))


if __name__ == "__main__":
    asyncio.run(main())
