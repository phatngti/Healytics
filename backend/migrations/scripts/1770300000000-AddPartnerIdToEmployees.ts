import { MigrationInterface, QueryRunner, TableColumn, TableForeignKey, TableIndex } from "typeorm";

export class AddPartnerIdToEmployees1770300000000 implements MigrationInterface {
    name = 'AddPartnerIdToEmployees1770300000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Add partner_id column (nullable for backward compatibility)
        await queryRunner.addColumn("employees", new TableColumn({
            name: "partner_id",
            type: "uuid",
            isNullable: true,
        }));

        // 2. Add index on partner_id (required for FK performance)
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_PARTNER_ID",
            columnNames: ["partner_id"],
        }));

        // 3. Add FK constraint → health_partner_profile.id
        await queryRunner.createForeignKey("employees", new TableForeignKey({
            name: "FK_EMPLOYEES_PARTNER_ID",
            columnNames: ["partner_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "health_partner_profile",
            onDelete: "SET NULL",
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order: FK → Index → Column
        await queryRunner.dropForeignKey("employees", "FK_EMPLOYEES_PARTNER_ID");
        await queryRunner.dropIndex("employees", "IDX_EMPLOYEES_PARTNER_ID");
        await queryRunner.dropColumn("employees", "partner_id");
    }
}
