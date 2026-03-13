# start_runpod.py — chỉ start GPU chatbot
import runpod
import os
from dotenv import load_dotenv

load_dotenv()
runpod.api_key = os.getenv("RUNPOD_API_KEY")

CHATBOT_POD_ID = "op7x22fey8psm5"

print("🚀 Starting chatbot GPU pod...")
runpod.resume_pod(CHATBOT_POD_ID, gpu_count=1)
print("✅ Started: chatbot")
print("\n🌐 Gateway URL: https://u3gextiarhvqdt-9000.proxy.runpod.net")
print("⏳ Chờ 3 phút để chatbot load model xong rồi mới gọi API")