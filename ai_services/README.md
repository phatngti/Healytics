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


- UI gọi:
	POST /generative_ai/stream
	Content-Type: application/json

- Request body: 
{
  "conversation_id": "uuid-string",
  "user_id": "user-123",
  "message": "Tôi bị đau lưng ở quận 1",
  "top_k": 3,
  "enable_recommendation": true,
  "enable_ner": true
}

- Response stream:

   a. Streaming token
	event: token
	data: {
	  "conversation_id": "uuid",
	  "text": "Bạn",
	  "index": 1
	}
 
  b. NER location event
	event: ner_location
	data: {
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
	data: {
	  "conversation_id": "uuid",
	  "recommendations": [
	     {
  		"service_ids": ["SV002", "SV009"],
  		"scores": [0.78, 0.71]
	     }
	  ],
	  "total": 2
	}

  d. Done event
	event: done
	data: {
	  "conversation_id": "uuid"
	  "status": "completed"
	}

  e. Error event
	event: error
	data: {
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
  "user_id": "user-123",
  "top_k": 5
}

- Response:
	{
	  "recommendations": [
	     {
  		"service_ids": ["SV002", "SV009"],
  		"scores": [0.78, 0.71]
	     }
	  ],
	  "total": 2
	}

4. Define request từ backend --> AI: CHATBOT_RECOMMENDER (Non-stream)
- UI gọi:
	POST /recommender/chatbot
	Content-Type: application/json

- Request body:
{
  "conversation_id": "conv-001",
  "query": "Tôi bị đau lưng mãn tính, cần tìm dịch vụ phục hồi",
  "top_k": 3
}

- Response:
	{
	  "conversation_id": "uuid",
	  "recommendations": [
	     {
  		"service_ids": ["SV002", "SV009"],
  		"scores": [0.78, 0.71]
	     }
	  ],
	  "total": 2
	}

