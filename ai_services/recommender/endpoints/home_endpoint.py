"""
Home Recommender Endpoint
Backend có thể gọi hàm recommend_for_home() để lấy gợi ý cho trang chủ
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from typing import Dict, List, Optional
from src.recommender.service_loader import ServiceLoader
from src.recommender.embedding_model import EmbeddingModel
from src.recommender.vectorstore import VectorDB
from src.recommender.home_recommender import HomeRecommender
from config.settings import TOP_K_RESULTS

# Global instances (load một lần khi khởi động)
_service_loader = None
_vectordb = None
_home_recommender = None

def _initialize():
    """Khởi tạo các components (gọi một lần khi import)"""
    global _service_loader, _vectordb, _home_recommender
    
    if _home_recommender is not None:
        return
    
    print("Đang khởi tạo Home Recommender...")
    
    # Load service loader
    _service_loader = ServiceLoader()
    
    # Load embedding model và vector database
    embedding_model = EmbeddingModel()
    _vectordb = VectorDB(embedding_model=embedding_model)
    _vectordb.load_db()
    
    # Khởi tạo home recommender
    _home_recommender = HomeRecommender(_vectordb, _service_loader)
    
    print("Home Recommender đã sẵn sàng")

def recommend_for_home(
    user_profile: Optional[Dict] = None,
    selected_services: Optional[List[str]] = None,
    top_k: int = TOP_K_RESULTS
) -> Dict:
    """
    Hàm chính để backend gọi - Gợi ý services cho trang chủ
    
    Args:
        user_profile: Dict chứa thông tin user
            Example: {
                "health_conditions": ["đái tháo đường", "huyết áp cao"],
                "interests": ["yoga", "dinh dưỡng"],
                "goals": ["giảm cân", "cải thiện sức khỏe tim mạch"],
                "age": 45
            }
        selected_services: List service_id đã sử dụng
            Example: ["SV001", "SV003"]
        top_k: Số lượng gợi ý
    
    Returns:
        {
            "recommendations": [...],
            "total": 5
        }
    """
    # Khởi tạo nếu chưa có
    _initialize()
    
    try:
        # Gọi home recommender
        recommendations = _home_recommender.recommend(
            user_profile=user_profile,
            selected_services=selected_services,
            top_k=top_k
        )
        
        return {
            "recommendations": recommendations,
            "total": len(recommendations)
        }
    
    except Exception as e:
        return {
            "error": str(e),
            "recommendations": [],
            "total": 0
        }

# Test function
def test_home_endpoint():
    """Test home endpoint với các trường hợp khác nhau"""
    
    print("\n" + "="*60)
    print("TEST HOME RECOMMENDER ENDPOINT")
    print("="*60)
    
    # Test 1: User có profile và history
    print("\n[Test 1] User có profile đầy đủ:")
    result1 = recommend_for_home(
        user_profile={
            "health_conditions": ["đái tháo đường", "tim mạch"],
            "interests": ["yoga", "dinh dưỡng"],
            "goals": ["kiểm soát đường huyết"]
        },
        selected_services=["SV001"],
        top_k=3
    )
    print(f"Số gợi ý: {result1['total']}")
    for rec in result1['recommendations']:
        print(f"  - {rec['name']} (Score: {rec['similarity_score']:.2f})")
        print(f"    Lý do: {rec['reason']}")
    
    # Test 2: User mới (không có profile)
    print("\n[Test 2] User mới (không có profile):")
    result2 = recommend_for_home(top_k=3)
    print(f"Số gợi ý: {result2['total']}")
    for rec in result2['recommendations']:
        print(f"  - {rec['name']}")
        print(f"    Lý do: {rec['reason']}")
    
    # Test 3: User có một số interests
    print("\n[Test 3] User quan tâm đến thể thao:")
    result3 = recommend_for_home(
        user_profile={
            "interests": ["gym", "yoga", "thể thao"]
        },
        top_k=3
    )
    print(f"Số gợi ý: {result3['total']}")
    for rec in result3['recommendations']:
        print(f"  - {rec['name']}")
        print(f"    Tags: {', '.join(rec['tags'])}")

if __name__ == "__main__":
    test_home_endpoint()