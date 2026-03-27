import { MigrationInterface, QueryRunner, Table, TableColumn, TableForeignKey, TableIndex } from "typeorm";

export class RefactorLegalRepDocumentColumns1769427340000 implements MigrationInterface {
    name = 'RefactorLegalRepDocumentColumns1769427340000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop old columns from legal_representative (cleanup)
        // =====================
        await queryRunner.dropColumn("legal_representative", "is_authorized_user");
        await queryRunner.dropColumn("legal_representative", "auth_letter_doc_url");
        await queryRunner.dropColumn("legal_representative", "id_front_img_url");
        await queryRunner.dropColumn("legal_representative", "id_back_img_url");

        // =====================
        // 2. Recreate partner_document table with simplified schema
        //    Using TEXT instead of enums for flexibility
        // =====================
        
        // First, drop existing partner_document table if exists
        await queryRunner.dropTable("partner_document", true);

        // Create new simplified partner_document table
        await queryRunner.createTable(
            new Table({
                name: "partner_document",
                columns: [
                    {
                        name: "id",
                        type: "uuid",
                        isPrimary: true,
                        generationStrategy: "uuid",
                        default: "uuid_generate_v4()",
                    },
                    {
                        name: "partner_id",
                        type: "uuid",
                        isNullable: false,
                    },
                    {
                        name: "document_key",
                        type: "text",
                        isNullable: true,
                        comment: "Storage key (R2/S3 path)",
                    },
                    {
                        name: "file_url",
                        type: "text",
                        isNullable: true,
                        comment: "Public URL to access the document",
                    },
                    {
                        name: "type",
                        type: "text",
                        isNullable: false,
                        comment: "Document category: IDENTITY_FRONT, BUSINESS_LICENSE, etc.",
                    },
                    {
                        name: "file_type",
                        type: "text",
                        isNullable: false,
                        default: "'image'",
                        comment: "File type: image, pdf, txt, doc, other",
                    },
                    {
                        name: "status",
                        type: "text",
                        isNullable: false,
                        default: "'pending'",
                        comment: "Document status: pending, accepted, rejected",
                    },
                    {
                        name: "created_at",
                        type: "timestamptz",
                        default: "now()",
                    },
                    {
                        name: "updated_at",
                        type: "timestamptz",
                        default: "now()",
                    },
                    {
                        name: "deleted_at",
                        type: "timestamptz",
                        isNullable: true,
                    },
                ],
            }),
            true, // ifNotExists
        );

        // Add foreign key to partner table
        await queryRunner.createForeignKey(
            "partner_document",
            new TableForeignKey({
                columnNames: ["partner_id"],
                referencedColumnNames: ["id"],
                referencedTableName: "health_partner_profile",
                onDelete: "CASCADE",
            }),
        );

        // Add index on partner_id for faster lookups
        await queryRunner.createIndex(
            "partner_document",
            new TableIndex({
                name: "IDX_partner_document_partner_id",
                columnNames: ["partner_id"],
            }),
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop new partner_document table and recreate the original one
        //    (Required so CreatePartnerTables.down can drop its FK)
        // =====================
        await queryRunner.dropTable("partner_document", true);

        // Recreate original partner_document table from CreatePartnerTables migration
        await queryRunner.createTable(
            new Table({
                name: "partner_document",
                columns: [
                    { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                    { name: "partner_id", type: "uuid", isNullable: false },
                    { name: "documentType", type: "public.partner_document_documenttype_enum", isNullable: false },
                    { name: "document_url", type: "text", isNullable: true },
                    { name: "document_key", type: "text", isNullable: true },
                    { name: "is_reviewed", type: "boolean", default: "false", isNullable: false },
                    { name: "is_valid", type: "boolean", default: "true", isNullable: false },
                    { name: "verification_notes", type: "text", isNullable: true },
                    { name: "admin_feedback", type: "text", isNullable: true },
                    { name: "verified_by", type: "uuid", isNullable: true },
                    { name: "uploaded_at", type: "timestamp", default: "now()", isNullable: false },
                    { name: "updated_at", type: "timestamp", default: "now()", isNullable: false },
                ],
            }),
            true,
        );

        // Recreate index for FK column
        await queryRunner.createIndex(
            "partner_document",
            new TableIndex({
                name: "IDX_PARTNER_DOC_PARTNER_ID",
                columnNames: ["partner_id"],
            }),
        );

        // Recreate foreign key to partner table
        await queryRunner.createForeignKey(
            "partner_document",
            new TableForeignKey({
                name: "FK_PARTNER_DOC_PARTNER_ID",
                columnNames: ["partner_id"],
                referencedColumnNames: ["id"],
                referencedTableName: "health_partner_profile",
                onDelete: "CASCADE",
                onUpdate: "NO ACTION",
            }),
        );

        // =====================
        // 2. Restore old legal_representative columns
        // =====================
        await queryRunner.addColumns("legal_representative", [
            new TableColumn({
                name: "is_authorized_user",
                type: "boolean",
                default: false,
                isNullable: false,
            }),
            new TableColumn({
                name: "auth_letter_doc_url",
                type: "text",
                isNullable: true,
            }),
        ]);
    }
}
