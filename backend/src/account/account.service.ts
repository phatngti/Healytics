import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from './account.entity';
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

	findByEmail(email: string) {
		return this.accountRepo.findOneBy({ email });
	}

	findAll() {
		return this.accountRepo.find();
	}

	findOne(id: string) {
		return this.accountRepo.findOneBy({ id });
	}

	async setRefreshTokenHash(id: string, refreshTokenHash: string) {
		const user = await this.accountRepo.findOneBy({ id });
		if (!user) throw new NotFoundException('User not found');
		user.refreshTokenHash = refreshTokenHash;
		return this.accountRepo.save(user);
	}

	async removeRefreshToken(id: string) {
    // Directly sets the column to NULL in the database
		await this.accountRepo.update(id, { 
			refreshTokenHash: null 
		});
	}
}