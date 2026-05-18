import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateSearchIndexOutbox1779200000000 implements MigrationInterface {
  name = 'CreateSearchIndexOutbox1779200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "search_index_outbox" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "entity_type" varchar(50) NOT NULL,
        "entity_id" uuid NOT NULL,
        "operation" varchar(20) NOT NULL,
        "payload" jsonb,
        "status" varchar(20) NOT NULL DEFAULT 'pending',
        "attempt_count" integer NOT NULL DEFAULT 0,
        "last_error" text,
        "processed_at" timestamptz,
        "created_at" timestamptz NOT NULL DEFAULT now(),
        "updated_at" timestamptz NOT NULL DEFAULT now(),
        CONSTRAINT "PK_SEARCH_INDEX_OUTBOX" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SEARCH_INDEX_OUTBOX_STATUS_CREATED"
      ON "search_index_outbox" ("status", "created_at")
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SEARCH_INDEX_OUTBOX_ENTITY"
      ON "search_index_outbox" ("entity_type", "entity_id")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_SEARCH_INDEX_OUTBOX_ENTITY"',
    );
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_SEARCH_INDEX_OUTBOX_STATUS_CREATED"',
    );
    await queryRunner.query('DROP TABLE IF EXISTS "search_index_outbox"');
  }
}
