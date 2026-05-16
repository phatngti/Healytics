import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddAdminFinanceSupportTables1777100000000 implements MigrationInterface {
  name = 'AddAdminFinanceSupportTables1777100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE "partner_payouts"
      ADD COLUMN IF NOT EXISTS "attempt_count" integer NOT NULL DEFAULT 0,
      ADD COLUMN IF NOT EXISTS "failure_reason" text,
      ADD COLUMN IF NOT EXISTS "hold_reason" text,
      ADD COLUMN IF NOT EXISTS "masked_destination" character varying(120)
    `);

    await queryRunner.query(`
      ALTER TABLE "partner_refund_cases"
      ADD COLUMN IF NOT EXISTS "customer_request" text,
      ADD COLUMN IF NOT EXISTS "partner_response" text,
      ADD COLUMN IF NOT EXISTS "evidence_links" jsonb NOT NULL DEFAULT '[]'::jsonb,
      ADD COLUMN IF NOT EXISTS "decision_note" text
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "admin_finance_notes" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "entity_type" character varying(40) NOT NULL,
        "entity_id" uuid NOT NULL,
        "content" text NOT NULL,
        "created_by_account_id" uuid,
        "created_by_name" character varying(255),
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_admin_finance_notes" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_AFN_ENTITY"
      ON "admin_finance_notes" ("entity_type", "entity_id")
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "admin_finance_export_jobs" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "type" character varying(40) NOT NULL,
        "requested_by_account_id" uuid,
        "requested_by_name" character varying(255),
        "status" character varying(30) NOT NULL DEFAULT 'queued',
        "row_count" integer NOT NULL DEFAULT 0,
        "download_url" text,
        "expires_at" TIMESTAMP WITH TIME ZONE,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_admin_finance_export_jobs" PRIMARY KEY ("id")
      )
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "admin_finance_reconciliation_exceptions" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "detected_at" TIMESTAMP WITH TIME ZONE NOT NULL,
        "provider" character varying(30) NOT NULL,
        "provider_event_id" character varying(150) NOT NULL,
        "related_transaction_id" uuid,
        "expected_amount" numeric(15,2) NOT NULL DEFAULT 0,
        "provider_amount" numeric(15,2) NOT NULL DEFAULT 0,
        "difference" numeric(15,2) NOT NULL DEFAULT 0,
        "currency" character varying(10) NOT NULL DEFAULT 'VND',
        "type" character varying(50) NOT NULL,
        "status" character varying(30) NOT NULL DEFAULT 'open',
        "owner" character varying(255) NOT NULL,
        "summary" text NOT NULL,
        "provider_event_context" text,
        "ledger_context" text,
        "resolution_notes" text,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        "deleted_at" TIMESTAMP WITH TIME ZONE,
        CONSTRAINT "PK_admin_finance_reconciliation_exceptions" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_AFRE_STATUS_DETECTED"
      ON "admin_finance_reconciliation_exceptions" ("status", "detected_at")
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_AFRE_PROVIDER_EVENT"
      ON "admin_finance_reconciliation_exceptions" ("provider", "provider_event_id")
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_AFRE_RELATED_TRANSACTION_ID"
      ON "admin_finance_reconciliation_exceptions" ("related_transaction_id")
    `);
    await queryRunner.query(`
      ALTER TABLE "admin_finance_reconciliation_exceptions"
      ADD CONSTRAINT "FK_admin_finance_reconciliation_transaction"
      FOREIGN KEY ("related_transaction_id")
      REFERENCES "partner_ledger_transactions"("id")
      ON DELETE SET NULL ON UPDATE NO ACTION
    `);

    await queryRunner.query(`
      CREATE TABLE IF NOT EXISTS "partner_payout_attempts" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "payout_id" uuid NOT NULL,
        "partner_id" uuid NOT NULL,
        "attempt_number" integer NOT NULL,
        "attempted_at" TIMESTAMP WITH TIME ZONE NOT NULL,
        "status" character varying(30) NOT NULL,
        "failure_reason" text,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_partner_payout_attempts" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_PPA_PAYOUT_ID"
      ON "partner_payout_attempts" ("payout_id")
    `);
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_PPA_PARTNER_ID"
      ON "partner_payout_attempts" ("partner_id")
    `);
    await queryRunner.query(`
      CREATE UNIQUE INDEX IF NOT EXISTS "IDX_PPA_PAYOUT_ATTEMPT"
      ON "partner_payout_attempts" ("payout_id", "attempt_number")
    `);
    await queryRunner.query(`
      ALTER TABLE "partner_payout_attempts"
      ADD CONSTRAINT "FK_partner_payout_attempts_payout"
      FOREIGN KEY ("payout_id")
      REFERENCES "partner_payouts"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`DROP TABLE IF EXISTS "partner_payout_attempts"`);
    await queryRunner.query(
      `DROP TABLE IF EXISTS "admin_finance_reconciliation_exceptions"`,
    );
    await queryRunner.query(`DROP TABLE IF EXISTS "admin_finance_export_jobs"`);
    await queryRunner.query(`DROP TABLE IF EXISTS "admin_finance_notes"`);

    await queryRunner.query(`
      ALTER TABLE "partner_refund_cases"
      DROP COLUMN IF EXISTS "decision_note",
      DROP COLUMN IF EXISTS "evidence_links",
      DROP COLUMN IF EXISTS "partner_response",
      DROP COLUMN IF EXISTS "customer_request"
    `);

    await queryRunner.query(`
      ALTER TABLE "partner_payouts"
      DROP COLUMN IF EXISTS "masked_destination",
      DROP COLUMN IF EXISTS "hold_reason",
      DROP COLUMN IF EXISTS "failure_reason",
      DROP COLUMN IF EXISTS "attempt_count"
    `);
  }
}
