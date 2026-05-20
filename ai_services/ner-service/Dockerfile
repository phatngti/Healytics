FROM python:3.11-slim

# ── BUILD ──────────────────────────────────────────────────
# docker build -t giahung2111/healytics_ner:latest .
#
# ── PUSH ───────────────────────────────────────────────────
# docker push giahung2111/healytics_ner:latest
#
# ── RUN LOCAL ──────────────────────────────────────────────
# docker run --name healytics_ner -it -p 7000:7000 --env-file .env giahung2111/healytics_ner:latest
#
# ── START/STOP ─────────────────────────────────────────────
# docker start -ai healytics_ner
# docker stop healytics_ner
# uvicorn app.main:app --host 0.0.0.0 --port 7000 --reload

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

# ── 2. PyTorch CPU-only (semantic_matcher.py import torch trực tiếp) ──
RUN pip install --index-url https://download.pytorch.org/whl/cpu \
        torch

# ── 3. Heavy AI / NLP libs ────────────────────────────────────────
RUN pip install \
        sentence-transformers \
        underthesea \
        pyahocorasick \
        numpy

# ── 4. Light app libs ─────────────────────────────────────────────
RUN pip install \
        "fastapi>=0.111.0" \
        "uvicorn[standard]>=0.29.0" \
        "pydantic>=2.7.0" \
        "pydantic-settings>=2.3.0" \
        "python-dotenv" \
        "httpx>=0.27.0" \
        "asyncpg>=0.29.0" \
        "sqlalchemy>=2.0.0" \
        "rapidfuzz>=3.9.0" \
        "cachetools>=5.3.0"

# ── 5. Copy source code ───────────────────────────────────────────
COPY . /app

EXPOSE 7000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7000"]
