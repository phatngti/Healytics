import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateDocumentRequirementTable1769427320000 implements MigrationInterface {
    name = 'CreateDocumentRequirementTable1769427320000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."document_requirement_businesstype_enum" AS ENUM('MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS', 'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY', 'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY')`);
        await queryRunner.query(`CREATE TYPE "public"."document_requirement_documenttype_enum" AS ENUM('BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE')`);
        await queryRunner.query(`CREATE TABLE "document_requirement" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "businessType" "public"."document_requirement_businesstype_enum" NOT NULL, "documentType" "public"."document_requirement_documenttype_enum" NOT NULL, "isRequired" boolean NOT NULL DEFAULT true, "description" text, "displayOrder" integer NOT NULL DEFAULT '0', CONSTRAINT "PK_DOCUMENT_REQUIREMENT" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "document_requirement"`);
        await queryRunner.query(`DROP TYPE "public"."document_requirement_documenttype_enum"`);
        await queryRunner.query(`DROP TYPE "public"."document_requirement_businesstype_enum"`);
    }
}
