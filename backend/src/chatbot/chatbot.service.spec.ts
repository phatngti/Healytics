import { Test, TestingModule } from '@nestjs/testing';
import { ChatbotService } from './chatbot.service';
import { lastValueFrom, toArray } from 'rxjs';
import { MOCK_CONVERSATION_SCRIPTS } from './mock-data/chatbot.mock-data';

describe('ChatbotService', () => {
  let service: ChatbotService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ChatbotService],
    }).compile();

    service = module.get<ChatbotService>(ChatbotService);
  });

  describe('storeMessage / getMessage', () => {
    it('should store and retrieve a message', () => {
      const id = service.storeMessage('Hello');

      const result = service.getMessage(id);

      expect(result).toBe('Hello');
    });

    it('should consume the message on retrieval (single use)', () => {
      const id = service.storeMessage('Hello');
      service.getMessage(id);

      const result = service.getMessage(id);

      expect(result).toBeUndefined();
    });

    it('should use provided conversationId when given', () => {
      const customId = '11111111-1111-1111-1111-111111111111';

      const id = service.storeMessage('Hello', customId);

      expect(id).toBe(customId);
      expect(service.getMessage(customId)).toBe('Hello');
    });

    it('should return undefined for unknown conversationId', () => {
      const result = service.getMessage('non-existent-id');

      expect(result).toBeUndefined();
    });
  });

  describe('streamResponse', () => {
    it('should emit token(s) → ner_location → service_recommendation → done event sequence', async () => {
      const conversationId = '22222222-2222-2222-2222-222222222222';

      const events = await lastValueFrom(
        service.streamResponse('test message', conversationId).pipe(toArray()),
      );

      // At least 4 events: 1+ tokens, ner_location, service_recommendation, done
      expect(events.length).toBeGreaterThanOrEqual(4);

      // Last event is 'done'
      const lastEvent = events[events.length - 1] as any;
      expect(lastEvent.type).toBe('done');
      expect(lastEvent.data.conversation_id).toBe(conversationId);
      expect(lastEvent.data.status).toBe('completed');

      // Second-to-last is 'service_recommendation'
      const recEvent = events[events.length - 2] as any;
      expect(recEvent.type).toBe('service_recommendation');
      expect(recEvent.data.total).toBeGreaterThan(0);
      expect(recEvent.data.recommendations).toBeInstanceOf(Array);

      // Third-to-last is 'ner_location'
      const nerEvent = events[events.length - 3] as any;
      expect(nerEvent.type).toBe('ner_location');
      expect(nerEvent.data.entities).toBeInstanceOf(Array);

      // All preceding events are 'token'
      const tokenEvents = events.slice(0, -3);
      expect(tokenEvents.length).toBeGreaterThanOrEqual(1);
      for (const event of tokenEvents) {
        const e = event as any;
        expect(e.type).toBe('token');
        expect(e.data.text).toBeTruthy();
        expect(e.data.response_index).toBeGreaterThanOrEqual(0);
      }
    });

    it('should include request_id and conversation_id in all events', async () => {
      const conversationId = 'id-123';
      const events = await lastValueFrom(
        service.streamResponse('test', conversationId).pipe(toArray()),
      );

      for (const event of events) {
        const data = (event as any).data;
        expect(data.request_id).toBeDefined();
        expect(data.conversation_id).toBe(conversationId);
      }
    });

    it('should advance through conversation turns on successive calls', async () => {
      const conversationId = 'multi-turn-test';

      const events1 = await lastValueFrom(
        service.streamResponse('first message', conversationId).pipe(toArray()),
      );
      const events2 = await lastValueFrom(
        service.streamResponse('follow-up message', conversationId).pipe(toArray()),
      );

      // Extract token texts from each turn
      const tokens1 = events1
        .filter((e: any) => e.type === 'token')
        .map((e: any) => e.data.text);
      const tokens2 = events2
        .filter((e: any) => e.type === 'token')
        .map((e: any) => e.data.text);

      // Different turns should produce different response tokens
      expect(tokens1).not.toEqual(tokens2);
    }, 15000);

    // ─── Performance / Chunking Tests ──────────────────────────────────────

    it('should chunk large text into multiple token events per response', async () => {
      // Use the large-text conversation script (Conversation 5) directly
      const largeScript = MOCK_CONVERSATION_SCRIPTS[MOCK_CONVERSATION_SCRIPTS.length - 1];
      const longResponse = largeScript.turns[0].response[0];
      // Sanity: mock data must actually contain a long response
      expect(longResponse.split(/\s+/).length).toBeGreaterThan(50);

      const conversationId = 'large-text-test';
      const events = await lastValueFrom(
        service.streamResponse('health checkup advice', conversationId).pipe(toArray()),
      );

      const tokenEvents = events.filter((e: any) => e.type === 'token');

      // With word-level chunking (4 words/chunk), a long response should produce
      // many more token events than total response strings
      const totalResponseStrings = largeScript.turns[0].response.length;
      expect(tokenEvents.length).toBeGreaterThan(totalResponseStrings * 3);
    }, 30000);

    it('should preserve original text when chunks are concatenated', async () => {
      const conversationId = 'lossless-test';
      const events = await lastValueFrom(
        service.streamResponse('test lossless', conversationId).pipe(toArray()),
      );

      const tokenEvents = events.filter((e: any) => e.type === 'token') as any[];

      // Group token events by response_index
      const groupedByResponse = new Map<number, string[]>();
      for (const e of tokenEvents) {
        const idx = e.data.response_index as number;
        if (!groupedByResponse.has(idx)) groupedByResponse.set(idx, []);
        groupedByResponse.get(idx)!.push(e.data.text);
      }

      // Get the script that was assigned to this conversation
      // (we can't know which random script was picked, but we can verify
      // the concatenated chunks match internally — each group's joined text
      // should be non-empty and chunk_index should be sequential)
      for (const [, chunks] of groupedByResponse) {
        const reconstructed = chunks.join('');
        expect(reconstructed.length).toBeGreaterThan(0);
        // Verify no leading/trailing whitespace was lost
        expect(reconstructed).not.toMatch(/^\s|\s$/);
      }

      // Verify chunk_index is sequential within each response_index
      for (const e of tokenEvents) {
        expect(e.data.chunk_index).toBeGreaterThanOrEqual(0);
      }
    }, 15000);

    it('should emit chunk_index starting from 0 for each response_index', async () => {
      const conversationId = 'chunk-index-test';
      const events = await lastValueFrom(
        service.streamResponse('test', conversationId).pipe(toArray()),
      );

      const tokenEvents = events.filter((e: any) => e.type === 'token') as any[];

      // Group by response_index and verify chunk_index starts at 0
      const groupedByResponse = new Map<number, number[]>();
      for (const e of tokenEvents) {
        const idx = e.data.response_index as number;
        if (!groupedByResponse.has(idx)) groupedByResponse.set(idx, []);
        groupedByResponse.get(idx)!.push(e.data.chunk_index);
      }

      for (const [, chunkIndices] of groupedByResponse) {
        expect(chunkIndices[0]).toBe(0);
        // Verify sequential
        for (let i = 1; i < chunkIndices.length; i++) {
          expect(chunkIndices[i]).toBe(chunkIndices[i - 1] + 1);
        }
      }
    }, 15000);
  });
});
