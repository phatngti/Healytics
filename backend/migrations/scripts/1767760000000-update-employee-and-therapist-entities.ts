import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class UpdateEmployeeAndTherapistEntities1767760000000 implements MigrationInterface {
    name = 'UpdateEmployeeAndTherapistEntities1767760000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Update employees table - check for each column before adding
        const employeesTable = await queryRunner.getTable("employees");
        
        const employeeColumns = [
            { name: "start_date", type: "date", isNullable: true },
            { name: "employment_type", type: "varchar", length: "50", isNullable: true },
            { name: "emergency_contact_name", type: "varchar", length: "100", isNullable: true },
            { name: "emergency_contact_phone", type: "varchar", length: "20", isNullable: true },
            { name: "id_card_url", type: "text", isNullable: true },
            { name: "description", type: "text", isNullable: true }
        ];

        for (const colDef of employeeColumns) {
            const existingColumn = employeesTable?.findColumnByName(colDef.name);
            if (!existingColumn) {
                await queryRunner.addColumn("employees", new TableColumn(colDef));
            }
        }

        // Update therapist_profiles table
        const therapistTable = await queryRunner.getTable("therapist_profiles");
        
        const therapistColumns = [
            { name: "device_proficiency", type: "jsonb", isNullable: true },
            { name: "license_url", type: "text", isNullable: true }
        ];

        for (const colDef of therapistColumns) {
            const existingColumn = therapistTable?.findColumnByName(colDef.name);
            if (!existingColumn) {
                await queryRunner.addColumn("therapist_profiles", new TableColumn(colDef));
            }
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Revert therapist_profiles changes
        const therapistTable = await queryRunner.getTable("therapist_profiles");
        if (therapistTable?.findColumnByName("license_url")) {
            await queryRunner.dropColumn("therapist_profiles", "license_url");
        }
        if (therapistTable?.findColumnByName("device_proficiency")) {
            await queryRunner.dropColumn("therapist_profiles", "device_proficiency");
        }

        // Revert employees changes
        const employeesTable = await queryRunner.getTable("employees");
        const columnsToRemove = ["description", "id_card_url", "emergency_contact_phone", "emergency_contact_name", "employment_type", "start_date"];
        
        for (const colName of columnsToRemove) {
            if (employeesTable?.findColumnByName(colName)) {
                await queryRunner.dropColumn("employees", colName);
            }
        }
    }
}
