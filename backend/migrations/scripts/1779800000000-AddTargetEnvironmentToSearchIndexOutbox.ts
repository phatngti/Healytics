import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddTargetEnvironmentToSearchIndexOutbox1779800000000 implements MigrationInterface {
  name = 'AddTargetEnvironmentToSearchIndexOutbox1779800000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "search_index_outbox"
      ADD COLUMN IF NOT EXISTS "target_environment" varchar(20) NOT NULL DEFAULT 'production'
    `);

    await queryRunner.query(`
      UPDATE "search_index_outbox"
      SET "target_environment" = 'production'
      WHERE "target_environment" IS NULL
    `);

    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_SEARCH_INDEX_OUTBOX_STATUS_CREATED"',
    );

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SEARCH_INDEX_OUTBOX_ENV_STATUS_CREATED"
      ON "search_index_outbox" ("target_environment", "status", "created_at")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_SEARCH_INDEX_OUTBOX_ENV_STATUS_CREATED"',
    );

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SEARCH_INDEX_OUTBOX_STATUS_CREATED"
      ON "search_index_outbox" ("status", "created_at")
    `);

    await queryRunner.query(`
      ALTER TABLE "search_index_outbox"
      DROP COLUMN IF EXISTS "target_environment"
    `);
  }
}
