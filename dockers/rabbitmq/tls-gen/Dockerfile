FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y \
    openssl \
    make \
    hostname \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

WORKDIR /app/basic

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]