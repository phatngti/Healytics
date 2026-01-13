import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateEmployeeTables1766323300000 implements MigrationInterface {
    name = 'CreateEmployeeTables1766323300000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Create ENUM Types (PostgreSQL specific) - Use IF NOT EXISTS for idempotency
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "employees_role_enum" AS ENUM ('DOCTOR', 'THERAPIST', 'RECEPTIONIST', 'MANAGER');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);
        
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "employees_status_enum" AS ENUM ('ACTIVE', 'INACTIVE', 'ON_LEAVE');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);
        
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "therapist_profiles_level_enum" AS ENUM ('JUNIOR', 'SENIOR', 'MASTER');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);
        
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "therapist_profiles_strength_level_enum" AS ENUM ('SOFT', 'MEDIUM', 'STRONG');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);
        
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "employees_gender_enum" AS ENUM ('MALE', 'FEMALE', 'OTHER');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);

        // 2. Create Core Table: EMPLOYEES
        await queryRunner.createTable(new Table({
            name: "employees",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "auth_id", type: "varchar", length: "255", isUnique: true, isNullable: true },
                { name: "employee_code", type: "varchar", length: "50", isUnique: true },
                { name: "full_name", type: "varchar", length: "100" },
                { name: "display_name", type: "varchar", length: "50", isNullable: true },
                { name: "email", type: "varchar", length: "100", isUnique: true },
                { name: "phone", type: "varchar", length: "20", isNullable: true },
                { name: "avatar_url", type: "text", isNullable: true },
                { name: "dob", type: "date", isNullable: true },
                { name: "gender", type: "employees_gender_enum", isNullable: true },
                
                // Enum columns
                { name: "role", type: "employees_role_enum" },
                { name: "status", type: "employees_status_enum", default: "'ACTIVE'" },
                
                // Cache fields for performance
                { name: "rating", type: "decimal", precision: 3, scale: 2, default: 0 },
                { name: "review_count", type: "int", default: 0 },
                
                // Foreign Keys
                { name: "branch_id", type: "uuid", isNullable: true },
                
                // Audit timestamps with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true },
            ]
        }), true);

        // Create indexes for employees (search optimization + FK indexing)
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_EMAIL",
            columnNames: ["email"]
        }));
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_PHONE",
            columnNames: ["phone"]
        }));
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_CODE",
            columnNames: ["employee_code"]
        }));
        await queryRunner.createIndex("employees", new TableIndex({
            name: "IDX_EMPLOYEES_BRANCH_ID",
            columnNames: ["branch_id"]
        }));

        // 3. Create Extension Table: DOCTOR_PROFILES
        await queryRunner.createTable(new Table({
            name: "doctor_profiles",
            columns: [
                { name: "employee_id", type: "uuid", isPrimary: true },
                { name: "title", type: "varchar", length: "100", isNullable: true },
                { name: "medical_license", type: "varchar", length: "50", isUnique: true },
                { name: "experience_years", type: "int", default: 0 },
                { name: "consultation_fee", type: "decimal", precision: 15, scale: 2, default: 0 },
                
                // JSONB columns for complex data
                { name: "specializations", type: "jsonb", isNullable: true },
                { name: "education", type: "jsonb", isNullable: true },
                { name: "certifications", type: "jsonb", isNullable: true },
            ]
        }), true);

        // FK for Doctor Profile -> Employees
        await queryRunner.createForeignKey("doctor_profiles", new TableForeignKey({
            name: "FK_DOCTOR_PROFILES_EMPLOYEE_ID",
            columnNames: ["employee_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE"
        }));

        // 4. Create Extension Table: THERAPIST_PROFILES
        await queryRunner.createTable(new Table({
            name: "therapist_profiles",
            columns: [
                { name: "employee_id", type: "uuid", isPrimary: true },
                { name: "level", type: "therapist_profiles_level_enum", default: "'JUNIOR'" },
                { name: "type", type: "varchar", length: "50", isNullable: true },
                { name: "strength_level", type: "therapist_profiles_strength_level_enum", isNullable: true },
                { name: "commission_rate", type: "decimal", precision: 5, scale: 2, default: 0 },
                { name: "health_check_date", type: "date", isNullable: true },
                
                // JSONB column
                { name: "skills", type: "jsonb", isNullable: true },
            ]
        }), true);

        // FK for Therapist Profile -> Employees
        await queryRunner.createForeignKey("therapist_profiles", new TableForeignKey({
            name: "FK_THERAPIST_PROFILES_EMPLOYEE_ID",
            columnNames: ["employee_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order to avoid FK constraint errors
        
        // 1. Drop therapist_profiles
        await queryRunner.dropForeignKey("therapist_profiles", "FK_THERAPIST_PROFILES_EMPLOYEE_ID");
        await queryRunner.dropTable("therapist_profiles", true);

        // 2. Drop doctor_profiles
        await queryRunner.dropForeignKey("doctor_profiles", "FK_DOCTOR_PROFILES_EMPLOYEE_ID");
        await queryRunner.dropTable("doctor_profiles", true);

        // 3. Drop employees indexes and table
        await queryRunner.dropIndex("employees", "IDX_EMPLOYEES_BRANCH_ID");
        await queryRunner.dropIndex("employees", "IDX_EMPLOYEES_CODE");
        await queryRunner.dropIndex("employees", "IDX_EMPLOYEES_PHONE");
        await queryRunner.dropIndex("employees", "IDX_EMPLOYEES_EMAIL");
        await queryRunner.dropTable("employees", true);

        // 4. Drop Enums
        await queryRunner.query(`DROP TYPE IF EXISTS "employees_gender_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "therapist_profiles_strength_level_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "therapist_profiles_level_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "employees_status_enum"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "employees_role_enum"`);
    }
}
