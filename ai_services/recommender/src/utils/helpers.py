import json
from typing import Dict, List, Any

def format_recommendations(recommendations: List[Dict]) -> str:
    """Format danh sách recommendations thành string đẹp"""
    if not recommendations:
        return "Không tìm thấy dịch vụ phù hợp."
    
    output = []
    for idx, rec in enumerate(recommendations, 1):
        output.append(f"\n{idx}. {rec['name']}")
        output.append(f"   Danh mục: {rec['category']}")
        output.append(f"   Mô tả: {rec['description'][:100]}...")
        output.append(f"   Điểm tương đồng: {rec['similarity_score']:.2%}")
        output.append(f"   Lý do: {rec['reason']}")
    
    return "\n".join(output)

def validate_user_profile(user_profile: Dict) -> bool:
    """Validate user profile data"""
    if not isinstance(user_profile, dict):
        return False
    
    # Có thể thêm các validation rules khác
    return True

def extract_keywords(text: str) -> List[str]:
    """Trích xuất keywords từ text"""
    # Simple keyword extraction (có thể cải thiện bằng NLP)
    keywords = []
    
    # Danh sách keywords y tế phổ biến
    health_keywords = [
        "tim mạch", "đái tháo đường", "huyết áp", "cholesterol",
        "yoga", "gym", "thể dục", "massage",
        "dinh dưỡng", "giảm cân", "tăng cân",
        "tâm lý", "stress", "lo âu", "trầm cảm",
        "phục hồi", "chấn thương"
    ]
    
    text_lower = text.lower()
    for keyword in health_keywords:
        if keyword in text_lower:
            keywords.append(keyword)
    
    return keywords

def save_json(data: Any, file_path: str):
    """Save data to JSON file"""
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def load_json(file_path: str) -> Any:
    """Load data from JSON file"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)