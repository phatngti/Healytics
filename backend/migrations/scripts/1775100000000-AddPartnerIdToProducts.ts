import {
  MigrationInterface,
  QueryRunner,
  TableColumn,
  TableIndex,
  TableForeignKey,
} from 'typeorm';

/**
 * Adds `partner_id` FK column to `products` table, establishing the
 * one-to-many relationship: one health partner → many products.
 *
 * The column is nullable so existing products are not broken on deploy.
 */
export class AddPartnerIdToProducts1775100000000
  implements MigrationInterface
{
  name = 'AddPartnerIdToProducts1775100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. Add the column (idempotent)
    const hasCol = await queryRunner.query(
      `SELECT 1 FROM information_schema.columns WHERE table_name = 'products' AND column_name = 'partner_id'`,
    );
    if (hasCol.length === 0) {
      await queryRunner.addColumn(
        'products',
        new TableColumn({
          name: 'partner_id',
          type: 'uuid',
          isNullable: true,
        }),
      );
    }

    // 2. Add index for FK column (required for join performance)
    await queryRunner.createIndex(
      'products',
      new TableIndex({
        name: 'IDX_PRODUCTS_PARTNER_ID',
        columnNames: ['partner_id'],
      }),
    );

    // 3. Add foreign key constraint
    await queryRunner.createForeignKey(
      'products',
      new TableForeignKey({
        name: 'FK_PRODUCTS_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'SET NULL',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order: FK → Index → Column
    await queryRunner.dropForeignKey('products', 'FK_PRODUCTS_PARTNER');
    await queryRunner.dropIndex('products', 'IDX_PRODUCTS_PARTNER_ID');
    await queryRunner.dropColumn('products', 'partner_id');
  }
}
