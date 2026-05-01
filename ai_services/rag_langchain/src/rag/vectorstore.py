#vectortore.py
import os
import torch
from pathlib import Path
from typing import Union # Hỗ trợ type hint
from dotenv import load_dotenv
from langchain_chroma import Chroma #Vector databse nhẹ, dùng khi lưu trữ local RAG
from langchain_community.vectorstores import FAISS # Vector database mạnh hơn, tìm kiếm cosine
from langchain_community.embeddings import HuggingFaceEmbeddings

ENV_PATH = Path(__file__).resolve().parents[2] / ".env"
load_dotenv(ENV_PATH)


def _resolve_embedding_device() -> str:
    """
    Resolve embedding device safely for both GPU and CPU-only deployments.

    EMBEDDING_DEVICE options:
      - auto (default): use cuda if available, otherwise cpu
      - cuda: force cuda, but fallback to cpu if cuda is unavailable
      - cpu: force cpu
    """
    configured_device = os.getenv("EMBEDDING_DEVICE", "auto").strip().lower()
    cuda_available = torch.cuda.is_available()

    if configured_device in {"", "auto"}:
        return "cuda" if cuda_available else "cpu"

    if configured_device == "cuda" and not cuda_available:
        print("⚠️ EMBEDDING_DEVICE=cuda but CUDA is not available; falling back to CPU.")
        return "cpu"

    if configured_device not in {"cuda", "cpu"}:
        print(f"⚠️ Invalid EMBEDDING_DEVICE={configured_device!r}; using auto.")
        return "cuda" if cuda_available else "cpu"

    return configured_device


def _build_embedding_model():
    device = _resolve_embedding_device()
    print("Embedding device:", device)
    return HuggingFaceEmbeddings(model_kwargs={"device": device})


class  VectorDB:
    def __init__(self, documents = None, vector_db: Union[Chroma, FAISS] = Chroma, embedding = None) -> None:
        self.vectordb = vector_db # Loại database vector (FAISS || Chroma)
        self.embedding = embedding or _build_embedding_model() # Lưu lại mô hình dùng để mã hóa văn bản
        self.db = self._build_db(documents)

    def _build_db(self, documents):
        db = self.vectordb.from_documents(documents=documents, embedding=self.embedding)

        return db
    
    def get_retriever(self, search_type: str = "similarity", search_kwargs: dict = {"k": 10}):
        retriever = self.db.as_retriever(search_type=search_type, search_kwargs=search_kwargs)
        return retriever