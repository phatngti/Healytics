## 📁 Cấu trúc thư mục

gateway-service/
│
├── app/
│   │
│   ├── 6th - main.py                      # FastAPI app entrypoint, include routers, middleware
│   │
│   ├── 5th - api/                         # Layer 1 - HTTP Controllers
│   │   ├── chatbot_routes.py        # POST /chat/stream  (SSE endpoint)
│   │   ├── recommender_routes.py    # POST /recommender/home + /recommender/chatbot
│   │   ├── ner_routes.py            # POST /ner/extract  (nếu expose riêng)
│   │   └── health_routes.py         # GET /health
│   │
│   ├── 4th - orchestrators/               # Layer 2 - Business Flow
│   │   ├── chatbot_orchestrator.py  # Điều phối LLM + NER + Recommender + DB + SSE
│   │   └── recommendation_orchestrator.py # Logic orchestration cho recommend APIs
│   │
│   ├── 3rd - clients/                     # Layer 3 - HTTP client gọi microservices
│   │   ├── chatbot_client.py        # Gọi chatbot-service
│   │   ├── recommender_client.py    # Gọi recommender-service
│   │   └── ner_client.py            # Gọi ner-service (future-proof)
│   │
│   ├── repositories/                # Layer 4 - DB access
│   │   ├── conversation_repo.py     # CRUD conversation    
│   │   ├── message_repo.py          # CRUD message
│   │   └── service_repo.py          # Cache service metadata (optional)
│   │
│   ├── 2nd - schemas/                     # Pydantic models (Request/Response/Event)
│   │   ├── chatbot_schema.py        # ChatRequest + SSE event schemas
│   │   ├── recommender_schema.py    # Home + Chatbot recommender request/response
│   │   ├── ner_schema.py            # Entity model
│   │   └── common_schema.py         # shared models (User, Price, Rating...)
│   │
│   ├── 1st - core/                        # System-level utilities
│   │   ├── config.py                # ENV config (URLs of services, timeout)
│   │   ├── sse.py                   # format_sse(event, data)
│   │   ├── enums.py                 # Error codes, message status
│   │   └── middleware.py            # Xử lý trước sau mỗi request (gán request_id, log request, auth,...) --> Hiện ch cần làm 
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


## Bàn giao công việc cho NGUYÊN
# Công việc 1:
===============================
REPOSITORIES LAYER SPECIFICATION
Gateway Service - DB Access Layer
===============================

MỤC TIÊU
--------

Repositories layer chịu trách nhiệm:
- Tất cả thao tác với database
- Không chứa business logic
- Không chứa HTTP logic
- Không chứa orchestration logic

Chỉ làm nhiệm vụ CRUD cho:
- Conversation
- Message

Orchestrator sẽ gọi các hàm trong repositories.
Repositories không được gọi ngược lên orchestrator.


========================================
I. DATABASE MODELING (MINIMAL VERSION)
========================================

1) conversation table

Fields:
- id (string / uuid) PRIMARY KEY
- user_id (string) NULLABLE
- created_at (timestamp)
- updated_at (timestamp)

Relationship:
1 conversation -> many messages


2) message table

Fields:
- id (string / uuid) PRIMARY KEY
- conversation_id (string) FOREIGN KEY -> conversation.id
- role (string)  # "user" | "assistant"
- content (text)
- created_at (timestamp)



========================================
II. FOLDER STRUCTURE
========================================

repositories/
    conversation_repo.py
    message_repo.py


========================================
III. REQUIRED FUNCTIONS
========================================


----------------------------------------
1) conversation_repo.py
----------------------------------------

Purpose:
Manage conversation entity.


Functions to implement:


async def get_conversation_by_id(session, conversation_id: str):
    """
    Return conversation object or None
    """


async def create_conversation(session, conversation_id: str, user_id: str | None):
    """
    Create new conversation
    Return created object
    """


async def get_or_create_conversation(session, conversation_id: str, user_id: str | None):
    """
    If exists -> return
    Else -> create and return
    """


----------------------------------------
2) message_repo.py
----------------------------------------

Purpose:
Manage message entity.


async def create_message(
    session,
    conversation_id: str,
    role: str,
    content: str
):
    """
    Insert new message.
    Return created message object.
    """


async def get_messages_by_conversation(
    session,
    conversation_id: str
):
    """
    Return list of messages ordered by created_at ASC
    """



========================================
IV. HOW ORCHESTRATOR WILL USE THIS
========================================

Example Flow:

1) User sends message
2) Orchestrator:

    conversation = await conversation_repo.get_or_create_conversation(...)

    user_msg = await message_repo.create_message(
        session,
        conversation_id=conversation.id,
        role="user",
        content=request.message
    )

3) LLM streaming finishes

    assistant_msg = await message_repo.create_message(
        session,
        conversation_id=conversation.id,
        role="assistant",
        content=full_llm_response
    )



========================================
VI. IMPORTANT DESIGN RULES
========================================

1) No business logic in repository
2) No HTTP logic
3) No try/except swallowing errors silently
4) Keep functions small and atomic
5) Repository returns DB model


========================================
VII. MINIMAL SUCCESS CRITERIA
========================================

✔ Can create conversation
✔ Can create user message
✔ Can create assistant message
✔ Can query conversation history

That is enough for Phase 1 implementation.


END OF SPEC

