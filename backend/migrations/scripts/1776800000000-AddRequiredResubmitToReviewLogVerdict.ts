import { MigrationInterface, QueryRunner } from "typeorm";

export class AddRequiredResubmitToReviewLogVerdict1776800000000 implements MigrationInterface {
    name = 'AddRequiredResubmitToReviewLogVerdict1776800000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Add REQUIRED_RESUBMIT to the review log verdict enum (idempotent).
        // The previous migration (1776500000000) only added it to
        // health_partner_profile_verification_status_enum but missed
        // health_partner_review_log_verdict_enum.
        const enumCheck = await queryRunner.query(`
            SELECT 1 FROM pg_enum 
            WHERE enumlabel = 'REQUIRED_RESUBMIT' 
            AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'health_partner_review_log_verdict_enum')
        `);

        if (enumCheck.length === 0) {
            await queryRunner.query(`ALTER TYPE "public"."health_partner_review_log_verdict_enum" ADD VALUE 'REQUIRED_RESUBMIT'`);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // PostgreSQL does not support removing individual values from an enum type.
        // To fully revert, you would need to recreate the type — left as no-op for safety.
    }
}
