import { MigrationInterface, QueryRunner } from "typeorm";

export class AddRequiredResubmitStatus1776500000000 implements MigrationInterface {
    name = 'AddRequiredResubmitStatus1776500000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Add REQUIRED_RESUBMIT to the partner verification status enum (idempotent).
        const enumCheck = await queryRunner.query(`
            SELECT 1 FROM pg_enum 
            WHERE enumlabel = 'REQUIRED_RESUBMIT' 
            AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'health_partner_profile_verification_status_enum')
        `);

        if (enumCheck.length === 0) {
            await queryRunner.query(`ALTER TYPE "public"."health_partner_profile_verification_status_enum" ADD VALUE 'REQUIRED_RESUBMIT'`);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // PostgreSQL does not support removing individual values from an enum type.
        // To fully revert, you would need to recreate the type — left as no-op for safety.
    }
}
