import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateDocumentRequirementTable1766322500000 implements MigrationInterface {
    name = 'CreateDocumentRequirementTable1766322500000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create business type enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."document_requirement_businesstype_enum" AS ENUM(
                    'MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS',
                    'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY',
                    'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY'
                );
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create document type enum (same as partner_document)
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."document_requirement_documenttype_enum" AS ENUM(
                    'TAX_CODE', 'BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK',
                    'AUTHORIZATION_LETTER', 'ANTT', 'CCHN', 'GPP', 'GCN_FITNESS',
                    'RHM_LICENSE', 'YHCT_LICENSE', 'PSYCHIATRY_LICENSE', 'DERMATOLOGY_LICENSE',
                    'CCHN_MASSAGE', 'CCHN_PHARMACY', 'CCHN_DENTAL', 'CCHN_NUTRITION',
                    'CCHN_PSYCHOLOGY', 'PORTFOLIO'
                );
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create document_requirement table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "document_requirement" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "businessType" "public"."document_requirement_businesstype_enum" NOT NULL,
                "documentType" "public"."document_requirement_documenttype_enum" NOT NULL,
                "isRequired" boolean NOT NULL DEFAULT true,
                "description" text,
                "displayOrder" integer NOT NULL DEFAULT 0,
                CONSTRAINT "PK_document_requirement" PRIMARY KEY ("id")
            )
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE IF EXISTS "document_requirement"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_documenttype_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_businesstype_enum"`);
    }
}
