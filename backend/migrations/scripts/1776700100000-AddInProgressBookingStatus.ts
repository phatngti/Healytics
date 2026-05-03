import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddInProgressBookingStatus1776700100000
  implements MigrationInterface
{
  name = 'AddInProgressBookingStatus1776700100000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // The Booking entity defines `status` as varchar(30), so any string
    // value is already accepted — no DDL change required.
    // This migration exists purely as documentation that IN_PROGRESS
    // is now a valid BookingStatus value.
    //
    // Safety: query information_schema to confirm the column is varchar.
    // If someone has changed it to a Postgres ENUM, handle that too.
    const [{ data_type }] = await queryRunner.query(`
      SELECT data_type
      FROM information_schema.columns
      WHERE table_schema = 'public'
        AND table_name   = 'bookings'
        AND column_name  = 'status'
    `);

    if (data_type !== 'USER-DEFINED') {
      // varchar / text / etc. — no DDL needed
      return;
    }

    // Only runs if the column is actually a Postgres ENUM type
    // Fetch the real enum type name from pg_attribute + pg_type
    const [{ typname }] = await queryRunner.query(`
      SELECT t.typname
      FROM pg_attribute a
      JOIN pg_type t ON a.atttypid = t.oid
      JOIN pg_class c ON a.attrelid = c.oid
      JOIN pg_namespace n ON c.relnamespace = n.oid
      WHERE n.nspname = 'public'
        AND c.relname  = 'bookings'
        AND a.attname  = 'status'
    `);

    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_enum
          WHERE enumlabel = 'IN_PROGRESS'
          AND enumtypid = (SELECT oid FROM pg_type WHERE typname = '${typname}')
        ) THEN
          ALTER TYPE "${typname}" ADD VALUE 'IN_PROGRESS';
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
