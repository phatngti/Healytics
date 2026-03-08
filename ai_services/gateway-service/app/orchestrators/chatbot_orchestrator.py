# app/orchestrators/chatbot_orchestrator.py
import logging
from typing import AsyncGenerator, Optional, Dict, Any, List
from datetime import datetime, timezone

from app.repositories import conversation_repo, message_repo
from app.clients.chatbot_client import ChatbotClient
from app.clients.recommender_client import RecommenderClient
from app.core.sse import SSEEvent
from app.core.enums import SSEEventType

logger = logging.getLogger(__name__)


class ChatbotOrchestrator:

    def __init__(self):
        self.chatbot_client = ChatbotClient()
        self.recommender_client = RecommenderClient()

        # Import ở đây để tránh circular import
        from app.orchestrators.recommendation_orchestrator import RecommendationOrchestrator
        self.recommendation_orchestrator = RecommendationOrchestrator()

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
            conversation_id=str(request.conversation_id),
            user_id=getattr(request, "user_id", None),
        )

        # 2. Save user message
        await message_repo.create_message(
            session=session,
            conversation_id=conversation.id,
            role="user",
            content=request.message,
        )

        # 3. Load conversation history
        history = await message_repo.get_messages_by_conversation(
            session=session,
            conversation_id=conversation.id,
        )

        # 4. Call Recommender (optional)
        recommendation = None
        if request.enable_recommendation:
            recommendation = await self._call_recommender_safe(request)

        # 5. Build enriched prompt — dùng thông tin chi tiết
        enriched_payload = self._build_chatbot_payload(
            history=history,
            user_message=request.message,
            recommendation=recommendation,
        )

        # 6. Stream LLM tokens
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

        # 7. Emit recommendation AFTER chatbot finished
        # SSE trả về thông tin chi tiết để UI hiển thị cards
        if recommendation:
            yield SSEEvent(
                SSEEventType.RECOMMENDATION,
                {
                    "conversation_id": str(request.conversation_id),
                    "recommendations": recommendation["services"],   # list service detail
                    "total": len(recommendation["services"]),
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                },
            )

        # 8. Persist assistant message
        if full_response:
            await message_repo.create_message(
                session=session,
                conversation_id=conversation.id,
                role="assistant",
                content=full_response,
            )

        # 9. Emit DONE
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

    async def _call_recommender_safe(self, request: Any) -> Optional[Dict[str, Any]]:
        try:
            payload = {
                "conversation_id": str(request.conversation_id),
                "query": request.message,
                "top_k": request.top_k,
            }
            result = await self.recommender_client.recommend_chatbot(payload=payload)

            # Lấy service_ids từ kết quả thô
            service_ids = (
                result["recommendations"][0]["service_ids"]
                if result.get("recommendations") else []
            )

            # Enrich thành thông tin chi tiết
            services = self.recommendation_orchestrator.get_enriched_services(service_ids)
            services_text = self.recommendation_orchestrator.get_enriched_services_for_prompt(service_ids)

            return {
                "services": services,        # list dict chi tiết → dùng cho SSE
                "services_text": services_text,  # string mô tả → dùng cho prompt
            }

        except Exception as e:
            logger.warning(f"Recommender call failed: {e}")
            return None

    def _build_chatbot_payload(
        self,
        history: List[Any],
        user_message: str,
        recommendation: Optional[Dict[str, Any]],
    ) -> Dict[str, Any]:

        # Format history
        history_text = ""
        for msg in history:
            role = "User" if msg.role == "user" else "Assistant"
            history_text += f"{role}: {msg.content}\n"

        # Dùng thông tin chi tiết cho prompt — chatbot giải thích tốt hơn
        services_text = recommendation["services_text"] if recommendation else ""

        return {
            "history": history_text,
            "services": services_text,   
            "question": user_message,
        }


