import { MigrationInterface, QueryRunner, Table, TableIndex } from "typeorm";

export class CreateAuditLogTable1769427330000 implements MigrationInterface {
    name = 'CreateAuditLogTable1769427330000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Create audit_log table with IF NOT EXISTS
        await queryRunner.createTable(new Table({
            name: "audit_log",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
                { name: "actor_id", type: "uuid", isNullable: false },
                { name: "action", type: "varchar", isNullable: false },
                { name: "target_entity", type: "varchar", isNullable: false },
                { name: "target_id", type: "uuid", isNullable: true },
                { name: "ip_address", type: "varchar", isNullable: true },
                { name: "user_agent", type: "varchar", isNullable: true },
                { name: "metadata", type: "jsonb", isNullable: true },
                { name: "created_at", type: "timestamp", default: "now()", isNullable: false }
            ]
        }), true); // true = IF NOT EXISTS

        // 2. Add indexes for common query patterns
        await queryRunner.createIndex("audit_log", new TableIndex({
            name: "IDX_AUDIT_LOG_ACTOR_ID",
            columnNames: ["actor_id"]
        }));

        await queryRunner.createIndex("audit_log", new TableIndex({
            name: "IDX_AUDIT_LOG_TARGET",
            columnNames: ["target_entity", "target_id"]
        }));

        await queryRunner.createIndex("audit_log", new TableIndex({
            name: "IDX_AUDIT_LOG_CREATED_AT",
            columnNames: ["created_at"]
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order: Indexes -> Table (all with IF EXISTS for safe rollback)
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_AUDIT_LOG_CREATED_AT"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_AUDIT_LOG_TARGET"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_AUDIT_LOG_ACTOR_ID"`);
        await queryRunner.dropTable("audit_log", true);
    }
}
