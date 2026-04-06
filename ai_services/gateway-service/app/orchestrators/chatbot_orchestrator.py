# app/orchestrators/chatbot_orchestrator.py
import logging
from typing import AsyncGenerator, Optional, Dict, Any, List
from datetime import datetime, timezone

from app.repositories import conversation_repo, message_repo
from app.clients.chatbot_client import ChatbotClient
from app.clients.recommender_client import RecommenderClient
from app.clients.ner_client import NERClient
from app.core.sse import SSEEvent
from app.core.enums import SSEEventType
from app.intent_classification.main import load_model, predict_intent
from uuid import uuid4, UUID
from app.utils import formatters

logger = logging.getLogger(__name__)


class ChatbotOrchestrator:

    def __init__(self):
        self.chatbot_client = ChatbotClient()
        self.recommender_client = RecommenderClient()
        self.ner_client = NERClient()

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
        
        if request.conversation_id is None:
            request.conversation_id = uuid4()

        # 1. Get or create conversation
        conversation = await conversation_repo.get_or_create_conversation(
            session=session,
            conversation_id=request.conversation_id,
            user_id=request.user_id,
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
        model, clf = load_model()
        need_recommend = predict_intent(request.message, model, clf)
        
        if need_recommend:
            recommendation = await self._call_recommender_safe(request)

        # 5. Build enriched prompt — dùng thông tin chi tiết
        enriched_payload = self._build_chatbot_payload(
            history=history,
            user_message=request.message,
            recommendation=recommendation,
        )

        # 6. Stream LLM tokens
        full_response = ""
        try:
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
        except Exception as e:
            logger.exception("Chatbot stream failed: %s", e)
            yield SSEEvent(
                SSEEventType.ERROR,
                {
                    "conversation_id": str(request.conversation_id),
                    "message": str(e),
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                },
            )
            yield SSEEvent(
                SSEEventType.DONE,
                {
                    "conversation_id": str(request.conversation_id),
                    "status": "failed",
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                },
            )
            return

        # 7. Emit recommendation AFTER chatbot finished
        # SSE trả về thông tin chi tiết để UI hiển thị cards
        if need_recommend and recommendation:
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

    async def get_conversations(
        self,
        session: Any,
        user_id: UUID,
        page: int = 1,
        limit: int = 10,
    ) -> Dict[str, Any]:
        """
        Return a paginated list of conversations for a user.
        """
        conversations, total = await conversation_repo.get_conversations_page(
            session=session,
            user_id=user_id,
            page=page,
            limit=limit,
        )
        return formatters.format_conversations_page(conversations, total, page, limit)

    async def get_messages(
        self,
        session: Any,
        conversation_id: str | UUID,
        page: int = 1,
        limit: int = 20,
    ) -> Dict[str, Any]:
        """
        Return a paginated list of messages for a conversation.
        """
        messages, total = await message_repo.get_messages_page(
            session=session,
            conversation_id=conversation_id,
            page=page,
            limit=limit,
        )
        return formatters.format_messages_page(messages, total, page, limit)

    # ============================================
    # PRIVATE HELPERS
    # ============================================

    async def _call_recommender_safe(self, request: Any) -> Optional[Dict[str, Any]]:
        try:
            ner_payload = {
                "text": request.message
            }
            filtered_ids = await self.ner_client.get_service_ids(payload=ner_payload)
            logger.info(
                "[TRACE] ner_prefilter conversation_id=%s message_len=%s filtered_ids_count=%s filtered_ids_sample=%s ner_url=%s",
                str(request.conversation_id),
                len(request.message or ""),
                len(filtered_ids) if isinstance(filtered_ids, list) else -1,
                [str(x) for x in (filtered_ids or [])[:5]] if isinstance(filtered_ids, list) else [],
                self.ner_client.base_url,
            )
            recommender_payload = {
                "conversation_id": str(request.conversation_id),
                "query": request.message,
                "top_k": request.top_k,
                "filtered_ids": filtered_ids,
            }
            result = await self.recommender_client.recommend_chatbot(payload=recommender_payload)

            # Lấy service_ids từ kết quả thô
            service_ids = (
                result["recommendations"][0]["service_ids"]
                if result.get("recommendations") else []
            )
            scores = (
                result["recommendations"][0].get("scores")
                if result.get("recommendations") else []
            )
            logger.info(
                "[TRACE] recommender_chatbot conversation_id=%s top_k=%s service_ids_count=%s service_ids_sample=%s scores_sample=%s recommender_url=%s",
                str(request.conversation_id),
                request.top_k,
                len(service_ids) if isinstance(service_ids, list) else -1,
                [str(x) for x in (service_ids or [])[:5]] if isinstance(service_ids, list) else [],
                (scores or [])[:5] if isinstance(scores, list) else [],
                self.recommender_client.base_url,
            )

            # Enrich thành thông tin chi tiết
            services = await self.recommendation_orchestrator.get_enriched_services(service_ids)
            services_text = await self.recommendation_orchestrator.get_enriched_services_for_prompt(service_ids)
            logger.info(
                "[TRACE] enrich_done conversation_id=%s services_count=%s",
                str(request.conversation_id),
                len(services) if isinstance(services, list) else -1,
            )

            return {
                "services": services,        # list dict chi tiết → dùng cho SSE
                "services_text": services_text,  # string mô tả → dùng cho prompt
            }

        except Exception as e:
            logger.warning(
                "Recommender call failed: %r | ner_url=%s | recommender_url=%s",
                e,
                self.ner_client.base_url,
                self.recommender_client.base_url,
                exc_info=True,
            )
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


