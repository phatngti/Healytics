import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateEmployeeTables1766323300000 implements MigrationInterface {
    name = 'CreateEmployeeTables1766323300000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Tạo ENUM Types (PostgreSQL specific)
        // Giúp đảm bảo data consistency ngay từ level database
        await queryRunner.query(`CREATE TYPE "employee_role_enum" AS ENUM ('DOCTOR', 'THERAPIST', 'RECEPTIONIST', 'MANAGER')`);
        await queryRunner.query(`CREATE TYPE "employee_status_enum" AS ENUM ('ACTIVE', 'INACTIVE', 'ON_LEAVE')`);
        await queryRunner.query(`CREATE TYPE "therapist_level_enum" AS ENUM ('JUNIOR', 'SENIOR', 'MASTER')`);
        await queryRunner.query(`CREATE TYPE "strength_level_enum" AS ENUM ('SOFT', 'MEDIUM', 'STRONG')`);
        await queryRunner.query(`CREATE TYPE "gender_enum" AS ENUM ('MALE', 'FEMALE', 'OTHER')`);

        // 2. Tạo bảng Core: EMPLOYEES
        await queryRunner.createTable(new Table({
            name: "employees",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()", // Yêu cầu extension "uuid-ossp"
                },
                { name: "auth_id", type: "varchar", length: "255", isUnique: true, isNullable: true }, // Link với Firebase/Auth0
                { name: "employee_code", type: "varchar", length: "50", isUnique: true },
                { name: "full_name", type: "varchar", length: "100" },
                { name: "display_name", type: "varchar", length: "50", isNullable: true },
                { name: "email", type: "varchar", length: "100", isUnique: true },
                { name: "phone", type: "varchar", length: "20", isNullable: true },
                { name: "avatar_url", type: "text", isNullable: true },
                { name: "dob", type: "date", isNullable: true },
                { name: "gender", type: "gender_enum", isNullable: true },
                
                // Các cột Enum quan trọng
                { name: "role", type: "employee_role_enum" },
                { name: "status", type: "employee_status_enum", default: "'ACTIVE'" },
                
                // Cache fields cho performance
                { name: "rating", type: "decimal", precision: 3, scale: 2, default: 0 }, // VD: 4.85
                { name: "review_count", type: "int", default: 0 },
                
                // Foreign Keys placeholders (Giả sử bảng branches đã tồn tại)
                { name: "branch_id", type: "uuid", isNullable: true },
                
                // Timestamps
                { name: "created_at", type: "timestamp", default: "now()" },
                { name: "updated_at", type: "timestamp", default: "now()" },
            ]
        }), true);

        // Tạo Index cho employees để search nhanh
        await queryRunner.createIndex("employees", new TableIndex({ columnNames: ["email"] }));
        await queryRunner.createIndex("employees", new TableIndex({ columnNames: ["phone"] }));
        await queryRunner.createIndex("employees", new TableIndex({ columnNames: ["employee_code"] }));


        // 3. Tạo bảng Extension: DOCTOR_PROFILES
        await queryRunner.createTable(new Table({
            name: "doctor_profiles",
            columns: [
                { name: "employee_id", type: "uuid", isPrimary: true }, // PK cũng là FK
                { name: "title", type: "varchar", length: "100", isNullable: true }, // VD: Thạc sĩ, BS CKI
                { name: "medical_license", type: "varchar", length: "50", isUnique: true }, // Cực kỳ quan trọng
                { name: "experience_years", type: "int", default: 0 },
                { name: "consultation_fee", type: "decimal", precision: 15, scale: 2, default: 0 },
                
                // JSONB columns cho dữ liệu phức tạp
                { name: "specializations", type: "jsonb", isNullable: true }, // ['Acne', 'Laser']
                { name: "education", type: "jsonb", isNullable: true }, // [{school: '...', degree: '...'}]
                { name: "certifications", type: "jsonb", isNullable: true }, // Các chứng chỉ phụ
            ]
        }), true);

        // FK cho Doctor Profile -> Employees
        await queryRunner.createForeignKey("doctor_profiles", new TableForeignKey({
            columnNames: ["employee_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE" // Xóa Employee thì xóa luôn Profile bác sĩ
        }));


        // 4. Tạo bảng Extension: THERAPIST_PROFILES
        await queryRunner.createTable(new Table({
            name: "therapist_profiles",
            columns: [
                { name: "employee_id", type: "uuid", isPrimary: true },
                { name: "level", type: "therapist_level_enum", default: "'JUNIOR'" },
                { name: "type", type: "varchar", length: "50", isNullable: true }, // SPA vs MASSAGE
                { name: "strength_level", type: "strength_level_enum", isNullable: true }, // Quan trọng cho massage
                { name: "commission_rate", type: "decimal", precision: 5, scale: 2, default: 0 }, // % hoa hồng
                { name: "health_check_date", type: "date", isNullable: true },
                
                // JSONB column
                { name: "skills", type: "jsonb", isNullable: true }, // ['Thai Massage', 'Shiatsu']
            ]
        }), true);

        // FK cho Therapist Profile -> Employees
        await queryRunner.createForeignKey("therapist_profiles", new TableForeignKey({
            columnNames: ["employee_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE"
        }));


        // NOTE: Bạn cần thêm FK tới bảng `branches` và `services` nếu các bảng đó đã tồn tại
        // Ví dụ:
        /*
        await queryRunner.createForeignKey("employees", new TableForeignKey({
            columnNames: ["branch_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "branches",
            onDelete: "SET NULL"
        }));
        */
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Xóa theo thứ tự ngược lại để tránh lỗi ràng buộc khóa ngoại (Foreign Key constraints)
        
        // 1. Xóa bảng employee_services
        // employee_services moved to Product/Service migration
        
        // 2. Xóa bảng therapist_profiles
        const tableTherapist = await queryRunner.getTable("therapist_profiles");
        if (tableTherapist) await queryRunner.dropTable("therapist_profiles");

        // 3. Xóa bảng doctor_profiles
        const tableDoctor = await queryRunner.getTable("doctor_profiles");
        if (tableDoctor) await queryRunner.dropTable("doctor_profiles");

        // 4. Xóa bảng employees
        // (Tự động xóa FKs liên quan nếu dropTable)
        await queryRunner.dropTable("employees");

        // 5. Xóa Enums
        await queryRunner.query(`DROP TYPE "gender_enum"`);
        await queryRunner.query(`DROP TYPE "strength_level_enum"`);
        await queryRunner.query(`DROP TYPE "therapist_level_enum"`);
        await queryRunner.query(`DROP TYPE "employee_status_enum"`);
        await queryRunner.query(`DROP TYPE "employee_role_enum"`);
    }
}
