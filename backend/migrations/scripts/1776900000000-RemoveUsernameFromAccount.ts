import { MigrationInterface, QueryRunner } from 'typeorm';

export class RemoveUsernameFromAccount1776900000000
  implements MigrationInterface
{
  public async up(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('account');
    if (!table) return;

    // Drop the unique index on username (if it exists)
    const usernameIndex = table.indices.find((idx) =>
      idx.columnNames.includes('username'),
    );
    if (usernameIndex) {
      await queryRunner.dropIndex('account', usernameIndex);
    }

    // Drop the unique constraint on username (if it exists, e.g. from entity sync)
    const usernameUnique = table.uniques.find((uq) =>
      uq.columnNames.includes('username'),
    );
    if (usernameUnique) {
      await queryRunner.dropUniqueConstraint('account', usernameUnique);
    }

    // Drop the column itself
    if (table.columns.some((col) => col.name === 'username')) {
      await queryRunner.dropColumn('account', 'username');
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('account');
    if (!table) return;

    if (!table.columns.some((col) => col.name === 'username')) {
      await queryRunner.query(
        `ALTER TABLE "account" ADD "username" varchar NULL`,
      );
      await queryRunner.query(
        `CREATE UNIQUE INDEX "IDX_account_username" ON "account" ("username") WHERE "username" IS NOT NULL`,
      );
    }
  }
}
