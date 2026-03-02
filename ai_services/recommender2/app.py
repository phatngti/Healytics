from fastapi import FastAPI
from src.recommender.home_recommender import Home_Recommender
from src.recommender.chatbot_recommender import Chatbot_Recommender
from src.schemas import recommender
from fastapi.middleware.cors import CORSMiddleware

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

@app.post("/recommender/home")
async def recommend_home(request: recommender.HomeRecommenderRequest):
    pass

@app.post("/recommender/chatbot")
async def recommend_chatbot(request: recommender.ChatbotRecommenderRequest):
    pass

