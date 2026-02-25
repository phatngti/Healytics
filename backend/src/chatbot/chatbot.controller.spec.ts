import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { of } from 'rxjs';
import { ChatbotController } from './chatbot.controller';
import { ChatbotService } from './chatbot.service';

describe('ChatbotController', () => {
  let controller: ChatbotController;
  let service: Record<string, jest.Mock>;

  beforeEach(async () => {
    service = {
      storeMessage: jest.fn(),
      getMessage: jest.fn(),
      streamResponse: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [ChatbotController],
      providers: [
        { provide: ChatbotService, useValue: service },
      ],
    }).compile();

    controller = module.get<ChatbotController>(ChatbotController);
  });

  afterEach(() => jest.clearAllMocks());

  describe('sendMessage', () => {
    it('should store message and return conversationId + streamUrl', () => {
      // Arrange
      const mockId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
      service.storeMessage.mockReturnValue(mockId);

      // Act
      const result = controller.sendMessage({ message: 'Hello bot' });

      // Assert
      expect(service.storeMessage).toHaveBeenCalledWith('Hello bot', undefined);
      expect(result.conversationId).toBe(mockId);
      expect(result.streamUrl).toBe(`/v1/chatbot/stream/${mockId}`);
    });

    it('should pass existing conversationId to service', () => {
      // Arrange
      const existingId = '11111111-2222-3333-4444-555555555555';
      service.storeMessage.mockReturnValue(existingId);

      // Act
      const result = controller.sendMessage({
        message: 'Hello',
        conversationId: existingId,
      });

      // Assert
      expect(service.storeMessage).toHaveBeenCalledWith('Hello', existingId);
      expect(result.conversationId).toBe(existingId);
    });
  });

  describe('streamChat', () => {
    it('should return SSE observable when conversation exists', () => {
      // Arrange
      const conversationId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
      const mockMessage = 'User message';
      const mockObservable = of({ data: { type: 'start' } });
      service.getMessage.mockReturnValue(mockMessage);
      service.streamResponse.mockReturnValue(mockObservable);

      // Act
      const result = controller.streamChat(conversationId);

      // Assert
      expect(service.getMessage).toHaveBeenCalledWith(conversationId);
      expect(service.streamResponse).toHaveBeenCalledWith(mockMessage, conversationId);
      expect(result).toBe(mockObservable);
    });

    it('should throw NotFoundException when conversation not found', () => {
      // Arrange
      service.getMessage.mockReturnValue(undefined);

      // Act & Assert
      expect(() =>
        controller.streamChat('nonexistent-id'),
      ).toThrow(NotFoundException);
    });
  });
});
