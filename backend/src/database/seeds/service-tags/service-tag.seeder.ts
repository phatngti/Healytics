import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { ServiceTag } from '@/common/entities/service-tag.entity';
import { Account } from '@/common/entities/account.entity';
import { Role } from '@/account/enum/role.enum';
import { ISeeder } from '../seeder.interface';

const SEED_SERVICE_TAGS = [
  { name: 'Pain Relief', description: 'Pain management and relief services', colorValue: "#FF4CAF50" },
  { name: 'Relaxation', description: 'Relaxation and stress relief services', colorValue: "#FF2196F3" },
  { name: 'Rehabilitation', description: 'Functional rehabilitation services', colorValue: "#xFFFF9800" },
  { name: 'Beauty', description: 'Beauty and aesthetic services', colorValue: "#FFE91E63" },
  { name: 'Skincare', description: 'Skincare and dermatology services', colorValue: "#FF9C27B0" },
];

@Injectable()
export class ServiceTagSeeder implements ISeeder {
  private readonly logger = new Logger(ServiceTagSeeder.name);

  constructor(
    @InjectRepository(ServiceTag)
    private readonly serviceTagRepo: Repository<ServiceTag>,

    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding service tags...');

    // Requires an admin user to attach tags to
    const adminUser = await this.accountRepo.findOne({
      where: { role: Role.HEALTH_PARTNER },
    });

    if (!adminUser) {
      this.logger.warn('⚠ No admin user found — skipping service tag seeding. Run UserSeeder first.');
      return;
    }

    for (const tagData of SEED_SERVICE_TAGS) {
      const exists = await this.serviceTagRepo.findOne({
        where: { name: tagData.name, userId: adminUser.id },
      });

      if (exists) {
        this.logger.log(`  ⏭ Service tag "${tagData.name}" already exists, skipping`);
        continue;
      }

      const tag = this.serviceTagRepo.create({
        name: tagData.name,
        description: tagData.description,
        colorValue: tagData.colorValue,
        userId: adminUser.id,
        isActive: true,
        sortOrder: 0,
      });

      await this.serviceTagRepo.save(tag);
      this.logger.log(`  ✅ Created service tag "${tagData.name}"`);
    }

    this.logger.log('Service tags seeding completed');
  }

  async clear(): Promise<void> {
    const names = SEED_SERVICE_TAGS.map((t) => t.name);
    const { affected } = await this.serviceTagRepo.delete({ name: In(names) });
    if (!affected) {
      this.logger.warn('⚠ No seed service tags found to delete');
    } else {
      this.logger.log(`🗑️ Hard-deleted ${affected} seed service tag(s)`);
    }
  }
}
