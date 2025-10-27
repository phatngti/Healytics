#main.py
from pydantic import BaseModel, Field # Xác thực dữ liệu
from src.rag.file_loader import Loader
from src.rag.vectorstore import VectorDB
from src.rag.offline_rag import Offline_RAG

# Mô tả dữ liệu đầu vào
class InputQA(BaseModel):
    question: str = Field(..., title=" Question to ask the model") # Chỉ nhận chuỗi (string), ... là bắt buộc phải có giá trị

# Mô tả dữ liệu đầu ra
class OutputQA(BaseModel):
    answer: str = Field(..., title="Answer from the model")

# Xây dựng toàn bộ pipeline RAG
def build_rag_chain(llm, data_dir, data_type):
    doc_loaded = Loader(file_type=data_type).load_dir(data_dir, workers=2)
    retriever = VectorDB(documents = doc_loaded).get_retriever()
    rag_chain = Offline_RAG(llm).get_chain(retriever) # Điều phối pipeline RAG

    return rag_chain