FROM python:3.11-slim

# docker build -t healytics_gateway .
# docker run -p 9000:9000 healytics_gateway
# uvicorn app.main:app --host 0.0.0.0 --port 9000
# docker start -ai healytics_gateway

# 1. Workdir
WORKDIR /app

# 2. System dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Upgrade pip
RUN pip install --upgrade pip

# 4. Install python libraries
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    httpx \
    pydantic \
    sqlalchemy \
    asyncpg \
    python-dotenv \
    pydantic_settings

# 5. Copy source code
COPY . /app

# 6. Expose port
EXPOSE 9000

# 7. Start service
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "9000"]