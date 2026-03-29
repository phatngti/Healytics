import { MigrationInterface, QueryRunner } from "typeorm";

export class AddServiceManualToProducts1773592155767 implements MigrationInterface {
    name = 'AddServiceManualToProducts1773592155767'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "products" ADD "service_manual" jsonb`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "products" DROP COLUMN "service_manual"`);
    }

}
