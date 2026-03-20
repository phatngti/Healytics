"""
ai_services/ner-service/app/main.py

FastAPI application entry point.
Loads location + category caches at startup via lifespan.
"""

import logging
import time
import asyncio

from contextlib import asynccontextmanager

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware

from app.api import ner_routes, prefilter_routes
from app.ner import cache
from app.ner.semantic_matcher import get_matcher

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load RAM caches at startup."""
    await cache.startup_load()
    try:
        await asyncio.to_thread(get_matcher)
        logger.info("[Startup] SemanticMatcher preloaded")
    except Exception as exc:
        logger.warning("[Startup] SemanticMatcher preload failed: %s", exc)
    yield


app = FastAPI(
    title="NER Service",
    description=(
        "Named Entity Recognition service for Healytics. "
        "Trích xuất entities (BusinessType, Location, Price, Rating, Category) "
        "từ text tiếng Việt bằng underthesea + regex + RapidFuzz."
    ),
    version="1.0.0",
    lifespan=lifespan,
)


@app.middleware("http")
async def log_requests(request: Request, call_next):
    start = time.time()
    response = await call_next(request)
    duration = time.time() - start
    logger.info(
        f"{request.method} {request.url.path} | "
        f"status={response.status_code} | {duration:.3f}s"
    )
    return response


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(ner_routes.router, tags=["NER"])
app.include_router(prefilter_routes.router, tags=["PreFilter"])
