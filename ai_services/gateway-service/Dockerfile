FROM python:3.11-slim

# docker build -t giahung2111/healytics_gateway:latest .
# docker run --name healytics_gateway -p 9000:9000 --env-file .env healytics_gateway
# uvicorn app.main:app --host 0.0.0.0 --port 9000 --reload
# docker start -ai healytics_gateway
# docker tag healytics_gateway giahung2111/healytics_gateway:latest 
# docker push giahung2111/healytics_gateway:latest


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
    pydantic_settings \
    sentence-transformers \
    scikit-learn \
    joblib \
    pandas

# 5. Copy source code
COPY . /app

# 6. Expose port
EXPOSE 9000

# 7. Start service
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "9000"]