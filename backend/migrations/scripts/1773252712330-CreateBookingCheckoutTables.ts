import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreateBookingCheckoutTables1773252712330
  implements MigrationInterface
{
  name = 'CreateBookingCheckoutTables1773252712330';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ----------------------------------------------------------------
    // 1. CREATE TABLE: bookings
    // ----------------------------------------------------------------
    await queryRunner.createTable(
      new Table({
        name: 'bookings',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'user_id',
            type: 'uuid',
          },
          {
            name: 'staff_id',
            type: 'uuid',
          },
          {
            name: 'product_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'start_time',
            type: 'timestamptz',
          },
          {
            name: 'end_time',
            type: 'timestamptz',
            isNullable: true,
          },
          {
            name: 'status',
            type: 'varchar',
            length: '30',
            default: "'PENDING_PAYMENT'",
          },
          {
            name: 'payment_url',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'payment_expires_at',
            type: 'timestamptz',
            isNullable: true,
          },
          {
            name: 'notes',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'version',
            type: 'int',
            default: 1,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'updated_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'deleted_at',
            type: 'timestamptz',
            isNullable: true,
          },
        ],
      }),
      true,
    );

    // Indexes for bookings
    await queryRunner.createIndex(
      'bookings',
      new TableIndex({
        name: 'IDX_BOOKINGS_USER_ID',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'bookings',
      new TableIndex({
        name: 'IDX_BOOKINGS_STAFF_ID',
        columnNames: ['staff_id'],
      }),
    );
    await queryRunner.createIndex(
      'bookings',
      new TableIndex({
        name: 'IDX_BOOKINGS_PRODUCT_ID',
        columnNames: ['product_id'],
      }),
    );

    // Unique partial index: prevent double-booking for same staff + time slot
    await queryRunner.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "IDX_BOOKING_STAFF_START_TIME"
      ON "bookings" ("staff_id", "start_time")
      WHERE "deleted_at" IS NULL
    `);

    // Foreign keys for bookings
    await queryRunner.createForeignKey(
      'bookings',
      new TableForeignKey({
        name: 'FK_BOOKINGS_USER_ID',
        columnNames: ['user_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'bookings',
      new TableForeignKey({
        name: 'FK_BOOKINGS_STAFF_ID',
        columnNames: ['staff_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'employees',
        onDelete: 'SET NULL',
      }),
    );
    await queryRunner.createForeignKey(
      'bookings',
      new TableForeignKey({
        name: 'FK_BOOKINGS_PRODUCT_ID',
        columnNames: ['product_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'products',
        onDelete: 'SET NULL',
      }),
    );

    // ----------------------------------------------------------------
    // 2. CREATE TABLE: checkout_tickets
    // ----------------------------------------------------------------
    await queryRunner.createTable(
      new Table({
        name: 'checkout_tickets',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'user_id',
            type: 'uuid',
          },
          {
            name: 'staff_id',
            type: 'uuid',
          },
          {
            name: 'product_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'start_time',
            type: 'timestamptz',
          },
          {
            name: 'idempotency_key',
            type: 'varchar',
            length: '255',
            isUnique: true,
          },
          {
            name: 'status',
            type: 'varchar',
            length: '30',
            default: "'QUEUED'",
          },
          {
            name: 'webhook_url',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'booking_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'error_message',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'updated_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    // Indexes for checkout_tickets
    await queryRunner.createIndex(
      'checkout_tickets',
      new TableIndex({
        name: 'IDX_CHECKOUT_TICKETS_USER_ID',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'checkout_tickets',
      new TableIndex({
        name: 'IDX_CHECKOUT_TICKETS_STATUS',
        columnNames: ['status'],
      }),
    );
    await queryRunner.createIndex(
      'checkout_tickets',
      new TableIndex({
        name: 'IDX_CHECKOUT_TICKETS_IDEMPOTENCY_KEY',
        columnNames: ['idempotency_key'],
        isUnique: true,
      }),
    );

    // Foreign keys for checkout_tickets
    await queryRunner.createForeignKey(
      'checkout_tickets',
      new TableForeignKey({
        name: 'FK_CHECKOUT_TICKETS_USER_ID',
        columnNames: ['user_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'checkout_tickets',
      new TableForeignKey({
        name: 'FK_CHECKOUT_TICKETS_STAFF_ID',
        columnNames: ['staff_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'employees',
        onDelete: 'SET NULL',
      }),
    );
    await queryRunner.createForeignKey(
      'checkout_tickets',
      new TableForeignKey({
        name: 'FK_CHECKOUT_TICKETS_PRODUCT_ID',
        columnNames: ['product_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'products',
        onDelete: 'SET NULL',
      }),
    );
    await queryRunner.createForeignKey(
      'checkout_tickets',
      new TableForeignKey({
        name: 'FK_CHECKOUT_TICKETS_BOOKING_ID',
        columnNames: ['booking_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'bookings',
        onDelete: 'SET NULL',
      }),
    );

    // ----------------------------------------------------------------
    // 3. CREATE TABLE: booking_status_logs
    // ----------------------------------------------------------------
    await queryRunner.createTable(
      new Table({
        name: 'booking_status_logs',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'booking_id',
            type: 'uuid',
          },
          {
            name: 'from_status',
            type: 'varchar',
            length: '30',
            isNullable: true,
          },
          {
            name: 'to_status',
            type: 'varchar',
            length: '30',
          },
          {
            name: 'changed_by',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'reason',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    // Index for booking_status_logs
    await queryRunner.createIndex(
      'booking_status_logs',
      new TableIndex({
        name: 'IDX_BOOKING_STATUS_LOGS_BOOKING_ID',
        columnNames: ['booking_id'],
      }),
    );

    // Foreign key for booking_status_logs
    await queryRunner.createForeignKey(
      'booking_status_logs',
      new TableForeignKey({
        name: 'FK_BOOKING_STATUS_LOGS_BOOKING_ID',
        columnNames: ['booking_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'bookings',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order: booking_status_logs → checkout_tickets → bookings

    // 3. booking_status_logs
    await queryRunner.dropForeignKey(
      'booking_status_logs',
      'FK_BOOKING_STATUS_LOGS_BOOKING_ID',
    );
    await queryRunner.dropIndex(
      'booking_status_logs',
      'IDX_BOOKING_STATUS_LOGS_BOOKING_ID',
    );
    await queryRunner.dropTable('booking_status_logs', true);

    // 2. checkout_tickets
    await queryRunner.dropForeignKey(
      'checkout_tickets',
      'FK_CHECKOUT_TICKETS_BOOKING_ID',
    );
    await queryRunner.dropForeignKey(
      'checkout_tickets',
      'FK_CHECKOUT_TICKETS_PRODUCT_ID',
    );
    await queryRunner.dropForeignKey(
      'checkout_tickets',
      'FK_CHECKOUT_TICKETS_STAFF_ID',
    );
    await queryRunner.dropForeignKey(
      'checkout_tickets',
      'FK_CHECKOUT_TICKETS_USER_ID',
    );
    await queryRunner.dropIndex(
      'checkout_tickets',
      'IDX_CHECKOUT_TICKETS_IDEMPOTENCY_KEY',
    );
    await queryRunner.dropIndex(
      'checkout_tickets',
      'IDX_CHECKOUT_TICKETS_STATUS',
    );
    await queryRunner.dropIndex(
      'checkout_tickets',
      'IDX_CHECKOUT_TICKETS_USER_ID',
    );
    await queryRunner.dropTable('checkout_tickets', true);

    // 1. bookings
    await queryRunner.dropForeignKey('bookings', 'FK_BOOKINGS_PRODUCT_ID');
    await queryRunner.dropForeignKey('bookings', 'FK_BOOKINGS_STAFF_ID');
    await queryRunner.dropForeignKey('bookings', 'FK_BOOKINGS_USER_ID');
    await queryRunner.query(
      'DROP INDEX IF EXISTS "IDX_BOOKING_STAFF_START_TIME"',
    );
    await queryRunner.dropIndex('bookings', 'IDX_BOOKINGS_PRODUCT_ID');
    await queryRunner.dropIndex('bookings', 'IDX_BOOKINGS_STAFF_ID');
    await queryRunner.dropIndex('bookings', 'IDX_BOOKINGS_USER_ID');
    await queryRunner.dropTable('bookings', true);
  }
}
