# ai_services/gateway-service/app/main.py
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.api import chatbot_routes, ner_routes, prefilter_routes, recommender_routes, health_routes
from app.core.database import engine, Base
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    await engine.dispose()


# App phải được tạo TRƯỚC khi dùng @app.middleware
app = FastAPI(
    title="Gateway Service",
    description=(
        "Gateway điều phối: Chatbot streaming (SSE), "
        "NER extraction, Home & Chatbot Recommender."
    ),
    version="1.0.0",
    lifespan=lifespan,
)


# Middleware log — đặt SAU khi app được tạo
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    body = await request.body()
    logger.info(f"→ REQUEST  {request.method} {request.url.path}")
    logger.info(f"  HEADERS: {dict(request.headers)}")
    logger.info(f"  BODY: {body.decode()}")
    response = await call_next(request)
    duration = time.time() - start
    logger.info(f"← RESPONSE {request.url.path} | status={response.status_code} | {duration:.2f}s")
    return response


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)

app.include_router(health_routes.router, tags=["Health"])
app.include_router(chatbot_routes.router, tags=["Chatbot"])
app.include_router(ner_routes.router, tags=["NER"])
app.include_router(prefilter_routes.router, tags=["Pre-Filter"])
app.include_router(recommender_routes.router, tags=["Recommender"])