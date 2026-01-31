import { MigrationInterface, QueryRunner, Table, TableIndex, TableForeignKey } from "typeorm";

export class CreateLocationTable1769427300000 implements MigrationInterface {
    name = 'CreateLocationTable1769427300000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Create enum type (PostgreSQL-specific, using raw SQL for enum)
        await queryRunner.query(`
            DO $$ BEGIN 
                CREATE TYPE "public"."location_level_enum" AS ENUM('PROVINCE', 'DISTRICT', 'WARD'); 
            EXCEPTION WHEN duplicate_object THEN null; 
            END $$
        `);

        // 2. Create location table with IF NOT EXISTS
        await queryRunner.createTable(new Table({
            name: "location",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "code", type: "varchar", length: "10", isNullable: false },
                { name: "name", type: "varchar", length: "100", isNullable: false },
                { name: "name_en", type: "varchar", length: "100", isNullable: true },
                { name: "full_name", type: "varchar", length: "150", isNullable: false },
                { name: "full_name_en", type: "varchar", length: "150", isNullable: true },
                { name: "code_name", type: "varchar", length: "100", isNullable: true },
                { name: "level", type: "public.location_level_enum", isNullable: false },
                { name: "mpath", type: "varchar", isNullable: true, default: "''" },
                { name: "parentId", type: "uuid", isNullable: true }
            ],
            uniques: [
                { name: "UQ_LOCATION_CODE", columnNames: ["code"] }
            ]
        }), true); // true = IF NOT EXISTS

        // 3. Add index on code column for faster lookups
        await queryRunner.createIndex("location", new TableIndex({
            name: "IDX_LOCATION_CODE",
            columnNames: ["code"]
        }));

        // 4. Add self-referential foreign key for parent location
        await queryRunner.createForeignKey("location", new TableForeignKey({
            name: "FK_LOCATION_PARENT_ID",
            columnNames: ["parentId"],
            referencedTableName: "location",
            referencedColumnNames: ["id"],
            onDelete: "NO ACTION",
            onUpdate: "NO ACTION"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order: FK -> Index -> Table -> Enum
        await queryRunner.query("DROP INDEX IF EXISTS location_idx_parent_id");
        await queryRunner.query("DROP INDEX IF EXISTS location_idx_code");
        await queryRunner.query("DROP TABLE IF EXISTS location"); // true = IF EXISTS
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."location_level_enum"`);
    }
}
