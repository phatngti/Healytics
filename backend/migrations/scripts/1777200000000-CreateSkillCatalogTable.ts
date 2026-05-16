import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreateSkillCatalogTable1777200000000
  implements MigrationInterface
{
  name = 'CreateSkillCatalogTable1777200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'skill_catalog',
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
          { name: 'slug', type: 'varchar', length: '100' },
          { name: 'label', type: 'varchar', length: '200' },
          {
            name: 'type',
            type: 'varchar',
            length: '50',
            comment:
              'Skill type: MASSAGE, SPA, DOCTOR, etc.',
          },
          {
            name: 'is_default',
            type: 'boolean',
            default: false,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    // Unique constraint per partner + slug + type
    await queryRunner.createUniqueConstraint(
      'skill_catalog',
      new TableUnique({
        name: 'UQ_SKILL_CATALOG_PARTNER_SLUG_TYPE',
        columnNames: ['partner_id', 'slug', 'type'],
      }),
    );

    await queryRunner.createIndex(
      'skill_catalog',
      new TableIndex({
        name: 'IDX_SKILL_CATALOG_PARTNER_ID',
        columnNames: ['partner_id'],
      }),
    );

    await queryRunner.createIndex(
      'skill_catalog',
      new TableIndex({
        name: 'IDX_SKILL_CATALOG_TYPE',
        columnNames: ['type'],
      }),
    );

    await queryRunner.createForeignKey(
      'skill_catalog',
      new TableForeignKey({
        name: 'FK_SKILL_CATALOG_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'skill_catalog',
      'FK_SKILL_CATALOG_PARTNER',
    );
    await queryRunner.dropIndex(
      'skill_catalog',
      'IDX_SKILL_CATALOG_TYPE',
    );
    await queryRunner.dropIndex(
      'skill_catalog',
      'IDX_SKILL_CATALOG_PARTNER_ID',
    );
    await queryRunner.dropUniqueConstraint(
      'skill_catalog',
      'UQ_SKILL_CATALOG_PARTNER_SLUG_TYPE',
    );
    await queryRunner.dropTable('skill_catalog', true);
  }
}
