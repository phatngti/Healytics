# sudo apt-get update
# sudo apt-get install ca-certificates curl
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc
# echo \
# sudo apt update
# sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
# sudo docker run hello-world
# sudo usermod -aG docker $USER
# newgrp docker
# docker build -t healytics_chatbot_rag . (Build docker image)
# docker run --gpus all -it healytics_chatbot_rag bash
# docker run --name healytics_chatbot_2 --gpus all -it -p 5000:5000 -v /home/giahung21112004/Projects/Healytics/ai_services/rag_langchain:/app -v torch_cache:/root/.cache/torch -v hf_cache:/root/.cache/huggingface -w /app healytics_chatbot_rag bash (lệnh thay thế để mount code khỏi build)
# docker start -ai healytics_chatbot


FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 1. Thiết lập thư mục làm việc
WORKDIR /app

# 2. Cài system dependencies 
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. Upgrade pip
RUN python3 -m pip install --upgrade pip

# 4. Cài thư viện Python cần cho RAG chatbot
RUN pip install --no-cache-dir \
    uvicorn \
    fastapi \
    langserve \
    torch \
    torchvision \
    torchaudio \
    bitsandbytes \
    accelerate \
    transformers \
    langchain-huggingface \
    langchain-community \
    langchain-chroma \
    sentence-transformers \
    pypdf \
    huggingface_hub \
    sse-starlette

# 5. Copy source code
COPY . /app

# 6. Expose port
EXPOSE 5000

# 7. Command chạy app
CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "5000"]
