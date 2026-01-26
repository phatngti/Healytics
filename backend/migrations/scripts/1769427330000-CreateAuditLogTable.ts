import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateAuditLogTable1769427330000 implements MigrationInterface {
    name = 'CreateAuditLogTable1769427330000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "audit_log" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "actor_id" uuid NOT NULL, "action" character varying NOT NULL, "target_entity" character varying NOT NULL, "target_id" uuid, "ip_address" character varying, "user_agent" character varying, "metadata" jsonb, "created_at" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_AUDIT_LOG" PRIMARY KEY ("id"))`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE "audit_log"`);
    }
}
