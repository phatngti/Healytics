# ai_services/gateway-service/app/orchestrators/recommendation_orchestrator.py
from datetime import datetime, timezone
from typing import Any, Dict

from app.clients.recommender_client import RecommenderClient


class RecommendationOrchestrator:

    def __init__(self):
        self.recommender_client = RecommenderClient()

    async def recommend_home(self, request: Any) -> Dict:

        payload = {
            "user_id": request.user_id,
            "top_k": request.top_k,
        }

        result = await self.recommender_client.recommend_home(payload)

        result["timestamp"] = datetime.now(timezone.utc).isoformat()

        return result

    async def recommend_chatbot(self, request: Any) -> Dict:

        payload = {
            "conversation_id": request.conversation_id,
            "query": request.query,
            "top_k": request.top_k,
        }

        result = await self.recommender_client.recommend_chatbot(payload)

        result["timestamp"] = datetime.now(timezone.utc).isoformat()

        return result