FROM python:3.11-slim

# docker build -t giahung2111/healytics_gateway:latest .
# docker run --name healytics_gateway -p 9000:9000 --env-file .env healytics_gateway
# uvicorn app.main:app --host 0.0.0.0 --port 9000 --reload
# docker start -ai healytics_gateway
# docker tag healytics_gateway giahung2111/healytics_gateway:latest
# docker push giahung2111/healytics_gateway:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# ── 1. System deps + pip upgrade (layer hiếm khi đổi) ─────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip

# ── 2. PyTorch CPU-only (~200 MB, thay vì 530 MB CUDA + 5 GB NVIDIA libs) ──
RUN pip install --index-url https://download.pytorch.org/whl/cpu \
        torch

# ── 3. Heavy ML libs (layer riêng: ít đổi, tái dùng cache tốt) ────
RUN pip install \
        sentence-transformers \
        scikit-learn

# ── 4. Light app libs (thêm/bớt lib nhẹ chỉ invalidate layer này) ─
RUN pip install \
        fastapi \
        uvicorn \
        httpx \
        pydantic \
        pydantic-settings \
        python-dotenv \
        sqlalchemy \
        asyncpg \
        joblib

# ── 5. Copy source code (layer đổi mỗi lần dev) ───────────────────
COPY . /app

EXPOSE 9000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "9000"]
