import os
import torch

# Cấu hình chung
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(BASE_DIR, "data")
RAW_DATA_DIR = os.path.join(DATA_DIR, "raw")
PROCESSED_DATA_DIR = os.path.join(DATA_DIR, "processed")

# Tạo thư mục nếu chưa có
os.makedirs(RAW_DATA_DIR, exist_ok=True)
os.makedirs(PROCESSED_DATA_DIR, exist_ok=True)

# Cấu hình model
EMBEDDING_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

# Cấu hình vector database
VECTOR_DB_TYPE = "chroma"  # hoặc "faiss"
COLLECTION_NAME = "health_services"

# Cấu hình recommender
TOP_K_RESULTS = 5
SIMILARITY_THRESHOLD = 0.2 

# File paths
SERVICES_JSON_PATH = os.path.join(RAW_DATA_DIR, "services.json")
SERVICES_EMBEDDED_PATH = os.path.join(PROCESSED_DATA_DIR, "services_embedded.pkl")
VECTOR_DB_PATH = os.path.join(PROCESSED_DATA_DIR, "vectordb")