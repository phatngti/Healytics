# stop_runpod.py — chỉ stop GPU chatbot
import runpod
import os
from dotenv import load_dotenv

load_dotenv()
runpod.api_key = os.getenv("RUNPOD_API_KEY")

CHATBOT_POD_ID = "op7x22fey8psm5"

print("🛑 Stopping chatbot GPU pod...")
runpod.stop_pod(CHATBOT_POD_ID)
print("✅ Stopped: chatbot")
print("💡 Recommender và Gateway vẫn chạy bình thường")