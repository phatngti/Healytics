import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Account } from './account.entity';

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

	findAll() {
		return this.accountRepo.find();
	}

	findOne(id: string) {
		return this.accountRepo.findOneBy({ id });
	}
}
