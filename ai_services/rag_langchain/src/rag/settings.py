"""
settings.py — Cấu hình tập trung cho pipeline RAG.

Đọc biến môi trường từ rag_langchain/.env để chọn chế độ retrieval:

  RAG_MODE=standard  → RAG cũ (Chroma + similarity), mặc định, KHÔNG đổi hành vi production.
  RAG_MODE=advanced  → Hybrid (dense + BM25) + Fusion (RRF) + Reranker (CrossEncoder).

Khi advanced + có ELASTICSEARCH_URL: đọc corpus WHO từ OpenSearch/Elasticsearch.
Khi advanced + không có ES: fallback hybrid trên PDF local (Chroma + BM25 in-memory).
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv

import sys
from pathlib import Path as _Path

# Cho phép import common.es_client từ ai_services/
_AI_SERVICES_ROOT = _Path(__file__).resolve().parents[3]
if str(_AI_SERVICES_ROOT) not in sys.path:
    sys.path.insert(0, str(_AI_SERVICES_ROOT))

from common.es_client import normalize_elasticsearch_url

# Luôn load .env từ thư mục gốc rag_langchain (không phụ thuộc cwd khi chạy uvicorn)
_ENV_PATH = Path(__file__).resolve().parents[2] / ".env"
load_dotenv(_ENV_PATH)


def _env_bool(name: str, default: bool = False) -> bool:
    """Chuyển chuỗi env ('true'/'1'/'yes') thành bool."""
    raw = os.getenv(name)
    if raw is None:
        return default
    return raw.strip().lower() in {"1", "true", "yes", "on"}


def _env_float(name: str, default: float) -> float:
    raw = os.getenv(name)
    if raw is None or not raw.strip():
        return default
    return float(raw)


def _env_int(name: str, default: int) -> int:
    raw = os.getenv(name)
    if raw is None or not raw.strip():
        return default
    return int(raw)


@dataclass(frozen=True)
class RagSettings:
    """
    Snapshot cấu hình RAG tại thời điểm khởi động service.
    frozen=True → không sửa nhầm sau khi load.
    """

    # --- Chế độ RAG ---
    mode: str = "standard"  # standard | advanced

    # --- Retrieval ---
    top_k: int = 10  # Số chunk lấy sau fusion (trước rerank)
    rerank_top_n: int = 5  # Số chunk giữ lại sau CrossEncoder reranker
    hybrid_dense_weight: float = 0.5  # Trọng số nhánh embedding (local EnsembleRetriever)
    hybrid_sparse_weight: float = 0.5  # Trọng số nhánh BM25

    # --- Dịch query (cho BM25 trên tài liệu WHO tiếng Anh) ---
    query_translation_enabled: bool = True
    translation_model: str = "mistral-small-latest"  # Model nhỏ, rẻ, đủ cho dịch câu hỏi

    # --- Model embedding / reranker ---
    embedding_model: str = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
    reranker_model: str = "cross-encoder/ms-marco-MiniLM-L-6-v2"

    # --- Nguồn PDF local (standard mode hoặc advanced fallback) ---
    data_dir: str = "./data_source/generative_ai"
    chunk_size: int = 300  # Giữ như báo cáo cũ cho standard
    chunk_overlap: int = 0

    # --- Elasticsearch / AWS OpenSearch (advanced + corpus WHO) ---
    elasticsearch_url: str = ""
    elasticsearch_index: str = "healytics_who_chunks"
    elasticsearch_api_key: str = ""
    elasticsearch_username: str = ""
    elasticsearch_password: str = ""
    elasticsearch_verify_certs: bool = True

    @property
    def is_advanced(self) -> bool:
        """True nếu bật pipeline hybrid + fusion + rerank."""
        return self.mode.strip().lower() == "advanced"

    @property
    def elasticsearch_enabled(self) -> bool:
        """True nếu có URL cluster → dùng ES thay vì load PDF vào RAM."""
        return bool(self.elasticsearch_url.strip())


def load_rag_settings() -> RagSettings:
    """Factory: đọc toàn bộ biến RAG_* và ELASTICSEARCH_* từ môi trường."""
    return RagSettings(
        mode=os.getenv("RAG_MODE", "standard").strip().lower(),
        top_k=_env_int("RAG_TOP_K", 10),
        rerank_top_n=_env_int("RAG_RERANK_TOP_N", 5),
        hybrid_dense_weight=_env_float("RAG_HYBRID_DENSE_WEIGHT", 0.5),
        hybrid_sparse_weight=_env_float("RAG_HYBRID_SPARSE_WEIGHT", 0.5),
        query_translation_enabled=_env_bool("RAG_QUERY_TRANSLATION_ENABLED", True),
        translation_model=os.getenv("RAG_TRANSLATION_MODEL", "mistral-small-latest"),
        embedding_model=os.getenv(
            "RAG_EMBEDDING_MODEL",
            "sentence-transformers/paraphrase-multilingual-mpnet-base-v2",
        ),
        reranker_model=os.getenv(
            "RAG_RERANKER_MODEL",
            "cross-encoder/ms-marco-MiniLM-L-6-v2",
        ),
        data_dir=os.getenv("RAG_DATA_DIR", "./data_source/generative_ai"),
        chunk_size=_env_int("RAG_CHUNK_SIZE", 300),
        chunk_overlap=_env_int("RAG_CHUNK_OVERLAP", 0),
        elasticsearch_url=normalize_elasticsearch_url(
            os.getenv("ELASTICSEARCH_URL", "")
        ),
        elasticsearch_index=os.getenv("ELASTICSEARCH_INDEX", "healytics_who_chunks").strip(),
        elasticsearch_api_key=os.getenv("ELASTICSEARCH_API_KEY", "").strip(),
        elasticsearch_username=os.getenv("ELASTICSEARCH_USERNAME", "").strip(),
        elasticsearch_password=os.getenv("ELASTICSEARCH_PASSWORD", "").strip(),
        elasticsearch_verify_certs=_env_bool("ELASTICSEARCH_VERIFY_CERTS", True),
    )
