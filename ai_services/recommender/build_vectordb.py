
import sys
import os

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

from src.recommender.service_loader import ServiceLoader
from src.recommender.embedding_model import EmbeddingModel
from src.recommender.vectorstore import VectorDB
from config.settings import SERVICES_JSON_PATH, VECTOR_DB_PATH

def build_vector_database():
    """Build vector database từ services data"""
    
    print("=" * 60)
    print("BẮT ĐẦU XÂY DỰNG VECTOR DATABASE")
    print("=" * 60)
    
    # Step 1: Load services
    print("\n[1/3] Đang load services...")
    service_loader = ServiceLoader(SERVICES_JSON_PATH)
    services = service_loader.load_services()
    print(f"  Đã load {len(services)} services")
    
    # Step 2: Convert to texts and metadata
    print("\n[2/3] Đang chuyển đổi services thành texts...")
    texts, metadatas, ids = service_loader.services_to_texts_and_metadata()
    print(f"  Đã tạo {len(texts)} texts")
    
    # Sample
    print("\nVí dụ text đầu tiên:")
    print(f"Content: {texts[0][:200]}...")
    print(f"Metadata: {metadatas[0]}")
    print(f"ID: {ids[0]}")
    
    # Step 3: Build vector database
    print("\n[3/3] Đang xây dựng vector database...")
    embedding_model = EmbeddingModel()
    vectordb = VectorDB(embedding_model=embedding_model)
    vectordb.build_db(texts=texts, metadatas=metadatas, ids=ids)
    
    print("\n" + "=" * 60)
    print("  HOÀN THÀNH XÂY DỰNG VECTOR DATABASE")
    print(f"  Vector database đã được lưu tại: {VECTOR_DB_PATH}")
    print("=" * 60)
    
    return vectordb

if __name__ == "__main__":
    # Kiểm tra file services.json có tồn tại không
    if not os.path.exists(SERVICES_JSON_PATH):
        print(f"Không tìm thấy file: {SERVICES_JSON_PATH}")
        print("Vui lòng chạy: python create_sample_data.py trước")
        sys.exit(1)
    
    build_vector_database()