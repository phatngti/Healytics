"""
elasticsearch_retriever.py — Retriever hybrid đọc từ Elasticsearch / AWS OpenSearch.

Dùng khi:
  - RAG_MODE=advanced
  - Đã ingest corpus WHO qua who_ingestion pipeline

Kiến trúc retrieval cho MỘT truy vấn (trong index healytics_who_chunks):
  1. Dense search: kNN trên field `embedding` (768 chiều, cosine)
  2. Sparse search: BM25 multi_match trên content_en, title, content
  3. Fusion: Reciprocal Rank Fusion (RRF) gộp 2 danh sách

Multi-query fusion và CrossEncoder rerank nằm ở retriever_factory.py.

Lưu ý:
  - sparse_query thường là bản dịch EN (do ElasticsearchQueryAwareRetriever set)
  - dense query giữ nguyên tiếng Việt (embedding đa ngôn ngữ xử lý được)
"""

from __future__ import annotations

from typing import Any, List, Sequence

from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from pydantic import Field

from src.rag.settings import RagSettings


def _rrf_fuse(
    ranked_lists: Sequence[Sequence[str]],
    *,
    k: int = 60,
    top_n: int,
) -> List[str]:
    """
    Reciprocal Rank Fusion — gộp nhiều danh sách xếp hạng thành một.

    Công thức: score(doc) += 1 / (k + rank)
    - k=60 là hằng số chuẩn trong literatue RRF
    - Doc xuất hiện cao ở CẢ dense lẫn sparse → điểm cao hơn
    """
    scores: dict[str, float] = {}
    for ranked in ranked_lists:
        for rank, doc_id in enumerate(ranked, start=1):
            scores[doc_id] = scores.get(doc_id, 0.0) + 1.0 / (k + rank)
    ordered = sorted(scores.items(), key=lambda item: item[1], reverse=True)
    return [doc_id for doc_id, _ in ordered[:top_n]]


class ElasticsearchHybridRetriever(BaseRetriever):
    """
    Retriever LangChain tương thích, backend là Elasticsearch.

    sparse_query: query riêng cho BM25 (thường là tiếng Anh sau dịch).
    Nếu rỗng → dùng cùng query với dense.
    """

    settings: RagSettings = Field(...)
    embedding_model: Any = Field(default=None, exclude=True)
    sparse_query: str = ""

    class Config:
        arbitrary_types_allowed = True

    def _get_client(self):
        """Tạo ES client — IAM / basic auth / API key qua common/es_client.py."""
        import os
        import sys
        from pathlib import Path

        ai_services_root = Path(__file__).resolve().parents[3]
        if str(ai_services_root) not in sys.path:
            sys.path.insert(0, str(ai_services_root))

        from common.es_client import build_elasticsearch_client

        return build_elasticsearch_client(
            url=self.settings.elasticsearch_url,
            api_key=self.settings.elasticsearch_api_key,
            username=self.settings.elasticsearch_username,
            password=self.settings.elasticsearch_password,
            verify_certs=self.settings.elasticsearch_verify_certs,
            aws_region=os.getenv("AWS_REGION", "ap-southeast-1"),
            aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID", ""),
            aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY", ""),
        )

    def _embed_query(self, query: str) -> List[float]:
        """Embed câu hỏi người dùng → vector 768 chiều cho kNN."""
        if self.embedding_model is None:
            from langchain_community.embeddings import HuggingFaceEmbeddings
            from src.rag.vectorstore import _resolve_embedding_device

            device = _resolve_embedding_device()
            self.embedding_model = HuggingFaceEmbeddings(
                model_name=self.settings.embedding_model,
                model_kwargs={"device": device},
            )
        return self.embedding_model.embed_query(query)

    _SOURCE_FIELDS = [
        "chunk_id", "doc_id", "title", "domain", "content", "content_en", "source_url",
    ]

    def _dense_search(self, client, query: str, fetch_k: int) -> List[dict]:
        """
        Tìm kiếm vector (semantic) trên field embedding.

        Cú pháp kNN của OpenSearch (khác Elasticsearch):
          query.knn.<field>.{vector, k}
        """
        vector = self._embed_query(query)
        body = {
            "size": fetch_k,
            "_source": self._SOURCE_FIELDS,
            "query": {
                "knn": {
                    "embedding": {
                        "vector": vector,
                        "k": fetch_k,
                    }
                }
            },
        }
        response = client.search(index=self.settings.elasticsearch_index, body=body)
        return response.get("hits", {}).get("hits", [])

    def _sparse_search(self, client, query: str, fetch_k: int) -> List[dict]:
        """Tìm kiếm từ khóa BM25 — ưu tiên content_en (tiếng Anh)."""
        body = {
            "size": fetch_k,
            "_source": self._SOURCE_FIELDS,
            "query": {
                "multi_match": {
                    "query": query,
                    "fields": ["content_en^2", "title^1.5", "content"],
                    "type": "best_fields",
                }
            },
        }
        response = client.search(index=self.settings.elasticsearch_index, body=body)
        return response.get("hits", {}).get("hits", [])

    def _hit_to_document(self, hit: dict) -> Document:
        """Chuyển ES hit → LangChain Document (offline_rag.format_docs đọc page_content)."""
        source = hit.get("_source", {})
        chunk_id = source.get("chunk_id") or hit.get("_id", "")
        content = source.get("content_en") or source.get("content") or ""
        metadata = {
            "doc_id": source.get("doc_id", chunk_id),
            "chunk_id": chunk_id,
            "title": source.get("title", ""),
            "domain": source.get("domain", ""),
            "source_url": source.get("source_url", ""),
            "retrieval_source": "elasticsearch",
        }
        return Document(page_content=content, metadata=metadata)

    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: CallbackManagerForRetrieverRun | None = None,
    ) -> List[Document]:
        """
        Entry point LangChain: query → danh sách Document sau hybrid + RRF.

        fetch_k = top_k * 2 để fusion có đủ ứng viên trước khi cắt top_k.
        """
        client = self._get_client()
        fetch_k = max(self.settings.top_k * 2, 20)

        # Nhánh 1: dense — query gốc (có thể tiếng Việt)
        dense_hits = self._dense_search(client, query, fetch_k)

        # Nhánh 2: sparse — query tiếng Anh (sparse_query do lớp ngoài set)
        sparse_query = self.sparse_query or query
        sparse_hits = self._sparse_search(client, sparse_query, fetch_k)

        dense_ids = [
            (hit.get("_source", {}).get("chunk_id") or hit.get("_id", ""))
            for hit in dense_hits
        ]
        sparse_ids = [
            (hit.get("_source", {}).get("chunk_id") or hit.get("_id", ""))
            for hit in sparse_hits
        ]

        # Gộp 2 ranking bằng RRF
        fused_ids = _rrf_fuse([dense_ids, sparse_ids], top_n=self.settings.top_k)

        # Map id → hit để lấy nội dung đầy đủ
        hit_map: dict[str, dict] = {}
        for hit in dense_hits + sparse_hits:
            chunk_id = hit.get("_source", {}).get("chunk_id") or hit.get("_id", "")
            hit_map[chunk_id] = hit

        documents: List[Document] = []
        for chunk_id in fused_ids:
            hit = hit_map.get(chunk_id)
            if hit:
                documents.append(self._hit_to_document(hit))
        return documents
