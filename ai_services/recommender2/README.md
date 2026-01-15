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