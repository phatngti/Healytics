"""
app/core/config.py

Application settings loaded from environment variables.
Uses pydantic-settings so every field can be overridden
via a .env file or real env vars at runtime.
"""

import os

from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(BASE_DIR, ".env")

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        # Use absolute path so running uvicorn from any cwd still loads gateway-service/.env
        env_file=ENV_PATH,
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
    CHATBOT_SERVICE_URL: str = "http://chatbot-service:5000"
    RECOMMENDER_SERVICE_URL: str = "http://recommender-service:8000"
    NER_SERVICE_URL: str = "http://ner-service:7000"

    # ------------------------------------------------------------------
    # Backend API (public) for enriching service details
    # ------------------------------------------------------------------
    BACKEND_BASE_URL: str = "https://healytics.me"
    AI_API_KEY: str = ""
    AI_API_KEY_HEADER: str = "X-AI-API-Key"

    # ------------------------------------------------------------------
    # HTTP client timeouts (seconds)
    # ------------------------------------------------------------------
    HTTP_CONNECT_TIMEOUT: float = 5.0
    HTTP_READ_TIMEOUT: float = 60.0
    HTTP_WRITE_TIMEOUT: float = 10.0
    HTTP_POOL_TIMEOUT: float = 5.0


settings = Settings()