# ai_services/gateway-service/app/api/chatbot_routes.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.sse import sse_stream
from app.schemas.chatbot_schema import ChatbotRequest
from app.orchestrators.chatbot_orchestrator import ChatbotOrchestrator
from app.database import get_db_session

router = APIRouter()

@router.post("/generative_ai/stream")
async def generative_ai_stream(
    request: ChatbotRequest,
    session: AsyncSession = Depends(get_db_session),
):
    orchestrator = ChatbotOrchestrator()
    event_generator = orchestrator.stream_chat(request, session)
    return sse_stream(event_generator)