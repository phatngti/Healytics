from typing import List, Dict
from src.recommender.vectorstore import VectorDB
from src.recommender.service_loader import ServiceLoader
from config.settings import TOP_K_RESULTS, SIMILARITY_THRESHOLD

class ChatbotRecommender:
    """
    Pipeline: Query từ người dùng -> Embedding -> Search vector DB -> Top-K services
    """
    
    def __init__(self, vectordb: VectorDB, service_loader: ServiceLoader):
        self.vectordb = vectordb
        self.service_loader = service_loader
    
    def recommend(self, query: str, top_k: int = TOP_K_RESULTS) -> List[Dict]:
        """
        Gợi ý services dựa trên query từ chatbot
        
        Args:
            query: Câu hỏi/yêu cầu từ người dùng
            top_k: Số lượng services gợi ý
        
        Returns:
            List các services được gợi ý với thông tin chi tiết
        """
        # Tìm kiếm trong vector database
        results = self.vectordb.similarity_search_with_score(query, k=top_k)
        
        recommendations = []
        for result, score in results:
            # Lọc theo threshold
            if score < SIMILARITY_THRESHOLD:
                continue
            
            # Lấy thông tin đầy đủ của service
            service_id = result['metadata']['service_id']
            service_full_info = self.service_loader.get_service_by_id(service_id)
            
            if service_full_info:
                recommendation = {
                    "service_id": service_id,
                    "name": service_full_info["name"],
                    "description": service_full_info["description"],
                    "category": service_full_info["category"],
                    "tags": service_full_info["tags"],
                    "type": service_full_info["type"],
                    "similarity_score": round(score, 3),
                    "reason": self._generate_reason(query, service_full_info, score)
                }
                recommendations.append(recommendation)
        
        return recommendations
    
    def _generate_reason(self, query: str, service: Dict, score: float) -> str:
        """Tạo lý do gợi ý"""
        # Tìm tags match với query
        matching_tags = [tag for tag in service["tags"] if tag.lower() in query.lower()]
        
        if matching_tags:
            reason = f"Dịch vụ phù hợp với nhu cầu '{query}' vì liên quan đến: {', '.join(matching_tags)}."
        else:
            reason = f"Dịch vụ được gợi ý dựa trên độ tương đồng cao ({score:.1%}) với yêu cầu của bạn."
        
        return reason
    
    def get_service_detail(self, service_id: str) -> Dict:
        """Lấy thông tin chi tiết của 1 service"""
        return self.service_loader.get_service_by_id(service_id)