"""
query_translator.py — Dịch câu hỏi tiếng Việt sang tiếng Anh cho nhánh BM25.

Vì sao cần module này?
  - Tài liệu WHO trong Elasticsearch chủ yếu là tiếng Anh (field content_en).
  - Người dùng Healytics hỏi bằng tiếng Việt.
  - Nhánh dense (embedding đa ngôn ngữ) hiểu được cả VI và EN.
  - Nhánh sparse (BM25) cần từ khóa tiếng Anh để khớp tốt hơn.

Luồng:
  1. Phát hiện câu hỏi có ký tự tiếng Việt không (looks_vietnamese).
  2. Nếu có → gọi Mistral small (RAG_TRANSLATION_MODEL) dịch sang EN.
  3. Nếu lỗi hoặc không có API key → trả về câu hỏi gốc (không làm hỏng pipeline).
"""

from __future__ import annotations

import os
import re

import httpx

# Regex nhận diện ký tự có dấu tiếng Việt (ă, â, đ, ơ, ư, ...)
_VIET_CHARS = re.compile(
    r"[\u00C0-\u1EF9\u0102\u0103\u00C2\u00E2\u00CA\u00EA\u00D4\u00F4\u01A0\u01A1\u01AF\u01B0\u0110\u0111]"
)


def looks_vietnamese(text: str) -> bool:
    """Trả True nếu chuỗi có ít nhất một ký tự tiếng Việt có dấu."""
    if not text or not text.strip():
        return False
    return bool(_VIET_CHARS.search(text))


def translate_query_to_english(
    query: str,
    *,
    model: str | None = None,
    api_key: str | None = None,
    timeout: float = 30.0,
) -> str:
    """
    Dịch query sang tiếng Anh để dùng cho BM25.

    Chỉ dịch khi:
      - Câu hỏi có vẻ là tiếng Việt
      - Có MISTRAL_API_KEY

    Returns:
        Chuỗi tiếng Anh (hoặc nguyên bản nếu không cần / không dịch được).
    """
    cleaned = (query or "").strip()
    if not cleaned:
        return cleaned

    # Câu hỏi đã là tiếng Anh → BM25 dùng trực tiếp
    if not looks_vietnamese(cleaned):
        return cleaned

    resolved_key = (api_key or os.getenv("MISTRAL_API_KEY", "")).strip()
    if not resolved_key:
        return cleaned

    resolved_model = model or os.getenv("RAG_TRANSLATION_MODEL", "mistral-small-latest")
    api_url = os.getenv(
        "MISTRAL_API_URL",
        "https://api.mistral.ai/v1/chat/completions",
    )

    # Prompt ngắn, yêu cầu CHỈ trả bản dịch (không giải thích)
    prompt = (
        "Translate the following Vietnamese health/wellness question into concise English "
        "for searching WHO medical publications. Return ONLY the English translation, "
        "no explanation.\n\n"
        f"Question: {cleaned}"
    )

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
                "temperature": 0.0,
                "max_tokens": 128,
            },
            timeout=timeout,
        )
        response.raise_for_status()
        translated = response.json()["choices"][0]["message"]["content"].strip()
        return translated or cleaned
    except Exception as exc:
        # Fail-safe: pipeline vẫn chạy với query gốc
        print(f"⚠️ Query translation failed, using original query: {exc}")
        return cleaned
