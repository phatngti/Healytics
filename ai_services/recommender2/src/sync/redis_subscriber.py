import asyncio
import json
import os
from urllib.parse import urlparse
import redis.asyncio as redis
from src.sync.sync_handler import handle_sync_event

async def start_subscriber(redis_url: str):
    if not redis_url:
        print("REDIS_URL not set, skipping subscriber")
        return
    
    channels = ("new_service_created", "service:updated", "service:deleted")

    # Robust loop: handle disconnects/reloads gracefully
    while True:
        try:
            # redis.asyncio client factory is sync (do NOT await)
            r = redis.Redis.from_url(redis_url)
            await r.ping()

            parsed = urlparse(redis_url)
            safe_host = f"{parsed.scheme}://{parsed.hostname}:{parsed.port}"
            print(f"[RedisSubscriber] Connected: {safe_host}")

            pubsub = r.pubsub()

            await pubsub.subscribe(*channels)
            print(f"[RedisSubscriber] Subscribed: {', '.join(channels)}")

            async for message in pubsub.listen():
                if message.get("type") != "message":
                    continue

                raw = message.get("data")
                try:
                    data = json.loads(raw)
                except Exception:
                    try:
                        data = json.loads(
                            raw.decode() if isinstance(raw, (bytes, bytearray)) else str(raw)
                        )
                    except Exception:
                        print(
                            f"[RedisSubscriber] Invalid payload, skipping. "
                            f"channel={message.get('channel')}, data={raw!r}"
                        )
                        continue

                channel_raw = message.get("channel")
                channel = (
                    channel_raw.decode()
                    if isinstance(channel_raw, (bytes, bytearray))
                    else str(channel_raw)
                )
                asyncio.create_task(handle_sync_event(channel, data))

        except asyncio.CancelledError:
            raise
        except Exception as e:
            # If running under --reload, subprocess restarts can briefly break connections.
            print(f"[RedisSubscriber] Error: {e}. Retrying in 2s...")
            await asyncio.sleep(2)