import { MigrationInterface, QueryRunner, TableColumn, TableIndex } from "typeorm";

export class RemoveUnusedEmployeeColumns1774300000000 implements MigrationInterface {
    name = 'RemoveUnusedEmployeeColumns1774300000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable("employees");
        if (!table) return;

        // Drop branch_id index first (if exists)
        const branchIndex = table.indices.find(
            (idx) => idx.columnNames.includes("branch_id"),
        );
        if (branchIndex) {
            await queryRunner.dropIndex("employees", branchIndex);
        }

        // Drop columns
        const columnsToDrop = ["password", "branch_id", "auth_id", "display_name"];
        for (const colName of columnsToDrop) {
            const column = table.findColumnByName(colName);
            if (column) {
                await queryRunner.dropColumn("employees", colName);
            }
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Restore columns in reverse order
        await queryRunner.addColumn("employees", new TableColumn({
            name: "display_name",
            type: "varchar",
            length: "50",
            isNullable: true,
        }));

        await queryRunner.addColumn("employees", new TableColumn({
            name: "auth_id",
            type: "varchar",
            length: "255",
            isNullable: true,
            isUnique: true,
        }));

        await queryRunner.addColumn("employees", new TableColumn({
            name: "branch_id",
            type: "uuid",
            isNullable: true,
        }));

        // Restore branch_id index
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_BRANCH_ID",
            columnNames: ["branch_id"],
        }));

        await queryRunner.addColumn("employees", new TableColumn({
            name: "password",
            type: "varchar",
            length: "255",
            isNullable: true,
        }));
    }
}
