import { MigrationInterface, QueryRunner, Table, TableIndex } from "typeorm";

export class CreateDocumentRequirementTable1769427320000 implements MigrationInterface {
    name = 'CreateDocumentRequirementTable1769427320000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Create enum types (PostgreSQL-specific, using raw SQL)
        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'document_requirement_businesstype_enum') THEN 
                    CREATE TYPE "public"."document_requirement_businesstype_enum" AS ENUM(
                        'MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS', 
                        'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY', 
                        'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY'
                    ); 
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'document_requirement_documenttype_enum') THEN 
                    CREATE TYPE "public"."document_requirement_documenttype_enum" AS ENUM(
                        'BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 
                        'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 
                        'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 
                        'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE'
                    ); 
                END IF; 
            END $$
        `);

        // 2. Create document_requirement table with IF NOT EXISTS
        await queryRunner.createTable(new Table({
            name: "document_requirement",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "businessType", type: "public.document_requirement_businesstype_enum", isNullable: false },
                { name: "documentType", type: "public.document_requirement_documenttype_enum", isNullable: false },
                { name: "isRequired", type: "boolean", default: true, isNullable: false },
                { name: "description", type: "text", isNullable: true },
                { name: "displayOrder", type: "integer", default: 0, isNullable: false }
            ]
        }), true); // true = IF NOT EXISTS

        // 3. Add index on businessType for faster lookups
        await queryRunner.createIndex("document_requirement", new TableIndex({
            name: "IDX_DOC_REQ_BUSINESS_TYPE",
            columnNames: ["businessType"]
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order: Index -> Table -> Enums
        await queryRunner.query("DROP INDEX IF EXISTS document_requirement_idx_business_type");
        await queryRunner.dropTable("document_requirement", true); // true = IF EXISTS
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_documenttype_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."document_requirement_businesstype_enum"`);
    }
}
