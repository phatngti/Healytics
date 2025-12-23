from typing import List, Dict, Optional
from collections import Counter
from src.recommender.vectorstore import VectorDB
from src.recommender.service_loader import ServiceLoader
from config.settings import TOP_K_RESULTS

class HomeRecommender:
    """
    Recommender cho trang chủ
    Dựa trên: User Profile + Lịch sử dịch vụ đã chọn + Global Trend
    """
    
    def __init__(self, vectordb: VectorDB, service_loader: ServiceLoader):
        self.vectordb = vectordb
        self.service_loader = service_loader
        self.all_services = service_loader.get_all_services()
    
    def recommend(self, 
                  user_profile: Optional[Dict] = None,
                  selected_services: Optional[List[str]] = None,
                  top_k: int = TOP_K_RESULTS) -> List[Dict]:
        """
        Gợi ý services cho trang chủ
        
        Args:
            user_profile: Thông tin profile người dùng (health_conditions, interests, age, etc.)
            selected_services: List service_id mà user đã chọn/sử dụng trước đó
            top_k: Số lượng services gợi ý
        
        Returns:
            List các services được gợi ý
        """
        # Build query từ user profile và history
        query = self._build_home_query(user_profile, selected_services)
        
        # Nếu không có query (user mới hoàn toàn), trả về trending services
        if not query:
            return self._get_trending_services(top_k)
        
        # Search trong vector database
        results_with_score = self.vectordb.similarity_search_with_score(query, k=top_k * 2)
        
        # Lọc bỏ các services đã sử dụng
        selected_ids = set(selected_services or [])
        
        recommendations = []
        for doc, score in results_with_score:
            service_id = doc['metadata']['service_id'] 
            
            # Skip nếu đã sử dụng
            if service_id in selected_ids:
                continue
            
            similarity_score = 1 - score if score < 1 else 0
            service_full_info = self.service_loader.get_service_by_id(service_id)
            
            if service_full_info:
                recommendation = {
                    "service_id": service_id,
                    "name": service_full_info["name"],
                    "description": service_full_info["description"],
                    "category": service_full_info["category"],
                    "tags": service_full_info["tags"],
                    "type": service_full_info["type"],
                    "similarity_score": round(similarity_score, 3),
                    "reason": self._generate_home_reason(user_profile, service_full_info)
                }
                recommendations.append(recommendation)
                
                if len(recommendations) >= top_k:
                    break
        
        return recommendations
    
    def _build_home_query(self, 
                          user_profile: Optional[Dict],
                          selected_services: Optional[List[str]]) -> str:
        """Xây dựng query từ user profile và lịch sử"""
        query_parts = []
        
        # Từ user profile
        if user_profile:
            if "health_conditions" in user_profile:
                conditions = user_profile["health_conditions"]
                if isinstance(conditions, list):
                    query_parts.extend(conditions)
                else:
                    query_parts.append(conditions)
            
            if "interests" in user_profile:
                interests = user_profile["interests"]
                if isinstance(interests, list):
                    query_parts.extend(interests)
                else:
                    query_parts.append(interests)
            
            if "goals" in user_profile:
                goals = user_profile["goals"]
                if isinstance(goals, list):
                    query_parts.extend(goals)
                else:
                    query_parts.append(goals)
        
        # Từ lịch sử services đã chọn
        if selected_services:
            # Lấy tags từ các services đã chọn
            for service_id in selected_services:
                service = self.service_loader.get_service_by_id(service_id)
                if service:
                    query_parts.extend(service.get("tags", []))
                    query_parts.append(service.get("category", ""))
        
        return " ".join(query_parts)
    
    def _generate_home_reason(self, user_profile: Optional[Dict], service: Dict) -> str:
        """Tạo lý do gợi ý cho trang chủ"""
        reasons = []
        
        if user_profile:
            # Check health conditions
            if "health_conditions" in user_profile:
                conditions = user_profile["health_conditions"]
                if isinstance(conditions, str):
                    conditions = [conditions]
                
                for condition in conditions:
                    if any(condition.lower() in tag.lower() for tag in service["tags"]):
                        reasons.append(f"phù hợp với tình trạng sức khỏe ({condition})")
                        break
            
            # Check interests
            if "interests" in user_profile:
                interests = user_profile["interests"]
                if isinstance(interests, str):
                    interests = [interests]
                
                for interest in interests:
                    if any(interest.lower() in tag.lower() for tag in service["tags"]):
                        reasons.append(f"phù hợp với sở thích ({interest})")
                        break
        
        if not reasons:
            reasons.append("được nhiều người quan tâm")
        
        return f"Gợi ý vì dịch vụ này {', '.join(reasons)}."
    
    def _get_trending_services(self, top_k: int) -> List[Dict]:
        """Trả về trending services (có thể dựa vào global trend hoặc random)"""
        # Giả lập trending bằng cách lấy services theo category đa dạng
        trending = []
        
        # Lấy đa dạng category
        categories = list(set(s["category"] for s in self.all_services))
        
        services_by_category = {}
        for service in self.all_services:
            cat = service["category"]
            if cat not in services_by_category:
                services_by_category[cat] = []
            services_by_category[cat].append(service)
        
        # Lấy đều từ mỗi category
        idx = 0
        while len(trending) < top_k and idx < max(len(services) for services in services_by_category.values()):
            for cat in categories:
                if len(trending) >= top_k:
                    break
                if idx < len(services_by_category[cat]):
                    service = services_by_category[cat][idx]
                    trending.append({
                        "service_id": service["id"],
                        "name": service["name"],
                        "description": service["description"],
                        "category": service["category"],
                        "tags": service["tags"],
                        "type": service["type"],
                        "similarity_score": 0.0,
                        "reason": "Dịch vụ phổ biến được nhiều người lựa chọn."
                    })
            idx += 1
        
        return trending[:top_k]