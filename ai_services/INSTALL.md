# Cài đặt môi trường ai_services

## macOS (Apple Silicon) — Python 3.11

```bash
cd ~/Code/Healytics
brew install python@3.11
python3.11 -m venv env
source env/bin/activate
pip install --upgrade pip
cd ai_services
pip install -r requirements.txt
```

**Không** cài `requirements-gpu-linux.txt` trên Mac.

## Linux CPU (gateway / ner / recommender)

```bash
pip install -r requirements.txt
```

## Linux GPU (chatbot RAG local Llama trên RunPod)

```bash
pip install -r requirements.txt
pip install -r requirements-gpu-linux.txt
# Hoặc torch CUDA:
# pip install torch --index-url https://download.pytorch.org/whl/cu121
```

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách sửa |
|-----|-------------|----------|
| `nvidia-cublas-cu12` not found | Đang dùng file freeze CUDA trên Mac | Dùng `requirements.txt` mới (không phải `.lock.linux-cuda.txt`) |
| Cache deserialization failed | Pip cache hỏng | `pip cache purge` rồi cài lại |
| `bitsandbytes` fail on Mac | Chỉ hỗ trợ Linux+CUDA | Bỏ qua; dùng `LLM_BACKEND=mistral` |

## File requirements

| File | Mục đích |
|------|----------|
| `requirements.txt` | Dev Mac + Linux CPU (đủ cho toàn bộ ai_services) |
| `requirements-gpu-linux.txt` | Thêm GPU inference trên Linux |
| `requirements.lock.linux-cuda.txt` | Backup freeze cũ (tham khảo, không cài trên Mac) |
