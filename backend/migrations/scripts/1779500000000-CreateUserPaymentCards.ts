import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreateUserPaymentCards1779500000000 implements MigrationInterface {
  name = 'CreateUserPaymentCards1779500000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'user_payment_customers',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'user_id', type: 'uuid' },
          {
            name: 'provider',
            type: 'varchar',
            length: '30',
            default: "'STRIPE'",
          },
          { name: 'gateway_customer_id', type: 'varchar', length: '100' },
          { name: 'created_at', type: 'timestamptz', default: 'now()' },
          { name: 'updated_at', type: 'timestamptz', default: 'now()' },
          { name: 'deleted_at', type: 'timestamptz', isNullable: true },
        ],
      }),
      true,
    );

    await queryRunner.createIndex(
      'user_payment_customers',
      new TableIndex({
        name: 'IDX_USER_PAYMENT_CUSTOMERS_USER',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'user_payment_customers',
      new TableIndex({
        name: 'UQ_USER_PAYMENT_CUSTOMERS_USER_PROVIDER_ACTIVE',
        columnNames: ['user_id', 'provider'],
        isUnique: true,
        where: 'deleted_at IS NULL',
      }),
    );
    await queryRunner.createIndex(
      'user_payment_customers',
      new TableIndex({
        name: 'UQ_USER_PAYMENT_CUSTOMERS_GATEWAY_CUSTOMER',
        columnNames: ['gateway_customer_id'],
        isUnique: true,
      }),
    );
    await queryRunner.createForeignKey(
      'user_payment_customers',
      new TableForeignKey({
        name: 'FK_USER_PAYMENT_CUSTOMERS_USER_ID',
        columnNames: ['user_id'],
        referencedTableName: 'account',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'user_payment_methods',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'user_id', type: 'uuid' },
          { name: 'customer_id', type: 'uuid' },
          {
            name: 'provider',
            type: 'varchar',
            length: '30',
            default: "'STRIPE'",
          },
          {
            name: 'gateway_payment_method_id',
            type: 'varchar',
            length: '100',
          },
          { name: 'brand', type: 'varchar', length: '30' },
          { name: 'last4', type: 'varchar', length: '4' },
          { name: 'exp_month', type: 'int' },
          { name: 'exp_year', type: 'int' },
          { name: 'funding', type: 'varchar', length: '30', isNullable: true },
          { name: 'country', type: 'varchar', length: '2', isNullable: true },
          { name: 'is_default', type: 'boolean', default: false },
          { name: 'created_at', type: 'timestamptz', default: 'now()' },
          { name: 'updated_at', type: 'timestamptz', default: 'now()' },
          { name: 'deleted_at', type: 'timestamptz', isNullable: true },
        ],
      }),
      true,
    );

    await queryRunner.createIndex(
      'user_payment_methods',
      new TableIndex({
        name: 'IDX_USER_PAYMENT_METHODS_USER',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'user_payment_methods',
      new TableIndex({
        name: 'IDX_USER_PAYMENT_METHODS_CUSTOMER',
        columnNames: ['customer_id'],
      }),
    );
    await queryRunner.createIndex(
      'user_payment_methods',
      new TableIndex({
        name: 'UQ_USER_PAYMENT_METHODS_GATEWAY_METHOD',
        columnNames: ['gateway_payment_method_id'],
        isUnique: true,
      }),
    );
    await queryRunner.createIndex(
      'user_payment_methods',
      new TableIndex({
        name: 'UQ_USER_PAYMENT_METHODS_ONE_DEFAULT',
        columnNames: ['user_id', 'provider'],
        isUnique: true,
        where: 'is_default = true AND deleted_at IS NULL',
      }),
    );
    await queryRunner.createForeignKey(
      'user_payment_methods',
      new TableForeignKey({
        name: 'FK_USER_PAYMENT_METHODS_USER_ID',
        columnNames: ['user_id'],
        referencedTableName: 'account',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'user_payment_methods',
      new TableForeignKey({
        name: 'FK_USER_PAYMENT_METHODS_CUSTOMER_ID',
        columnNames: ['customer_id'],
        referencedTableName: 'user_payment_customers',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('user_payment_methods', true);
    await queryRunner.dropTable('user_payment_customers', true);
  }
}
