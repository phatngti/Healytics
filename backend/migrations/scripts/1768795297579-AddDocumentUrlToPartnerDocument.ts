import { MigrationInterface, QueryRunner } from "typeorm";

export class AddDocumentUrlToPartnerDocument1768795297579 implements MigrationInterface {
    name = 'AddDocumentUrlToPartnerDocument1768795297579'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Add document_url as nullable text column
        await queryRunner.query(`ALTER TABLE "partner_document" ADD "document_url" text`);

        // 2. Map existing document_key to document_url for the existing data
        await queryRunner.query(`UPDATE "partner_document" SET "document_url" = "document_key" WHERE "document_url" IS NULL`);

        // 3. Set document_url to NOT NULL after populating the data
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_url" SET NOT NULL`);

        // 4. Update document_key to be nullable text column
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" TYPE text`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Reverse the changes: Make document_key NOT NULL again, and drop document_url
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" TYPE character varying`);
        await queryRunner.query(`ALTER TABLE "partner_document" SET "document_key" = "document_url" WHERE "document_key" IS NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN "document_url"`);
    }
}
