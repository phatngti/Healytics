import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddInProgressBookingStatus1776700100000
  implements MigrationInterface
{
  name = 'AddInProgressBookingStatus1776700100000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Check if the booking status column uses a varchar or an enum type.
    // Our entity uses varchar(30), so we just need to ensure existing
    // check constraints (if any) allow the new value.
    // If the column uses a Postgres ENUM type, we would need:
    //   ALTER TYPE booking_status ADD VALUE 'IN_PROGRESS' BEFORE 'CANCELLED';
    //
    // Since our Booking entity defines status as varchar(30), no DDL is needed.
    // This migration serves as documentation that IN_PROGRESS is now valid.
    //
    // Verify column type:
    const table = await queryRunner.getTable('bookings');
    const statusColumn = table?.columns.find((c) => c.name === 'status');

    if (statusColumn && statusColumn.type === 'varchar') {
      // varchar — no DDL needed, new values are already allowed
      return;
    }

    // If it's an enum type, add the new value
    // Note: PostgreSQL does not support IF NOT EXISTS for ADD VALUE in older versions,
    // but v10+ supports it in a transaction-safe way when not inside a transaction block.
    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_enum
          WHERE enumlabel = 'IN_PROGRESS'
          AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'bookings_status_enum')
        ) THEN
          ALTER TYPE bookings_status_enum ADD VALUE 'IN_PROGRESS' BEFORE 'CANCELLED';
        END IF;
      END
      $$;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // PostgreSQL does not support removing enum values.
    // Leaving IN_PROGRESS in the enum is safe — it simply won't be used.
    // For a full revert, you'd need to recreate the enum type, which is
    // destructive and not recommended for a production downgrade.
  }
}
