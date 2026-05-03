import { MigrationInterface, QueryRunner } from 'typeorm';

export class FixBookingStaffStartTimeIndex1776200000000
  implements MigrationInterface
{
  name = 'FixBookingStaffStartTimeIndex1776200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Drop old index (staff_id + start_time, WHERE deleted_at IS NULL)
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_BOOKING_STAFF_START_TIME"',
    );

    // Recreate with status filter: only active bookings block the slot
    await queryRunner.query(`
      CREATE UNIQUE INDEX "IDX_BOOKING_STAFF_START_TIME"
      ON "bookings" ("staff_id", "start_time")
      WHERE "deleted_at" IS NULL
        AND "status" IN ('PENDING_PAYMENT', 'CONFIRMED')
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Revert to original index without status filter
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_BOOKING_STAFF_START_TIME"',
    );

    await queryRunner.query(`
      CREATE UNIQUE INDEX "IDX_BOOKING_STAFF_START_TIME"
      ON "bookings" ("staff_id", "start_time")
      WHERE "deleted_at" IS NULL
    `);
  }
}
