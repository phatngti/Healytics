import { MigrationInterface, QueryRunner, Table, TableIndex, TableForeignKey, TableUnique } from "typeorm";

export class CreatePartnerTables1769427310000 implements MigrationInterface {
    name = 'CreatePartnerTables1769427310000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Create all enum types (PostgreSQL-specific, using raw SQL)
        // =====================
        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_profile_business_type_enum') THEN 
                    CREATE TYPE "public"."health_partner_profile_business_type_enum" AS ENUM(
                        'MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS', 
                        'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY', 
                        'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY'
                    ); 
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_profile_verification_status_enum') THEN 
                    CREATE TYPE "public"."health_partner_profile_verification_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED'); 
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'partner_document_documenttype_enum') THEN 
                    CREATE TYPE "public"."partner_document_documenttype_enum" AS ENUM(
                        'BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 
                        'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 
                        'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 
                        'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE'
                    ); 
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'partner_review_log_verdict_enum') THEN 
                    CREATE TYPE "public"."partner_review_log_verdict_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED'); 
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'legal_representative_id_type_enum') THEN 
                    CREATE TYPE "public"."legal_representative_id_type_enum" AS ENUM('CITIZEN_ID', 'PASSPORT', 'MILITARY_ID'); 
                END IF; 
            END $$
        `);

        // =====================
        // 2. Create health_partner_profile table
        // =====================
        await queryRunner.createTable(new Table({
            name: "health_partner_profile",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "tax_code", type: "varchar", length: "20", isNullable: false },
                { name: "legal_name", type: "varchar", length: "200", isNullable: false },
                { name: "brand_name", type: "varchar", length: "150", isNullable: false },
                { name: "business_type", type: "public.health_partner_profile_business_type_enum", isNullable: false },
                { name: "province_id", type: "uuid", isNullable: true },
                { name: "district_id", type: "uuid", isNullable: true },
                { name: "ward_id", type: "uuid", isNullable: true },
                { name: "street_address", type: "varchar", length: "300", isNullable: false },
                { name: "phone_number", type: "varchar", length: "20", isNullable: true },
                { name: "account_id", type: "uuid", isNullable: false },
                { name: "verification_status", type: "public.health_partner_profile_verification_status_enum", isNullable: false, default: "'PENDING'" },
                { name: "rejectionDetails", type: "jsonb", isNullable: true },
                { name: "verification_completed_at", type: "timestamptz", isNullable: true },
                { name: "created_at", type: "timestamptz", default: "now()", isNullable: false },
                { name: "updated_at", type: "timestamptz", default: "now()", isNullable: false },
                { name: "deleted_at", type: "timestamptz", isNullable: true }
            ],
            uniques: [
                { name: "UQ_PARTNER_TAX_CODE", columnNames: ["tax_code"] },
                { name: "UQ_PARTNER_ACCOUNT_ID", columnNames: ["account_id"] }
            ]
        }), true);

        // Add indexes for FK columns (REQUIRED for performance)
        await queryRunner.createIndex("health_partner_profile", new TableIndex({
            name: "IDX_PARTNER_PROVINCE_ID",
            columnNames: ["province_id"]
        }));
        await queryRunner.createIndex("health_partner_profile", new TableIndex({
            name: "IDX_PARTNER_DISTRICT_ID",
            columnNames: ["district_id"]
        }));
        await queryRunner.createIndex("health_partner_profile", new TableIndex({
            name: "IDX_PARTNER_WARD_ID",
            columnNames: ["ward_id"]
        }));
        await queryRunner.createIndex("health_partner_profile", new TableIndex({
            name: "IDX_PARTNER_ACCOUNT_ID",
            columnNames: ["account_id"]
        }));

        // =====================
        // 3. Create partner_document table
        // =====================
        await queryRunner.createTable(new Table({
            name: "partner_document",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "partner_id", type: "uuid", isNullable: false },
                { name: "documentType", type: "public.partner_document_documenttype_enum", isNullable: false },
                { name: "document_url", type: "text", isNullable: true },
                { name: "document_key", type: "text", isNullable: true },
                { name: "is_reviewed", type: "boolean", default: false, isNullable: false },
                { name: "is_valid", type: "boolean", default: true, isNullable: false },
                { name: "verification_notes", type: "text", isNullable: true },
                { name: "admin_feedback", type: "text", isNullable: true },
                { name: "verified_by", type: "uuid", isNullable: true },
                { name: "uploaded_at", type: "timestamp", default: "now()", isNullable: false },
                { name: "updated_at", type: "timestamp", default: "now()", isNullable: false }
            ]
        }), true);

        // Add index for FK column
        await queryRunner.createIndex("partner_document", new TableIndex({
            name: "IDX_PARTNER_DOC_PARTNER_ID",
            columnNames: ["partner_id"]
        }));

        // =====================
        // 4. Create partner_review_log table
        // =====================
        await queryRunner.createTable(new Table({
            name: "partner_review_log",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "partner_id", type: "uuid", isNullable: false },
                { name: "verdict", type: "public.partner_review_log_verdict_enum", isNullable: false, comment: "Kết quả của đợt review này (VD: REJECTED hoặc APPROVED)" },
                { name: "fieldReviews", type: "jsonb", isNullable: true },
                { name: "documentReviews", type: "jsonb", isNullable: true },
                { name: "reviewer_id", type: "uuid", isNullable: true },
                { name: "generalComment", type: "text", isNullable: true },
                { name: "created_at", type: "timestamp", default: "now()", isNullable: false }
            ]
        }), true);

        // Add indexes for FK columns
        await queryRunner.createIndex("partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_REVIEWER_ID",
            columnNames: ["reviewer_id"]
        }));

        // =====================
        // 5. Create legal_representative table
        // =====================
        await queryRunner.createTable(new Table({
            name: "legal_representative",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "full_name", type: "varchar", length: "150", isNullable: false },
                { name: "position", type: "varchar", length: "100", isNullable: false },
                { name: "id_type", type: "public.legal_representative_id_type_enum", isNullable: false },
                { name: "id_number", type: "varchar", length: "20", isNullable: false },
                { name: "id_issue_date", type: "date", isNullable: false },
                { name: "id_front_img_url", type: "text", isNullable: false },
                { name: "id_back_img_url", type: "text", isNullable: false },
                { name: "is_authorized_user", type: "boolean", default: false, isNullable: false },
                { name: "auth_letter_doc_url", type: "text", isNullable: true },
                { name: "phone_number", type: "varchar", length: "20", isNullable: true },
                { name: "partner_id", type: "uuid", isNullable: false },
                { name: "created_at", type: "timestamptz", default: "now()", isNullable: false },
                { name: "updated_at", type: "timestamptz", default: "now()", isNullable: false },
                { name: "deleted_at", type: "timestamptz", isNullable: true }
            ],
            uniques: [
                { name: "UQ_LEGAL_REP_PARTNER_ID", columnNames: ["partner_id"] }
            ]
        }), true);

        // Add index for FK column
        await queryRunner.createIndex("legal_representative", new TableIndex({
            name: "IDX_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"]
        }));

        // =====================
        // 6. Create all foreign key constraints
        // =====================
        // health_partner_profile FKs
        await queryRunner.createForeignKey("health_partner_profile", new TableForeignKey({
            name: "FK_PARTNER_PROVINCE_ID",
            columnNames: ["province_id"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "SET NULL",
            onUpdate: "NO ACTION"
        }));
        await queryRunner.createForeignKey("health_partner_profile", new TableForeignKey({
            name: "FK_PARTNER_DISTRICT_ID",
            columnNames: ["district_id"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "SET NULL",
            onUpdate: "NO ACTION"
        }));
        await queryRunner.createForeignKey("health_partner_profile", new TableForeignKey({
            name: "FK_PARTNER_WARD_ID",
            columnNames: ["ward_id"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "SET NULL",
            onUpdate: "NO ACTION"
        }));
        await queryRunner.createForeignKey("health_partner_profile", new TableForeignKey({
            name: "FK_PARTNER_ACCOUNT_ID",
            columnNames: ["account_id"],
            referencedTableName: "account",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));

        // partner_document FKs
        await queryRunner.createForeignKey("partner_document", new TableForeignKey({
            name: "FK_PARTNER_DOC_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "CASCADE",
            onUpdate: "NO ACTION"
        }));

        // partner_review_log FKs
        await queryRunner.createForeignKey("partner_review_log", new TableForeignKey({
            name: "FK_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "CASCADE",
            onUpdate: "NO ACTION"
        }));
        await queryRunner.createForeignKey("partner_review_log", new TableForeignKey({
            name: "FK_REVIEW_LOG_REVIEWER_ID",
            columnNames: ["reviewer_id"],
            referencedTableName: "account",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));

        // legal_representative FKs
        await queryRunner.createForeignKey("legal_representative", new TableForeignKey({
            name: "FK_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // Drop in reverse order: FKs -> Indexes -> Tables -> Enums
        // =====================

        // 1. Drop foreign keys
        await queryRunner.dropForeignKey("legal_representative", "FK_LEGAL_REP_PARTNER_ID");
        await queryRunner.dropForeignKey("partner_review_log", "FK_REVIEW_LOG_REVIEWER_ID");
        await queryRunner.dropForeignKey("partner_review_log", "FK_REVIEW_LOG_PARTNER_ID");
        await queryRunner.dropForeignKey("partner_document", "FK_PARTNER_DOC_PARTNER_ID");
        await queryRunner.dropForeignKey("health_partner_profile", "FK_PARTNER_ACCOUNT_ID");
        await queryRunner.dropForeignKey("health_partner_profile", "FK_PARTNER_WARD_ID");
        await queryRunner.dropForeignKey("health_partner_profile", "FK_PARTNER_DISTRICT_ID");
        await queryRunner.dropForeignKey("health_partner_profile", "FK_PARTNER_PROVINCE_ID");

        // 2. Drop indexes
        await queryRunner.dropIndex("legal_representative", "IDX_LEGAL_REP_PARTNER_ID");
        await queryRunner.dropIndex("partner_review_log", "IDX_REVIEW_LOG_REVIEWER_ID");
        await queryRunner.dropIndex("partner_review_log", "IDX_REVIEW_LOG_PARTNER_ID");
        await queryRunner.dropIndex("partner_document", "IDX_PARTNER_DOC_PARTNER_ID");
        await queryRunner.dropIndex("health_partner_profile", "IDX_PARTNER_ACCOUNT_ID");
        await queryRunner.dropIndex("health_partner_profile", "IDX_PARTNER_WARD_ID");
        await queryRunner.dropIndex("health_partner_profile", "IDX_PARTNER_DISTRICT_ID");
        await queryRunner.dropIndex("health_partner_profile", "IDX_PARTNER_PROVINCE_ID");

        // 3. Drop tables
        await queryRunner.dropTable("legal_representative", true);
        await queryRunner.dropTable("partner_review_log", true);
        await queryRunner.dropTable("partner_document", true);
        await queryRunner.dropTable("health_partner_profile", true);

        // 4. Drop enums
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."legal_representative_id_type_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_review_log_verdict_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_documenttype_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_verification_status_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_business_type_enum"`);
    }
}
