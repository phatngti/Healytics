import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateAccountTables1766322617959 implements MigrationInterface {
    name = 'CreateAccountTables1766322617959'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ------------------------------------------------------------------
        // 1. CREATE ENUM TYPE: account_role_enum
        // ------------------------------------------------------------------
        await queryRunner.query(`DO $$ BEGIN
            CREATE TYPE "public"."account_role_enum" AS ENUM ('user', 'employee', 'health_partner', 'admin');
        EXCEPTION WHEN duplicate_object THEN NULL; END $$;`);

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: account
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "account",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "email", type: "varchar", length: "255", isUnique: true },
                { name: "password_hash", type: "varchar", length: "255", isNullable: true },
                { name: "refresh_token_hash", type: "text", isNullable: true },
                { name: "role", type: "account_role_enum", default: "'user'" },
                { name: "survey", type: "jsonb", isNullable: true },
                { name: "is_active", type: "boolean", default: true },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Index for email search
        await queryRunner.createIndex("account", new TableIndex({
            name: "IDX_ACCOUNT_EMAIL",
            columnNames: ["email"]
        }));

        // ------------------------------------------------------------------
        // 3. CREATE TABLE: address
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "address",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "street", type: "varchar", length: "255" },
                { name: "ward", type: "varchar", length: "255" },
                { name: "district", type: "varchar", length: "255" },
                { name: "city_or_province", type: "varchar", length: "255" },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // ------------------------------------------------------------------
        // 4. CREATE TABLE: user_profile
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "user_profile",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "first_name", type: "varchar", length: "100", isNullable: true },
                { name: "last_name", type: "varchar", length: "100", isNullable: true },
                { name: "phone", type: "varchar", length: "20", isNullable: true },
                { name: "bio", type: "text", isNullable: true },
                { name: "date_of_birth", type: "date", isNullable: true },
                { name: "profile_completed", type: "boolean", default: false },
                { name: "is_used", type: "boolean", default: false },
                { name: "account_id", type: "uuid", isUnique: true, isNullable: true },
                { name: "address_id", type: "uuid", isUnique: true, isNullable: true },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Indexes for FK columns (required for performance)
        await queryRunner.createIndex("user_profile", new TableIndex({
            name: "IDX_USER_PROFILE_ACCOUNT_ID",
            columnNames: ["account_id"]
        }));
        await queryRunner.createIndex("user_profile", new TableIndex({
            name: "IDX_USER_PROFILE_ADDRESS_ID",
            columnNames: ["address_id"]
        }));

        // FK: user_profile -> account
        await queryRunner.createForeignKey("user_profile", new TableForeignKey({
            name: "FK_USER_PROFILE_ACCOUNT_ID",
            columnNames: ["account_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "account",
            onDelete: "CASCADE"
        }));

        // FK: user_profile -> address
        await queryRunner.createForeignKey("user_profile", new TableForeignKey({
            name: "FK_USER_PROFILE_ADDRESS_ID",
            columnNames: ["address_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "address",
            onDelete: "SET NULL"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order to avoid FK constraint errors
        // Use existence checks for idempotency (safe for partial re-runs)

        // 1. Drop user_profile
        const userProfileTable = await queryRunner.getTable("user_profile");
        if (userProfileTable) {
            const fkAddress = userProfileTable.foreignKeys.find(fk => fk.name === "FK_USER_PROFILE_ADDRESS_ID");
            if (fkAddress) {
                await queryRunner.dropForeignKey("user_profile", fkAddress);
            }
            const fkAccount = userProfileTable.foreignKeys.find(fk => fk.name === "FK_USER_PROFILE_ACCOUNT_ID");
            if (fkAccount) {
                await queryRunner.dropForeignKey("user_profile", fkAccount);
            }
            const idxAddress = userProfileTable.indices.find(idx => idx.name === "IDX_USER_PROFILE_ADDRESS_ID");
            if (idxAddress) {
                await queryRunner.dropIndex("user_profile", idxAddress);
            }
            const idxAccount = userProfileTable.indices.find(idx => idx.name === "IDX_USER_PROFILE_ACCOUNT_ID");
            if (idxAccount) {
                await queryRunner.dropIndex("user_profile", idxAccount);
            }
        }
        await queryRunner.dropTable("user_profile", true);

        // 2. Drop address
        await queryRunner.dropTable("address", true);

        // 3. Drop account
        const accountTable = await queryRunner.getTable("account");
        if (accountTable) {
            const idxEmail = accountTable.indices.find(idx => idx.name === "IDX_ACCOUNT_EMAIL");
            if (idxEmail) {
                await queryRunner.dropIndex("account", idxEmail);
            }
        }
        await queryRunner.dropTable("account", true);

        // 4. Drop enum
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."account_role_enum"`);
    }
}
