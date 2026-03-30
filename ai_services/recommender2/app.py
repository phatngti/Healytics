# recommender2/app.py
from contextlib import asynccontextmanager
from fastapi import FastAPI, Depends, HTTPException
from src.recommender.home_recommender import Home_Recommender
from src.recommender.chatbot_recommender import Chatbot_Recommender
from src.schemas import recommender
from fastapi.middleware.cors import CORSMiddleware
from src.repositories import user_repositories
from sqlalchemy.ext.asyncio import AsyncSession
from config.database import get_db
from config import settings
import asyncio
from src.sync.redis_subscriber import start_subscriber

# Khởi tạo object mỗi khi server start
home = Home_Recommender("healytics_collection")
chatbot = Chatbot_Recommender("healytics_collection")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Start Redis subscriber background khi app khởi động
    task = asyncio.create_task(start_subscriber(settings.REDIS_URL))
    yield
    # Cleanup khi shutdown
    task.cancel()
    try:
        await task
    except asyncio.CancelledError:
        pass

app = FastAPI(
    title="Recommender System",
    version="1.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

# ---------- Routes ----------

@app.get("/check")
async def check():
    return {"status": "ok"}

@app.post("/recommender/home", response_model=recommender.RecommendationResponse)
async def recommend_home(request: recommender.HomeRecommenderRequest, session: AsyncSession = Depends(get_db)):
    user_profile = await user_repositories.build_user_profile(session=session, user_id=request.user_id)
    
    if user_profile is None:
        raise HTTPException(status_code=404, detail="User not found")
    
    raw = home.recommend(
        user_profile["health_conditions"],
        user_profile["interests"],
        user_profile["goals"],
        user_profile["service_history_ids"],
        top_k_home_results=request.top_k,
    )
    
    service_ids = raw["ids"][0] if raw["ids"] else []
    scores = raw["distances"][0] if raw["distances"] else []
    
    result = [recommender.RecommendationItem(service_ids=service_ids, scores=scores)]
    return recommender.RecommendationResponse(recommendations=result, total=len(service_ids))

@app.post("/recommender/chatbot", response_model=recommender.ChatbotRecommendationResponse)
async def recommend_chatbot(request: recommender.ChatbotRecommenderRequest):
    raw = chatbot.recommend(request.query, request.top_k, request.filtered_ids)
    
    service_ids = raw["ids"][0] if raw["ids"] else []
    scores = raw["distances"][0] if raw["distances"] else []
    
    result = [recommender.RecommendationItem(service_ids=service_ids, scores=scores)]
    return recommender.ChatbotRecommendationResponse(
        conversation_id=request.conversation_id,
        recommendations=result,
        total=len(service_ids),
    )