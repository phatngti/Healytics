import { MigrationInterface, QueryRunner, TableForeignKey, TableIndex } from "typeorm";

export class RenamePartnerTablesAndFixColumnNames1769427350000 implements MigrationInterface {
    name = 'RenamePartnerTablesAndFixColumnNames1769427350000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop foreign keys before renaming tables
        // =====================
        
        // FK from legal_representative to health_partner_profile
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "legal_representative" 
            DROP CONSTRAINT IF EXISTS "FK_LEGAL_REP_PARTNER_ID"
        `);

        // FK from partner_document to health_partner_profile
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "partner_document" 
            DROP CONSTRAINT IF EXISTS "FK_partner_document_partner_id"
        `);

        // FK from partner_review_log to health_partner_profile and account
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "partner_review_log" 
            DROP CONSTRAINT IF EXISTS "FK_REVIEW_LOG_PARTNER_ID"
        `);
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "partner_review_log" 
            DROP CONSTRAINT IF EXISTS "FK_REVIEW_LOG_REVIEWER_ID"
        `);

        // FK from location (self-referential)
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "location" 
            DROP CONSTRAINT IF EXISTS "FK_LOCATION_PARENT_ID"
        `);

        // =====================
        // 2. Drop indexes before renaming (to avoid naming conflicts)
        // =====================
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_LEGAL_REP_PARTNER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_partner_document_partner_id"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_REVIEW_LOG_PARTNER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_REVIEW_LOG_REVIEWER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_DOC_REQ_BUSINESS_TYPE"`);

        // =====================
        // 3. Rename tables (using raw SQL to avoid automatic enum renaming which can cause conflicts)
        // =====================
        // Check if legal_representative still exists before renaming (handles partial migration state)
        const legalRepExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'legal_representative'
            )
        `);
        if (legalRepExists[0].exists) {
            await queryRunner.query(`ALTER TABLE "legal_representative" RENAME TO "health_partner_legal_representative"`);
        }

        const partnerDocExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'partner_document'
            )
        `);
        if (partnerDocExists[0].exists) {
            await queryRunner.query(`ALTER TABLE "partner_document" RENAME TO "health_partner_document"`);
        }

        const reviewLogExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'partner_review_log'
            )
        `);
        if (reviewLogExists[0].exists) {
            await queryRunner.query(`ALTER TABLE "partner_review_log" RENAME TO "health_partner_review_log"`);
        }

        const docReqExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'document_requirement'
            )
        `);
        if (docReqExists[0].exists) {
            await queryRunner.query(`ALTER TABLE "document_requirement" RENAME TO "health_partner_document_requirement"`);
        }

        // Rename enum types only if they haven't been renamed yet
        await queryRunner.query(`
            DO $$ BEGIN 
                IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'legal_representative_id_type_enum') 
                   AND NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_legal_representative_id_type_enum') THEN 
                    ALTER TYPE "public"."legal_representative_id_type_enum" RENAME TO "health_partner_legal_representative_id_type_enum";
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'partner_review_log_verdict_enum') 
                   AND NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_review_log_verdict_enum') THEN 
                    ALTER TYPE "public"."partner_review_log_verdict_enum" RENAME TO "health_partner_review_log_verdict_enum";
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'document_requirement_businesstype_enum') 
                   AND NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_document_requirement_businesstype_enum') THEN 
                    ALTER TYPE "public"."document_requirement_businesstype_enum" RENAME TO "health_partner_document_requirement_businesstype_enum";
                END IF; 
            END $$
        `);

        await queryRunner.query(`
            DO $$ BEGIN 
                IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'document_requirement_documenttype_enum') 
                   AND NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'health_partner_document_requirement_documenttype_enum') THEN 
                    ALTER TYPE "public"."document_requirement_documenttype_enum" RENAME TO "health_partner_document_requirement_documenttype_enum";
                END IF; 
            END $$
        `);

        // =====================
        // 4. Remove rejectionDetails column from health_partner_profile
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_profile" 
            DROP COLUMN IF EXISTS "rejectionDetails"
        `);

        // =====================
        // 5. Rename parentId -> parent_id in location table
        // =====================
        await queryRunner.query(`
            ALTER TABLE "location" 
            RENAME COLUMN "parentId" TO "parent_id"
        `);

        // =====================
        // 6. Rename columns in health_partner_review_log (camelCase -> snake_case)
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "fieldReviews" TO "field_reviews"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "documentReviews" TO "document_reviews"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "generalComment" TO "general_comment"
        `);

        // =====================
        // 7. Rename columns in health_partner_document_requirement (camelCase -> snake_case)
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "businessType" TO "business_type"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "documentType" TO "document_type"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "isRequired" TO "is_required"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "displayOrder" TO "display_order"
        `);

        // =====================
        // 8. Recreate indexes with new table names
        // =====================
        await queryRunner.createIndex("health_partner_legal_representative", new TableIndex({
            name: "IDX_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("health_partner_document", new TableIndex({
            name: "IDX_PARTNER_DOC_PARTNER_ID",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("health_partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("health_partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_REVIEWER_ID",
            columnNames: ["reviewer_id"]
        }));
        await queryRunner.createIndex("health_partner_document_requirement", new TableIndex({
            name: "IDX_DOC_REQ_BUSINESS_TYPE",
            columnNames: ["business_type"]
        }));

        // =====================
        // 9. Recreate foreign keys with new table names
        // =====================
        await queryRunner.createForeignKey("health_partner_legal_representative", new TableForeignKey({
            name: "FK_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));

        await queryRunner.createForeignKey("health_partner_document", new TableForeignKey({
            name: "FK_PARTNER_DOC_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "CASCADE"
        }));

        await queryRunner.createForeignKey("health_partner_review_log", new TableForeignKey({
            name: "FK_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "CASCADE",
            onUpdate: "NO ACTION"
        }));
        await queryRunner.createForeignKey("health_partner_review_log", new TableForeignKey({
            name: "FK_REVIEW_LOG_REVIEWER_ID",
            columnNames: ["reviewer_id"],
            referencedTableName: "account",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));

        await queryRunner.createForeignKey("location", new TableForeignKey({
            name: "FK_LOCATION_PARENT_ID",
            columnNames: ["parent_id"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop foreign keys
        // =====================
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "location" 
            DROP CONSTRAINT IF EXISTS "FK_LOCATION_PARENT_ID"
        `);
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "health_partner_review_log" 
            DROP CONSTRAINT IF EXISTS "FK_REVIEW_LOG_REVIEWER_ID"
        `);
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "health_partner_review_log" 
            DROP CONSTRAINT IF EXISTS "FK_REVIEW_LOG_PARTNER_ID"
        `);
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "health_partner_document" 
            DROP CONSTRAINT IF EXISTS "FK_PARTNER_DOC_PARTNER_ID"
        `);
        await queryRunner.query(`
            ALTER TABLE IF EXISTS "health_partner_legal_representative" 
            DROP CONSTRAINT IF EXISTS "FK_LEGAL_REP_PARTNER_ID"
        `);

        // =====================
        // 2. Drop indexes
        // =====================
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_DOC_REQ_BUSINESS_TYPE"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_REVIEW_LOG_REVIEWER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_REVIEW_LOG_PARTNER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_PARTNER_DOC_PARTNER_ID"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_LEGAL_REP_PARTNER_ID"`);

        // =====================
        // 3. Revert column renames in health_partner_document_requirement (snake_case -> camelCase)
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "display_order" TO "displayOrder"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "is_required" TO "isRequired"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "document_type" TO "documentType"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_document_requirement" 
            RENAME COLUMN "business_type" TO "businessType"
        `);

        // =====================
        // 4. Revert column renames in health_partner_review_log (snake_case -> camelCase)
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "general_comment" TO "generalComment"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "document_reviews" TO "documentReviews"
        `);
        await queryRunner.query(`
            ALTER TABLE "health_partner_review_log" 
            RENAME COLUMN "field_reviews" TO "fieldReviews"
        `);

        // =====================
        // 5. Revert parent_id -> parentId in location table
        // =====================
        await queryRunner.query(`
            ALTER TABLE "location" 
            RENAME COLUMN "parent_id" TO "parentId"
        `);

        // =====================
        // 6. Restore rejectionDetails column in health_partner_profile
        // =====================
        await queryRunner.query(`
            ALTER TABLE "health_partner_profile" 
            ADD COLUMN "rejectionDetails" jsonb
        `);

        // =====================
        // 7. Rename tables back to original names
        // =====================
        await queryRunner.renameTable("health_partner_document_requirement", "document_requirement");
        await queryRunner.renameTable("health_partner_review_log", "partner_review_log");
        await queryRunner.renameTable("health_partner_document", "partner_document");
        await queryRunner.renameTable("health_partner_legal_representative", "legal_representative");

        // =====================
        // 8. Recreate indexes with original names
        // =====================
        await queryRunner.createIndex("document_requirement", new TableIndex({
            name: "IDX_DOC_REQ_BUSINESS_TYPE",
            columnNames: ["businessType"]
        }));
        await queryRunner.createIndex("partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_REVIEWER_ID",
            columnNames: ["reviewer_id"]
        }));
        await queryRunner.createIndex("partner_review_log", new TableIndex({
            name: "IDX_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("partner_document", new TableIndex({
            name: "IDX_partner_document_partner_id",
            columnNames: ["partner_id"]
        }));
        await queryRunner.createIndex("legal_representative", new TableIndex({
            name: "IDX_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"]
        }));

        // =====================
        // 9. Recreate foreign keys with original names
        // =====================
        await queryRunner.createForeignKey("location", new TableForeignKey({
            name: "FK_LOCATION_PARENT_ID",
            columnNames: ["parentId"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
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
        await queryRunner.createForeignKey("partner_review_log", new TableForeignKey({
            name: "FK_REVIEW_LOG_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "CASCADE",
            onUpdate: "NO ACTION"
        }));

        await queryRunner.createForeignKey("partner_document", new TableForeignKey({
            columnNames: ["partner_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "health_partner_profile",
            onDelete: "CASCADE"
        }));

        await queryRunner.createForeignKey("legal_representative", new TableForeignKey({
            name: "FK_LEGAL_REP_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedTableName: "health_partner_profile",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));
    }
}
