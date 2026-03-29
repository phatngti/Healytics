import { MigrationInterface, QueryRunner, TableColumn, TableIndex } from 'typeorm';

/**
 * Migration: AddIdToProductEmployeeEligibility
 *
 * Promotes product_employee_eligibility from a composite PK table to one
 * with a surrogate UUID primary key (`id`).
 *
 * Steps (up):
 *  1. Add nullable `id` UUID column with default uuid_generate_v4()
 *  2. Backfill existing rows
 *  3. Alter column to NOT NULL
 *  4. Drop composite PK constraint
 *  5. Promote `id` to primary key
 *  6. Add UNIQUE constraint on (product_id, employee_id) for data integrity
 *
 * Steps (down — fully reversible):
 *  1. Drop unique index on (product_id, employee_id)
 *  2. Drop primary key on id
 *  3. Re-create composite PK on (product_id, employee_id)
 *  4. Drop column id
 */
export class AddIdToProductEmployeeEligibility1774700000000 implements MigrationInterface {
  name = 'AddIdToProductEmployeeEligibility1774700000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. Add nullable id column with a default so new inserts auto-populate
    //    (Idempotent: skip if column already exists from synchronize)
    const hasColumn = await queryRunner.query(
      `SELECT 1 FROM information_schema.columns WHERE table_name = 'product_employee_eligibility' AND column_name = 'id'`,
    );
    if (hasColumn.length === 0) {
      await queryRunner.addColumn(
        'product_employee_eligibility',
        new TableColumn({
          name: 'id',
          type: 'uuid',
          isNullable: true,
          default: 'uuid_generate_v4()',
        }),
      );
    }

    // 2. Backfill all existing rows (no default was applied on insert yet)
    await queryRunner.query(
      `UPDATE product_employee_eligibility SET id = uuid_generate_v4() WHERE id IS NULL`,
    );

    // 3. Alter to NOT NULL (all rows now have a value)
    await queryRunner.query(
      `ALTER TABLE product_employee_eligibility ALTER COLUMN id SET NOT NULL`,
    );

    // 4. Drop ANY existing primary key constraint (regardless of its name)
    //    TypeORM sync may create the PK with a non-default name, so we must
    //    look up the real constraint name dynamically instead of hard-coding it.
    const existingPk = await queryRunner.query(
      `SELECT con.conname
       FROM pg_constraint con
       INNER JOIN pg_class rel ON rel.oid = con.conrelid
       INNER JOIN pg_namespace nsp ON nsp.oid = rel.relnamespace
       WHERE con.contype = 'p'
         AND nsp.nspname = 'public'
         AND rel.relname = 'product_employee_eligibility'`,
    );
    for (const row of existingPk) {
      await queryRunner.query(
        `ALTER TABLE product_employee_eligibility DROP CONSTRAINT "${row.conname}"`,
      );
    }

    // 5. Promote id to primary key (idempotent: check if id is already PK)
    const hasPk = await queryRunner.query(
      `SELECT 1
       FROM information_schema.table_constraints tc
       JOIN information_schema.key_column_usage kcu
         ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
       WHERE tc.table_schema = 'public'
         AND tc.table_name = 'product_employee_eligibility'
         AND tc.constraint_type = 'PRIMARY KEY'
         AND kcu.column_name = 'id'`,
    );
    if (hasPk.length === 0) {
      await queryRunner.query(
        `ALTER TABLE product_employee_eligibility ADD PRIMARY KEY (id)`,
      );
    }

    // 6. Add unique index on (product_id, employee_id) to preserve data integrity (idempotent)
    const hasIdx = await queryRunner.query(
      `SELECT 1 FROM pg_indexes WHERE tablename = 'product_employee_eligibility' AND indexname = 'UQ_PRODUCT_EMPLOYEE_ELIGIBILITY'`,
    );
    if (hasIdx.length === 0) {
      await queryRunner.createIndex(
        'product_employee_eligibility',
        new TableIndex({
          name: 'UQ_PRODUCT_EMPLOYEE_ELIGIBILITY',
          columnNames: ['product_id', 'employee_id'],
          isUnique: true,
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // 1. Drop unique index on (product_id, employee_id)
    await queryRunner.dropIndex(
      'product_employee_eligibility',
      'UQ_PRODUCT_EMPLOYEE_ELIGIBILITY',
    );

    // 2. Drop primary key on id
    await queryRunner.query(
      `ALTER TABLE product_employee_eligibility DROP CONSTRAINT IF EXISTS "product_employee_eligibility_pkey"`,
    );

    // 3. Re-create composite PK on (product_id, employee_id)
    await queryRunner.query(
      `ALTER TABLE product_employee_eligibility ADD PRIMARY KEY (product_id, employee_id)`,
    );

    // 4. Drop the id column
    await queryRunner.dropColumn('product_employee_eligibility', 'id');
  }
}
