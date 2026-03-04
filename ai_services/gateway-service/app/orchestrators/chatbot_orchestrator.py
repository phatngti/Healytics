# ai_services/gateway-service/app/orchestrators/chatbot_orchestrator.py
"""
1. get_or_create_conversation
2. create_message (user)
3. get_messages_by_conversation
4. call ner_client (Hiện tại chưa cần thiết)
5. call recommender_client (Bỏ vào prompt để chatbot giải thích + trả về event:service_recommendation để trả về cards trên UI)
6. build enriched prompt
7. chatbot_client.stream_chat()
8. stream token → SSE (Chú ý là trả các event:token trước, sau khi chatbot trả lời hoàn chỉnh mới trả về event:recommendation để hiển thị cards sau)
9. collect full response
10. create_message (assistant)
11. emit DONE
"""

import math
from typing import AsyncGenerator, Optional, Dict, Any, List
from datetime import datetime, timezone

from app.repositories import conversation_repo, message_repo
from app.clients.chatbot_client import ChatbotClient
from app.clients.recommender_client import RecommenderClient
from app.clients.ner_client import NERClient
from app.core.sse import SSEEvent
from app.core.enums import SSEEventType
from app.models.conversation import Conversation
from app.models.message import Message


# ---------------------------------------------------------------------------
# Response formatters
# ---------------------------------------------------------------------------
# These helpers live here — not in the repositories — because repositories
# must return raw ORM objects only (no presentation logic).
# Routes call the repo, then pass the result to the formatter before
# returning the HTTP response.
#
#   repo  →  raw tuple / ORM object
#   orchestrator formatter  →  API-ready dict
# ---------------------------------------------------------------------------


# Use when returning a single message object from a route,
# e.g. after creating a message or fetching one by id.
def format_message(message: Message) -> dict[str, Any]:
    """Serialize a single Message ORM object for the API response."""
    return {
        "id": str(message.id),                    # UUID → string
        "conversationId": str(message.conversation_id),
        "role": message.role,                     # "user" | "assistant"
        "content": message.content,               # full message text
        "createdAt": (
            message.created_at.isoformat()        # ISO-8601 UTC timestamp
            if isinstance(message.created_at, datetime)
            else str(message.created_at)
        ),
    }


# Use in routes that return a paginated list of messages
# for a conversation, e.g. GET /conversations/{id}/messages?page=1.
# Unpack the tuple from message_repo.get_messages_page() and pass here.
def format_messages_page(
    messages: list[Message],
    total: int,
    page: int,
    limit: int,
) -> dict[str, Any]:
    """
    Shape the tuple from ``message_repo.get_messages_page()``
    into the paginated API response format.

    Usage::

        messages, total = await message_repo.get_messages_page(
            session, conversation_id, page, limit
        )
        return format_messages_page(messages, total, page, limit)
    """
    return {
        # Each Message ORM object is serialized via format_message()
        "messages": [format_message(m) for m in messages],
        "meta": {
            "page": page,
            "limit": limit,
            "total": total,                                     # total rows in DB
            "totalPages": math.ceil(total / limit) if limit else 0,
        },
    }


# Use when returning a single conversation object from a route,
# e.g. after creating or updating a conversation.
def format_conversation(conversation: Conversation) -> dict[str, Any]:
    """Serialize a single Conversation ORM object for the API response."""
    return {
        "id": str(conversation.id),               # UUID → string
        "userId": str(conversation.user_id) if conversation.user_id else None,
        "title": conversation.title,
        "createdAt": (
            conversation.created_at.isoformat()   # ISO-8601 UTC timestamp
            if isinstance(conversation.created_at, datetime)
            else str(conversation.created_at)
        ),
        "updatedAt": (
            conversation.updated_at.isoformat()   # reflects last message time
            if isinstance(conversation.updated_at, datetime)
            else str(conversation.updated_at)
        ),
    }


# Use in routes that return a paginated list of conversations
# for a user, e.g. GET /conversations?user_id=...&page=1.
# Unpack the tuple from conversation_repo.get_conversations_page() and pass here.
def format_conversations_page(
    conversations: list[Conversation],
    total: int,
    page: int,
    limit: int,
) -> dict[str, Any]:
    """
    Shape the tuple from ``conversation_repo.get_conversations_page()``
    into the paginated API response format.

    Usage::

        conversations, total = await conversation_repo.get_conversations_page(
            session, user_id, page, limit
        )
        return format_conversations_page(conversations, total, page, limit)
    """
    return {
        # Each Conversation ORM object is serialized via format_conversation()
        "conversations": [format_conversation(c) for c in conversations],
        "meta": {
            "page": page,
            "limit": limit,
            "total": total,                                     # total rows in DB
            "totalPages": math.ceil(total / limit) if limit else 0,
        },
    }


# ---------------------------------------------------------------------------
# Main chat orchestrator
# ---------------------------------------------------------------------------

class ChatbotOrchestrator:


    def __init__(self):
        self.chatbot_client = ChatbotClient()
        self.recommender_client = RecommenderClient()
        self.ner_client = NERClient()

    # ============================================
    # PUBLIC ENTRYPOINT
    # ============================================

    async def stream_chat(
        self,
        request: Any,
        session: Any,
    ) -> AsyncGenerator[SSEEvent, None]:

        # 1. Get or create conversation
        conversation = await conversation_repo.get_or_create_conversation(
            session=session,
            conversation_id_str = str(request.conversation_id),
            user_id=getattr(request, "user_id", None),
        )

        # 2. Save user message
        await message_repo.create_message(
            session=session,
            conversation_id=conversation.id,
            role="user",
            content=request.message,
        )

        # 3️. Load conversation history
        history = await message_repo.get_messages_by_conversation(
            session=session,
            conversation_id=conversation.id,
        )

        # 4️. Call NER (optional)
        ner_result = None
        if request.enable_ner:
            ner_result = await self._call_ner_safe(
                conversation_id=str(request.conversation_id),
                message=request.message,
            )

            if ner_result:
                yield SSEEvent(
                    SSEEventType.NER,
                    {
                        "conversation_id": str(request.conversation_id),
                        "entities": ner_result.get("entities", []),
                        "timestamp": datetime.now(timezone.utc).isoformat(),
                    },
                )

        # 5️. Call Recommender (safe)
        recommendation = None
        if request.enable_recommendation:
            recommendation = await self._call_recommender_safe(request)

        # 6️. Build enriched prompt
        enriched_payload = self._build_chatbot_payload(
            history=history,
            user_message=request.message,
            recommendation=recommendation,
        )

        # 7️. Stream LLM
        full_response = ""

        async for chunk in self.chatbot_client.stream_chat(enriched_payload):
            if chunk:
                full_response += chunk

                yield SSEEvent(
                    SSEEventType.TOKEN,
                    {
                        "conversation_id": str(request.conversation_id),
                        "text": chunk,
                        "timestamp": datetime.now(timezone.utc).isoformat(),
                    },
                )

        # 8️. Emit recommendation AFTER chatbot finished
        if recommendation:
            yield SSEEvent(
                SSEEventType.RECOMMENDATION,
                {
                    **recommendation,
                    "conversation_id": str(request.conversation_id),
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                },
            )

        # 9️. Persist assistant message
        if full_response:
            await message_repo.create_message(
                session=session,
                conversation_id=conversation.id,
                role="assistant",
                content=full_response,
            )

        # 10. Emit DONE
        yield SSEEvent(
            SSEEventType.DONE,
            {
                "conversation_id": str(request.conversation_id),
                "status": "completed",
                "timestamp": datetime.now(timezone.utc).isoformat(),
            },
        )

    # ============================================
    # PRIVATE HELPERS
    # ============================================

    async def _call_ner_safe(
        self,
        conversation_id,
        message: str,
    ) -> Optional[Dict[str, Any]]:

        try:
            payload = {
                "conversation_id": conversation_id,
                "text": message,
            }

            return await self.ner_client.extract_entities(payload)

        except Exception:
            return None

    async def _call_recommender_safe(self, request: Any):

        try:
            payload = {
                "conversation_id": request.conversation_id,
                "query": request.message,
                "top_k": request.top_k,
            }

            return await self.recommender_client.recommend_chatbot(
                payload=payload
            )

        except Exception:
            return None

    def _build_chatbot_payload(
        self,
        history: List[Any],
        user_message: str,
        recommendation: Optional[Dict[str, Any]],
    ) -> Dict[str, Any]:
        """
        Build payload gửi xuống chatbot-service.

        Lưu ý:
        ChatbotClient.stream_chat nhận payload dạng dict.
        """

        formatted_history = []

        for msg in history:
            formatted_history.append(
                {
                    "role": msg.role,
                    "content": msg.content,
                }
            )

        payload = {
            "messages": formatted_history,
            "current_message": user_message,
        }

        if recommendation:
            payload["recommendation_context"] = recommendation

        return payload
