import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddReasonCodeToBookingStatusLogs1779300000000
  implements MigrationInterface
{
  name = 'AddReasonCodeToBookingStatusLogs1779300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "booking_status_logs"
      ADD COLUMN IF NOT EXISTS "reason_code" varchar(80)
    `);

    await queryRunner.query(`
      UPDATE "booking_status_logs"
      SET "reason" = CONCAT(
        'Legacy booking status change from ',
        COALESCE("from_status", 'none'),
        ' to ',
        "to_status"
      )
      WHERE "reason" IS NULL OR BTRIM("reason") = ''
    `);

    await queryRunner.query(`
      UPDATE "booking_status_logs"
      SET "reason_code" = 'LEGACY_STATUS_CHANGE'
      WHERE "reason_code" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_BOOKING_STATUS_LOGS_REASON_CODE_CREATED"
      ON "booking_status_logs" ("reason_code", "created_at")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_BOOKING_STATUS_LOGS_REASON_CODE_CREATED"',
    );
    await queryRunner.query(`
      ALTER TABLE "booking_status_logs"
      DROP COLUMN IF EXISTS "reason_code"
    `);
  }
}
