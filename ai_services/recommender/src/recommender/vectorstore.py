import chromadb
from chromadb.config import Settings
import numpy as np
from typing import List, Dict, Tuple
from config.settings import VECTOR_DB_PATH, COLLECTION_NAME

class VectorDB:
    """Vector database cho services"""
    
    def __init__(self, embedding_model=None, persist_directory: str = VECTOR_DB_PATH):
        self.persist_directory = persist_directory
        self.embedding_model = embedding_model
        self.client = None
        self.collection = None
        
    def build_db(self, texts: List[str], metadatas: List[Dict], ids: List[str]):
        """Xây dựng vector database từ texts"""
        print(f"Đang xây dựng vector database với {len(texts)} services...")
        
        # Khởi tạo ChromaDB client
        self.client = chromadb.PersistentClient(path=self.persist_directory)
        
        # Tạo hoặc lấy collection
        try:
            self.collection = self.client.get_collection(name=COLLECTION_NAME)
            # Xóa collection cũ nếu có
            self.client.delete_collection(name=COLLECTION_NAME)
        except:
            pass
        
        self.collection = self.client.create_collection(
            name=COLLECTION_NAME,
            metadata={"hnsw:space": "cosine"}  # Dùng cosine similarity
        )
        
        # Embedding texts
        print("Đang embedding texts...")
        embeddings = self.embedding_model.embed_documents(texts)
        
        # Add to collection
        self.collection.add(
            embeddings=embeddings.tolist(),
            documents=texts,
            metadatas=metadatas,
            ids=ids
        )
        
        print("Đã xây dựng vector database thành công")
        return self
    
    def load_db(self):
        """Load vector database đã được persist"""
        print(f"Đang load vector database từ: {self.persist_directory}")
        
        self.client = chromadb.PersistentClient(path=self.persist_directory)
        self.collection = self.client.get_collection(name=COLLECTION_NAME)
        
        print("Đã load vector database thành công")
        return self
    
    def similarity_search(self, query: str, k: int = 5) -> List[Dict]:
        """
        Tìm kiếm similarity
        Returns: List of dicts với keys: id, document, metadata, distance
        """
        if self.collection is None:
            raise ValueError("Vector database chưa được khởi tạo. Hãy gọi build_db() hoặc load_db() trước.")
        
        # Embedding query
        query_embedding = self.embedding_model.embed_query(query)
        
        # Search
        results = self.collection.query(
            query_embeddings=[query_embedding.tolist()],
            n_results=k
        )
        
        # Format results
        formatted_results = []
        for i in range(len(results['ids'][0])):
            formatted_results.append({
                'id': results['ids'][0][i],
                'document': results['documents'][0][i],
                'metadata': results['metadatas'][0][i],
                'distance': results['distances'][0][i]
            })
        
        return formatted_results
    
    def similarity_search_with_score(self, query: str, k: int = 5) -> List[Tuple[Dict, float]]:
        """
        Tìm kiếm similarity với score
        Returns: List of tuples (metadata, score)
        """
        results = self.similarity_search(query, k)
        
        # Convert distance to similarity score (1 - distance)
        scored_results = []
        for result in results:
            score = 1 - result['distance']  # ChromaDB distance -> similarity
            scored_results.append((result, score))
        
        return scored_results