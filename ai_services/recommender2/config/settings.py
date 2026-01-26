import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Data Direction
DATA_DIR = os.path.join(BASE_DIR, "data")
PROCESSED_DATA_DIR = os.path.join(DATA_DIR, "processed")
RAW_DATA_DIR = os.path.join(DATA_DIR, "raw")
SERVICE_JSON_PATH = os.path.join(RAW_DATA_DIR, "services.json")

# Config model
EMBEDDING_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2" # 768 dimensions

# Cấu hình recommender
TOP_K_CHATBOT_RESULTS = 3
TOP_K_HOME_RESULTS = 2
SIMILARITY_THRESHOLD = 0.2 

# Cấu hình database
DATABASE_NAME = "healytics_collection"

