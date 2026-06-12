#main.py — Điểm lắp ráp pipeline RAG
from pydantic import BaseModel, Field
from src.rag.file_loader import Loader
from src.rag.offline_rag import Offline_RAG
from src.rag.retriever_factory import build_retriever
from src.rag.settings import load_rag_settings


class InputQA(BaseModel):
    question: str = Field(..., title=" Question to ask the model")


class OutputQA(BaseModel):
    answer: str = Field(..., title="Answer from the model")


def build_rag_chain(llm, data_dir, data_type):
    """
    Xây dựng toàn bộ chain RAG.

    Thay đổi so với bản cũ:
      - Đọc RAG_MODE từ .env (standard | advanced)
      - Chỉ load PDF local khi CẦN (standard, hoặc advanced không có ES)
      - Khi advanced + ES: bỏ qua bước load PDF → đọc trực tiếp từ OpenSearch

    Phần KHÔNG đổi:
      - offline_rag.Offline_RAG (prompt, format_docs, chain LCEL)
      - API app.py (history, services, question)
    """
    settings = load_rag_settings()
    resolved_dir = data_dir or settings.data_dir

    doc_loaded = None

    # Chỉ đọc PDF vào RAM khi không dùng ES làm nguồn tri thức chính
    need_local_pdfs = not settings.is_advanced or not settings.elasticsearch_enabled
    if need_local_pdfs:
        doc_loaded = Loader(
            file_type=data_type,
            split_kwargs={
                "chunk_size": settings.chunk_size,
                "chunk_overlap": settings.chunk_overlap,
            },
        ).load_dir(resolved_dir, workers=2)

    retriever = build_retriever(documents=doc_loaded, settings=settings)
    rag_chain = Offline_RAG(llm).get_chain(retriever)

    return rag_chain
