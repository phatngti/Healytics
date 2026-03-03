# recommender2/app.py
from fastapi import FastAPI
from src.recommender.home_recommender import Home_Recommender
from src.recommender.chatbot_recommender import Chatbot_Recommender
from src.schemas import recommender
from fastapi.middleware.cors import CORSMiddleware
from src.repositories import user_repositories
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession
from src.database import get_db_session

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
async def recommend_home(request: recommender.HomeRecommenderRequest, session: AsyncSession = Depends(get_db_session),):
    user_profile = await user_repositories.build_user_profile(session=session, user_id=request.user_id)
    result = await home.recommend(
    user_profile["health_conditions"],
    user_profile["interests"],
    user_profile["goals"],
    user_profile["service_history_ids"],
    top_k_home_results=request.top_k,
    )
    return recommender.RecommendationResponse(recommendations=result, total=len(result),)

@app.post("/recommender/chatbot", response_model=recommender.ChatbotRecommendationResponse)
async def recommend_chatbot(request: recommender.ChatbotRecommenderRequest):
    result = chatbot.recommend(request.query, request.top_k)
    return recommender.ChatbotRecommendationResponse(conversation_id=request.conversation_id, recommendations=result, total=len(result),)