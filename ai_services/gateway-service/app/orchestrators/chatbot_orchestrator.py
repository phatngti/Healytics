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

from typing import AsyncGenerator, Optional, Dict, Any, List

from app.repositories import conversation_repo, message_repo
from app.clients.chatbot_client import ChatbotClient
from app.clients.recommender_client import RecommenderClient
from app.clients.ner_client import NERClient
from app.core.sse import SSEEvent
from app.core.enums import SSEEventType
from datetime import datetime, timezone


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
            conversation_id=request.conversation_id,
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
                conversation_id=request.conversation_id,
                message=request.message,
            )

            if ner_result:
                yield SSEEvent(
                    SSEEventType.NER,
                    {
                        "conversation_id": request.conversation_id,
                        "entities": ner_result.get("entities", []),
                        "timestamp": datetime.now(timezone.utc),
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
                        "conversation_id": request.conversation_id,
                        "text": chunk,
                        "timestamp": datetime.now(timezone.utc),
                    },
                )

        # 8️. Emit recommendation AFTER chatbot finished
        if recommendation:
            yield SSEEvent(
                SSEEventType.RECOMMENDATION,
                {
                    **recommendation,
                    "timestamp": datetime.now(timezone.utc),
                },
            )

        # 9️. Persist assistant message
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
                "conversation_id": request.conversation_id,
                "status": "completed",
                "timestamp": datetime.now(timezone.utc),
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