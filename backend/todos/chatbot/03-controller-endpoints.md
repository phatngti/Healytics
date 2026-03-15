# 03 — Controller Endpoints (Disabled)

**Status:** ✅ COMPLETED

## Context

The controller endpoints are fully implemented but **commented out** pending AI backend integration. The architecture is ready for re-enablement.

## Prerequisites

- ✅ Todo 01 — ChatbotService
- ✅ Todo 02 — DTOs

## Tasks

### 1. Create `ChatbotController` (endpoints commented out)

Planned endpoints (currently commented out):

| Method | Path | Auth | Response |
|---|---|---|---|
| `GET` | `/chatbot/conversations` | JWT (USER role) | `ConversationListResponseDto` |
| `POST` | `/chatbot/send` | JWT (USER role) | `SendMessageResponseDto` |
| `SSE` | `/chatbot/stream/:conversationId` | JWT (USER role) | `Observable<MessageEvent>` |

**Usage flow:**
1. `POST /chatbot/send` — submit message, get conversationId + streamUrl
2. `GET /chatbot/stream/:conversationId` — connect to SSE for response
3. `GET /chatbot/conversations` — paginated history

**SSE stream implementation:**
```typescript
@Sse('stream/:conversationId')
streamChat(@Param('conversationId') id: string): Observable<MessageEvent> {
  return this.chatbotService.streamResponse(message, id).pipe(
    catchError(error => of({ type: 'error', data: { error: error.message } })),
    finalize(() => logger.log('SSE disconnect')),
  );
}
```

## Completed

Controller fully implemented with SSE streaming, error handling, and logging. All endpoints commented out pending AI backend. No version prefix (unlike other controllers). Ready for re-enablement when AI integration is complete.
