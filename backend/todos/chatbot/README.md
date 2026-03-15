# Chatbot Feature — Todo Pipeline

This folder documents the implementation history of the **Chatbot Module** (AI chatbot with SSE streaming for user-facing health service discovery).

## Ordering

Files are numbered `01-` through `03-`. They were executed sequentially.

## Status Convention

Each file starts with a `Status:` line:
- `🔲 TODO` — not started
- `🔄 IN PROGRESS` — currently being worked on
- `✅ COMPLETED` — done, review the **Completed** section for what was implemented

## Current State

> **Note:** The chatbot controller endpoints are currently **commented out** in production. The module provides `ChatbotService` but the SSE streaming controller is disabled pending AI backend integration.

## What's Already Built

| Component | Status | Location |
|---|---|---|
| `ChatbotService` (streaming logic) | ✅ | `src/chatbot/chatbot.service.ts` |
| `ChatbotController` (commented out) | ⏸️ | `src/chatbot/chatbot.controller.ts` |
| SSE DTOs (message, conversation) | ✅ | `src/chatbot/dto/` |
| Mock data for development | ✅ | `src/chatbot/mock-data/` |
