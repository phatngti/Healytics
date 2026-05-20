import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { AiConversation } from '@/common/entities/conversation.entity';
import { AiChatMessage } from '@/common/entities/chat-message.entity';
import { ISeeder } from '../seeder.interface';
import {
  SEED_MARKERS,
  buildMapBy,
  likePrefix,
  seedKey,
} from '../utils/seed.utils';

interface SeedConversationData {
  code: string;
  userEmail: string;
  title: string;
  messages: Array<{ role: 'user' | 'assistant'; content: string }>;
}

const SEED_AI_CONVERSATIONS: SeedConversationData[] = [
  {
    code: '001',
    userEmail: 'user@healytics.vn',
    title: seedKey(SEED_MARKERS.aiConversationTitle, 'WELLNESS'),
    messages: [
      {
        role: 'user',
        content:
          'I have persistent neck stiffness after long office hours. What service should I book first?',
      },
      {
        role: 'assistant',
        content:
          'You can start with a targeted neck and shoulder therapy session, then reassess after 2-3 visits.',
      },
      {
        role: 'user',
        content: 'Can I combine this with a relaxation massage on weekends?',
      },
      {
        role: 'assistant',
        content:
          'Yes, that combination works well for recovery and stress reduction.',
      },
    ],
  },
  {
    code: '002',
    userEmail: 'user@healytics.vn',
    title: seedKey(SEED_MARKERS.aiConversationTitle, 'DENTAL'),
    messages: [
      {
        role: 'user',
        content:
          'I am considering professional teeth whitening. Is there anything I should avoid beforehand?',
      },
      {
        role: 'assistant',
        content:
          'Avoid staining beverages and discuss sensitivity history with the specialist before treatment.',
      },
    ],
  },
  {
    code: '003',
    userEmail: 'nguyenvana@healytics.vn',
    title: seedKey(SEED_MARKERS.aiConversationTitle, 'ORAL_CARE'),
    messages: [
      {
        role: 'user',
        content:
          'How often should I book professional dental cleaning if I drink coffee daily?',
      },
      {
        role: 'assistant',
        content:
          'Many people benefit from cleaning every 6 months, but ask the dentist to adjust based on stain buildup and gum condition.',
      },
    ],
  },
  {
    code: '004',
    userEmail: 'levanc@healytics.vn',
    title: seedKey(SEED_MARKERS.aiConversationTitle, 'NUTRITION'),
    messages: [
      {
        role: 'user',
        content:
          'I want a meal plan for better afternoon energy without too much caffeine.',
      },
      {
        role: 'assistant',
        content:
          'A nutrition consultation can review breakfast protein, lunch portions, hydration and snack timing.',
      },
    ],
  },
  {
    code: '005',
    userEmail: 'vuthif@healytics.vn',
    title: seedKey(SEED_MARKERS.aiConversationTitle, 'MENTAL_WELLNESS'),
    messages: [
      {
        role: 'user',
        content:
          'I feel stressed before sleep and want to know whether counseling is appropriate.',
      },
      {
        role: 'assistant',
        content:
          'Counseling can help map triggers and create practical sleep routines. Consider booking an intake session.',
      },
    ],
  },
];

@Injectable()
export class AiConversationSeeder implements ISeeder {
  private readonly logger = new Logger(AiConversationSeeder.name);

  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(AiConversation)
    private readonly conversationRepo: Repository<AiConversation>,
    @InjectRepository(AiChatMessage)
    private readonly messageRepo: Repository<AiChatMessage>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding AI conversation history...');

    const accounts = await this.accountRepo.find({
      where: {
        email: In([
          ...new Set(SEED_AI_CONVERSATIONS.map((item) => item.userEmail)),
        ]),
      },
      select: ['id', 'email'],
      loadEagerRelations: false,
    });
    const accountMap = buildMapBy(accounts, (account) => account.email);

    for (const seed of SEED_AI_CONVERSATIONS) {
      const account = accountMap.get(seed.userEmail);
      if (!account) {
        this.logger.warn(
          `  ⚠ User "${seed.userEmail}" not found — skipping AI conversation`,
        );
        continue;
      }

      let conversation = await this.conversationRepo.findOne({
        where: { userId: account.id, title: seed.title },
      });
      if (!conversation) {
        conversation = await this.conversationRepo.save(
          this.conversationRepo.create({
            userId: account.id,
            title: seed.title,
          }),
        );
        this.logger.log(`  ✅ Created AI conversation "${seed.title}"`);
      } else {
        this.logger.log(
          `  ⏭ AI conversation "${seed.title}" already exists, reusing`,
        );
      }

      const existingMessages = await this.messageRepo.find({
        where: { conversationId: conversation.id },
        order: { createdAt: 'ASC' },
        select: ['id', 'role', 'content'],
      });
      if (existingMessages.length >= seed.messages.length) {
        this.logger.log(
          `  ⏭ AI messages already present for "${seed.title}", skipping`,
        );
        continue;
      }

      for (
        let index = existingMessages.length;
        index < seed.messages.length;
        index += 1
      ) {
        const messageSeed = seed.messages[index];
        await this.messageRepo.save(
          this.messageRepo.create({
            conversationId: conversation.id,
            role: messageSeed.role,
            content: messageSeed.content,
          }),
        );
      }
      this.logger.log(`  ✅ Seeded AI messages for "${seed.title}"`);
    }

    this.logger.log('AI conversation seeding completed');
  }

  async clear(): Promise<void> {
    const conversations = await this.conversationRepo.find({
      where: {
        title: In(SEED_AI_CONVERSATIONS.map((item) => item.title)),
      },
      select: ['id', 'title'],
    });

    if (!conversations.length) {
      this.logger.warn('⚠ No seed AI conversations found to delete');
      return;
    }

    const conversationIds = conversations.map(
      (conversation) => conversation.id,
    );
    const { affected: messageAffected } = await this.messageRepo.delete({
      conversationId: In(conversationIds),
    });
    if (messageAffected) {
      this.logger.log(`🗑️ Hard-deleted ${messageAffected} seed AI message(s)`);
    }

    const { affected: conversationAffected } =
      await this.conversationRepo.delete({
        id: In(conversationIds),
      });
    this.logger.log(
      `🗑️ Hard-deleted ${conversationAffected ?? 0} seed AI conversation(s)`,
    );
  }
}
