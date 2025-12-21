import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from typing import Dict, List
from src.recommender.service_loader import ServiceLoader
from src.recommender.embedding_model import EmbeddingModel
from src.recommender.vectorstore import VectorDB
from src.recommender.chatbot_recommender import ChatbotRecommender
from config.settings import TOP_K_RESULTS

# Global instances (load một lần khi khởi động)
_service_loader = None
_vectordb = None
_chatbot_recommender = None

def _initialize():
    """Khởi tạo các components (gọi một lần khi import)"""
    global _service_loader, _vectordb, _chatbot_recommender
    
    if _chatbot_recommender is not None:
        return
    
    print("Đang khởi tạo Chatbot Recommender...")
    
    # Load service loader
    _service_loader = ServiceLoader()
    
    # Load embedding model và vector database
    embedding_model = EmbeddingModel()
    _vectordb = VectorDB(embedding_model=embedding_model)
    _vectordb.load_db()
    
    # Khởi tạo chatbot recommender
    _chatbot_recommender = ChatbotRecommender(_vectordb, _service_loader)
    
    print("Chatbot Recommender đã sẵn sàng")

def recommend_for_chatbot(query: str, top_k: int = TOP_K_RESULTS) -> Dict:
    """
    Hàm chính để backend gọi - Gợi ý services từ query chatbot
    
    Pipeline: Query -> Embedding -> Search Vector DB -> Top-K Services
    
    Args:
        query: Câu hỏi/yêu cầu từ người dùng
        top_k: Số lượng services gợi ý
    
    Returns:
        {
            "query": "...",
            "recommendations": [...],
            "total": 3
        }
    """
    # Khởi tạo nếu chưa có
    _initialize()
    
    try:
        # Validate query
        if not query or not query.strip():
            return {
                "query": query,
                "error": "Query không được để trống",
                "recommendations": [],
                "total": 0
            }
        
        # Gọi chatbot recommender
        recommendations = _chatbot_recommender.recommend(
            query=query,
            top_k=top_k
        )
        
        return {
            "query": query,
            "recommendations": recommendations,
            "total": len(recommendations)
        }
    
    except Exception as e:
        return {
            "query": query,
            "error": str(e),
            "recommendations": [],
            "total": 0
        }

def get_service_detail(service_id: str) -> Dict:
    """
    Lấy thông tin chi tiết của một service
    
    Args:
        service_id: ID của service
    
    Returns:
        Service dict hoặc None nếu không tìm thấy
    """
    _initialize()
    
    try:
        service = _chatbot_recommender.get_service_detail(service_id)
        return service
    except Exception as e:
        return {
            "error": str(e),
            "service_id": service_id
        }

# Test function
def test_chatbot_endpoint():
    """Test chatbot endpoint với các query khác nhau"""
    
    print("\n" + "="*60)
    print("TEST CHATBOT RECOMMENDER ENDPOINT")
    print("="*60)
    
    test_queries = [
        "Tôi muốn tìm dịch vụ về tim mạch",
        "Có dịch vụ nào giúp giảm căng thẳng không?",
        "Tư vấn dinh dưỡng cho người đái tháo đường",
        "Tôi muốn tập yoga",
        "Dịch vụ massage trị liệu"
    ]
    
    for idx, query in enumerate(test_queries, 1):
        print(f"\n[Test {idx}] Query: '{query}'")
        result = recommend_for_chatbot(query, top_k=3)
        
        print(f"Số gợi ý: {result['total']}")
        for rec in result['recommendations']:
            print(f"\n  ✓ {rec['name']}")
            print(f"    ID: {rec['service_id']}")
            print(f"    Danh mục: {rec['category']}")
            print(f"    Điểm tương đồng: {rec['similarity_score']:.2%}")
            print(f"    Lý do: {rec['reason']}")
            print(f"    Tags: {', '.join(rec['tags'][:3])}...")
        
        if result['total'] == 0:
            print("Không tìm thấy dịch vụ phù hợp")
    
    # Test get service detail
    print("\n" + "="*60)
    print("TEST GET SERVICE DETAIL")
    print("="*60)
    service = get_service_detail("SV001")
    if service and "error" not in service:
        print(f"\nService ID: {service['id']}")
        print(f"Name: {service['name']}")
        print(f"Description: {service['description'][:100]}...")
    else:
        print("Không tìm thấy service")

if __name__ == "__main__":
    test_chatbot_endpoint()