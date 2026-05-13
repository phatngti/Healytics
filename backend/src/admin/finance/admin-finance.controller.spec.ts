import { PATH_METADATA } from '@nestjs/common/constants';
import { Role } from '@/account/enum/role.enum';
import { ROLES_KEY } from '@/common/decorators/auth/roles.decorator';
import { AdminFinanceController } from './admin-finance.controller';

describe('AdminFinanceController', () => {
  it('uses an admin-only finance route contract', () => {
    expect(Reflect.getMetadata(PATH_METADATA, AdminFinanceController)).toBe(
      'admin/finance',
    );
    expect(Reflect.getMetadata(ROLES_KEY, AdminFinanceController)).toEqual([
      Role.ADMIN,
    ]);
  });
});
