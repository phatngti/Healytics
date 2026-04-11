import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreateCartAndCouponTables1775300000000
  implements MigrationInterface
{
  name = 'CreateCartAndCouponTables1775300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ─── Coupons table ────────────────────────────────────────
    await queryRunner.createTable(
      new Table({
        name: 'coupons',
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
            name: 'code',
            type: 'varchar',
            length: '50',
          },
          {
            name: 'discount_percent',
            type: 'int',
          },
          {
            name: 'max_discount_amount',
            type: 'int',
            isNullable: true,
          },
          {
            name: 'usage_limit',
            type: 'int',
            isNullable: true,
          },
          {
            name: 'used_count',
            type: 'int',
            default: 0,
          },
          {
            name: 'is_active',
            type: 'boolean',
            default: true,
          },
          {
            name: 'expires_at',
            type: 'timestamptz',
            isNullable: true,
          },
          {
            name: 'service_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'category_id',
            type: 'uuid',
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

    await queryRunner.createIndex(
      'coupons',
      new TableIndex({
        name: 'UQ_COUPONS_CODE',
        columnNames: ['code'],
        isUnique: true,
      }),
    );

    await queryRunner.createIndex(
      'coupons',
      new TableIndex({
        name: 'IDX_COUPONS_SERVICE_ID',
        columnNames: ['service_id'],
      }),
    );

    await queryRunner.createIndex(
      'coupons',
      new TableIndex({
        name: 'IDX_COUPONS_CATEGORY_ID',
        columnNames: ['category_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'coupons',
      new TableForeignKey({
        name: 'FK_COUPONS_SERVICE_ID',
        columnNames: ['service_id'],
        referencedTableName: 'products',
        referencedColumnNames: ['id'],
        onDelete: 'SET NULL',
      }),
    );

    await queryRunner.createForeignKey(
      'coupons',
      new TableForeignKey({
        name: 'FK_COUPONS_CATEGORY_ID',
        columnNames: ['category_id'],
        referencedTableName: 'categories',
        referencedColumnNames: ['id'],
        onDelete: 'SET NULL',
      }),
    );

    // ─── Cart items table ─────────────────────────────────────
    await queryRunner.createTable(
      new Table({
        name: 'cart_items',
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
            name: 'service_id',
            type: 'uuid',
          },
          {
            name: 'employee_id',
            type: 'uuid',
          },
          {
            name: 'time_slot',
            type: 'timestamptz',
          },
          {
            name: 'status',
            type: 'varchar',
            length: '20',
            default: `'ACTIVE'`,
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

    // Indexes
    await queryRunner.createIndex(
      'cart_items',
      new TableIndex({
        name: 'IDX_CART_ITEMS_USER_ID',
        columnNames: ['user_id'],
      }),
    );

    await queryRunner.createIndex(
      'cart_items',
      new TableIndex({
        name: 'IDX_CART_ITEMS_SERVICE_ID',
        columnNames: ['service_id'],
      }),
    );

    await queryRunner.createIndex(
      'cart_items',
      new TableIndex({
        name: 'IDX_CART_ITEMS_EMPLOYEE_ID',
        columnNames: ['employee_id'],
      }),
    );

    // Unique constraint: same user + service + employee + time slot
    await queryRunner.createUniqueConstraint(
      'cart_items',
      new TableUnique({
        name: 'UQ_CART_ITEMS_USER_SERVICE_EMPLOYEE_SLOT',
        columnNames: ['user_id', 'service_id', 'employee_id', 'time_slot'],
      }),
    );

    // Foreign keys
    await queryRunner.createForeignKey(
      'cart_items',
      new TableForeignKey({
        name: 'FK_CART_ITEMS_USER_ID',
        columnNames: ['user_id'],
        referencedTableName: 'account',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'cart_items',
      new TableForeignKey({
        name: 'FK_CART_ITEMS_SERVICE_ID',
        columnNames: ['service_id'],
        referencedTableName: 'products',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'cart_items',
      new TableForeignKey({
        name: 'FK_CART_ITEMS_EMPLOYEE_ID',
        columnNames: ['employee_id'],
        referencedTableName: 'employees',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop cart_items
    await queryRunner.dropForeignKey('cart_items', 'FK_CART_ITEMS_EMPLOYEE_ID');
    await queryRunner.dropForeignKey('cart_items', 'FK_CART_ITEMS_SERVICE_ID');
    await queryRunner.dropForeignKey('cart_items', 'FK_CART_ITEMS_USER_ID');
    await queryRunner.dropUniqueConstraint(
      'cart_items',
      'UQ_CART_ITEMS_USER_SERVICE_EMPLOYEE_SLOT',
    );
    await queryRunner.dropIndex('cart_items', 'IDX_CART_ITEMS_EMPLOYEE_ID');
    await queryRunner.dropIndex('cart_items', 'IDX_CART_ITEMS_SERVICE_ID');
    await queryRunner.dropIndex('cart_items', 'IDX_CART_ITEMS_USER_ID');
    await queryRunner.dropTable('cart_items', true);

    // Drop coupons
    await queryRunner.dropForeignKey('coupons', 'FK_COUPONS_CATEGORY_ID');
    await queryRunner.dropForeignKey('coupons', 'FK_COUPONS_SERVICE_ID');
    await queryRunner.dropIndex('coupons', 'IDX_COUPONS_CATEGORY_ID');
    await queryRunner.dropIndex('coupons', 'IDX_COUPONS_SERVICE_ID');
    await queryRunner.dropIndex('coupons', 'UQ_COUPONS_CODE');
    await queryRunner.dropTable('coupons', true);
  }
}
