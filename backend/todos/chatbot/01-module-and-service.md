# 01 — Module & Service

**Status:** ✅ COMPLETED

## Context

The chatbot module provides an AI-powered health service discovery experience. Users send messages, and the backend streams responses via Server-Sent Events (SSE) including text tokens, NER entities, and service recommendations.

## Prerequisites

- ✅ `rxjs` for Observable-based SSE streaming
- ✅ Health service data for recommendations

## Tasks

### 1. Create `src/chatbot/chatbot.module.ts`
```typescript
@Module({
  // controllers: [ChatbotController],  // commented out pending AI integration
  providers: [ChatbotService],
  exports: [ChatbotService],
})
```
> Controller registration is commented out. Service is exported for potential internal use.

### 2. Create `src/chatbot/chatbot.service.ts`
Core methods:
- `storeMessage(message, conversationId?)` — stores message in memory map, returns conversationId
- `getMessage(conversationId)` — retrieves and consumes stored message
- `getConversations(page, limit)` — paginated conversation list (mock data)
- `streamResponse(message, conversationId)` — returns `Observable<MessageEvent>` with SSE event stream

SSE event types:
- `token` — incremental text tokens
- `ner_location` — named-entity recognition for locations
- `service_recommendation` — ranked service recommendations with IDs
- `done` — stream completed
- `error` — error event

## Completed

Service implemented with in-memory message storage and Observable-based SSE streaming. Mock data available for development. Module exports service but controller is disabled.
