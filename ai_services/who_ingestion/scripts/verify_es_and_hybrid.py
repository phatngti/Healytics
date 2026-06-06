#!/usr/bin/env python3
"""
Kiểm tra dữ liệu trên OpenSearch + hybrid search (BM25 + kNN + RRF).

Chạy: cd ai_services && python who_ingestion/scripts/verify_es_and_hybrid.py
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

AI_SERVICES = Path(__file__).resolve().parents[2]
RAG_ROOT = AI_SERVICES / "rag_langchain"
sys.path.insert(0, str(AI_SERVICES))
sys.path.insert(0, str(RAG_ROOT))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES / "who_ingestion" / ".env")
load_dotenv(RAG_ROOT / ".env")

from common.es_client import build_elasticsearch_client


def _client():
    return build_elasticsearch_client(
        url=os.getenv("ELASTICSEARCH_URL", ""),
        username=os.getenv("ELASTICSEARCH_USERNAME", ""),
        password=os.getenv("ELASTICSEARCH_PASSWORD", ""),
        verify_certs=os.getenv("ELASTICSEARCH_VERIFY_CERTS", "true").lower() == "true",
    )


def main() -> None:
    index = os.getenv("ELASTICSEARCH_INDEX", "healytics_who_chunks")
    es = _client()

    print("=== 1. Kiểm tra dữ liệu trên OpenSearch ===\n")
    count = es.count(index=index)["count"]
    print(f"Index: {index}")
    print(f"Tổng chunk: {count}")
    if count == 0:
        print("❌ Chưa có dữ liệu — chạy pipeline trước.")
        raise SystemExit(1)
    print("✅ Có dữ liệu trên OpenSearch\n")

    print("=== 2. BM25 (sparse) ===\n")
    bm25 = es.search(
        index=index,
        body={
            "size": 3,
            "_source": ["title", "domain", "chunk_id"],
            "query": {
                "multi_match": {
                    "query": "diabetes nutrition prevention",
                    "fields": ["content_en^2", "title^1.5"],
                }
            },
        },
    )
    for hit in bm25["hits"]["hits"]:
        src = hit["_source"]
        print(f"  score={hit['_score']:.2f} | {src.get('title', '')[:70]}")

    print("\n=== 3. Hybrid RAG retriever (dense + sparse + RRF) ===\n")
    rag_mode = os.getenv("RAG_MODE", "standard")
    print(f"RAG_MODE hiện tại: {rag_mode}")
    if rag_mode.strip().lower() != "advanced":
        print("⚠️  Chatbot vẫn dùng standard cho đến khi đặt RAG_MODE=advanced trong rag_langchain/.env")

    os.environ.setdefault("RAG_MODE", "advanced")
    from src.rag.settings import load_rag_settings
    from src.rag.elasticsearch_retriever import ElasticsearchHybridRetriever

    settings = load_rag_settings()
    retriever = ElasticsearchHybridRetriever(
        settings=settings,
        sparse_query="diabetes nutrition prevention",
    )
    docs = retriever.invoke("làm sao phòng ngừa bệnh tiểu đường?")
    print(f"Hybrid trả về {len(docs)} chunk:")
    for i, doc in enumerate(docs[:5], 1):
        title = doc.metadata.get("title", "")[:60]
        preview = doc.page_content[:120].replace("\n", " ")
        print(f"  [{i}] {title}")
        print(f"      {preview}...")

    print("\n✅ Hybrid search hoạt động — sẵn sàng cho RAG advanced.")
    print("\nBật chatbot hybrid: rag_langchain/.env → RAG_MODE=advanced → restart service")


if __name__ == "__main__":
    main()
