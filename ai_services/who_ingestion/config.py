"""
config.py — Cấu hình pipeline ingest tài liệu WHO.

Load từ who_ingestion/.env (ưu tiên) và rag_langchain/.env (chia sẻ MISTRAL, ES).

Xem HUONG_DAN_SETUP_AWS.md để biết cách lấy từng giá trị trên AWS Console.
"""

from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

from dotenv import load_dotenv

from common.es_client import normalize_elasticsearch_url

_ROOT = Path(__file__).resolve().parent
load_dotenv(_ROOT / ".env")
load_dotenv(_ROOT.parent / "rag_langchain" / ".env")


def _env_int(name: str, default: int) -> int:
    raw = os.getenv(name)
    if not raw or not raw.strip():
        return default
    return int(raw)


def _env_bool(name: str, default: bool = False) -> bool:
    raw = os.getenv(name)
    if raw is None:
        return default
    return raw.strip().lower() in {"1", "true", "yes", "on"}


@dataclass(frozen=True)
class WhoIngestionSettings:
    """Toàn bộ tham số crawl → S3 → chunk → Elasticsearch."""

    # --- Crawl WHO ---
    who_base_url: str = "https://www.who.int"
    who_publications_url: str = "https://www.who.int/publications/m"
    docs_per_domain: int = 50  # 50 × 4 domain = 200 tài liệu mục tiêu
    crawl_delay_seconds: float = 1.0  # Tránh bị WHO rate-limit
    crawl_timeout_seconds: float = 45.0
    crawl_retries: int = 3
    crawl_retry_backoff_seconds: float = 2.0
    crawl_max_pages_per_query: int = 15  # Số trang pagination mỗi nguồn/query
    crawl_user_agent: str = "HealyticsResearchBot/1.0 (+https://healytics.me)"
    who_hubs_api: str = "https://www.who.int/api/hubs/publications"
    who_iris_d7_api: str = "https://iris.who.int/server/api"
    who_iris_legacy_api: str = "https://apps.who.int/iris/rest"

    # --- Thư mục tạm trên máy chạy pipeline (PDF trước khi upload S3) ---
    staging_dir: str = "./data/staging/who"
    delete_local_after_ingest: bool = True  # Xóa PDF local sau khi index OpenSearch thành công

    # --- AWS S3 ---
    s3_bucket: str = ""
    s3_prefix: str = "who-publications/"  # Object key: prefix/domain/id/file.pdf
    aws_region: str = "ap-southeast-1"
    aws_access_key_id: str = ""
    aws_secret_access_key: str = ""
    s3_endpoint_url: str = ""  # Để trống với AWS S3 thật; điền nếu dùng MinIO

    # --- Chunk theo token (khác chunk_size=300 ký tự của RAG cũ) ---
    chunk_token_size: int = 256
    chunk_token_overlap: int = 32
    embedding_model: str = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
    embedding_dims: int = 768  # Phải khớp mapping dense_vector trong ES

    # --- Elasticsearch / AWS OpenSearch ---
    elasticsearch_url: str = ""
    elasticsearch_index: str = "healytics_who_chunks"
    elasticsearch_api_key: str = ""
    elasticsearch_username: str = ""
    elasticsearch_password: str = ""
    elasticsearch_verify_certs: bool = True
    elasticsearch_recreate_index: bool = False  # True = xóa index cũ rồi tạo mới
    # AWS OpenSearch 3-AZ: copies = shards×(1+replicas) phải chia hết cho 3
    elasticsearch_number_of_shards: int = 1
    elasticsearch_number_of_replicas: int = 2

    # --- Mistral (tùy chọn; WHO PDF đã là tiếng Anh nên content_en = content) ---
    mistral_api_key: str = ""
    mistral_model: str = "mistral-small-latest"

    @property
    def s3_enabled(self) -> bool:
        return bool(self.s3_bucket.strip())

    @property
    def elasticsearch_enabled(self) -> bool:
        return bool(self.elasticsearch_url.strip())


def load_settings() -> WhoIngestionSettings:
    """Đọc settings từ biến môi trường."""
    return WhoIngestionSettings(
        who_base_url=os.getenv("WHO_BASE_URL", "https://www.who.int").strip(),
        who_publications_url=os.getenv(
            "WHO_PUBLICATIONS_URL",
            "https://www.who.int/publications/m",
        ).strip(),
        docs_per_domain=_env_int("WHO_DOCS_PER_DOMAIN", 50),
        crawl_delay_seconds=float(os.getenv("WHO_CRAWL_DELAY_SECONDS", "1.0")),
        crawl_timeout_seconds=float(os.getenv("WHO_CRAWL_TIMEOUT_SECONDS", "45")),
        crawl_retries=_env_int("WHO_CRAWL_RETRIES", 3),
        crawl_retry_backoff_seconds=float(os.getenv("WHO_CRAWL_RETRY_BACKOFF_SECONDS", "2.0")),
        crawl_max_pages_per_query=_env_int("WHO_CRAWL_MAX_PAGES_PER_QUERY", 15),
        crawl_user_agent=os.getenv(
            "WHO_CRAWL_USER_AGENT",
            "HealyticsResearchBot/1.0 (+https://healytics.me)",
        ),
        who_hubs_api=os.getenv("WHO_HUBS_API", "https://www.who.int/api/hubs/publications").strip(),
        who_iris_d7_api=os.getenv("WHO_IRIS_D7_API", "https://iris.who.int/server/api").strip(),
        who_iris_legacy_api=os.getenv(
            "WHO_IRIS_LEGACY_API", "https://apps.who.int/iris/rest"
        ).strip(),
        staging_dir=os.getenv("WHO_STAGING_DIR", "./data/staging/who"),
        delete_local_after_ingest=_env_bool("WHO_DELETE_LOCAL_AFTER_INGEST", True),
        s3_bucket=os.getenv("S3_BUCKET", "").strip(),
        s3_prefix=os.getenv("S3_PREFIX", "who-publications/").strip(),
        aws_region=os.getenv("AWS_REGION", "ap-southeast-1").strip(),
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID", "").strip(),
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY", "").strip(),
        s3_endpoint_url=os.getenv("S3_ENDPOINT_URL", "").strip(),
        chunk_token_size=_env_int("WHO_CHUNK_TOKEN_SIZE", 256),
        chunk_token_overlap=_env_int("WHO_CHUNK_TOKEN_OVERLAP", 32),
        embedding_model=os.getenv(
            "RAG_EMBEDDING_MODEL",
            "sentence-transformers/paraphrase-multilingual-mpnet-base-v2",
        ),
        embedding_dims=_env_int("RAG_EMBEDDING_DIMS", 768),
        elasticsearch_url=normalize_elasticsearch_url(
            os.getenv("ELASTICSEARCH_URL", "")
        ),
        elasticsearch_index=os.getenv("ELASTICSEARCH_INDEX", "healytics_who_chunks").strip(),
        elasticsearch_api_key=os.getenv("ELASTICSEARCH_API_KEY", "").strip(),
        elasticsearch_username=os.getenv("ELASTICSEARCH_USERNAME", "").strip(),
        elasticsearch_password=os.getenv("ELASTICSEARCH_PASSWORD", "").strip(),
        elasticsearch_verify_certs=_env_bool("ELASTICSEARCH_VERIFY_CERTS", True),
        elasticsearch_recreate_index=_env_bool("ELASTICSEARCH_RECREATE_INDEX", False),
        elasticsearch_number_of_shards=_env_int("ELASTICSEARCH_NUMBER_OF_SHARDS", 1),
        elasticsearch_number_of_replicas=_env_int("ELASTICSEARCH_NUMBER_OF_REPLICAS", 2),
        mistral_api_key=os.getenv("MISTRAL_API_KEY", "").strip(),
        mistral_model=os.getenv("RAG_TRANSLATION_MODEL", "mistral-small-latest"),
    )
