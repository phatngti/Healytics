import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddClinicProfileColumnsToPartner1776000000000
  implements MigrationInterface
{
  name = 'AddClinicProfileColumnsToPartner1776000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'cover_image_url'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN cover_image_url TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'logo_image_url'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN logo_image_url TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'gallery'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN gallery JSONB DEFAULT '[]';
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'description'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN description TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'follower_count'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN follower_count INT DEFAULT 0;
        END IF;
      END $$;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE health_partner_profile
        DROP COLUMN IF EXISTS follower_count,
        DROP COLUMN IF EXISTS description,
        DROP COLUMN IF EXISTS gallery,
        DROP COLUMN IF EXISTS logo_image_url,
        DROP COLUMN IF EXISTS cover_image_url;
    `);
  }
}
