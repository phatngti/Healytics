1. Luồng tổng thể

Browser
   │
   ▼
FastAPI Controller
   │
   ▼
Chatbot Orchestrator
   ├── LLM Service (streaming)
   ├── NER Service (async task)
   ├── Recommendation Service (async task)
   └── DB / Storage
   │
   ▼
StreamingResponse (SSE)
   │
   ▼
Browser EventSource

2. Define request từ backend --> AI: CHATBOT
- Đầu tiên User mở phiên chat:
	+ Case 1: Chat mới thì UI gọi POST /generative_ai/stream và để trường history = None
	+ Case 2: Chat cũ thì UI truy cập database để lấy history rồi truyền vào Request body

- UI gọi:
	POST /generative_ai/stream
	Content-Type: application/json

- Request body: 
{
  "request_id": "uuid-string",
  "conversation_id": "uuid-string",
  "user_id": "user-123",
  "message": "Tôi bị đau lưng ở quận 1",
  "history": [
    {"role": "user", "content": "Xin chào"},
    {"role": "assistant", "content": "Chào bạn"}
  ],
  "top_k": 3,
  "enable_recommendation": true,
  "enable_ner": true
}

- Response stream:

   a. Streaming token
	event: token
	data: {
	  "request_id": "uuid",
	  "conversation_id": "uuid",
	  "text": "Bạn",
	  "index": 1
	}
 
  b. NER location event
	event: ner_location
	data: {
	  "request_id": "uuid",
	  "conversation_id": "uuid",
	  "entities": [
	    {
	      "type": "LOCATION",
	      "value": "Quận 1",
	      "confidence": 0.93
	    }
	  ]
	}

  c. Service recommendation event
	event: service_recommendation
data: 
{
  "request_id": "uuid",
  "conversation_id": "uuid",
  "total": 2,
  "recommendations": [
    {
      "service_id": "SV002",
      "similarity_score": 0.78,
      "rank": 1,

      "image": "https://cdn.healytics.vn/services/sv002.jpg",
      "name": "Phục hồi cột sống chuyên sâu",

      "price": {
        "amount": 800000,
        "currency": "VND"
      },

      "staff_name": "BS Nguyễn Văn A",

      "rating": {
        "average": 4.8,
        "total_reviews": 124
      },

      "location": {
        "address": "123 Nguyễn Huệ",
        "district": "Quận 1",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-21T09:00:00",
        "2026-02-21T14:00:00"
      ]
    },
    {
      "service_id": "SV009",
      "similarity_score": 0.71,
      "rank": 2,

      "image": "https://cdn.healytics.vn/services/sv009.jpg",
      "name": "Gói trị liệu đau lưng mãn tính",

      "price": {
        "amount": 650000,
        "currency": "VND"
      },

      "staff_name": "ThS Trần Minh B",

      "rating": {
        "average": 4.6,
        "total_reviews": 98
      },

      "location": {
        "address": "45 Lê Lợi",
        "district": "Quận 1",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-22T10:00:00",
        "2026-02-22T15:30:00"
      ]
    }
  ]
}

  d. Done event
	event: done
	data: {
	  "request_id": "uuid",
	  "conversation_id": "uuid"
	  "status": "completed"
	}

  e. Error event
	event: error
	data: {
	  "request_id": "uuid",
	  "conversation_id": "uuid",
	  "error_code": "MODEL_TIMEOUT" # Hoặc các lỗi khác như : RETRIEVER_ERROR, INVALID_INPUT, INTERNAL_ERROR
	  "message": "Generation timeout"
	}


3. Define request từ backend --> AI: HOME_RECOMMENDER --> — trả list service ID
- UI gọi:
	POST /recommender/home
	Content-Type: application/json

- Request body:
{
  "request_id": "uuid-string",
  "user_id": "user-123",
  "user_profile": {
    "health_conditions": ["tim mạch", "huyết áp cao"],
    "interests": ["dinh dưỡng"],
    "goals": ["giảm cholesterol", "ăn uống lành mạnh"]
  },
  "selected_services": ["SV001"],
  "top_k": 5
}

- Response:
{
  "request_id": "uuid-string",
  "total": 2,
  "recommendations": [
    {
      "service_id": "SV003",
      "similarity_score": 0.814,
      "rank": 1,

      "image": "https://cdn.healytics.vn/services/sv003.jpg",
      "name": "Gói tư vấn dinh dưỡng tim mạch",

      "price": {
        "amount": 500000,
        "currency": "VND"
      },

      "staff_name": "ThS Lê Thị C",

      "rating": {
        "average": 4.9,
        "total_reviews": 210
      },

      "location": {
        "address": "78 Nguyễn Đình Chiểu",
        "district": "Quận 3",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-23T08:30:00",
        "2026-02-23T13:00:00"
      ]
    },
    {
      "service_id": "SV005",
      "similarity_score": 0.692,
      "rank": 2,

      "image": "https://cdn.healytics.vn/services/sv005.jpg",
      "name": "Chương trình kiểm soát cholesterol",

      "price": {
        "amount": 450000,
        "currency": "VND"
      },

      "staff_name": "BS Phạm Văn D",

      "rating": {
        "average": 4.7,
        "total_reviews": 156
      },

      "location": {
        "address": "12 Võ Văn Tần",
        "district": "Quận 3",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-24T09:00:00",
        "2026-02-24T14:00:00"
      ]
    }
  ]
}

4. Define request từ backend --> AI: CHATBOT_RECOMMENDER (Non-stream)
- UI gọi:
	POST /recommender/chatbot
	Content-Type: application/json

- Request body:
{
  "request_id": "uuid-string",
  "conversation_id": "conv-001",
  "query": "Tôi bị đau lưng mãn tính, cần tìm dịch vụ phục hồi",
  "top_k": 3
}

- Response:
{
  "request_id": "uuid-string",
  "conversation_id": "conv-001",
  "total": 2,
  "recommendations": [
    {
      "service_id": "SV002",
      "similarity_score": 0.782,
      "rank": 1,

      "image": "https://cdn.healytics.vn/services/sv002.jpg",
      "name": "Phục hồi cột sống chuyên sâu",

      "price": {
        "amount": 800000,
        "currency": "VND"
      },

      "staff_name": "BS Nguyễn Văn A",

      "rating": {
        "average": 4.8,
        "total_reviews": 124
      },

      "location": {
        "address": "123 Nguyễn Huệ",
        "district": "Quận 1",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-21T09:00:00",
        "2026-02-21T14:00:00"
      ]
    },
    {
      "service_id": "SV009",
      "similarity_score": 0.718,
      "rank": 2,

      "image": "https://cdn.healytics.vn/services/sv009.jpg",
      "name": "Gói trị liệu đau lưng mãn tính",

      "price": {
        "amount": 650000,
        "currency": "VND"
      },

      "staff_name": "ThS Trần Minh B",

      "rating": {
        "average": 4.6,
        "total_reviews": 98
      },

      "location": {
        "address": "45 Lê Lợi",
        "district": "Quận 1",
        "city": "Hồ Chí Minh"
      },

      "slots": [
        "2026-02-22T10:00:00",
        "2026-02-22T15:30:00"
      ]
    }
  ]
}

