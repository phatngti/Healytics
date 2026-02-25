import { Test, TestingModule } from '@nestjs/testing';
import { ChatbotService } from './chatbot.service';
import { lastValueFrom, toArray } from 'rxjs';

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
    it('should emit start → token(s) → end event sequence', async () => {
      const conversationId = '22222222-2222-2222-2222-222222222222';

      const events = await lastValueFrom(
        service.streamResponse('test message', conversationId).pipe(toArray()),
      );

      // At least 3 events: start, 1+ tokens, end
      expect(events.length).toBeGreaterThanOrEqual(3);

      // First event is 'start'
      const startData = (events[0] as any).data;
      expect(startData.type).toBe('start');
      expect(startData.conversationId).toBe(conversationId);

      // Last event is 'end'
      const endData = (events[events.length - 1] as any).data;
      expect(endData.type).toBe('end');
      expect(endData.content).toBeTruthy();
      expect(endData.conversationId).toBe(conversationId);

      // Middle events are all 'token'
      const tokenEvents = events.slice(1, -1);
      for (const event of tokenEvents) {
        expect((event as any).data.type).toBe('token');
        expect((event as any).data.content).toBeTruthy();
      }
    });

    it('should include timestamp in all events', async () => {
      const events = await lastValueFrom(
        service.streamResponse('test', 'id-123').pipe(toArray()),
      );

      for (const event of events) {
        const data = (event as any).data;
        expect(data.timestamp).toBeDefined();
        expect(() => new Date(data.timestamp)).not.toThrow();
      }
    });

    it('should return deterministic response for the same message', async () => {
      const events1 = await lastValueFrom(
        service.streamResponse('exact same input', 'id-a').pipe(toArray()),
      );
      const events2 = await lastValueFrom(
        service.streamResponse('exact same input', 'id-b').pipe(toArray()),
      );

      const end1 = (events1[events1.length - 1] as any).data.content;
      const end2 = (events2[events2.length - 1] as any).data.content;

      expect(end1).toBe(end2);
    }, 15000);
  });
});
