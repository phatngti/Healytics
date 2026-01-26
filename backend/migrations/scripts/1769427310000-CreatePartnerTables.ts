import { MigrationInterface, QueryRunner } from "typeorm";

export class CreatePartnerTables1769427310000 implements MigrationInterface {
    name = 'CreatePartnerTables1769427310000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create enums
        await queryRunner.query(`CREATE TYPE "public"."health_partner_profile_business_type_enum" AS ENUM('MASSAGE_THERAPY', 'MASSAGE_REHABILITATION', 'SPA_BEAUTY', 'FITNESS', 'PHARMACY', 'DENTAL', 'TRADITIONAL_MEDICINE', 'PSYCHOLOGY', 'DERMATOLOGY', 'NUTRITION', 'PSYCHIATRY')`);
        await queryRunner.query(`CREATE TYPE "public"."health_partner_profile_verification_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED')`);
        await queryRunner.query(`CREATE TYPE "public"."partner_document_documenttype_enum" AS ENUM('BUSINESS_LICENSE', 'IDENTITY_FRONT', 'IDENTITY_BACK', 'AUTHORIZATION_LETTER', 'ANTT', 'KCB_LICENSE', 'GCN_FITNESS', 'GPP', 'RHM_LICENSE', 'MEDICAL_WASTE_CONTRACT', 'YHCT_LICENSE', 'PSYCHOLOGY_LICENSE', 'DERMATOLOGY_LICENSE', 'TECHNICAL_PORTFOLIO', 'NUTRITION_LICENSE', 'PSYCHIATRY_LICENSE')`);
        await queryRunner.query(`CREATE TYPE "public"."partner_review_log_verdict_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED')`);
        await queryRunner.query(`CREATE TYPE "public"."legal_representative_id_type_enum" AS ENUM('CITIZEN_ID', 'PASSPORT', 'MILITARY_ID')`);

        // Create health_partner_profile table
        await queryRunner.query(`CREATE TABLE "health_partner_profile" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "tax_code" character varying(20) NOT NULL, "legal_name" character varying(200) NOT NULL, "brand_name" character varying(150) NOT NULL, "business_type" "public"."health_partner_profile_business_type_enum" NOT NULL, "province_id" uuid, "district_id" uuid, "ward_id" uuid, "street_address" character varying(300) NOT NULL, "phone_number" character varying(20), "account_id" uuid NOT NULL, "verification_status" "public"."health_partner_profile_verification_status_enum" NOT NULL DEFAULT 'PENDING', "rejectionDetails" jsonb, "verification_completed_at" TIMESTAMP WITH TIME ZONE, "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP WITH TIME ZONE, CONSTRAINT "UQ_PARTNER_TAX_CODE" UNIQUE ("tax_code"), CONSTRAINT "UQ_PARTNER_ACCOUNT_ID" UNIQUE ("account_id"), CONSTRAINT "PK_PARTNER" PRIMARY KEY ("id"))`);

        // Create partner_document table
        await queryRunner.query(`CREATE TABLE "partner_document" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "partner_id" uuid NOT NULL, "documentType" "public"."partner_document_documenttype_enum" NOT NULL, "document_url" text, "document_key" text, "is_reviewed" boolean NOT NULL DEFAULT false, "is_valid" boolean NOT NULL DEFAULT true, "verification_notes" text, "admin_feedback" text, "verified_by" uuid, "uploaded_at" TIMESTAMP NOT NULL DEFAULT now(), "updated_at" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_PARTNER_DOCUMENT" PRIMARY KEY ("id"))`);

        // Create partner_review_log table
        await queryRunner.query(`CREATE TABLE "partner_review_log" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "partner_id" uuid NOT NULL, "verdict" "public"."partner_review_log_verdict_enum" NOT NULL, "fieldReviews" jsonb, "documentReviews" jsonb, "reviewer_id" uuid, "generalComment" text, "created_at" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_PARTNER_REVIEW_LOG" PRIMARY KEY ("id")); COMMENT ON COLUMN "partner_review_log"."verdict" IS 'Kết quả của đợt review này (VD: REJECTED hoặc APPROVED)'`);

        // Create legal_representative table
        await queryRunner.query(`CREATE TABLE "legal_representative" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "full_name" character varying(150) NOT NULL, "position" character varying(100) NOT NULL, "id_type" "public"."legal_representative_id_type_enum" NOT NULL, "id_number" character varying(20) NOT NULL, "id_issue_date" date NOT NULL, "id_front_img_url" text NOT NULL, "id_back_img_url" text NOT NULL, "is_authorized_user" boolean NOT NULL DEFAULT false, "auth_letter_doc_url" text, "phone_number" character varying(20), "partner_id" uuid NOT NULL, "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(), "deleted_at" TIMESTAMP WITH TIME ZONE, CONSTRAINT "UQ_LEGAL_REP_PARTNER_ID" UNIQUE ("partner_id"), CONSTRAINT "PK_LEGAL_REPRESENTATIVE" PRIMARY KEY ("id"))`);

        // Add foreign key constraints
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_PARTNER_PROVINCE_ID" FOREIGN KEY ("province_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_PARTNER_DISTRICT_ID" FOREIGN KEY ("district_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_PARTNER_WARD_ID" FOREIGN KEY ("ward_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_PARTNER_ACCOUNT_ID" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "partner_document" ADD CONSTRAINT "FK_PARTNER_DOC_PARTNER_ID" FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "partner_review_log" ADD CONSTRAINT "FK_REVIEW_LOG_PARTNER_ID" FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "partner_review_log" ADD CONSTRAINT "FK_REVIEW_LOG_REVIEWER_ID" FOREIGN KEY ("reviewer_id") REFERENCES "account"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "legal_representative" ADD CONSTRAINT "FK_LEGAL_REP_PARTNER_ID" FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop foreign key constraints
        await queryRunner.query(`ALTER TABLE "legal_representative" DROP CONSTRAINT "FK_LEGAL_REP_PARTNER_ID"`);
        await queryRunner.query(`ALTER TABLE "partner_review_log" DROP CONSTRAINT "FK_REVIEW_LOG_REVIEWER_ID"`);
        await queryRunner.query(`ALTER TABLE "partner_review_log" DROP CONSTRAINT "FK_REVIEW_LOG_PARTNER_ID"`);
        await queryRunner.query(`ALTER TABLE "partner_document" DROP CONSTRAINT "FK_PARTNER_DOC_PARTNER_ID"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_PARTNER_ACCOUNT_ID"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_PARTNER_WARD_ID"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_PARTNER_DISTRICT_ID"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_PARTNER_PROVINCE_ID"`);

        // Drop tables
        await queryRunner.query(`DROP TABLE "legal_representative"`);
        await queryRunner.query(`DROP TABLE "partner_review_log"`);
        await queryRunner.query(`DROP TABLE "partner_document"`);
        await queryRunner.query(`DROP TABLE "health_partner_profile"`);

        // Drop enums
        await queryRunner.query(`DROP TYPE "public"."legal_representative_id_type_enum"`);
        await queryRunner.query(`DROP TYPE "public"."partner_review_log_verdict_enum"`);
        await queryRunner.query(`DROP TYPE "public"."partner_document_documenttype_enum"`);
        await queryRunner.query(`DROP TYPE "public"."health_partner_profile_verification_status_enum"`);
        await queryRunner.query(`DROP TYPE "public"."health_partner_profile_business_type_enum"`);
    }
}
