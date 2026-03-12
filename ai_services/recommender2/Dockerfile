FROM python:3.11-slim

# docker build -t healytics_recommender .
# docker run -it healytics_recommender
# docker run -it -v ~/Projects/Healytics/ai_services/recommender2:/app -w /app healytics_recommender bash
# docker run --name healytics_recommender -it -p 8000:8000 --env-file .env -v /home/giahung21112004/Projects/Healytics/ai_services/recommender2:/app -v hf_cache:/root/.cache/huggingface -v torch_cache:/root/.cache/torch -w /app healytics_recommender 
# uvicorn app:app --host 0.0.0.0 --port 8000 --reload
# docker start -ai healytics_recommender
# docker tag healytics_recommender:latest giahung2111/healytics_recommender:latest
# docker push giahung2111/healytics_recommender:latest

# 1. Workdir
WORKDIR /app

# 2. System deps 
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Upgrade pip
RUN pip install --upgrade pip

# 4. Python libs đúng theo code recommender
RUN pip install --no-cache-dir \
    torch \
    sentence-transformers \
    chromadb \
    numpy \
    pandas \
    tqdm \
    fastapi \
    uvicorn \
    sqlalchemy \
    asyncpg

# 5. Copy source
COPY . /app

# 6. 
EXPOSE 8000

# 7. Command 
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

