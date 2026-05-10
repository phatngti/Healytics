import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddAccountLowerEmailIndex1777000000000
  implements MigrationInterface
{
  name = 'AddAccountLowerEmailIndex1777000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `CREATE INDEX IF NOT EXISTS "IDX_ACCOUNT_LOWER_EMAIL_ACTIVE" ON "account" (lower("email")) WHERE "deleted_at" IS NULL`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_ACCOUNT_LOWER_EMAIL_ACTIVE"`,
    );
  }
}
