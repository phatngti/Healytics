"""
app/core/config.py

Application settings loaded from environment variables.
Uses pydantic-settings so every field can be overridden
via a .env file or real env vars at runtime.
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
    # Database
    # ------------------------------------------------------------------
    # Async DSN required: postgresql+asyncpg://user:pass@host:port/db
    DATABASE_URL: str

    # ------------------------------------------------------------------
    # Downstream microservice base URLs
    # ------------------------------------------------------------------
    CHATBOT_SERVICE_URL: str = "http://chatbot-service:8001"
    NER_SERVICE_URL: str = "http://ner-service:8002"
    RECOMMENDER_SERVICE_URL: str = "http://recommender-service:8003"

    # ------------------------------------------------------------------
    # HTTP client timeouts (seconds)
    # ------------------------------------------------------------------
    HTTP_CONNECT_TIMEOUT: float = 5.0
    HTTP_READ_TIMEOUT: float = 60.0
    HTTP_WRITE_TIMEOUT: float = 10.0
    HTTP_POOL_TIMEOUT: float = 5.0


settings = Settings()