
import sys
import os

# Add paths
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'endpoints'))

from typing import Dict, List, Optional
from endpoints.home_endpoint import recommend_for_home
from endpoints.chatbot_endpoint import recommend_for_chatbot, get_service_detail

# =============================================================================
# MAIN API FUNCTIONS - Backend sẽ gọi các hàm này
# =============================================================================

def recommend_home(
    user_profile: Optional[Dict] = None,
    selected_services: Optional[List[str]] = None,
    top_k: int = 5
) -> Dict:
    """
    API cho Home Recommender
    
    Args:
        user_profile: Thông tin user profile
        selected_services: List service IDs đã sử dụng
        top_k: Số lượng gợi ý
    
    Returns:
        Dict chứa danh sách recommendations
    """
    return recommend_for_home(user_profile, selected_services, top_k)

def recommend_chatbot(query: str, top_k: int = 5) -> Dict:
    """
    API cho Chatbot Recommender
    
    Args:
        query: Query từ người dùng
        top_k: Số lượng gợi ý
    
    Returns:
        Dict chứa danh sách recommendations
    """
    return recommend_for_chatbot(query, top_k)

def get_service(service_id: str) -> Dict:
    """
    Lấy thông tin chi tiết của service
    
    Args:
        service_id: ID của service
    
    Returns:
        Dict chứa thông tin service
    """
    return get_service_detail(service_id)

# =============================================================================
# DEMO & TESTING
# =============================================================================

def demo_recommender_system():
    """Demo toàn bộ recommender system"""
    
    print("\n" + "="*80)
    print(" "*25 + "RECOMMENDER SYSTEM DEMO")
    print("="*80)
    
    # =========================================================================
    # DEMO 1: HOME RECOMMENDER
    # =========================================================================
    print("\n" + "="*80)
    print("DEMO 1: HOME RECOMMENDER - Gợi ý cho trang chủ")
    print("="*80)
    
    print("\n--- Scenario 1: User có vấn đề về tim mạch và đái tháo đường ---")
    result1 = recommend_home(
        user_profile={
            "health_conditions": ["tim mạch", "đái tháo đường"],
            "interests": ["dinh dưỡng"],
            "goals": ["kiểm soát đường huyết", "cải thiện sức khỏe tim mạch"]
        },
        selected_services=None,
        top_k=3
    )
    
    print(f"\nTìm thấy {result1['total']} gợi ý:")
    for idx, rec in enumerate(result1['recommendations'], 1):
        print(f"\n{idx}. {rec['name']} (ID: {rec['service_id']})")
        print(f"   Danh mục: {rec['category']}")
        print(f"   Điểm tương đồng: {rec['similarity_score']:.2%}")
        print(f"   Lý do: {rec['reason']}")
    
    print("\n--- Scenario 2: User quan tâm đến thể thao và phục hồi ---")
    result2 = recommend_home(
        user_profile={
            "interests": ["yoga", "gym", "phục hồi chức năng"],
            "goals": ["giảm đau lưng", "tăng sức bền"]
        },
        selected_services=["SV002"],  # Đã dùng Yoga
        top_k=3
    )
    
    print(f"\nTìm thấy {result2['total']} gợi ý (đã loại bỏ dịch vụ đã sử dụng):")
    for idx, rec in enumerate(result2['recommendations'], 1):
        print(f"\n{idx}. {rec['name']}")
        print(f"   Tags: {', '.join(rec['tags'])}")
        print(f"   Lý do: {rec['reason']}")
    
    # =========================================================================
    # DEMO 2: CHATBOT RECOMMENDER
    # =========================================================================
    print("\n" + "="*80)
    print("DEMO 2: CHATBOT RECOMMENDER - Gợi ý từ query tự nhiên")
    print("="*80)
    
    test_queries = [
        "Tôi bị lo âu và stress nhiều, có dịch vụ nào giúp được không?",
        "Muốn tìm dịch vụ tư vấn dinh dưỡng để giảm cân",
        "Có khóa học yoga nào phù hợp với người đau lưng không?",
        "Tôi cần khám sức khỏe tổng quát",
    ]
    
    for idx, query in enumerate(test_queries, 1):
        print(f"\n--- Query {idx}: '{query}' ---")
        result = recommend_chatbot(query, top_k=2)
        
        print(f"\nTìm thấy {result['total']} gợi ý:")
        for rec in result['recommendations']:
            print(f"\n  • {rec['name']}")
            print(f"    Điểm tương đồng: {rec['similarity_score']:.2%}")
            print(f"    Lý do: {rec['reason']}")
    
    # =========================================================================
    # DEMO 3: GET SERVICE DETAIL
    # =========================================================================
    print("\n" + "="*80)
    print("DEMO 3: GET SERVICE DETAIL - Lấy thông tin chi tiết")
    print("="*80)
    
    service_id = "SV004"
    print(f"\nLấy thông tin chi tiết của service: {service_id}")
    service = get_service(service_id)
    
    if service and "error" not in service:
        print(f"\nThông tin service:")
        print(f"  ID: {service['id']}")
        print(f"  Tên: {service['name']}")
        print(f"  Danh mục: {service['category']}")
        print(f"  Loại: {service['type']}")
        print(f"  Mô tả: {service['description']}")
        print(f"  Tags: {', '.join(service['tags'])}")
    
    print("\n" + "="*80)
    print(" "*30 + "END OF DEMO")
    print("="*80 + "\n")

# =============================================================================
# MAIN
# =============================================================================

if __name__ == "__main__":
    demo_recommender_system()