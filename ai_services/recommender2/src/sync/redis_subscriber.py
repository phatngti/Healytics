import asyncio
import json
import redis.asyncio as redis
from src.sync.sync_handler import handle_sync_event

async def start_subscriber(redis_url: str):
    if not redis_url:
        print("REDIS_URL not set, skipping subscriber")
        return
    
    r = await redis.from_url(redis_url)
    pubsub = r.pubsub()
    await pubsub.subscribe("service:updated", "service:deleted")
    
    print("Redis subscriber started...")
    async for message in pubsub.listen():
        if message["type"] == "message":
            data = json.loads(message["data"])
            channel = message["channel"].decode()
            asyncio.create_task(handle_sync_event(channel, data))