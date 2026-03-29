import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AddWorkHistoryToEmployees1774288230000 implements MigrationInterface {
    name = 'AddWorkHistoryToEmployees1774288230000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable("employees");
        const column = table?.findColumnByName("work_history");

        if (!column) {
            await queryRunner.addColumn("employees", new TableColumn({
                name: "work_history",
                type: "jsonb",
                isNullable: true,
            }));
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable("employees");
        const column = table?.findColumnByName("work_history");

        if (column) {
            await queryRunner.dropColumn("employees", "work_history");
        }
    }
}
