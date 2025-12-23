# Health Service Recommender System

Hệ thống gợi ý dịch vụ sức khỏe sử dụng Vector Search 

## 📁 Cấu trúc thư mục

```
recommender_system/
│
├── data/
│   ├── raw/
│   │   └── services.json          # Dữ liệu services mẫu
│   └── processed/
│       └── vectordb/               # Vector database (ChromaDB)
│
├── src/
│   ├── recommender/
│   │   ├── service_loader.py      # Load services (no LangChain Document)
│   │   ├── embedding_model.py     # SentenceTransformer wrapper
│   │   ├── vectorstore.py         # ChromaDB wrapper (no LangChain)
│   │   ├── home_recommender.py    # Home recommender
│   │   └── chatbot_recommender.py # Chatbot recommender
│   │
│   └── utils/
│       └── helpers.py
│
├── endpoints/
│   ├── home_endpoint.py           # API cho home
│   └── chatbot_endpoint.py        # API cho chatbot
│
├── config/
│   └── settings.py
│
├── tests/
│   └── test_recommender.py
│
├── create_sample_data.py
├── build_vectordb.py
├── main.py
├── app.py                          # Demo UI Streamlit
└── requirements.txt
```

##  Setup nhanh

### 1. Cài đặt 

```bash
pip install -r requirements.txt
```

### 2. Tạo dữ liệu

```bash
python create_sample_data.py
```

### 3. Build Vector Database

```bash
python build_vectordb.py
```

### 4. Test

```bash
python main.py
```

```bash
streamlit run app.py
```

##  Cách sử dụng

### Home Recommender

```python
from main import recommend_home

result = recommend_home(
    user_profile={
        "health_conditions": ["tim mạch"],
        "interests": ["yoga"],
        "goals": ["giảm cân"]
    },
    selected_services=["SV001"],
    top_k=5
)
```

### Chatbot Recommender

```python
from main import recommend_chatbot

result = recommend_chatbot(
    query="Tôi muốn tìm dịch vụ giúp giảm stress",
    top_k=5
)
```

## Tích hợp Backend

```python
# backend_api.py
from main import recommend_home, recommend_chatbot

@app.post("/api/recommend/home")
def home_recommendations(user_data: dict):
    return recommend_home(
        user_profile=user_data.get("profile"),
        selected_services=user_data.get("selected_services"),
        top_k=5
    )

@app.post("/api/recommend/chatbot")  
def chatbot_recommendations(request: dict):
    return recommend_chatbot(
        query=request["query"],
        top_k=5
    )
```

## Input/Output Format

### Input (Home):
```json
{
  "user_profile": {
    "health_conditions": ["tim mạch"],
    "interests": ["yoga"],
    "goals": ["giảm cân"]
  },
  "selected_services": ["SV001"],
  "top_k": 5
}
```

### Input (Chatbot):
```json
{
  "query": "Tôi muốn tìm dịch vụ về tim mạch",
  "top_k": 5
}
```

### Output:
```json
{
  "recommendations": [
    {
      "service_id": "SV001",
      "name": "Tư vấn tim mạch trực tuyến",
      "description": "...",
      "category": "y_te",
      "tags": ["tim mạch", "tư vấn online"],
      "type": "consultation",
      "similarity_score": 0.85,
      "reason": "Dịch vụ phù hợp vì..."
    }
  ],
  "total": 5
}
```

## Cấu hình

Edit `config/settings.py`:

```python
EMBEDDING_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"
TOP_K_RESULTS = 5
SIMILARITY_THRESHOLD = 0.3
DEVICE = "cuda"  # hoặc "cpu"
```

##  Testing

```bash
# All tests
python tests/test_recommender.py

# Individual endpoints
python endpoints/home_endpoint.py
python endpoints/chatbot_endpoint.py
```

## Cập nhật data

Khi sửa `data/raw/services.json`:

```bash
python build_vectordb.py
```

## Troubleshooting

**"Vector database not found"**
```bash
python build_vectordb.py
```

**"CUDA out of memory"**
```python
# config/settings.py
DEVICE = "cpu"
```

**Slow embedding**
```python
# Dùng model nhỏ hơn
EMBEDDING_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"
```