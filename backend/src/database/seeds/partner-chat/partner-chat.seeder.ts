import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { Booking } from '@/common/entities/booking.entity';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { PartnerChatMessage } from '@/common/entities/partner-chat-message.entity';
import { PartnerChatAttachment } from '@/common/entities/partner-chat-attachment.entity';
import { MessageType } from '@/chat/enums/message-type.enum';
import { ConversationStatus } from '@/chat/enums/conversation-status.enum';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, buildMapBy, likePrefix, seedKey } from '../utils/seed.utils';

interface SeedConversation {
  code: string;
  userEmail: string;
  partnerEmail: string;
  bookingNotes: string | null;
}

interface SeedMessage {
  conversationCode: string;
  code: string;
  sender: 'user' | 'partner';
  messageType: MessageType;
  content: string;
  attachments?: Array<{
    fileUrl: string;
    fileName: string;
    fileType: string;
    fileSize: number;
  }>;
}

const SEED_CONVERSATIONS: SeedConversation[] = [
  {
    code: 'CONV_001',
    userEmail: 'user@healytics.vn',
    partnerEmail: 'partner@healytics.vn',
    bookingNotes: 'Please use lavender oil',
  },
  {
    code: 'CONV_002',
    userEmail: 'user@healytics.vn',
    partnerEmail: 'partner2@healytics.vn',
    bookingNotes: null,
  },
];

const SEED_MESSAGES: SeedMessage[] = [
  {
    conversationCode: 'CONV_001',
    code: '001',
    sender: 'user',
    messageType: MessageType.TEXT,
    content: 'Hello clinic, I would like to confirm my booking details.',
  },
  {
    conversationCode: 'CONV_001',
    code: '002',
    sender: 'partner',
    messageType: MessageType.TEXT,
    content: 'Hi! Your booking is confirmed. Please arrive 15 minutes early.',
  },
  {
    conversationCode: 'CONV_001',
    code: '003',
    sender: 'user',
    messageType: MessageType.IMAGE,
    content: 'Sharing my skin condition image before treatment.',
    attachments: [
      {
        fileUrl: 'https://storage.healytics.vn/chat/seed/condition-image.jpg',
        fileName: 'seed_condition_image.jpg',
        fileType: 'image/jpeg',
        fileSize: 145000,
      },
    ],
  },
  {
    conversationCode: 'CONV_001',
    code: '004',
    sender: 'partner',
    messageType: MessageType.SYSTEM,
    content: 'System note: Consultation checklist has been updated.',
  },
  {
    conversationCode: 'CONV_002',
    code: '005',
    sender: 'user',
    messageType: MessageType.TEXT,
    content: 'Can your dental clinic handle sensitive teeth whitening?',
  },
  {
    conversationCode: 'CONV_002',
    code: '006',
    sender: 'partner',
    messageType: MessageType.FILE,
    content: 'Please review this treatment guide PDF before your appointment.',
    attachments: [
      {
        fileUrl: 'https://storage.healytics.vn/chat/seed/dental-guide.pdf',
        fileName: 'seed_dental_guide.pdf',
        fileType: 'application/pdf',
        fileSize: 298000,
      },
    ],
  },
  {
    conversationCode: 'CONV_002',
    code: '007',
    sender: 'partner',
    messageType: MessageType.TEXT,
    content: 'We can customize whitening intensity for sensitive teeth.',
  },
  {
    conversationCode: 'CONV_002',
    code: '008',
    sender: 'user',
    messageType: MessageType.TEXT,
    content: 'Great, thank you. I will book a slot this weekend.',
  },
];

@Injectable()
export class PartnerChatSeeder implements ISeeder {
  private readonly logger = new Logger(PartnerChatSeeder.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(PartnerConversation)
    private readonly conversationRepo: Repository<PartnerConversation>,
    @InjectRepository(PartnerChatMessage)
    private readonly messageRepo: Repository<PartnerChatMessage>,
    @InjectRepository(PartnerChatAttachment)
    private readonly attachmentRepo: Repository<PartnerChatAttachment>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding partner chat data...');

    const accountEmails = [
      ...new Set(
        SEED_CONVERSATIONS.flatMap((conversation) => [
          conversation.userEmail,
          conversation.partnerEmail,
        ]),
      ),
    ];

    const accounts = await this.accountRepo.find({
      where: { email: In(accountEmails) },
      select: ['id', 'email'],
    });
    const accountMap = buildMapBy(accounts, (account) => account.email);

    const conversationMap = new Map<string, PartnerConversation>();
    for (const seed of SEED_CONVERSATIONS) {
      const user = accountMap.get(seed.userEmail);
      const partner = accountMap.get(seed.partnerEmail);
      if (!user || !partner) {
        this.logger.warn(`  ⚠ Missing accounts for conversation "${seed.code}" — skipping`);
        continue;
      }

      let bookingId: string | null = null;
      if (seed.bookingNotes) {
        const booking = await this.bookingRepo.findOne({
          where: { notes: seed.bookingNotes },
          select: ['id'],
        });
        bookingId = booking?.id ?? null;
      }

      let conversation = await this.conversationRepo.findOne({
        where: { userId: user.id, partnerAccountId: partner.id },
      });

      if (!conversation) {
        conversation = await this.conversationRepo.save(
          this.conversationRepo.create({
            userId: user.id,
            partnerAccountId: partner.id,
            bookingId,
            status: ConversationStatus.ACTIVE,
            userUnreadCount: 0,
            partnerUnreadCount: 0,
          }),
        );
        this.logger.log(`  ✅ Created conversation "${seed.code}"`);
      } else {
        this.logger.log(`  ⏭ Conversation "${seed.code}" already exists, reusing`);
      }

      conversationMap.set(seed.code, conversation);
    }

    for (const seed of SEED_MESSAGES) {
      const conversation = conversationMap.get(seed.conversationCode);
      if (!conversation) continue;

      const senderId =
        seed.sender === 'user' ? conversation.userId : conversation.partnerAccountId;
      const clientMessageId = seedKey(SEED_MARKERS.chatClientMessageId, seed.code);

      const existing = await this.messageRepo.findOne({
        where: { conversationId: conversation.id, clientMessageId },
      });
      if (existing) {
        this.logger.log(`  ⏭ Message "${clientMessageId}" already exists, skipping`);
        continue;
      }

      const message = await this.messageRepo.save(
        this.messageRepo.create({
          conversationId: conversation.id,
          senderId,
          messageType: seed.messageType,
          content: seed.content,
          clientMessageId,
        }),
      );

      if (seed.attachments?.length) {
        for (const attachmentSeed of seed.attachments) {
          await this.attachmentRepo.save(
            this.attachmentRepo.create({
              messageId: message.id,
              fileUrl: attachmentSeed.fileUrl,
              fileName: attachmentSeed.fileName,
              fileType: attachmentSeed.fileType,
              fileSize: attachmentSeed.fileSize,
            }),
          );
        }
      }

      await this.conversationRepo.update(conversation.id, {
        lastMessageText: seed.content.substring(0, 200),
        lastMessageAt: message.createdAt,
        lastMessageSenderId: senderId,
        userUnreadCount: senderId === conversation.userId ? 0 : 1,
        partnerUnreadCount: senderId === conversation.partnerAccountId ? 0 : 1,
      });

      this.logger.log(`  ✅ Created message "${clientMessageId}"`);
    }

    this.logger.log('Partner chat seeding completed');
  }

  async clear(): Promise<void> {
    const seededMessages = await this.messageRepo.find({
      where: { clientMessageId: Like(likePrefix(SEED_MARKERS.chatClientMessageId)) },
      select: ['id'],
    });

    if (!seededMessages.length) {
      this.logger.warn('⚠ No seed partner chat messages found to delete');
      return;
    }

    const messageIds = seededMessages.map((message) => message.id);
    const { affected: attachmentAffected } = await this.attachmentRepo.delete({
      messageId: In(messageIds),
    });
    if (attachmentAffected) {
      this.logger.log(`🗑️ Hard-deleted ${attachmentAffected} seed chat attachment(s)`);
    }

    const { affected: messageAffected } = await this.messageRepo.delete({
      id: In(messageIds),
    });
    this.logger.log(`🗑️ Hard-deleted ${messageAffected ?? 0} seed chat message(s)`);

    const accountEmails = [
      ...new Set(
        SEED_CONVERSATIONS.flatMap((conversation) => [
          conversation.userEmail,
          conversation.partnerEmail,
        ]),
      ),
    ];
    const accounts = await this.accountRepo.find({
      where: { email: In(accountEmails) },
      select: ['id', 'email'],
    });
    const accountMap = buildMapBy(accounts, (account) => account.email);

    for (const seed of SEED_CONVERSATIONS) {
      const user = accountMap.get(seed.userEmail);
      const partner = accountMap.get(seed.partnerEmail);
      if (!user || !partner) continue;

      const conversation = await this.conversationRepo.findOne({
        where: { userId: user.id, partnerAccountId: partner.id },
      });
      if (!conversation) continue;

      const remainingMessages = await this.messageRepo.count({
        where: { conversationId: conversation.id },
      });
      if (remainingMessages === 0) {
        await this.conversationRepo.delete({ id: conversation.id });
      }
    }
  }
}
