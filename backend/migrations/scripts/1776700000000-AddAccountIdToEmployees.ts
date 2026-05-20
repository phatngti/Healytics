import {
  MigrationInterface,
  QueryRunner,
  TableColumn,
  TableIndex,
  TableForeignKey,
  TableUnique,
} from 'typeorm';

export class AddAccountIdToEmployees1776700000000 implements MigrationInterface {
  name = 'AddAccountIdToEmployees1776700000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. Add the column
    await queryRunner.addColumn(
      'employees',
      new TableColumn({
        name: 'account_id',
        type: 'uuid',
        isNullable: true,
      }),
    );

    // 2. Add index (REQUIRED for FK columns)
    await queryRunner.createIndex(
      'employees',
      new TableIndex({
        name: 'IDX_EMPLOYEES_ACCOUNT_ID',
        columnNames: ['account_id'],
      }),
    );

    // 3. Add unique constraint (one account per employee)
    await queryRunner.createUniqueConstraint(
      'employees',
      new TableUnique({
        name: 'UQ_EMPLOYEES_ACCOUNT_ID',
        columnNames: ['account_id'],
      }),
    );

    // 4. Add foreign key constraint
    await queryRunner.createForeignKey(
      'employees',
      new TableForeignKey({
        name: 'FK_EMPLOYEES_ACCOUNT',
        columnNames: ['account_id'],
        referencedTableName: 'account',
        referencedColumnNames: ['id'],
        onDelete: 'SET NULL',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order: FK -> Unique -> Index -> Column
    await queryRunner.dropForeignKey('employees', 'FK_EMPLOYEES_ACCOUNT');
    await queryRunner.dropUniqueConstraint(
      'employees',
      'UQ_EMPLOYEES_ACCOUNT_ID',
    );
    await queryRunner.dropIndex('employees', 'IDX_EMPLOYEES_ACCOUNT_ID');
    await queryRunner.dropColumn('employees', 'account_id');
  }
}
