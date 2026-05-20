# recommender2/app.py
from contextlib import asynccontextmanager
import asyncio
import logging
import os
import re

import chromadb
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import AsyncSession

from build_vectordb import build_vector_database
from config import settings
from config.database import get_db
from src.recommender.chatbot_recommender import Chatbot_Recommender
from src.recommender.home_recommender import Home_Recommender
from src.repositories import user_repositories
from src.schemas import recommender
from src.sync.redis_subscriber import start_subscriber

logger = logging.getLogger(__name__)

# Demo catalog từ data/raw/services.json dùng id dạng SV001 — không tồn tại trên DB Azure thật.
_LEGACY_SV_ID = re.compile(r"^SV\d+$")

_home_vector_bootstrap_lock = asyncio.Lock()
_home_vector_catalog_checked = False


def _reload_recommender_clients() -> None:
    """Tạo lại client sau khi rebuild Chroma (PersistentClient giữ handle cũ)."""
    global home, chatbot
    home = Home_Recommender(settings.DATABASE_NAME)
    chatbot = Chatbot_Recommender(settings.DATABASE_NAME)


# Khởi tạo object mỗi khi server start
home = Home_Recommender(settings.DATABASE_NAME)
chatbot = Chatbot_Recommender(settings.DATABASE_NAME)


async def _ensure_azure_product_vectors_for_home() -> None:
    """
    Chỉ phục vụ POST /recommender/home.

    Nếu Chroma vẫn chứa catalog demo (id SVxxx từ services.json) hoặc collection rỗng,
    rebuild vectordb từ PostgreSQL (Azure) giống build_vectordb.py rồi reload client.
    """
    global _home_vector_catalog_checked

    async with _home_vector_bootstrap_lock:
        if _home_vector_catalog_checked:
            return

        vectordb_path = os.path.join(settings.PROCESSED_DATA_DIR, "vectordb")
        needs_rebuild = False
        try:
            os.makedirs(vectordb_path, exist_ok=True)
            client = chromadb.PersistentClient(path=vectordb_path)
            coll = client.get_or_create_collection(name=settings.DATABASE_NAME)
            n = int(coll.count())

            if n <= 0:
                logger.info(
                    "[recommender/home] Chroma collection empty (count=0) — "
                    "building vectors from PostgreSQL (Azure) catalog."
                )
                needs_rebuild = True
            else:
                sample_n = min(50, n)
                sample = coll.get(limit=sample_n, include=[])
                ids = sample.get("ids") or []
                if any(isinstance(i, str) and _LEGACY_SV_ID.fullmatch(i) for i in ids):
                    logger.info(
                        "[recommender/home] Chroma still has demo SV* service ids — "
                        "rebuilding from PostgreSQL (Azure) catalog."
                    )
                    needs_rebuild = True
        except Exception as exc:
            logger.warning(
                "[recommender/home] Vector catalog check failed (non-fatal): %s",
                exc,
                exc_info=True,
            )

        if needs_rebuild:
            try:
                await build_vector_database(
                    vector_database_name=settings.DATABASE_NAME,
                    clean=True,
                )
                _reload_recommender_clients()
                logger.info(
                    "[recommender/home] Vector catalog rebuilt from DB; recommender clients reloaded."
                )
            except Exception as exc:
                logger.error(
                    "[recommender/home] Failed to rebuild vector catalog from DB: %s",
                    exc,
                    exc_info=True,
                )

        _home_vector_catalog_checked = True

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
    await _ensure_azure_product_vectors_for_home()

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