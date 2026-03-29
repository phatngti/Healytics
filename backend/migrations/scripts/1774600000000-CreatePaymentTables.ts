import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreatePaymentTables1774600000000
  implements MigrationInterface
{
  name = 'CreatePaymentTables1774600000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ----------------------------------------------------------------
    // 1. CREATE TABLE: payments
    // ----------------------------------------------------------------
    await queryRunner.createTable(
      new Table({
        name: 'payments',
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
            name: 'user_id',
            type: 'uuid',
          },
          {
            name: 'payment_method',
            type: 'varchar',
            length: '30',
          },
          {
            name: 'payment_status',
            type: 'varchar',
            length: '30',
            default: "'UNPAID'",
          },
          {
            name: 'amount',
            type: 'decimal',
            precision: 15,
            scale: 2,
            default: 0,
          },
          {
            name: 'gateway_order_id',
            type: 'varchar',
            length: '100',
            isNullable: true,
          },
          {
            name: 'gateway_trans_id',
            type: 'varchar',
            length: '100',
            isNullable: true,
          },
          {
            name: 'payment_url',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'gateway_result_code',
            type: 'int',
            isNullable: true,
          },
          {
            name: 'gateway_message',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'paid_at',
            type: 'timestamptz',
            isNullable: true,
          },
          {
            name: 'refunded_at',
            type: 'timestamptz',
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
          {
            name: 'deleted_at',
            type: 'timestamptz',
            isNullable: true,
          },
        ],
      }),
      true,
    );

    // Indexes for payments
    await queryRunner.createIndex(
      'payments',
      new TableIndex({
        name: 'IDX_PAYMENTS_BOOKING_ID',
        columnNames: ['booking_id'],
      }),
    );
    await queryRunner.createIndex(
      'payments',
      new TableIndex({
        name: 'IDX_PAYMENTS_USER_ID',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'payments',
      new TableIndex({
        name: 'IDX_PAYMENTS_STATUS',
        columnNames: ['payment_status'],
      }),
    );

    // Foreign keys for payments
    await queryRunner.createForeignKey(
      'payments',
      new TableForeignKey({
        name: 'FK_PAYMENTS_BOOKING_ID',
        columnNames: ['booking_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'bookings',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'payments',
      new TableForeignKey({
        name: 'FK_PAYMENTS_USER_ID',
        columnNames: ['user_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );

    // ----------------------------------------------------------------
    // 2. CREATE TABLE: payment_transaction_logs  (append-only)
    // ----------------------------------------------------------------
    await queryRunner.createTable(
      new Table({
        name: 'payment_transaction_logs',
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
            name: 'payment_id',
            type: 'uuid',
          },
          {
            name: 'action',
            type: 'varchar',
            length: '50',
          },
          {
            name: 'gateway',
            type: 'varchar',
            length: '30',
          },
          {
            name: 'result_code',
            type: 'int',
            isNullable: true,
          },
          {
            name: 'message',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'request_payload',
            type: 'jsonb',
            isNullable: true,
          },
          {
            name: 'response_payload',
            type: 'jsonb',
            isNullable: true,
          },
          {
            name: 'ip_address',
            type: 'varchar',
            length: '45',
            isNullable: true,
          },
          {
            name: 'actor',
            type: 'varchar',
            length: '255',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          // No updated_at or deleted_at — append-only by design
        ],
      }),
      true,
    );

    // Indexes for payment_transaction_logs
    await queryRunner.createIndex(
      'payment_transaction_logs',
      new TableIndex({
        name: 'IDX_PAYMENT_TX_LOGS_PAYMENT_ID',
        columnNames: ['payment_id'],
      }),
    );
    await queryRunner.createIndex(
      'payment_transaction_logs',
      new TableIndex({
        name: 'IDX_PAYMENT_TX_LOGS_ACTION',
        columnNames: ['action'],
      }),
    );

    // Foreign key for payment_transaction_logs
    await queryRunner.createForeignKey(
      'payment_transaction_logs',
      new TableForeignKey({
        name: 'FK_PAYMENT_TX_LOGS_PAYMENT_ID',
        columnNames: ['payment_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'payments',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order: payment_transaction_logs → payments

    // 2. payment_transaction_logs
    await queryRunner.dropForeignKey(
      'payment_transaction_logs',
      'FK_PAYMENT_TX_LOGS_PAYMENT_ID',
    );
    await queryRunner.dropIndex(
      'payment_transaction_logs',
      'IDX_PAYMENT_TX_LOGS_ACTION',
    );
    await queryRunner.dropIndex(
      'payment_transaction_logs',
      'IDX_PAYMENT_TX_LOGS_PAYMENT_ID',
    );
    await queryRunner.dropTable('payment_transaction_logs', true);

    // 1. payments
    await queryRunner.dropForeignKey('payments', 'FK_PAYMENTS_USER_ID');
    await queryRunner.dropForeignKey('payments', 'FK_PAYMENTS_BOOKING_ID');
    await queryRunner.dropIndex('payments', 'IDX_PAYMENTS_STATUS');
    await queryRunner.dropIndex('payments', 'IDX_PAYMENTS_USER_ID');
    await queryRunner.dropIndex('payments', 'IDX_PAYMENTS_BOOKING_ID');
    await queryRunner.dropTable('payments', true);
  }
}
