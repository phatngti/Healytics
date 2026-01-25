import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AddJobTitleToEmployees1767668600000 implements MigrationInterface {
    name = 'AddJobTitleToEmployees1767668600000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if column exists first for idempotency
        const table = await queryRunner.getTable("employees");
        const column = table?.findColumnByName("job_title");
        
        if (!column) {
            await queryRunner.addColumn("employees", new TableColumn({
                name: "job_title",
                type: "varchar",
                length: "100",
                isNullable: true
            }));
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const table = await queryRunner.getTable("employees");
        const column = table?.findColumnByName("job_title");
        
        if (column) {
            await queryRunner.dropColumn("employees", "job_title");
        }
    }
}
