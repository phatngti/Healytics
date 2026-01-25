import { MigrationInterface, QueryRunner } from "typeorm";

export class MakePartnerLocationFieldsNullable1768804479234 implements MigrationInterface {
    name = 'MakePartnerLocationFieldsNullable1768804479234'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Drop existing FK constraints (use correct names from CreateHealthPartnerProfileTable migration)
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_province"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_district"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_ward"`);

        // The columns are already nullable in the original table definition, but ensure they are nullable
        // These will be no-ops if already nullable
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "province_id" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "district_id" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "ward_id" DROP NOT NULL`);

        // Re-add FK constraints with ON DELETE SET NULL
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_province"
                FOREIGN KEY ("province_id")
                REFERENCES "location"("id")
                ON DELETE SET NULL ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_district"
                FOREIGN KEY ("district_id")
                REFERENCES "location"("id")
                ON DELETE SET NULL ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_ward"
                FOREIGN KEY ("ward_id")
                REFERENCES "location"("id")
                ON DELETE SET NULL ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_ward"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_district"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_province"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "ward_id" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "district_id" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "province_id" SET NOT NULL`);
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_province"
                FOREIGN KEY ("province_id")
                REFERENCES "location"("id")
                ON DELETE NO ACTION ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_district"
                FOREIGN KEY ("district_id")
                REFERENCES "location"("id")
                ON DELETE NO ACTION ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_ward"
                FOREIGN KEY ("ward_id")
                REFERENCES "location"("id")
                ON DELETE NO ACTION ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
    }

}

