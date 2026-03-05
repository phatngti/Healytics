# ai_services/gateway-service/app/main.py

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.api import chatbot_routes, recommender_routes, ner_routes, health_routes
from app.core.database import engine, Base


# ============================================================
# LIFESPAN
# Dùng asynccontextmanager thay @app.on_event (đã deprecated)
# Chạy startup / shutdown logic tại đây
# ============================================================

@asynccontextmanager
async def lifespan(app: FastAPI):
    yield  # không cần startup logic
    await engine.dispose()


# ============================================================
# APP INSTANCE
# ============================================================

app = FastAPI(
    title="Gateway Service",
    description=(
        "Gateway điều phối: Chatbot streaming (SSE), "
        "NER extraction, Home & Chatbot Recommender."
    ),
    version="1.0.0",
    lifespan=lifespan,
)


# ============================================================
# MIDDLEWARE
# ============================================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],       # Production: đổi thành list domain cụ thể
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],      # Bắt buộc cho SSE: client cần đọc header
)


# ============================================================
# ROUTERS
# ============================================================

# GET /health
app.include_router(
    health_routes.router,
    tags=["Health"],
)

# POST /generative_ai/stream
app.include_router(
    chatbot_routes.router,
    tags=["Chatbot"],
)

# POST /recommender/home
# POST /recommender/chatbot
app.include_router(
    recommender_routes.router,
    tags=["Recommender"],
)

# POST /ner/extract
# app.include_router(
#     ner_routes.router,
#     tags=["NER"],
# )

