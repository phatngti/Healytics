import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateAuditLogTable1768793000000 implements MigrationInterface {
    name = 'CreateAuditLogTable1768793000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create audit_log table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "audit_log" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "actor_id" uuid NOT NULL,
                "action" character varying NOT NULL,
                "target_entity" character varying NOT NULL,
                "target_id" uuid,
                "ip_address" character varying,
                "user_agent" character varying,
                "metadata" jsonb,
                "created_at" TIMESTAMP NOT NULL DEFAULT now(),
                CONSTRAINT "PK_audit_log" PRIMARY KEY ("id")
            )
        `);

        // Create indexes for common queries
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS "IDX_audit_log_actor_id" ON "audit_log" ("actor_id")`);
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS "IDX_audit_log_target_id" ON "audit_log" ("target_id")`);
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS "IDX_audit_log_action" ON "audit_log" ("action")`);
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS "IDX_audit_log_created_at" ON "audit_log" ("created_at")`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_audit_log_created_at"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_audit_log_action"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_audit_log_target_id"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_audit_log_actor_id"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "audit_log"`);
    }
}
