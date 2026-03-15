import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddGeoColumnsToPartnerProfile1773500000000 implements MigrationInterface {
    name = 'AddGeoColumnsToPartnerProfile1773500000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Use raw SQL with IF NOT EXISTS to safely handle both fresh and synced databases
        await queryRunner.query(`
            DO $$
            BEGIN
                IF NOT EXISTS (
                    SELECT 1 FROM information_schema.columns
                    WHERE table_name = 'health_partner_profile' AND column_name = 'latitude'
                ) THEN
                    ALTER TABLE health_partner_profile ADD COLUMN latitude DECIMAL(10, 7);
                END IF;

                IF NOT EXISTS (
                    SELECT 1 FROM information_schema.columns
                    WHERE table_name = 'health_partner_profile' AND column_name = 'longitude'
                ) THEN
                    ALTER TABLE health_partner_profile ADD COLUMN longitude DECIMAL(10, 7);
                END IF;
            END $$;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS longitude`);
        await queryRunner.query(`ALTER TABLE health_partner_profile DROP COLUMN IF EXISTS latitude`);
    }
}
