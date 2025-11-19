import { Injectable } from '@nestjs/common';
import { PassportSerializer } from '@nestjs/passport';
import { AccountService } from '../account/account.service';

@Injectable()
export class SessionSerializer extends PassportSerializer {
  constructor(private readonly accountService: AccountService) {
    super();
  }

  serializeUser(user: any, done: Function) {
    done(null, user.id);
  }

  async deserializeUser(payload: any, done: Function) {
    const user = await this.accountService.findOne(payload);
    done(null, user || null);
  }
}
