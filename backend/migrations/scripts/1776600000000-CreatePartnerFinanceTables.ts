import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreatePartnerFinanceTables1776600000000 implements MigrationInterface {
  name = 'CreatePartnerFinanceTables1776600000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ── 1. partner_payouts ──────────────────────────────────────
    await queryRunner.query(`
            CREATE TABLE "partner_payouts" (
                "id"                  uuid DEFAULT uuid_generate_v4() NOT NULL,
                "partner_id"          uuid NOT NULL,
                "period_start"        TIMESTAMP WITH TIME ZONE NOT NULL,
                "period_end"          TIMESTAMP WITH TIME ZONE NOT NULL,
                "included_volume"     numeric(15,2) NOT NULL DEFAULT 0,
                "fees_adjustments"    numeric(15,2) NOT NULL DEFAULT 0,
                "net_payout"          numeric(15,2) NOT NULL DEFAULT 0,
                "scheduled_date"      TIMESTAMP WITH TIME ZONE NOT NULL,
                "method_label"        character varying(100) NOT NULL,
                "status"              character varying(30) NOT NULL,
                "currency"            character varying(10) NOT NULL DEFAULT 'VND',
                "provider_payout_id"  character varying(100),
                "created_at"          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "updated_at"          TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "deleted_at"          TIMESTAMP WITH TIME ZONE,
                CONSTRAINT "PK_partner_payouts" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(
      `CREATE INDEX "IDX_PP_PARTNER_ID" ON "partner_payouts" ("partner_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PP_PARTNER_SCHEDULED" ON "partner_payouts" ("partner_id", "scheduled_date")`,
    );

    await queryRunner.query(`
            ALTER TABLE "partner_payouts"
            ADD CONSTRAINT "FK_partner_payouts_partner"
            FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    // ── 2. partner_ledger_transactions ──────────────────────────
    await queryRunner.query(`
            CREATE TABLE "partner_ledger_transactions" (
                "id"                        uuid DEFAULT uuid_generate_v4() NOT NULL,
                "partner_id"                uuid NOT NULL,
                "type"                      character varying(30) NOT NULL,
                "source_type"               character varying(30) NOT NULL,
                "source_id"                 uuid,
                "reference"                 character varying(100) NOT NULL,
                "customer_name_snapshot"     character varying(255) NOT NULL,
                "gross_amount"              numeric(15,2) NOT NULL DEFAULT 0,
                "fee_amount"                numeric(15,2) NOT NULL DEFAULT 0,
                "currency"                  character varying(10) NOT NULL DEFAULT 'VND',
                "status"                    character varying(30) NOT NULL,
                "settlement_status"         character varying(30) NOT NULL,
                "payout_status"             character varying(30) NOT NULL,
                "payment_method_label"      character varying(100),
                "source_title_snapshot"     character varying(255),
                "source_subtitle_snapshot"  character varying(255),
                "flagged_for_review"        boolean NOT NULL DEFAULT false,
                "notes"                     text,
                "payout_id"                 uuid,
                "created_at"                TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "updated_at"                TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "deleted_at"                TIMESTAMP WITH TIME ZONE,
                CONSTRAINT "PK_partner_ledger_transactions" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_ID" ON "partner_ledger_transactions" ("partner_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PAYOUT_ID" ON "partner_ledger_transactions" ("payout_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_CREATED" ON "partner_ledger_transactions" ("partner_id", "created_at")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_STATUS_CREATED" ON "partner_ledger_transactions" ("partner_id", "status", "created_at")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_SETTLEMENT_CREATED" ON "partner_ledger_transactions" ("partner_id", "settlement_status", "created_at")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_PAYOUT_STATUS_CREATED" ON "partner_ledger_transactions" ("partner_id", "payout_status", "created_at")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_SOURCE_TYPE_CREATED" ON "partner_ledger_transactions" ("partner_id", "source_type", "created_at")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PLT_PARTNER_REFERENCE" ON "partner_ledger_transactions" ("partner_id", "reference")`,
    );

    await queryRunner.query(`
            ALTER TABLE "partner_ledger_transactions"
            ADD CONSTRAINT "FK_partner_ledger_transactions_partner"
            FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    await queryRunner.query(`
            ALTER TABLE "partner_ledger_transactions"
            ADD CONSTRAINT "FK_partner_ledger_transactions_payout"
            FOREIGN KEY ("payout_id") REFERENCES "partner_payouts"("id")
            ON DELETE SET NULL ON UPDATE NO ACTION
        `);

    // ── 3. partner_payout_transactions ─────────────────────────
    await queryRunner.query(`
            CREATE TABLE "partner_payout_transactions" (
                "id"              uuid DEFAULT uuid_generate_v4() NOT NULL,
                "payout_id"       uuid NOT NULL,
                "transaction_id"  uuid NOT NULL,
                "partner_id"      uuid NOT NULL,
                CONSTRAINT "PK_partner_payout_transactions" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(
      `CREATE INDEX "IDX_PPT_PAYOUT_ID" ON "partner_payout_transactions" ("payout_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PPT_TRANSACTION_ID" ON "partner_payout_transactions" ("transaction_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PPT_PARTNER_ID" ON "partner_payout_transactions" ("partner_id")`,
    );
    await queryRunner.query(
      `CREATE UNIQUE INDEX "IDX_PPT_PAYOUT_TXN" ON "partner_payout_transactions" ("payout_id", "transaction_id")`,
    );

    await queryRunner.query(`
            ALTER TABLE "partner_payout_transactions"
            ADD CONSTRAINT "FK_partner_payout_transactions_payout"
            FOREIGN KEY ("payout_id") REFERENCES "partner_payouts"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    await queryRunner.query(`
            ALTER TABLE "partner_payout_transactions"
            ADD CONSTRAINT "FK_partner_payout_transactions_transaction"
            FOREIGN KEY ("transaction_id") REFERENCES "partner_ledger_transactions"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    await queryRunner.query(`
            ALTER TABLE "partner_payout_transactions"
            ADD CONSTRAINT "FK_partner_payout_transactions_partner"
            FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    // ── 4. partner_refund_cases ─────────────────────────────────
    await queryRunner.query(`
            CREATE TABLE "partner_refund_cases" (
                "id"              uuid DEFAULT uuid_generate_v4() NOT NULL,
                "partner_id"      uuid NOT NULL,
                "transaction_id"  uuid NOT NULL,
                "case_type"       character varying(30) NOT NULL,
                "requested_at"    TIMESTAMP WITH TIME ZONE NOT NULL,
                "amount"          numeric(15,2) NOT NULL DEFAULT 0,
                "currency"        character varying(10) NOT NULL DEFAULT 'VND',
                "reason"          text,
                "owner"           character varying(255) NOT NULL,
                "status"          character varying(30) NOT NULL,
                "sla_due_at"      TIMESTAMP WITH TIME ZONE,
                "created_at"      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "updated_at"      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "deleted_at"      TIMESTAMP WITH TIME ZONE,
                CONSTRAINT "PK_partner_refund_cases" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(
      `CREATE INDEX "IDX_PRC_PARTNER_ID" ON "partner_refund_cases" ("partner_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PRC_TRANSACTION_ID" ON "partner_refund_cases" ("transaction_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PRC_PARTNER_REQUESTED" ON "partner_refund_cases" ("partner_id", "requested_at")`,
    );

    await queryRunner.query(`
            ALTER TABLE "partner_refund_cases"
            ADD CONSTRAINT "FK_partner_refund_cases_partner"
            FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    await queryRunner.query(`
            ALTER TABLE "partner_refund_cases"
            ADD CONSTRAINT "FK_partner_refund_cases_transaction"
            FOREIGN KEY ("transaction_id") REFERENCES "partner_ledger_transactions"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);

    // ── 5. partner_transaction_timeline_events ──────────────────
    await queryRunner.query(`
            CREATE TABLE "partner_transaction_timeline_events" (
                "id"                uuid DEFAULT uuid_generate_v4() NOT NULL,
                "transaction_id"    uuid NOT NULL,
                "partner_id"        uuid NOT NULL,
                "title"             character varying(255) NOT NULL,
                "description"       text,
                "occurred_at"       TIMESTAMP WITH TIME ZONE NOT NULL,
                "actor_account_id"  uuid,
                "metadata"          jsonb,
                "created_at"        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                CONSTRAINT "PK_partner_transaction_timeline_events" PRIMARY KEY ("id")
            )
        `);

    await queryRunner.query(
      `CREATE INDEX "IDX_PTTE_TRANSACTION_ID" ON "partner_transaction_timeline_events" ("transaction_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_PTTE_PARTNER_ID" ON "partner_transaction_timeline_events" ("partner_id")`,
    );

    await queryRunner.query(`
            ALTER TABLE "partner_transaction_timeline_events"
            ADD CONSTRAINT "FK_partner_timeline_events_transaction"
            FOREIGN KEY ("transaction_id") REFERENCES "partner_ledger_transactions"("id")
            ON DELETE CASCADE ON UPDATE NO ACTION
        `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order to respect FK dependencies
    await queryRunner.query(
      `DROP TABLE IF EXISTS "partner_transaction_timeline_events"`,
    );
    await queryRunner.query(`DROP TABLE IF EXISTS "partner_refund_cases"`);
    await queryRunner.query(
      `DROP TABLE IF EXISTS "partner_payout_transactions"`,
    );
    await queryRunner.query(
      `DROP TABLE IF EXISTS "partner_ledger_transactions"`,
    );
    await queryRunner.query(`DROP TABLE IF EXISTS "partner_payouts"`);
  }
}
