import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

/**
 * Adds a nullable `lock_token` column to the `checkout_tickets` table.
 *
 * This stores the Redis pre-lock token acquired at ticket creation time,
 * allowing the RabbitMQ consumer to validate lock ownership instead of
 * re-acquiring — closing the TOCTOU race condition between the API and
 * the message queue consumer.
 */
export class AddLockTokenToCheckoutTicket1776400000000
  implements MigrationInterface
{
  name = 'AddLockTokenToCheckoutTicket1776400000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    const hasColumn = await queryRunner.hasColumn(
      'checkout_tickets',
      'lock_token',
    );
    if (!hasColumn) {
      await queryRunner.addColumn(
        'checkout_tickets',
        new TableColumn({
          name: 'lock_token',
          type: 'varchar',
          length: '36',
          isNullable: true,
          default: null,
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('checkout_tickets', 'lock_token');
  }
}
