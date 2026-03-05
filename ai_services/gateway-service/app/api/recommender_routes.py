# ai_services/gateway-service/app/api/recommender_routes.py

from fastapi import APIRouter
from app.schemas.recommender_schema import (
    HomeRecommenderRequest,
    ChatbotRecommenderRequest,
    RecommendationResponse, 
    ChatbotRecommendationResponse,
)
from app.orchestrators.recommendation_orchestrator import RecommendationOrchestrator

router = APIRouter()

@router.post("/recommender/home", response_model=RecommendationResponse)
async def recommend_home(request: HomeRecommenderRequest):
    """
    Home recommender (non-stream).
    """
    orchestrator = RecommendationOrchestrator()
    return await orchestrator.recommend_home(request)


@router.post("/recommender/chatbot", response_model=ChatbotRecommendationResponse)
async def recommend_chatbot(request: ChatbotRecommenderRequest):
    """
    Chatbot recommender (non-stream).
    """
    orchestrator = RecommendationOrchestrator()
    return await orchestrator.recommend_chatbot(request)