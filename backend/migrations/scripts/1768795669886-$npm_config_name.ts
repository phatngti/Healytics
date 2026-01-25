import { MigrationInterface, QueryRunner } from "typeorm";

export class  $npmConfigName1768795669886 implements MigrationInterface {
    name = ' $npmConfigName1768795669886'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_url" DROP NOT NULL`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "partner_document" ALTER COLUMN "document_url" SET NOT NULL`);
    }

}
