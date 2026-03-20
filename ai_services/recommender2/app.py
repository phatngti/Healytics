# recommender2/app.py
from fastapi import FastAPI, Depends, HTTPException
from src.recommender.home_recommender import Home_Recommender
from src.recommender.chatbot_recommender import Chatbot_Recommender
from src.schemas import recommender
from fastapi.middleware.cors import CORSMiddleware
from src.repositories import user_repositories
from sqlalchemy.ext.asyncio import AsyncSession
from config.database import get_db

app = FastAPI(
    title="Recommender System",
    version="1.0",
)

# Khởi tạo object mỗi khi server start
home = Home_Recommender("healytics_collection")
chatbot = Chatbot_Recommender("healytics_collection")

# Cho phép truy cập API từ mọi nguồn (CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # Cho phép tất cả domain truy cập
    allow_credentials=True,     # Cho phép gửi cookies/token
    allow_methods=["*"],        # Cho phép tất cả phương thức (GET, POST, PUT...)
    allow_headers=["*"],        # Cho phép tất cả header
    expose_headers=["*"],       # Hiển thị tất cả header cho client
)

# ---------- Route (API endpoint) ----------

# Route kiểm tra server
@app.get("/check")
async def check():
    return {"status": "ok"}   # Để kiểm tra xem server có chạy không

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
    
    # Convert từ ChromaDB format → schema format
    service_ids = raw["ids"][0] if raw["ids"] else []
    scores = raw["distances"][0] if raw["distances"] else []
    
    result = [recommender.RecommendationItem(
        service_ids=service_ids,
        scores=scores,
    )]
    
    return recommender.RecommendationResponse(
        recommendations=result,
        total=len(service_ids),
    )

@app.post("/recommender/chatbot", response_model=recommender.ChatbotRecommendationResponse)
async def recommend_chatbot(request: recommender.ChatbotRecommenderRequest):
    raw = chatbot.recommend(request.query, request.top_k, request.filtered_ids)
    
    # Convert từ ChromaDB format → schema format
    service_ids = raw["ids"][0] if raw["ids"] else []
    scores = raw["distances"][0] if raw["distances"] else []
    
    result = [recommender.RecommendationItem(
        service_ids=service_ids,
        scores=scores,
    )]
    
    return recommender.ChatbotRecommendationResponse(
        conversation_id=request.conversation_id,
        recommendations=result,
        total=len(service_ids),
    )