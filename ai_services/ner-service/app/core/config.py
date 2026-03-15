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
    DATABASE_URL: str = "postgresql+asyncpg://admin:admin%40123@localhost:5432/mydb"

    # ------------------------------------------------------------------
    # Downstream microservice base URLs
    # ------------------------------------------------------------------
    # NOTE: Dùng khi cần fallback fetching, giờ ưu tiên DB direct
    BACKEND_API_URL: str = "http://localhost:3000/api"

    # ------------------------------------------------------------------
    # Cache Configuration (TTL in seconds)
    # ------------------------------------------------------------------
    LOCATION_CACHE_TTL: int = 3600    # 1 hour
    CATEGORY_CACHE_TTL: int = 3600    # 1 hour
    QUERY_CACHE_MAXSIZE: int = 1000   # Max LRU size for parsed entities

    # ------------------------------------------------------------------
    # Spatial/PostGIS Configuration
    # ------------------------------------------------------------------
    ENABLE_SPATIAL_QUERIES: bool = True                # Feature flag for PostGIS spatial queries
    DEFAULT_PROXIMITY_RADIUS_M: int = 5000             # Default radius for "gần đây" (implicit ~15-20 phút xe máy)
    MAX_PROXIMITY_RADIUS_M: int = 50000                # Max allowed radius for DDoS protection
    POSTGIS_FALLBACK_TO_TEXT: bool = True              # Fallback to text-only query if PostGIS fails

settings = Settings()
