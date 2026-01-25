import { MigrationInterface, QueryRunner } from "typeorm";

export class CreatePartnerDocumentTable1768794000000 implements MigrationInterface {
    name = 'CreatePartnerDocumentTable1768794000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create the document type enum (original types before later migration updates)
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."partner_document_documenttype_enum" AS ENUM(
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

        // Create the status enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."partner_document_status_enum" AS ENUM('PENDING', 'APPROVED', 'REJECTED');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create the partner_document table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "partner_document" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "partner_id" uuid NOT NULL,
                "documentType" "public"."partner_document_documenttype_enum" NOT NULL,
                "document_key" character varying NOT NULL,
                "status" "public"."partner_document_status_enum" NOT NULL DEFAULT 'PENDING',
                "verification_notes" text,
                "admin_feedback" text,
                "verified_by" uuid,
                "uploaded_at" TIMESTAMP NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP NOT NULL DEFAULT now(),
                CONSTRAINT "PK_partner_document" PRIMARY KEY ("id")
            )
        `);

        // Add foreign key constraint to health_partner_profile
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "partner_document" 
                ADD CONSTRAINT "FK_partner_document_partner" 
                FOREIGN KEY ("partner_id") 
                REFERENCES "health_partner_profile"("id") 
                ON DELETE CASCADE ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "partner_document" DROP CONSTRAINT IF EXISTS "FK_partner_document_partner"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "partner_document"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_status_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."partner_document_documenttype_enum"`);
    }
}
