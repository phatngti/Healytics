import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex, TableUnique } from 'typeorm';

/**
 * Migration: 1775000000000
 *
 * 1. Hard-drop the `product_reviews` table (fake/seeded display reviews).
 * 2. Rename `treatment_reviews` → `product_treatment_reviews`.
 *    All indexes and foreign-key constraints are renamed to match the new table name.
 */
export class DropProductReviewsRenameReviewTables1775000000000 implements MigrationInterface {
  name = 'DropProductReviewsRenameReviewTables1775000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ── 1. Drop product_reviews ──────────────────────────────────────────────

    // Drop the FK from product_reviews → products (if it exists by name)
    await queryRunner.dropForeignKey('product_reviews', 'FK_PRODUCT_REVIEWS_PRODUCT').catch(() => {
      // Ignore if the constraint doesn't exist (e.g. created via TypeORM cascade)
    });

    // Drop any indexes
    await queryRunner.dropIndex('product_reviews', 'IDX_product_reviews_productId').catch(() => {});

    // Hard-drop the table
    await queryRunner.dropTable('product_reviews', true /* ifExists */);

    // ── 2. Rename treatment_reviews → product_treatment_reviews ─────────────

    await queryRunner.renameTable('treatment_reviews', 'product_treatment_reviews');

    // Rename unique constraint
    await queryRunner.dropUniqueConstraint(
      'product_treatment_reviews',
      'UQ_TREATMENT_REVIEWS_APPOINTMENT_ID',
    ).catch(() => {});

    await queryRunner.createUniqueConstraint('product_treatment_reviews', new TableUnique({
      name: 'UQ_PRODUCT_TREATMENT_REVIEWS_APPOINTMENT_ID',
      columnNames: ['appointment_id'],
    }));

    // Rename indexes
    await queryRunner.dropIndex('product_treatment_reviews', 'IDX_TREATMENT_REVIEWS_APPOINTMENT_ID').catch(() => {});
    await queryRunner.createIndex('product_treatment_reviews', new TableIndex({
      name: 'IDX_PRODUCT_TREATMENT_REVIEWS_APPOINTMENT_ID',
      columnNames: ['appointment_id'],
    }));

    await queryRunner.dropIndex('product_treatment_reviews', 'IDX_TREATMENT_REVIEWS_USER_ID').catch(() => {});
    await queryRunner.createIndex('product_treatment_reviews', new TableIndex({
      name: 'IDX_PRODUCT_TREATMENT_REVIEWS_USER_ID',
      columnNames: ['user_id'],
    }));

    // Rename foreign keys
    await queryRunner.dropForeignKey('product_treatment_reviews', 'FK_TREATMENT_REVIEWS_BOOKING').catch(() => {});
    await queryRunner.createForeignKey('product_treatment_reviews', new TableForeignKey({
      name: 'FK_PRODUCT_TREATMENT_REVIEWS_BOOKING',
      columnNames: ['appointment_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'bookings',
      onDelete: 'CASCADE',
    }));

    await queryRunner.dropForeignKey('product_treatment_reviews', 'FK_TREATMENT_REVIEWS_ACCOUNT').catch(() => {});
    await queryRunner.createForeignKey('product_treatment_reviews', new TableForeignKey({
      name: 'FK_PRODUCT_TREATMENT_REVIEWS_ACCOUNT',
      columnNames: ['user_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'account',
      onDelete: 'CASCADE',
    }));
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // ── 1. Rename product_treatment_reviews back to treatment_reviews ────────

    // Restore foreign keys
    await queryRunner.dropForeignKey('product_treatment_reviews', 'FK_PRODUCT_TREATMENT_REVIEWS_ACCOUNT').catch(() => {});
    await queryRunner.createForeignKey('product_treatment_reviews', new TableForeignKey({
      name: 'FK_TREATMENT_REVIEWS_ACCOUNT',
      columnNames: ['user_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'account',
      onDelete: 'CASCADE',
    }));

    await queryRunner.dropForeignKey('product_treatment_reviews', 'FK_PRODUCT_TREATMENT_REVIEWS_BOOKING').catch(() => {});
    await queryRunner.createForeignKey('product_treatment_reviews', new TableForeignKey({
      name: 'FK_TREATMENT_REVIEWS_BOOKING',
      columnNames: ['appointment_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'bookings',
      onDelete: 'CASCADE',
    }));

    // Restore indexes
    await queryRunner.dropIndex('product_treatment_reviews', 'IDX_PRODUCT_TREATMENT_REVIEWS_USER_ID').catch(() => {});
    await queryRunner.createIndex('product_treatment_reviews', new TableIndex({
      name: 'IDX_TREATMENT_REVIEWS_USER_ID',
      columnNames: ['user_id'],
    }));

    await queryRunner.dropIndex('product_treatment_reviews', 'IDX_PRODUCT_TREATMENT_REVIEWS_APPOINTMENT_ID').catch(() => {});
    await queryRunner.createIndex('product_treatment_reviews', new TableIndex({
      name: 'IDX_TREATMENT_REVIEWS_APPOINTMENT_ID',
      columnNames: ['appointment_id'],
    }));

    // Restore unique constraint
    await queryRunner.dropUniqueConstraint(
      'product_treatment_reviews',
      'UQ_PRODUCT_TREATMENT_REVIEWS_APPOINTMENT_ID',
    ).catch(() => {});
    await queryRunner.createUniqueConstraint('product_treatment_reviews', new TableUnique({
      name: 'UQ_TREATMENT_REVIEWS_APPOINTMENT_ID',
      columnNames: ['appointment_id'],
    }));

    await queryRunner.renameTable('product_treatment_reviews', 'treatment_reviews');

    // ── 2. Recreate product_reviews ──────────────────────────────────────────

    await queryRunner.createTable(new Table({
      name: 'product_reviews',
      columns: [
        {
          name: 'id',
          type: 'uuid',
          isPrimary: true,
          isGenerated: true,
          generationStrategy: 'uuid',
          default: 'uuid_generate_v4()',
        },
        { name: 'product_id', type: 'uuid' },
        { name: 'reviewer_name', type: 'varchar', length: '100' },
        { name: 'avatar_url', type: 'text', isNullable: true },
        { name: 'rating', type: 'int' },
        { name: 'status', type: 'varchar', length: '20', default: "'Completed'" },
        { name: 'date', type: 'timestamptz' },
        { name: 'text', type: 'text' },
        { name: 'image_urls', type: 'jsonb', default: "'[]'" },
        { name: 'created_at', type: 'timestamptz', default: 'now()' },
        { name: 'deleted_at', type: 'timestamptz', isNullable: true },
      ],
    }), true);

    await queryRunner.createIndex('product_reviews', new TableIndex({
      name: 'IDX_product_reviews_productId',
      columnNames: ['product_id'],
    }));

    await queryRunner.createForeignKey('product_reviews', new TableForeignKey({
      name: 'FK_PRODUCT_REVIEWS_PRODUCT',
      columnNames: ['product_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'products',
      onDelete: 'CASCADE',
    }));
  }
}
