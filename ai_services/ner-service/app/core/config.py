from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Database
    DATABASE_URL: str = "postgresql+asyncpg://admin:admin%40123@localhost:5432/mydb"

    # Backend/API base URL
    BACKEND_API_URL: str = "http://localhost:3000/api"

    # Cache
    LOCATION_CACHE_TTL: int = 3600
    CATEGORY_CACHE_TTL: int = 3600
    QUERY_CACHE_MAXSIZE: int = 1000

    # Spatial/PostGIS
    ENABLE_SPATIAL_QUERIES: bool = True
    DEFAULT_PROXIMITY_RADIUS_M: int = 5000
    MAX_PROXIMITY_RADIUS_M: int = 50000
    POSTGIS_FALLBACK_TO_TEXT: bool = True

    # Location intent gating
    LOCATION_INTENT_THRESHOLD: float = 0.58
    LOCATION_INTENT_LOG_ENABLED: bool = True
    LOCATION_INTENT_LOG_PATH: str = "data/intent_logs/location_intent.jsonl"

    # Unified semantic thresholds
    SEMANTIC_BT_HIGH_THRESHOLD: float = 0.60
    SEMANTIC_BT_MEDIUM_THRESHOLD: float = 0.50
    SEMANTIC_CATEGORY_HIGH_THRESHOLD: float = 0.60
    SEMANTIC_CATEGORY_MEDIUM_THRESHOLD: float = 0.50
    SEMANTIC_TAG_HIGH_THRESHOLD: float = 0.80
    SEMANTIC_TAG_MEDIUM_THRESHOLD: float = 0.72

    # LLM NER (Gemini)
    LLM_NER_ENABLED: bool = True
    GEMINI_API_KEY: str = ""
    GEMINI_MODEL: str = "gemini-2.5-flash"
    GEMINI_API_BASE_URL: str = "https://generativelanguage.googleapis.com/v1beta"
    GEMINI_TIMEOUT_MS: int = 1500
    GEMINI_MAX_RETRIES: int = 1
    GEMINI_RETRY_BACKOFF_MS: int = 400
    GEMINI_COOLDOWN_SECONDS: int = 30


settings = Settings()
