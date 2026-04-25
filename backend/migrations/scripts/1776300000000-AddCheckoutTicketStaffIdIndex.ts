import { MigrationInterface, QueryRunner, TableIndex } from 'typeorm';

/**
 * Adds an index on checkout_tickets.staff_id to speed up queries
 * that filter by staff (e.g., slot availability checks).
 *
 * Performance context: without this index, queries on the checkout_tickets
 * table by staff_id require a sequential scan.
 */
export class AddCheckoutTicketStaffIdIndex1776300000000
  implements MigrationInterface
{
  name = 'AddCheckoutTicketStaffIdIndex1776300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createIndex(
      'checkout_tickets',
      new TableIndex({
        name: 'IDX_CHECKOUT_TICKETS_STAFF_ID',
        columnNames: ['staff_id'],
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropIndex(
      'checkout_tickets',
      'IDX_CHECKOUT_TICKETS_STAFF_ID',
    );
  }
}
