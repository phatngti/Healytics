import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
} from 'typeorm';

export class CreatePartnerStatistics1779100000000 implements MigrationInterface {
  name = 'CreatePartnerStatistics1779100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'partner_statistics',
        columns: [
          {
            name: 'partner_id',
            type: 'uuid',
            isPrimary: true,
          },
          {
            name: 'completed_bookings_count',
            type: 'int',
            default: 0,
          },
          {
            name: 'review_count',
            type: 'int',
            default: 0,
          },
          {
            name: 'average_stars',
            type: 'numeric',
            precision: 3,
            scale: 2,
            default: 0,
          },
          {
            name: 'last_calculated_at',
            type: 'timestamptz',
            default: 'now()',
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

    await queryRunner.createForeignKey(
      'partner_statistics',
      new TableForeignKey({
        name: 'FK_PARTNER_STATISTICS_PARTNER_ID',
        columnNames: ['partner_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'health_partner_profile',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'partner_statistics',
      'FK_PARTNER_STATISTICS_PARTNER_ID',
    );
    await queryRunner.dropTable('partner_statistics', true);
  }
}
