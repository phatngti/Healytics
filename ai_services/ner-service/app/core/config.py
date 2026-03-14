"""
ai_services/ner-service/app/core/config.py

Application settings loaded from environment variables.
"""

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # ------------------------------------------------------------------
    # Backend API (for loading categories + locations into cache)
    # ------------------------------------------------------------------
    BACKEND_API_URL: str = "http://localhost:3000"

    # ------------------------------------------------------------------
    # Cache TTLs (seconds)
    # ------------------------------------------------------------------
    LOCATION_CACHE_TTL: int = 86400     # 24h — địa giới ít thay đổi
    CATEGORY_CACHE_TTL: int = 300       # 5 phút — admin thêm mới thường xuyên hơn
    QUERY_CACHE_MAXSIZE: int = 512      # LRU eviction cho query cache

    # ------------------------------------------------------------------
    # Service
    # ------------------------------------------------------------------
    PORT: int = 8002


settings = Settings()
