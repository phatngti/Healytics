FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
WORKDIR app

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
# apt-get update
# apt-get install python3

RUN apt-get update
RUN apt-get install -y python3 python3-pip
RUN pip install uvicorn fastapi langserve torch torchvision torchaudio bitsandbytes accelerate transformers langchain-huggingface langchain-community langchain-chroma sentence-transformers
RUN pip install -U huggingface_hub



COPY . /app
