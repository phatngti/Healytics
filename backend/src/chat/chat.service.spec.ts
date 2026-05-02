import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { ChatService } from './chat.service';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { SendMessageHandler } from './application/handlers/send-message.handler';
import { CreateConversationHandler } from './application/handlers/create-conversation.handler';
import { GetConversationMessagesHandler } from './application/handlers/get-conversation-messages.handler';
import { MarkMessagesReadHandler } from './application/handlers/mark-messages-read.handler';
import { GetUserConversationsHandler } from './application/handlers/get-user-conversations.handler';
import { GetPartnerConversationsHandler } from './application/handlers/get-partner-conversations.handler';
import {
  MockRepository,
  createMockRepository,
} from '../../test/mocks/mock-types';

describe('ChatService', () => {
  let service: ChatService;
  let conversationRepo: MockRepository<PartnerConversation>;
  let sendMessageHandler: { execute: jest.Mock };
  let createConversationHandler: { execute: jest.Mock };
  let getMessagesHandler: { execute: jest.Mock };
  let markReadHandler: { execute: jest.Mock };
  let getUserConversationsHandler: { execute: jest.Mock };
  let getPartnerConversationsHandler: { execute: jest.Mock };

  beforeEach(async () => {
    conversationRepo = createMockRepository<PartnerConversation>();
    sendMessageHandler = { execute: jest.fn() };
    createConversationHandler = { execute: jest.fn() };
    getMessagesHandler = { execute: jest.fn() };
    markReadHandler = { execute: jest.fn() };
    getUserConversationsHandler = { execute: jest.fn() };
    getPartnerConversationsHandler = { execute: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChatService,
        {
          provide: getRepositoryToken(PartnerConversation),
          useValue: conversationRepo,
        },
        { provide: SendMessageHandler, useValue: sendMessageHandler },
        {
          provide: CreateConversationHandler,
          useValue: createConversationHandler,
        },
        {
          provide: GetConversationMessagesHandler,
          useValue: getMessagesHandler,
        },
        { provide: MarkMessagesReadHandler, useValue: markReadHandler },
        {
          provide: GetUserConversationsHandler,
          useValue: getUserConversationsHandler,
        },
        {
          provide: GetPartnerConversationsHandler,
          useValue: getPartnerConversationsHandler,
        },
      ],
    }).compile();

    service = module.get<ChatService>(ChatService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── Gateway Server Registry ─────────────────────────────────

  describe('server registry', () => {
    it('should set and get user server', () => {
      const mockServer = { emit: jest.fn() } as any;
      service.setUserServer(mockServer);
      expect(service.getUserServer()).toBe(mockServer);
    });

    it('should set and get partner server', () => {
      const mockServer = { emit: jest.fn() } as any;
      service.setPartnerServer(mockServer);
      expect(service.getPartnerServer()).toBe(mockServer);
    });

    it('should return null when servers not set', () => {
      expect(service.getUserServer()).toBeNull();
      expect(service.getPartnerServer()).toBeNull();
    });
  });

  // ── Mutations ──────────────────────────────────────────────

  describe('send', () => {
    it('should delegate to sendMessageHandler', async () => {
      const expected = { id: 'msg-1', content: 'Hello' };
      sendMessageHandler.execute.mockResolvedValue(expected);

      const result = await service.send({ content: 'Hello' } as any, 'user-1');

      expect(sendMessageHandler.execute).toHaveBeenCalledWith(
        { content: 'Hello' },
        'user-1',
      );
      expect(result).toEqual(expected);
    });
  });

  describe('create', () => {
    it('should delegate to createConversationHandler', async () => {
      const expected = { id: 'conv-1' };
      createConversationHandler.execute.mockResolvedValue(expected);

      const result = await service.create(
        { partnerId: 'partner-1' } as any,
        'user-1',
      );

      expect(createConversationHandler.execute).toHaveBeenCalledWith(
        { partnerId: 'partner-1' },
        'user-1',
      );
      expect(result).toEqual(expected);
    });
  });

  describe('markAsRead', () => {
    it('should delegate to markReadHandler', async () => {
      markReadHandler.execute.mockResolvedValue(undefined);

      await service.markAsRead('conv-1', 'user-1');

      expect(markReadHandler.execute).toHaveBeenCalledWith('conv-1', 'user-1');
    });
  });

  // ── Queries ────────────────────────────────────────────────

  describe('messagesFor', () => {
    it('should delegate to getMessagesHandler', async () => {
      const expected = { messages: [], hasMore: false, nextCursor: null };
      getMessagesHandler.execute.mockResolvedValue(expected);

      const result = await service.messagesFor('conv-1', 'user-1', {} as any);

      expect(getMessagesHandler.execute).toHaveBeenCalledWith(
        'conv-1',
        'user-1',
        {},
      );
      expect(result).toEqual(expected);
    });
  });

  describe('userConversations', () => {
    it('should delegate to getUserConversationsHandler', async () => {
      const expected = [{ id: 'conv-1' }];
      getUserConversationsHandler.execute.mockResolvedValue(expected);

      const result = await service.userConversations('user-1');

      expect(getUserConversationsHandler.execute).toHaveBeenCalledWith(
        'user-1',
      );
      expect(result).toEqual(expected);
    });
  });

  describe('partnerConversations', () => {
    it('should delegate to getPartnerConversationsHandler', async () => {
      const expected = [{ id: 'conv-2' }];
      getPartnerConversationsHandler.execute.mockResolvedValue(expected);

      const result = await service.partnerConversations('partner-1');

      expect(getPartnerConversationsHandler.execute).toHaveBeenCalledWith(
        'partner-1',
      );
      expect(result).toEqual(expected);
    });
  });

  // ── Helpers ────────────────────────────────────────────────

  describe('getUserConversationIds', () => {
    it('should return list of conversation IDs', async () => {
      conversationRepo.find.mockResolvedValue([
        { id: 'conv-1' },
        { id: 'conv-2' },
      ]);

      const result = await service.getUserConversationIds('user-1');

      expect(result).toEqual(['conv-1', 'conv-2']);
      expect(conversationRepo.find).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        select: ['id'],
      });
    });
  });

  describe('getPartnerConversationIds', () => {
    it('should return list of conversation IDs', async () => {
      conversationRepo.find.mockResolvedValue([{ id: 'conv-3' }]);

      const result = await service.getPartnerConversationIds('partner-1');

      expect(result).toEqual(['conv-3']);
    });
  });
});
