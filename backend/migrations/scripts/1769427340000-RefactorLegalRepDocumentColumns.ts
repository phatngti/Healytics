import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class RefactorLegalRepDocumentColumns1769427340000 implements MigrationInterface {
    name = 'RefactorLegalRepDocumentColumns1769427340000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop old columns
        // =====================
        await queryRunner.dropColumn("legal_representative", "is_authorized_user");
        await queryRunner.dropColumn("legal_representative", "auth_letter_doc_url");

        // =====================
        // 2. Add new document columns
        // =====================
        await queryRunner.addColumns("legal_representative", [
            new TableColumn({
                name: "business_license_url",
                type: "text",
                isNullable: true,
            }),
            new TableColumn({
                name: "authorization_letter_url",
                type: "text",
                isNullable: true,
            }),
            new TableColumn({
                name: "tax_certificate_url",
                type: "text",
                isNullable: true,
            }),
            new TableColumn({
                name: "other_document_urls",
                type: "text",
                isNullable: true,
                comment: "Comma-separated list of other document URLs (simple-array)",
            }),
        ]);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // =====================
        // 1. Drop new document columns
        // =====================
        await queryRunner.dropColumn("legal_representative", "other_document_urls");
        await queryRunner.dropColumn("legal_representative", "tax_certificate_url");
        await queryRunner.dropColumn("legal_representative", "authorization_letter_url");
        await queryRunner.dropColumn("legal_representative", "business_license_url");

        // =====================
        // 2. Restore old columns
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
