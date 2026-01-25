import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateHealthPartnerProfileTable1766323000000 implements MigrationInterface {
    name = 'CreateHealthPartnerProfileTable1766323000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create business type enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."health_partner_profile_business_type_enum" AS ENUM(
                    'MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS',
                    'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY',
                    'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY'
                );
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create verification status enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."health_partner_profile_verification_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create health_partner_profile table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "health_partner_profile" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "tax_code" character varying(20) NOT NULL,
                "legal_name" character varying(200) NOT NULL,
                "brand_name" character varying(150) NOT NULL,
                "business_type" "public"."health_partner_profile_business_type_enum" NOT NULL,
                "province_id" uuid,
                "district_id" uuid,
                "ward_id" uuid,
                "street_address" character varying(300) NOT NULL,
                "phone_number" character varying(20),
                "account_id" uuid NOT NULL,
                "verification_status" "public"."health_partner_profile_verification_status_enum" NOT NULL DEFAULT 'PENDING',
                "rejectionDetails" jsonb,
                "verification_completed_at" TIMESTAMP WITH TIME ZONE,
                "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP WITH TIME ZONE,
                CONSTRAINT "UQ_health_partner_profile_tax_code" UNIQUE ("tax_code"),
                CONSTRAINT "PK_health_partner_profile" PRIMARY KEY ("id")
            )
        `);

        // Add foreign key constraints
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "health_partner_profile"
                ADD CONSTRAINT "FK_health_partner_profile_account"
                FOREIGN KEY ("account_id")
                REFERENCES "account"("id")
                ON DELETE CASCADE ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

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
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT IF EXISTS "FK_health_partner_profile_account"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "health_partner_profile"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_verification_status_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_business_type_enum"`);
    }
}
