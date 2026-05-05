# chatbot-service/app.py
import os
import asyncio
import re
os.environ["TOKENIZERS_PARALLELISM"] = "false"

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from pydantic import BaseModel

from src.base.llm_model import get_hf_llm
from src.rag.main import build_rag_chain, InputQA, OutputQA
from langchain_core.messages import AIMessage


# ============================================================
# LLM + RAG CHAIN INIT
# ============================================================

llm = get_hf_llm(temperature=0.2)

genai_docs = "./data_source/generative_ai"

genai_chain = build_rag_chain(
    llm=llm,
    data_dir=genai_docs,
    data_type="pdf"
)


# ============================================================
# APP
# ============================================================

app = FastAPI(
    title="Healytics Chatbot Service",
    version="1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"],
)


# ============================================================
# SCHEMAS
# ============================================================

class ChatStreamRequest(BaseModel):
    """
    Payload được gửi từ Gateway ChatbotOrchestrator._build_chatbot_payload()

    Gateway gửi:
        {
            "history":   "User: ...\nAssistant: ...\n",
            "services":  "Tên dịch vụ: ...",   # có thể rỗng ""
            "question":  "câu hỏi của user"
        }
    """
    history: str = ""
    services: str = ""
    question: str


class ChatTitleRequest(BaseModel):
    """
    Payload dùng để tạo tiêu đề ngắn cho conversation.
    """
    user_message: str
    assistant_message: str = ""


# ============================================================
# RESPONSE PARSER  (giữ nguyên logic của app.py gốc)
# ============================================================

def parse_llm_output(result) -> str:
    """Trích xuất text thuần từ các kiểu output khác nhau của LangChain."""
    if isinstance(result, str):
        if "<|assistant|>" in result:
            return result.split("<|assistant|>")[-1].strip()
        return result.strip()
    elif isinstance(result, dict):
        return result.get("answer", "").strip()
    elif isinstance(result, AIMessage):
        return result.content.strip()
    return str(result).strip()


def clean_conversation_title(text: str) -> str:
    """Chuẩn hóa output LLM thành title ngắn để lưu DB/UI."""
    title = parse_llm_output(text)
    title = title.splitlines()[0] if title else ""
    title = re.sub(r"^[\"'“”‘’`]+|[\"'“”‘’`]+$", "", title).strip()
    title = re.sub(r"^(title|tiêu đề)\s*:\s*", "", title, flags=re.IGNORECASE).strip()
    title = re.sub(r"\s+", " ", title)
    if not title:
        return "Cuộc trò chuyện mới"
    return title[:80].rstrip(" .,-")


async def generate_conversation_title(
    user_message: str,
    assistant_message: str = "",
) -> str:
    prompt = f"""
You create short conversation titles for the Healytics chatbot UI.

Rules:
- Return ONLY the title text.
- Use the same language as the user's message.
- Keep it concise: 3 to 8 words.
- No quotes, no markdown, no punctuation at the end.
- The domain is wellness services: spa & massage, traditional medicine, physiotherapy and rehabilitation.

User message:
{user_message}

Assistant answer:
{assistant_message[:800]}
"""
    result = await asyncio.to_thread(llm.invoke, prompt)
    return clean_conversation_title(result)


# ============================================================
# FAKE STREAM GENERATOR
# ============================================================

async def fake_stream_generator(answer: str, chunk_size: int = 3, delay: float = 0.05):
    """
    Nhận full answer từ LLM, chia thành từng từ nhỏ rồi yield từ từ.

    Args:
        answer:     Câu trả lời đầy đủ từ LLM.
        chunk_size: Số từ mỗi lần gửi. Mặc định 3 từ/chunk → mượt mà.
        delay:      Thời gian chờ giữa các chunk (giây). Mặc định 50ms.

    Yield:
        str — chunk text (Gateway nhận rồi yield SSEEvent TOKEN)
    """
    words = answer.split(" ")

    for i in range(0, len(words), chunk_size):
        chunk_words = words[i : i + chunk_size]
        chunk = " ".join(chunk_words)

        # Thêm space sau mỗi chunk (trừ chunk cuối) để ghép lại đúng
        if i + chunk_size < len(words):
            chunk += " "

        yield chunk
        await asyncio.sleep(delay)


# ============================================================
# ROUTES
# ============================================================

@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/generative_ai")
async def generative_ai(inputs: InputQA):
    """
    Endpoint gốc — giữ nguyên, không đụng vào.
    Dùng để test trực tiếp qua Swagger docs.
    """
    result = genai_chain.invoke({
        "history": "",
        "services": "",
        "question": inputs.question,
    })
    answer = parse_llm_output(result)
    return {"answer": answer}


@app.post("/chat/stream")
async def chat_stream(request: ChatStreamRequest):
    """
    Streaming endpoint — được gọi bởi Gateway ChatbotClient.stream_chat().

    Flow:
        1. Ghép history + services + question thành enriched_question
        2. Gọi RAG chain bình thường (blocking) → lấy full answer
        3. Fake stream: chia answer thành chunks → yield từng chunk với delay nhỏ
        4. Gateway nhận từng chunk text → wrap thành SSEEvent(TOKEN) → gửi về client

    Returns:
        StreamingResponse (text/plain) — mỗi chunk là plain text, KHÔNG phải SSE format.
        SSE formatting do Gateway đảm nhiệm.
    """

    # 1. Build enriched question từ context gateway gửi xuống
    enriched_question = {
        "history": request.history,
        "services": request.services,
        "question": request.question,
    }

    # 2. Gọi RAG chain → lấy full answer (blocking, chạy trong thread pool)
    #    Dùng asyncio.to_thread để không block event loop FastAPI
    result = await asyncio.to_thread(genai_chain.invoke, enriched_question)
    answer = parse_llm_output(result)

    # 3. Fake stream: trả về StreamingResponse với generator
    return StreamingResponse(
        fake_stream_generator(answer, chunk_size=3, delay=0.05),
        media_type="text/plain; charset=utf-8",
        headers={
            "Cache-Control": "no-cache",
            "X-Accel-Buffering": "no",   # tắt buffer nginx nếu có
        },
    )


@app.post("/chat/title")
async def chat_title(request: ChatTitleRequest):
    """
    Tạo tiêu đề ngắn cho conversation để Gateway lưu vào conversations.title.
    """
    title = await generate_conversation_title(
        user_message=request.user_message,
        assistant_message=request.assistant_message,
    )
    return {"title": title}