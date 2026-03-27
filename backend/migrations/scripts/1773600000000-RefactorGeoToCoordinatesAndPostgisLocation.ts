import { MigrationInterface, QueryRunner } from 'typeorm';

export class RefactorGeoToCoordinatesAndPostgisLocation1773600000000 implements MigrationInterface {
    name = 'RefactorGeoToCoordinatesAndPostgisLocation1773600000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Enable PostGIS extension
        await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS postgis`);

        // 2. Add new columns
        await queryRunner.query(`
            DO $$
            BEGIN
                IF NOT EXISTS (
                    SELECT 1 FROM information_schema.columns
                    WHERE table_name = 'health_partner_profile' AND column_name = 'coordinates'
                ) THEN
                    ALTER TABLE health_partner_profile ADD COLUMN coordinates TEXT;
                END IF;

                IF NOT EXISTS (
                    SELECT 1 FROM information_schema.columns
                    WHERE table_name = 'health_partner_profile' AND column_name = 'location'
                ) THEN
                    ALTER TABLE health_partner_profile ADD COLUMN location geography(Point, 4326);
                END IF;
            END $$;
        `);

        // 3. Migrate existing data from latitude/longitude to new columns
        await queryRunner.query(`
            UPDATE health_partner_profile
            SET
                coordinates = latitude || ',' || longitude,
                location = ST_SetSRID(ST_MakePoint(longitude::double precision, latitude::double precision), 4326)::geography
            WHERE latitude IS NOT NULL AND longitude IS NOT NULL
        `);

        // 4. Drop old latitude and longitude columns
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS latitude`);
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS longitude`);

        // 5. Create spatial index for distance queries
        await queryRunner.query(`
            CREATE INDEX IF NOT EXISTS "IDX_PARTNER_LOCATION"
            ON health_partner_profile USING GIST(location)
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // 1. Drop spatial index
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_PARTNER_LOCATION"`);

        // 2. Add back old decimal columns
        await queryRunner.query(`
            ALTER TABLE health_partner_profile
            ADD COLUMN IF NOT EXISTS latitude DECIMAL(10, 7),
            ADD COLUMN IF NOT EXISTS longitude DECIMAL(10, 7)
        `);

        // 3. Migrate data back from coordinates text to decimal columns
        await queryRunner.query(`
            UPDATE health_partner_profile
            SET
                latitude = CAST(split_part(coordinates, ',', 1) AS DECIMAL(10, 7)),
                longitude = CAST(split_part(coordinates, ',', 2) AS DECIMAL(10, 7))
            WHERE coordinates IS NOT NULL AND coordinates LIKE '%,%'
        `);

        // 4. Drop new columns
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS location`);
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS coordinates`);
    }
}
