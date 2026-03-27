# 02 — DTOs & Streaming Architecture

**Status:** ✅ COMPLETED

## Context

Defines the data transfer objects for the chatbot API contract and SSE event structures.

## Prerequisites

- ✅ Todo 01 — ChatbotService

## Tasks

### 1. Create DTOs in `src/chatbot/dto/`

- **`send-message.dto.ts`**
  - `message: string` — user message
  - `conversationId?: string` — optional existing conversation

- **`chat-message-response.dto.ts`** (`SendMessageResponseDto`)
  - `conversationId: string`
  - `streamUrl: string` — SSE endpoint URL

- **`conversation-list.dto.ts`**
  - `ConversationListQueryDto` — page, limit query params
  - `ConversationListResponseDto` — paginated conversation summaries

### 2. Create mock data in `src/chatbot/mock-data/`
Development mock responses for testing SSE streaming without the AI backend.

## Completed

DTOs define the full API contract. Mock data enables frontend development without AI backend dependency. SSE events are structured as `MessageEvent` from `@nestjs/common`.
