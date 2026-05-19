import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreateFacilityReviews1779400000000 implements MigrationInterface {
  name = 'CreateFacilityReviews1779400000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'facility_reviews',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'appointment_id', type: 'uuid' },
          { name: 'facility_id', type: 'uuid' },
          { name: 'user_id', type: 'uuid' },
          { name: 'rating', type: 'int' },
          { name: 'comment', type: 'text', isNullable: true },
          { name: 'tags', type: 'jsonb', default: "'[]'" },
          { name: 'photo_urls', type: 'jsonb', default: "'[]'" },
          { name: 'created_at', type: 'timestamptz', default: 'now()' },
          { name: 'updated_at', type: 'timestamptz', default: 'now()' },
        ],
      }),
      true,
    );

    await queryRunner.createUniqueConstraint(
      'facility_reviews',
      new TableUnique({
        name: 'UQ_FACILITY_REVIEWS_APPOINTMENT_ID',
        columnNames: ['appointment_id'],
      }),
    );

    await queryRunner.createIndex(
      'facility_reviews',
      new TableIndex({
        name: 'IDX_FACILITY_REVIEWS_APPOINTMENT_ID',
        columnNames: ['appointment_id'],
      }),
    );

    await queryRunner.createIndex(
      'facility_reviews',
      new TableIndex({
        name: 'IDX_FACILITY_REVIEWS_FACILITY_ID',
        columnNames: ['facility_id'],
      }),
    );

    await queryRunner.createIndex(
      'facility_reviews',
      new TableIndex({
        name: 'IDX_FACILITY_REVIEWS_USER_ID',
        columnNames: ['user_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'facility_reviews',
      new TableForeignKey({
        name: 'FK_FACILITY_REVIEWS_BOOKING',
        columnNames: ['appointment_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'bookings',
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'facility_reviews',
      new TableForeignKey({
        name: 'FK_FACILITY_REVIEWS_PARTNER',
        columnNames: ['facility_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'health_partner_profile',
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'facility_reviews',
      new TableForeignKey({
        name: 'FK_FACILITY_REVIEWS_ACCOUNT',
        columnNames: ['user_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'facility_reviews',
      'FK_FACILITY_REVIEWS_ACCOUNT',
    );
    await queryRunner.dropForeignKey(
      'facility_reviews',
      'FK_FACILITY_REVIEWS_PARTNER',
    );
    await queryRunner.dropForeignKey(
      'facility_reviews',
      'FK_FACILITY_REVIEWS_BOOKING',
    );
    await queryRunner.dropIndex(
      'facility_reviews',
      'IDX_FACILITY_REVIEWS_USER_ID',
    );
    await queryRunner.dropIndex(
      'facility_reviews',
      'IDX_FACILITY_REVIEWS_FACILITY_ID',
    );
    await queryRunner.dropIndex(
      'facility_reviews',
      'IDX_FACILITY_REVIEWS_APPOINTMENT_ID',
    );
    await queryRunner.dropUniqueConstraint(
      'facility_reviews',
      'UQ_FACILITY_REVIEWS_APPOINTMENT_ID',
    );
    await queryRunner.dropTable('facility_reviews', true);
  }
}
