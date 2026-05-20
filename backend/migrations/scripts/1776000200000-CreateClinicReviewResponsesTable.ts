import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreateClinicReviewResponsesTable1776000200000
  implements MigrationInterface
{
  name = 'CreateClinicReviewResponsesTable1776000200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'clinic_review_responses',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'review_id', type: 'uuid' },
          { name: 'partner_id', type: 'uuid' },
          { name: 'response_text', type: 'text' },
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

    await queryRunner.createUniqueConstraint(
      'clinic_review_responses',
      new TableUnique({
        name: 'UQ_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
        columnNames: ['review_id'],
      }),
    );

    await queryRunner.createIndex(
      'clinic_review_responses',
      new TableIndex({
        name: 'IDX_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
        columnNames: ['review_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'clinic_review_responses',
      new TableForeignKey({
        name: 'FK_CLINIC_REVIEW_RESPONSES_REVIEW',
        columnNames: ['review_id'],
        referencedTableName: 'product_treatment_reviews',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'clinic_review_responses',
      new TableForeignKey({
        name: 'FK_CLINIC_REVIEW_RESPONSES_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'clinic_review_responses',
      'FK_CLINIC_REVIEW_RESPONSES_PARTNER',
    );
    await queryRunner.dropForeignKey(
      'clinic_review_responses',
      'FK_CLINIC_REVIEW_RESPONSES_REVIEW',
    );
    await queryRunner.dropIndex(
      'clinic_review_responses',
      'IDX_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
    );
    await queryRunner.dropUniqueConstraint(
      'clinic_review_responses',
      'UQ_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
    );
    await queryRunner.dropTable('clinic_review_responses', true);
  }
}
