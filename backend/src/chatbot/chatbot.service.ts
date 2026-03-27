import { Injectable, Logger } from '@nestjs/common';
import { Observable, concat, merge, of, delay, finalize } from 'rxjs';
import { ChatEventType } from './dto/chat-message-response.dto';
import { ConversationListResponseDto } from './dto/conversation-list.dto';
import { randomUUID } from 'crypto';
import {
  MOCK_CONVERSATION_SCRIPTS,
  MOCK_CONVERSATIONS,
  type MockConversationScript,
  type MockScript,
} from './mock-data/chatbot.mock-data';

/**
 * Mock chatbot service that simulates streaming AI responses
 * using Server-Sent Events (SSE) via rxjs Observables.
 *
 * Each conversation is assigned a random {@link MockConversationScript}
 * on its first message. Subsequent messages in the same conversation
 * advance through the script's turns, providing contextually evolving
 * mock responses.
 *
 * Event flow per turn: token(s) → [ ner_location ∥ service_recommendation ] → done
 */
@Injectable()
export class ChatbotService {
  private readonly logger = new Logger(ChatbotService.name);

  /** In-memory store: conversationId → user message */
  private readonly pendingMessages = new Map<string, string>();

  /** Tracks assigned script + current turn index per conversation */
  private readonly conversationState = new Map<
    string,
    { script: MockConversationScript; turnIndex: number }
  >();

  /**
   * Store a user message and return a conversation ID.
   */
  storeMessage(message: string, conversationId?: string): string {
    const id = conversationId || randomUUID();
    this.pendingMessages.set(id, message);
    this.logger.log(`Stored message for conversation ${id}`);
    return id;
  }

  /**
   * Retrieve and consume a stored message by conversation ID.
   */
  getMessage(conversationId: string): string | undefined {
    const message = this.pendingMessages.get(conversationId);
    if (message) {
      this.pendingMessages.delete(conversationId);
    }
    return message;
  }

  /**
   * Stream a mock AI response via SSE.
   *
   * On the first call for a conversation, a random
   * {@link MockConversationScript} is assigned. Each subsequent call
   * advances to the next turn within that script. If all turns are
   * exhausted, the last turn is repeated.
   *
   * Event sequence: token(s) → [ ner_location ∥ service_recommendation ] → done
   */
  streamResponse(message: string, conversationId: string): Observable<MessageEvent> {
    this.logger.log(
      `Streaming response for conversation ${conversationId}: "${message.substring(0, 50)}..."`,
    );

    const requestId = randomUUID();
    const script = this.pickScript(conversationId);

    // Helper to build an SSE MessageEvent with a named event type
    const makeEvent = (type: ChatEventType, data: Record<string, unknown>): MessageEvent =>
      ({ type, data }) as unknown as MessageEvent;

    // 1. Token events — stream each response message word-by-word for realistic typing
    const tokens$: Observable<MessageEvent>[] = script.response.flatMap(
      (response, responseIndex) =>
        this.chunkText(response).map((chunk, chunkIndex) =>
          of(
            makeEvent('token', {
              request_id: requestId,
              conversation_id: conversationId,
              text: chunk,
              response_index: responseIndex,
              chunk_index: chunkIndex,
            }),
          ).pipe(delay(this.randomDelay())),
        ),
    );
    
    

    // 2. NER location event — arrives ~100 ms after tokens finish
    const nerLocation$ = of(
      makeEvent('ner_location', {
        request_id: requestId,
        conversation_id: conversationId,
        entities: script.entities,
      }),
    ).pipe(delay(100));

    // 3. Service recommendation event — arrives ~100 ms after tokens finish
    //    (same delay as nerLocation$ so both fire simultaneously)
    const serviceRec$ = of(
      makeEvent('service_recommendation', {
        request_id: requestId,
        conversation_id: conversationId,
        total: script.recommendations.length,
        recommendations: script.recommendations,
      }),
    ).pipe(delay(100));

    // 4. Done event — sent after both parallel events complete
    const done$ = of(
      makeEvent('done', {
        request_id: requestId,
        conversation_id: conversationId,
        status: 'completed',
      }),
    );


    // ner_location and service_recommendation are merged so they are emitted
    // concurrently, then done is appended sequentially after both complete.
    const parallel$ = merge(nerLocation$, serviceRec$);

    return concat(...tokens$, parallel$, done$).pipe(
      finalize(() =>
        this.logger.log(`Stream completed for conversation ${conversationId}`),
      ),
    );
  }

  /**
   * Return a paginated list of conversations.
   *
   * Currently returns mock data. Replace with a real repository query
   * once conversation persistence is implemented.
   *
   * @param page  1-indexed page number
   * @param limit Number of items per page (max 100)
   */
  getConversations(page: number, limit: number): ConversationListResponseDto {
    const total = MOCK_CONVERSATIONS.length;
    const totalPages = Math.ceil(total / limit);
    const start = (page - 1) * limit;
    const conversations = MOCK_CONVERSATIONS.slice(start, start + limit);

    return {
      conversations,
      meta: { page, limit, total, totalPages },
    };
  }

  // ─── Private helpers ─────────────────────────────────────────────────────────

  /**
   * Pick the appropriate script turn for a conversation.
   *
   * - First call: assigns a random {@link MockConversationScript} and returns turn 0.
   * - Subsequent calls: advances the turn index. If all turns are exhausted,
   *   clamps to the last turn so the conversation always has a valid response.
   */
  private pickScript(conversationId: string): MockScript {
    let state = this.conversationState.get(conversationId);

    if (!state) {
      // First message in this conversation — assign a random conversation script
      const script =
        MOCK_CONVERSATION_SCRIPTS[
          Math.floor(Math.random() * MOCK_CONVERSATION_SCRIPTS.length)
        ];
      state = { script, turnIndex: 0 };
      this.conversationState.set(conversationId, state);
      this.logger.log(
        `Assigned script "${script.title}" to conversation ${conversationId}`,
      );
    }

    const { script, turnIndex } = state;
    const clampedIndex = Math.min(turnIndex, script.turns.length - 1);
    const turn = script.turns[clampedIndex];

    // Advance turn index for the next call
    state.turnIndex = turnIndex + 1;

    this.logger.log(
      `Conversation ${conversationId}: turn ${clampedIndex + 1}/${script.turns.length} ("${script.title}")`,
    );

    return turn;
  }

  /**
   * Split text into small word-group chunks for realistic streaming.
   *
   * Uses `split(/(\s+)/)` to preserve whitespace so that
   * `chunks.join('')` reconstructs the original text losslessly.
   */
  private chunkText(text: string, wordsPerChunk = 4): string[] {
    const parts = text.split(/(\s+)/);
    // Each "word" occupies 2 slots (word + whitespace), except possibly the last.
    const step = wordsPerChunk * 2 - 1;
    const chunks: string[] = [];
    for (let i = 0; i < parts.length; i += step) {
      chunks.push(parts.slice(i, i + step).join(''));
    }
    return chunks.filter(Boolean);
  }

  /** Random delay between 50ms and 150ms to simulate typing speed. */
  private randomDelay(): number {
    return 50 + Math.floor(Math.random() * 100);
  }
}
