# ai_services/gateway-service/app/api/chatbot_routes.py

from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.sse import sse_stream
from app.schemas.chatbot_schema import (
    ChatbotRequest,
    ConversationsPageResponse,
    MessagesPageResponse,
)
from app.orchestrators.chatbot_orchestrator import ChatbotOrchestrator
from app.core.database import get_db
from app.repositories import conversation_repo

router = APIRouter()

@router.post("/generative_ai/stream")
async def generative_ai_stream(
    request: ChatbotRequest,
    session: AsyncSession = Depends(get_db),
):
    orchestrator = ChatbotOrchestrator()
    event_generator = orchestrator.stream_chat(request, session)
    return sse_stream(event_generator)


@router.get("/chatbot/conversations", response_model=ConversationsPageResponse)
async def get_conversations(
    user_id: str = Query(..., min_length=1),
    page: int = Query(1, ge=1),
    limit: int = Query(10, ge=1),
    session: AsyncSession = Depends(get_db),
):
    orchestrator = ChatbotOrchestrator()
    return await orchestrator.get_conversations(
        session=session, user_id=user_id, page=page, limit=limit
    )


@router.get("/chatbot/conversations/{conversation_id}/messages", response_model=MessagesPageResponse)
async def get_messages(
    conversation_id: UUID,
    user_id: str | None = Query(default=None, min_length=1),
    page: int = Query(1, ge=1),
    limit: int = Query(20, ge=1),
    session: AsyncSession = Depends(get_db),
):
    if user_id is not None:
        conversation = await conversation_repo.get_conversation_by_id(
            session=session,
            conversation_id=conversation_id,
        )
        if conversation is None or conversation.user_id != user_id:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Conversation not found",
            )

    orchestrator = ChatbotOrchestrator()
    return await orchestrator.get_messages(
        session=session,
        conversation_id=conversation_id,
        page=page,
        limit=limit,
    )
