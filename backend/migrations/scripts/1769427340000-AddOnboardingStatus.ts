import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOnboardingStatus1769427340000 implements MigrationInterface {
    name = 'AddOnboardingStatus1769427340000'
    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Add ONBOARDING to enum
        // We need to commit this change before using it in the same migration flow (Postgres restriction).
        // First check if it exists to be safe (idempotent for retry).
        const enumCheck = await queryRunner.query(`
            SELECT 1 FROM pg_enum 
            WHERE enumlabel = 'ONBOARDING' 
            AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'health_partner_profile_verification_status_enum')
        `);

        if (enumCheck.length === 0) {
            await queryRunner.query(`ALTER TYPE "public"."health_partner_profile_verification_status_enum" ADD VALUE 'ONBOARDING'`);
        }

        // COMMIT the Enum change so it can be used below.
        await queryRunner.commitTransaction();
        await queryRunner.startTransaction();

        // 2. Change column default
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "verification_status" SET DEFAULT 'ONBOARDING'`);

        // 3. Update existing partners who are PENDING and have NO documents to ONBOARDING
        await queryRunner.query(`
            UPDATE "health_partner_profile"
            SET "verification_status" = 'ONBOARDING'
            WHERE "verification_status" = 'PENDING'
            AND NOT EXISTS (
                SELECT 1 FROM "partner_document"
                WHERE "partner_document"."partner_id" = "health_partner_profile"."id"
            )
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // 1. Revert default
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "verification_status" SET DEFAULT 'PENDING'`);

        // 2. Move ONBOARDING partners back to PENDING
        await queryRunner.query(`
            UPDATE "health_partner_profile"
            SET "verification_status" = 'PENDING'
            WHERE "verification_status" = 'ONBOARDING'
        `);


    }
}
