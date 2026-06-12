import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddLocationColumnsToUserAddress1779600000000
  implements MigrationInterface
{
  name = 'AddLocationColumnsToUserAddress1779600000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`);

    await queryRunner.query(`
      ALTER TABLE address
        ADD COLUMN IF NOT EXISTS province_id uuid,
        ADD COLUMN IF NOT EXISTS district_id uuid,
        ADD COLUMN IF NOT EXISTS ward_id uuid,
        ADD COLUMN IF NOT EXISTS coordinates text,
        ADD COLUMN IF NOT EXISTS location geography(Point, 4326)
    `);

    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'FK_ADDRESS_PROVINCE_ID'
        ) THEN
          ALTER TABLE address
            ADD CONSTRAINT "FK_ADDRESS_PROVINCE_ID"
            FOREIGN KEY (province_id) REFERENCES location(id) ON DELETE SET NULL;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'FK_ADDRESS_DISTRICT_ID'
        ) THEN
          ALTER TABLE address
            ADD CONSTRAINT "FK_ADDRESS_DISTRICT_ID"
            FOREIGN KEY (district_id) REFERENCES location(id) ON DELETE SET NULL;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM pg_constraint WHERE conname = 'FK_ADDRESS_WARD_ID'
        ) THEN
          ALTER TABLE address
            ADD CONSTRAINT "FK_ADDRESS_WARD_ID"
            FOREIGN KEY (ward_id) REFERENCES location(id) ON DELETE SET NULL;
        END IF;
      END $$;
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_ADDRESS_PROVINCE_ID" ON address(province_id)
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_ADDRESS_DISTRICT_ID" ON address(district_id)
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_ADDRESS_WARD_ID" ON address(ward_id)
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_ADDRESS_LOCATION"
      ON address USING GIST(location)
    `);

    await queryRunner.query(`
      UPDATE address a
      SET
        province_id = province.id,
        district_id = district.id,
        ward_id = ward.id
      FROM location province
      JOIN location district
        ON district.parent_id = province.id
       AND district.level = 'DISTRICT'
      JOIN location ward
        ON ward.parent_id = district.id
       AND ward.level = 'WARD'
      WHERE a.province_id IS NULL
        AND province.level = 'PROVINCE'
        AND lower(trim(a.city_or_province)) IN (
          lower(trim(province.name)),
          lower(trim(province.full_name)),
          lower(trim(coalesce(province.name_en, ''))),
          lower(trim(coalesce(province.full_name_en, '')))
        )
        AND lower(trim(a.district)) IN (
          lower(trim(district.name)),
          lower(trim(district.full_name)),
          lower(trim(coalesce(district.name_en, ''))),
          lower(trim(coalesce(district.full_name_en, '')))
        )
        AND lower(trim(a.ward)) IN (
          lower(trim(ward.name)),
          lower(trim(ward.full_name)),
          lower(trim(coalesce(ward.name_en, ''))),
          lower(trim(coalesce(ward.full_name_en, '')))
        )
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_ADDRESS_LOCATION"`);
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_ADDRESS_WARD_ID"`);
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_ADDRESS_DISTRICT_ID"`);
    await queryRunner.query(`DROP INDEX IF EXISTS "IDX_ADDRESS_PROVINCE_ID"`);

    await queryRunner.query(`
      ALTER TABLE address
        DROP CONSTRAINT IF EXISTS "FK_ADDRESS_WARD_ID",
        DROP CONSTRAINT IF EXISTS "FK_ADDRESS_DISTRICT_ID",
        DROP CONSTRAINT IF EXISTS "FK_ADDRESS_PROVINCE_ID"
    `);

    await queryRunner.query(`
      ALTER TABLE address
        DROP COLUMN IF EXISTS location,
        DROP COLUMN IF EXISTS coordinates,
        DROP COLUMN IF EXISTS ward_id,
        DROP COLUMN IF EXISTS district_id,
        DROP COLUMN IF EXISTS province_id
    `);
  }
}
