import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddCategoryAdminFields1773700000000 implements MigrationInterface {
  name = 'AddCategoryAdminFields1773700000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "categories" ADD COLUMN IF NOT EXISTS "icon_name" character varying(100)`,
    );
    await queryRunner.query(
      `ALTER TABLE "categories" ADD COLUMN IF NOT EXISTS "color_value" character varying(9)`,
    );
    await queryRunner.query(
      `ALTER TABLE "categories" ADD COLUMN IF NOT EXISTS "sort_order" integer NOT NULL DEFAULT 0`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "categories" DROP COLUMN IF EXISTS "sort_order"`,
    );
    await queryRunner.query(
      `ALTER TABLE "categories" DROP COLUMN IF EXISTS "color_value"`,
    );
    await queryRunner.query(
      `ALTER TABLE "categories" DROP COLUMN IF EXISTS "icon_name"`,
    );
  }
}
