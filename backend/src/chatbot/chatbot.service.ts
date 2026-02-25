import { Injectable, Logger } from '@nestjs/common';
import { Observable, concat, of, concatMap, delay, map, finalize } from 'rxjs';
import { ChatMessageResponseDto, ChatEventType } from './dto/chat-message-response.dto';
import { randomUUID } from 'crypto';

/**
 * Mock chatbot service that simulates streaming AI responses
 * using Server-Sent Events (SSE) via rxjs Observables.
 */
@Injectable()
export class ChatbotService {
  private readonly logger = new Logger(ChatbotService.name);

  /** In-memory store: conversationId → user message */
  private readonly pendingMessages = new Map<string, string>();

  /** Pool of mock health-related responses */
  private readonly mockResponses: string[] = [
    'Regular health checkups are essential for early detection of potential health issues. They help monitor vital signs like blood pressure, cholesterol levels, and blood sugar. I recommend scheduling annual checkups with your healthcare provider to maintain optimal health.',
    'Based on your symptoms, I would suggest consulting with a specialist. In the meantime, make sure to stay hydrated, get adequate rest, and maintain a balanced diet rich in vitamins and minerals. Would you like me to recommend some dietary guidelines?',
    'Exercise plays a crucial role in maintaining both physical and mental health. Studies show that 30 minutes of moderate exercise daily can significantly reduce the risk of heart disease, diabetes, and depression. Start with walking and gradually increase intensity.',
    'Sleep hygiene is often overlooked but is vital for recovery and immune function. Adults should aim for 7-9 hours of quality sleep. Establish a consistent bedtime routine, limit screen time before bed, and keep your bedroom cool and dark.',
    'Stress management is key to overall wellness. Consider incorporating mindfulness meditation, deep breathing exercises, or yoga into your daily routine. Even 10 minutes of meditation can significantly reduce cortisol levels and improve mental clarity.',
    'A balanced diet rich in fruits, vegetables, whole grains, and lean proteins provides the essential nutrients your body needs. Limit processed foods, excessive sugar, and sodium. Staying hydrated by drinking at least 8 glasses of water daily is equally important.',
  ];

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
   * Stream a mock AI response word-by-word via SSE.
   *
   * Event sequence: start → token(s) → end
   *
   * @param message  The user's input message
   * @param conversationId  The conversation identifier
   * @returns Observable<MessageEvent> suitable for NestJS @Sse()
   */
  streamResponse(message: string, conversationId: string): Observable<MessageEvent> {
    this.logger.log(`Streaming response for conversation ${conversationId}: "${message.substring(0, 50)}..."`);

    const reply = this.pickMockResponse(message);
    const words = reply.split(' ');

    const makeEvent = (type: ChatEventType, content: string): MessageEvent => {
      const data: ChatMessageResponseDto = {
        type,
        content,
        conversationId,
        timestamp: new Date().toISOString(),
      };
      return { data } as MessageEvent;
    };

    // 1. Start event
    const start$ = of(makeEvent('start', ''));

    // 2. Token events — stream word-by-word with random delay
    const tokens$ = of(...words).pipe(
      concatMap((word, index) =>
        of(makeEvent('token', word)).pipe(
          delay(this.randomDelay()),
        ),
      ),
    );

    // 3. End event — full reply
    const end$ = of(makeEvent('end', reply));

    return concat(start$, tokens$, end$).pipe(
      finalize(() => this.logger.log(`Stream completed for conversation ${conversationId}`)),
    );
  }

  /**
   * Pick a mock response. Uses a simple hash of the message
   * to provide deterministic-feeling responses.
   */
  private pickMockResponse(message: string): string {
    const hash = message.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0);
    return this.mockResponses[hash % this.mockResponses.length];
  }

  /**
   * Random delay between 50ms and 150ms to simulate typing speed.
   */
  private randomDelay(): number {
    return 50 + Math.floor(Math.random() * 100);
  }
}
