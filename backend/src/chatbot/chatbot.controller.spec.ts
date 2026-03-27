import { Test, TestingModule } from '@nestjs/testing';
import { ChatbotController } from './chatbot.controller';
import { ChatbotService } from './chatbot.service';

describe('ChatbotController', () => {
  let controller: ChatbotController;

  beforeEach(async () => {
    const service = {
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

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
