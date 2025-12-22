import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from './entities/account.entity';
import { NotFoundException } from '@nestjs/common';

@Injectable()
export class AccountService {
  constructor(
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
  ) {}

  create(data: Partial<Account>) {
    const acc = this.accountRepo.create(data);
    return this.accountRepo.save(acc);
  }

  async getSurvey(accountId: string): Promise<Record<string, any> | null> {
    const acc = await this.accountRepo.findOne({
      where: { id: accountId },
      select: ['id', 'survey'] as any,
    });
    return acc?.survey ?? null;
  }

  async setSurvey(
    accountId: string,
    survey: Record<string, any> | null,
  ): Promise<Account> {
    const user = await this.accountRepo.findOneBy({ id: accountId });
    if (!user) throw new NotFoundException('User not found');
    user['survey'] = survey;
    return this.accountRepo.save(user);
  }

  async clearSurvey(accountId: string) {
    await this.accountRepo.update(accountId, { survey: null } as any);
  }

  findByEmail(email: string): Promise<Account | null> {
    return this.accountRepo.findOneBy({ email });
  }

  findAll(): Promise<Account[]> {
    return this.accountRepo.find();
  }

  findOne(id: string): Promise<Account | null> {
    return this.accountRepo.findOneBy({ id });
  }

  /**
   * Find a user including the refreshTokenHash (selected explicitly)
   */
  async findOneWithRefreshHash(id: string): Promise<Account | null> {
    return this.accountRepo.findOne({
      where: { id },
      select: [
        'id',
        'email',
        'passwordHash',
        'refreshTokenHash',
        'isActive',
        'createdAt',
        'updatedAt',
      ],
    });
  }

  async setRefreshTokenHash(
    id: string,
    refreshTokenHash: string,
  ): Promise<Account> {
    const user = await this.accountRepo.findOneBy({ id });
    if (!user) throw new NotFoundException('User not found');
    user.refreshTokenHash = refreshTokenHash;
    return this.accountRepo.save(user);
  }

  async removeRefreshToken(id: string): Promise<void> {
    // Directly sets the column to NULL in the database
    await this.accountRepo.update(id, {
      refreshTokenHash: null,
    });
  }
}
