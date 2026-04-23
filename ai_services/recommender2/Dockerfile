FROM python:3.11-slim

# docker build -t giahung2111/healytics_recommender:latest .
# docker run -it healytics_recommender
# docker run -it -v ~/Projects/Healytics/ai_services/recommender2:/app -w /app healytics_recommender bash
# docker run --name healytics_recommender -it -p 8000:8000 --env-file .env \
#     -v /home/giahung21112004/Projects/Healytics/ai_services/recommender2:/app \
#     -v hf_cache:/root/.cache/huggingface \
#     -v torch_cache:/root/.cache/torch \
#     -w /app healytics_recommender
# uvicorn app:app --host 0.0.0.0 --port 8000 --reload
# docker start -ai healytics_recommender
# docker tag healytics_recommender:latest giahung2111/healytics_recommender:latest
# docker push giahung2111/healytics_recommender:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# ── 1. System deps + pip upgrade ──────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip

# ── 2. PyTorch CPU-only ───────────────────────────────────────────
RUN pip install --index-url https://download.pytorch.org/whl/cpu \
        torch

# ── 3. Heavy AI / vector libs ─────────────────────────────────────
RUN pip install \
        sentence-transformers \
        chromadb \
        numpy

# ── 4. Light app libs ─────────────────────────────────────────────
RUN pip install \
        fastapi \
        uvicorn \
        pydantic \
        python-dotenv \
        sqlalchemy \
        asyncpg \
        redis

# ── 5. Copy source code ───────────────────────────────────────────
COPY . /app

EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
