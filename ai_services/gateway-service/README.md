## 📁 Cấu trúc thư mục

gateway-service/
│
├── app/
│   │
│   ├── main.py                      # FastAPI app entrypoint, include routers, middleware
│   │
│   ├── api/                         # Layer 1 - HTTP Controllers
│   │   ├── chatbot_routes.py        # POST /chat/stream  (SSE endpoint)
│   │   ├── recommender_routes.py    # POST /recommender/home + /recommender/chatbot
│   │   ├── ner_routes.py            # POST /ner/extract  (nếu expose riêng)
│   │   └── health_routes.py         # GET /health
│   │
│   ├── orchestrators/               # Layer 2 - Business Flow
│   │   ├── chatbot_orchestrator.py  # Điều phối LLM + NER + Recommender + DB + SSE
│   │   └── recommendation_orchestrator.py # Logic orchestration cho recommend APIs
│   │
│   ├── clients/                     # Layer 3 - HTTP client gọi microservices
│   │   ├── chatbot_client.py        # Gọi chatbot-service
│   │   ├── recommender_client.py    # Gọi recommender-service
│   │   └── ner_client.py            # Gọi ner-service (future-proof)
│   │
│   ├── repositories/                # Layer 4 - DB access
│   │   ├── conversation_repo.py     # CRUD conversation
│   │   ├── message_repo.py          # CRUD message
│   │   └── service_repo.py          # Cache service metadata (optional)
│   │
│   ├── schemas/                     # Pydantic models (Request/Response/Event)
│   │   ├── chatbot_schema.py        # ChatRequest + SSE event schemas
│   │   ├── recommender_schema.py    # Home + Chatbot recommender request/response
│   │   ├── ner_schema.py            # Entity model
│   │   └── common_schema.py         # shared models (User, Price, Rating...)
│   │
│   ├── core/                        # System-level utilities
│   │   ├── config.py                # ENV config (URLs of services, timeout)
│   │   ├── sse.py                   # format_sse(event, data)
│   │   ├── enums.py                 # Error codes, message status
│   │   └── middleware.py            # request_id logging middleware
│   │
│   └── utils/
│       ├── logger.py                # structured logging
│       └── exceptions.py            # custom exception classes
│
├── tests/                           # Unit + integration test
│
├── Dockerfile                       # Build gateway image
├── requirements.txt
└── docker-compose.yml               # Orchestrate 3 services