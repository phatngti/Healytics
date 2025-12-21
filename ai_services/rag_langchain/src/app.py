#app.py
import os
# Tắt cảnh báo khi dùng tokenizer song song (tối ưu tốc độ)
os.environ["TOKENIZERS_PARALLELISM"] = "false"

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from langserve import add_routes
from src.base.llm_model import get_hf_llm
from src.rag.main import build_rag_chain, InputQA, OutputQA

# Khởi tạo mô hình ngôn ngữ
llm = get_hf_llm(temperature=0.2)  # temperature cao => câu trả lời sáng tạo hơn

# Thư mục chứa dữ liệu RAG (PDF, tài liệu, v.v.)
genai_docs = "./data_source/generative_ai"

# ---------- Chains ----------
genai_chain = build_rag_chain(
    llm=llm,
    data_dir=genai_docs,
    data_type="pdf"
)

# ---------- App - FastAPI ---------- 
app = FastAPI(
    title="LangChain Server",
    version="1.0",
    description="A simple API server using LangChain's Runnable interfaces",
)

# Cho phép truy cập API từ mọi nguồn (CORS)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # Cho phép tất cả domain truy cập
    allow_credentials=True,     # Cho phép gửi cookies/token
    allow_methods=["*"],        # Cho phép tất cả phương thức (GET, POST, PUT...)
    allow_headers=["*"],        # Cho phép tất cả header
    expose_headers=["*"],       # Hiển thị tất cả header cho client
)

# ---------- Route (API endpoint) ----------

# Route kiểm tra server
@app.get("/check")
async def check():
    return {"status": "ok"}   # Để kiểm tra xem server có chạy không


# Route chính để hỏi mô hình RAG
@app.post("/generative_ai", response_model=OutputQA)
async def generative_ai(inputs: InputQA):
    # Gửi câu hỏi (inputs.question) vào mô hình
    answer = genai_chain.invoke(inputs.question)
    return {"answer": answer}



# ---------- LangServe Playground ----------
# Cho phép test RAG trực tiếp qua giao diện web LangServe
add_routes(
    app,
    genai_chain,
    path="/generative_ai",      # Đường dẫn hiển thị trên web
    playground_type="default",  # Giao diện test mặc định
)
