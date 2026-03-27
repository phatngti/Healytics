FROM python:3.11-slim

# ── BUILD ──────────────────────────────────────────────────
# docker build -t giahung2111/healytics_ner:latest .

# ── PUSH ───────────────────────────────────────────────────
# docker push giahung2111/healytics_ner:latest

# ── RUN LOCAL ──────────────────────────────────────────────
# docker run --name healytics_ner -it -p 7000:7000 --env-file .env giahung2111/healytics_ner:latest

# ── START/STOP ─────────────────────────────────────────────
# docker start -ai healytics_ner
# docker stop healytics_ner

# 1. Workdir
WORKDIR /app

# 2. System deps
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Upgrade pip
RUN pip install --upgrade pip

# 4. Python libs từ requirements.txt
RUN pip install --no-cache-dir \
    "fastapi>=0.111.0" \
    "uvicorn[standard]>=0.29.0" \
    "pydantic>=2.7.0" \
    "pydantic-settings>=2.3.0" \
    "underthesea>=6.8.0" \
    "rapidfuzz>=3.9.0" \
    "cachetools>=5.3.0" \
    "httpx>=0.27.0" \
    "asyncpg>=0.29.0" \
    "sentence-transformers>=3.0.0" \
    "numpy" \
    "pyahocorasick>=2.1.0" \
    "sqlalchemy>=2.0.0"

# 5. Copy source
COPY . /app

# 6.
EXPOSE 7000

# 7. Command
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "7000"]