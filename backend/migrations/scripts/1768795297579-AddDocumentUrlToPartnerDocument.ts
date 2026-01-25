import { MigrationInterface, QueryRunner } from "typeorm";

export class AddDocumentUrlToPartnerDocument1768795297579 implements MigrationInterface {
    name = 'AddDocumentUrlToPartnerDocument1768795297579'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "partner_document" ADD "document_url" text`);
        await queryRunner.query(`UPDATE "partner_document" SET "document_url" = "document_key" WHERE "document_url" IS NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_url" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" TYPE text`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" TYPE character varying`);
        await queryRunner.query(`ALTER TABLE "partner_document" SET "document_key" = "document_url" WHERE "document_key" IS NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_key" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "partner_document" DROP COLUMN "document_url"`);
    }
}
