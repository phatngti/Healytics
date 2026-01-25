import { MigrationInterface, QueryRunner } from "typeorm";

export class UpdateDocumentTypesAndVerificationStatus1768866540811 implements MigrationInterface {
    name = 'UpdateDocumentTypesAndVerificationStatus1768866540811'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP COLUMN IF EXISTS "is_verified"`);

        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_verification_status_enum" CASCADE`);
        await queryRunner.query(`CREATE TYPE "public"."health_partner_profile_verification_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED')`);

        const hasVerificationStatus = await queryRunner.query(`
            SELECT column_name FROM information_schema.columns 
            WHERE table_name = 'health_partner_profile' AND column_name = 'verification_status'
        `);
        if (hasVerificationStatus.length === 0) {
            await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD "verification_status" "public"."health_partner_profile_verification_status_enum" NOT NULL DEFAULT 'PENDING'`);
        }

        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN IF EXISTS "status"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_status_enum" CASCADE`);

        const hasIsReviewed = await queryRunner.query(`
            SELECT column_name FROM information_schema.columns 
            WHERE table_name = 'partner_document' AND column_name = 'is_reviewed'
        `);
        if (hasIsReviewed.length === 0) {
            await queryRunner.query(`ALTER TABLE "partner_document" ADD "is_reviewed" boolean NOT NULL DEFAULT false`);
        }

        const hasIsValid = await queryRunner.query(`
            SELECT column_name FROM information_schema.columns 
            WHERE table_name = 'partner_document' AND column_name = 'is_valid'
        `);
        if (hasIsValid.length === 0) {
            await queryRunner.query(`ALTER TABLE "partner_document" ADD "is_valid" boolean NOT NULL DEFAULT true`);
        }

        await queryRunner.query(`TRUNCATE TABLE "document_requirement" CASCADE`);
        await queryRunner.query(`TRUNCATE TABLE "partner_document" CASCADE`);

        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN IF EXISTS "documentType"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_documenttype_enum" CASCADE`);
        await queryRunner.query(`CREATE TYPE "public"."partner_document_documenttype_enum" AS ENUM('BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE')`);
        await queryRunner.query(`ALTER TABLE "partner_document" ADD "documentType" "public"."partner_document_documenttype_enum" NOT NULL`);

        await queryRunner.query(`ALTER TABLE "document_requirement" DROP COLUMN IF EXISTS "documentType"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_documenttype_enum" CASCADE`);
        await queryRunner.query(`CREATE TYPE "public"."document_requirement_documenttype_enum" AS ENUM('BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE')`);
        await queryRunner.query(`ALTER TABLE "document_requirement" ADD "documentType" "public"."document_requirement_documenttype_enum" NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "document_requirement" DROP COLUMN "documentType"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_documenttype_enum" CASCADE`);
        await queryRunner.query(`CREATE TYPE "public"."document_requirement_documenttype_enum" AS ENUM('TAX_CODE', 'BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'CCHN', 'GPP', 'GCN_FITNESS', 'RHM_LICENSE', 'YHCT_LICENSE', 'PSYCHIATRY_LICENSE', 'DERMATOLOGY_LICENSE', 'CCHN_MASSAGE', 'CCHN_PHARMACY', 'CCHN_DENTAL', 'CCHN_NUTRITION', 'CCHN_PSYCHOLOGY', 'PORTFOLIO')`);
        await queryRunner.query(`ALTER TABLE "document_requirement" ADD "documentType" "public"."document_requirement_documenttype_enum" NOT NULL`);

        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN "documentType"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_documenttype_enum" CASCADE`);
        await queryRunner.query(`CREATE TYPE "public"."partner_document_documenttype_enum" AS ENUM('TAX_CODE', 'BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'CCHN', 'GPP', 'GCN_FITNESS', 'RHM_LICENSE', 'YHCT_LICENSE', 'PSYCHIATRY_LICENSE', 'DERMATOLOGY_LICENSE', 'CCHN_MASSAGE', 'CCHN_PHARMACY', 'CCHN_DENTAL', 'CCHN_NUTRITION', 'CCHN_PSYCHOLOGY', 'PORTFOLIO')`);
        await queryRunner.query(`ALTER TABLE "partner_document" ADD "documentType" "public"."partner_document_documenttype_enum" NOT NULL`);

        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN IF EXISTS "is_valid"`);
        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN IF EXISTS "is_reviewed"`);
        await queryRunner.query(`CREATE TYPE "public"."partner_document_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED')`);
        await queryRunner.query(`ALTER TABLE "partner_document" ADD "status" "public"."partner_document_status_enum" NOT NULL DEFAULT 'PENDING'`);

        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP COLUMN IF EXISTS "verification_status"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_verification_status_enum" CASCADE`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD "is_verified" boolean NOT NULL DEFAULT false`);
    }
}
