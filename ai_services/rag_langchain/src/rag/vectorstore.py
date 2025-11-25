#vectortore.py
import torch
from typing import Union # Hỗ trợ type hint
from langchain_chroma import Chroma #Vector databse nhẹ, dùng khi lưu trữ local RAG
from langchain_community.vectorstores import FAISS # Vector database mạnh hơn, tìm kiếm cosine
from langchain_community.embeddings import HuggingFaceEmbeddings

class  VectorDB:
    def __init__(self, documents = None, vector_db: Union[Chroma, FAISS] = Chroma, embedding = HuggingFaceEmbeddings(model_kwargs={'device': 'cuda'})) -> None:
        self.vectordb = vector_db # Loại database vector (FAISS || Chroma)
        self.embedding = embedding # Lưu lại mô hình dùng để mã hóa văn bản
        self.db = self._build_db(documents)

    def _build_db(self, documents):
        db = self.vectordb.from_documents(documents=documents, embedding=self.embedding)

        return db
    
    def get_retriever(self, search_type: str = "similarity", search_kwargs: dict = {"k": 10}):
        retriever = self.db.as_retriever(search_type=search_type, search_kwargs=search_kwargs)
        return retriever