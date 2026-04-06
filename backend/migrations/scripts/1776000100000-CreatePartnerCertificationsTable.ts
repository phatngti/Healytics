import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
} from 'typeorm';

export class CreatePartnerCertificationsTable1776000100000
  implements MigrationInterface
{
  name = 'CreatePartnerCertificationsTable1776000100000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'partner_certifications',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          { name: 'partner_id', type: 'uuid' },
          { name: 'title', type: 'varchar', length: '200' },
          {
            name: 'subtitle',
            type: 'varchar',
            length: '200',
            isNullable: true,
          },
          {
            name: 'icon_name',
            type: 'varchar',
            length: '50',
            default: "'workspace_premium'",
          },
          { name: 'sort_order', type: 'int', default: 0 },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    await queryRunner.createIndex(
      'partner_certifications',
      new TableIndex({
        name: 'IDX_PARTNER_CERTIFICATIONS_PARTNER_ID',
        columnNames: ['partner_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'partner_certifications',
      new TableForeignKey({
        name: 'FK_PARTNER_CERTIFICATIONS_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'partner_certifications',
      'FK_PARTNER_CERTIFICATIONS_PARTNER',
    );
    await queryRunner.dropIndex(
      'partner_certifications',
      'IDX_PARTNER_CERTIFICATIONS_PARTNER_ID',
    );
    await queryRunner.dropTable('partner_certifications', true);
  }
}
