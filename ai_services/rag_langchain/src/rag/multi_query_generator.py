"""
multi_query_generator.py — Sinh nhiều truy vấn tìm kiếm từ một câu hỏi người dùng.

Dùng trong Advanced RAG (multi-query fusion):
  1. Nhận câu hỏi gốc của người dùng.
  2. Gọi LLM (Mistral API) sinh N câu hỏi thay thế / bổ sung góc nhìn.
  3. Mỗi truy vấn được retrieve riêng (hybrid BM25 + kNN).
  4. retriever_factory gộp tất cả danh sách kết quả bằng RRF.

Fail-safe: nếu API lỗi → chỉ dùng câu hỏi gốc (pipeline vẫn chạy).
"""

from __future__ import annotations

import json
import os
import re
from typing import List

import httpx

from src.rag.settings import RagSettings

_JSON_ARRAY_RE = re.compile(r"\[[\s\S]*\]")


def _parse_generated_queries(raw: str, *, max_count: int) -> List[str]:
    """Trích danh sách query từ JSON array hoặc từng dòng."""
    cleaned = (raw or "").strip()
    if not cleaned:
        return []

    # Thử parse JSON array trước
    match = _JSON_ARRAY_RE.search(cleaned)
    if match:
        try:
            payload = json.loads(match.group(0))
            if isinstance(payload, list):
                items = [str(item).strip() for item in payload if str(item).strip()]
                return items[:max_count]
        except json.JSONDecodeError:
            pass

    # Fallback: mỗi dòng một query (bỏ prefix số thứ tự)
    lines: List[str] = []
    for line in cleaned.splitlines():
        text = line.strip()
        if not text:
            continue
        text = re.sub(r"^[\-\*\d\.\)\s]+", "", text).strip()
        if text:
            lines.append(text)
    return lines[:max_count]


def _dedupe_queries(queries: List[str]) -> List[str]:
    """Giữ thứ tự, loại trùng không phân biệt hoa thường."""
    seen: set[str] = set()
    result: List[str] = []
    for query in queries:
        normalized = query.strip()
        if not normalized:
            continue
        key = normalized.casefold()
        if key in seen:
            continue
        seen.add(key)
        result.append(normalized)
    return result


def generate_multi_queries(
    query: str,
    *,
    settings: RagSettings | None = None,
    count: int | None = None,
    model: str | None = None,
    api_key: str | None = None,
    timeout: float = 45.0,
) -> List[str]:
    """
    Sinh danh sách truy vấn dùng cho multi-query fusion.

    Luôn đưa câu hỏi gốc vào đầu danh sách (nếu multi_query_include_original=True).
    """
    from src.rag.settings import load_rag_settings

    settings = settings or load_rag_settings()
    cleaned = (query or "").strip()
    if not cleaned:
        return []

    if not settings.multi_query_enabled:
        return [cleaned]

    target_count = count if count is not None else settings.multi_query_count
    target_count = max(1, int(target_count))

    resolved_key = (api_key or os.getenv("MISTRAL_API_KEY", "")).strip()
    if not resolved_key:
        return [cleaned]

    resolved_model = model or settings.multi_query_model
    api_url = os.getenv(
        "MISTRAL_API_URL",
        "https://api.mistral.ai/v1/chat/completions",
    )

    prompt = (
        "You are a search-query generator for a WHO wellness knowledge base.\n"
        f"Given the user question below, write exactly {target_count} alternative "
        "search queries that would help retrieve relevant WHO documents.\n"
        "Each query must rephrase or approach the question from a different angle "
        "(synonyms, related symptoms, guideline terms, prevention vs treatment, etc.).\n"
        "Keep the same language as the user question (Vietnamese → Vietnamese, English → English).\n"
        "Return ONLY a JSON array of strings, no explanation.\n\n"
        f"User question: {cleaned}"
    )

    generated: List[str] = []
    try:
        response = httpx.post(
            api_url,
            headers={
                "Authorization": f"Bearer {resolved_key}",
                "Content-Type": "application/json",
            },
            json={
                "model": resolved_model,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.3,
                "max_tokens": 512,
            },
            timeout=timeout,
        )
        response.raise_for_status()
        raw = response.json()["choices"][0]["message"]["content"]
        generated = _parse_generated_queries(raw, max_count=target_count)
    except Exception as exc:
        print(f"⚠️ Multi-query generation failed, using original query only: {exc}")
        return [cleaned]

    if settings.multi_query_include_original:
        queries = _dedupe_queries([cleaned, *generated])
    else:
        queries = _dedupe_queries(generated) or [cleaned]

    return queries
