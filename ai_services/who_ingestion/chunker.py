"""
chunker.py — Chia văn bản WHO theo số token (tiktoken).

Khác RAG cũ (300 ký tự, overlap=0):
  - chunk_token_size=256, overlap=32 → giữ ngữ cảnh tốt hơn cho embedding
  - Mỗi chunk có metadata đầy đủ để index ES và debug
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import List

import tiktoken

from who_ingestion.config import WhoIngestionSettings


@dataclass
class WhoChunk:
    """Một đoạn text sẵn sàng bulk index vào Elasticsearch."""

    chunk_id: str  # Primary key trong ES (doc_id + index)
    doc_id: str  # ID publication WHO
    domain: str  # nutrition | physical_activity | ...
    title: str
    source_url: str  # Trang WHO gốc
    s3_key: str  # Đường dẫn PDF trên S3
    content: str  # Nội dung chunk (WHO = tiếng Anh)
    content_en: str  # Field riêng cho BM25 (hiện = content)
    token_count: int
    chunk_index: int  # Thứ tự chunk trong cùng 1 PDF


def _encoding():
    """Tokenizer cl100k_base — ổn định cho đếm token chunk."""
    try:
        return tiktoken.get_encoding("cl100k_base")
    except Exception:
        return tiktoken.encoding_for_model("gpt-4")


def chunk_text_by_tokens(
    text: str,
    *,
    doc_id: str,
    domain: str,
    title: str,
    source_url: str,
    s3_key: str,
    settings: WhoIngestionSettings,
    content_en: str | None = None,
) -> List[WhoChunk]:
    """
    Sliding window theo token: [0:256], [224:480], ...

    overlap giúp câu không bị cắt đôi ở ranh giới chunk.
    """
    cleaned = (text or "").strip()
    if not cleaned:
        return []

    encoder = _encoding()
    tokens = encoder.encode(cleaned)
    size = settings.chunk_token_size
    overlap = settings.chunk_token_overlap

    chunks: List[WhoChunk] = []
    start = 0
    index = 0

    while start < len(tokens):
        end = min(start + size, len(tokens))
        token_slice = tokens[start:end]
        content = encoder.decode(token_slice).strip()
        if content:
            chunk_id = f"{doc_id}_chunk_{index:04d}"
            chunks.append(
                WhoChunk(
                    chunk_id=chunk_id,
                    doc_id=doc_id,
                    domain=domain,
                    title=title,
                    source_url=source_url,
                    s3_key=s3_key,
                    content=content,
                    content_en=content_en or content,
                    token_count=len(token_slice),
                    chunk_index=index,
                )
            )
            index += 1
        if end >= len(tokens):
            break
        start = max(end - overlap, start + 1)

    return chunks
