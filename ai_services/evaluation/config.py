import os

EVAL_DIR = os.path.dirname(os.path.abspath(__file__))
try:
    from dotenv import load_dotenv

    load_dotenv(os.path.join(EVAL_DIR, ".env"))
except Exception:
    pass

# =========================
# Paths
# =========================
DATASET_PATH = os.getenv(
    "EVAL_DATASET_PATH",
    os.path.join(EVAL_DIR, "data", "eval_dataset.json"),
)


# =========================
# Retriever config
# =========================

TOP_K = int(os.getenv("TOP_K", "10"))
VECTORSTORE_BACKEND = os.getenv("VECTORSTORE_BACKEND", "chroma").lower()  # "chroma" | "faiss"
EMBEDDING_DEVICE = os.getenv("EMBEDDING_DEVICE", "cuda")  # "cuda" | "cpu"


# =========================
# LLM config (Generator + Judge)
# =========================

MODE = os.getenv("MODE", "local").lower()  # "local" | "runpod"
# Generator: Llama 3B local HF (khớp default trong rag_langchain/src/base/llm_model.py) hoặc endpoint qua MODE=runpod
MODEL_NAME = os.getenv("MODEL_NAME", "meta-llama/Llama-3.2-3B-Instruct")

# OpenAI-compatible endpoint (RunPod / local vLLM / etc.)
BASE_URL = os.getenv("BASE_URL", "http://localhost:8000/v1")
API_KEY = os.getenv("API_KEY", "EMPTY")

TEMPERATURE = float(os.getenv("TEMPERATURE", "0.2"))
MAX_NEW_TOKENS = int(os.getenv("MAX_NEW_TOKENS", "512"))

# Judge: Mistral API (REST tương thích OpenAI — cùng kiểu gọi với fusion_ragGH / Mistral SDK)
JUDGE_BACKEND = os.getenv("JUDGE_BACKEND", "mistral").lower()  # "mistral" | "same"
MISTRAL_API_KEY = os.getenv("MISTRAL_API_KEY", "")
MISTRAL_BASE_URL = os.getenv("MISTRAL_BASE_URL", "https://api.mistral.ai/v1")
JUDGE_MODEL = os.getenv("JUDGE_MODEL", "mistral-large-latest")
JUDGE_TEMPERATURE = float(os.getenv("JUDGE_TEMPERATURE", "0.45"))
JUDGE_MAX_TOKENS = int(os.getenv("JUDGE_MAX_TOKENS", "512"))


# =========================
# Runtime
# =========================

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
SEED = int(os.getenv("SEED", "42"))
