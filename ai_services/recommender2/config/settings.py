"""
config/settings.py

Application constants and environment-driven settings.
Values that must differ per environment (DB credentials, etc.)
are loaded from a .env file via python-dotenv.
"""

import os

from dotenv import load_dotenv

# Load .env from the project root (recommender2/)
load_dotenv(dotenv_path=os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    ".env",
))

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Data directories
DATA_DIR = os.path.join(BASE_DIR, "data")
PROCESSED_DATA_DIR = os.path.join(DATA_DIR, "processed")
RAW_DATA_DIR = os.path.join(DATA_DIR, "raw")
SERVICE_JSON_PATH = os.path.join(RAW_DATA_DIR, "services.json")

# Embedding model
EMBEDDING_MODEL_NAME = (
    "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
)  # 768 dimensions

# Recommender tuning
TOP_K_CHATBOT_RESULTS = 3
TOP_K_HOME_RESULTS = 2
SIMILARITY_THRESHOLD = 0.2

# Vector-DB collection name
DATABASE_NAME = "healytics_collection"

# ------------------------------------------------------------------
# Relational DB — async DSN for asyncpg driver
# ------------------------------------------------------------------
DATABASE_URL: str = os.environ["DATABASE_URL"]
REDIS_URL: str = os.environ.get("REDIS_URL", "")


