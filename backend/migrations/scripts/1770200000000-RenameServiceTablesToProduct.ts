import { MigrationInterface, QueryRunner } from "typeorm";

export class RenameServiceTablesToProduct1770200000000 implements MigrationInterface {
    name = 'RenameServiceTablesToProduct1770200000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Rename service_definitions → product_definitions
        await queryRunner.query(`ALTER TABLE "service_definitions" RENAME TO "product_definitions"`);

        // 2. Rename service_employee_eligibility → product_employee_eligibility
        await queryRunner.query(`ALTER TABLE "service_employee_eligibility" RENAME TO "product_employee_eligibility"`);

        // 3. Rename service_resource_requirements → product_resource_requirements
        await queryRunner.query(`ALTER TABLE "service_resource_requirements" RENAME TO "product_resource_requirements"`);

        // 4. Rename service_tags → product_feature_tags
        await queryRunner.query(`ALTER TABLE "service_tags" RENAME TO "product_feature_tags"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert in reverse order
        await queryRunner.query(`ALTER TABLE "product_feature_tags" RENAME TO "service_tags"`);
        await queryRunner.query(`ALTER TABLE "product_resource_requirements" RENAME TO "service_resource_requirements"`);
        await queryRunner.query(`ALTER TABLE "product_employee_eligibility" RENAME TO "service_employee_eligibility"`);
        await queryRunner.query(`ALTER TABLE "product_definitions" RENAME TO "service_definitions"`);
    }
}
