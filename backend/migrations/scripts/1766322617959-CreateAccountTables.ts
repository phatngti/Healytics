import { MigrationInterface, QueryRunner, TableIndex } from "typeorm";

export class CreateAccountTables1766322617959 implements MigrationInterface {
    name = 'CreateAccountTables1766322617959'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(
            `CREATE TABLE "account" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "email" character varying NOT NULL,
                "password_hash" character varying,
                "refresh_token_hash" text,
                "role" "public"."account_role_enum" NOT NULL DEFAULT 'user',
                "survey" jsonb,
                "is_active" boolean NOT NULL DEFAULT true,
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMPTZ,
                CONSTRAINT "UQ_4c8f96ccf523e9a3faefd5bdd4c" UNIQUE ("email"),
                CONSTRAINT "PK_54115ee388cdb6d86bb4bf5b2ea" PRIMARY KEY ("id")
            )`
        );
        await queryRunner.query(
            `CREATE TABLE "address" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "street" character varying NOT NULL,
                "ward" character varying NOT NULL,
                "district" character varying NOT NULL,
                "city_or_province" character varying NOT NULL,
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMPTZ,
                CONSTRAINT "PK_d92de1f82754668b5f5f5dd4fd5" PRIMARY KEY ("id")
            )`
        );
        await queryRunner.query(
            `CREATE TABLE "user_profile" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "first_name" character varying,
                "last_name" character varying,
                "phone" character varying,
                "bio" text,
                "date_of_birth" date,
                "profile_completed" boolean NOT NULL DEFAULT false,
                "is_used" boolean NOT NULL DEFAULT false,
                "account_id" uuid,
                "address_id" uuid,
                "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMPTZ,
                CONSTRAINT "REL_b0da23332d347bef77f1f4d1e1" UNIQUE ("account_id"),
                CONSTRAINT "REL_0850f469e017ce01896d785950" UNIQUE ("address_id"),
                CONSTRAINT "PK_f44d0cd18cfd80b0fed7806c3b7" PRIMARY KEY ("id")
            )`
        );
        
        // Add FK constraints
        await queryRunner.query(
            `ALTER TABLE "user_profile" ADD CONSTRAINT "FK_b0da23332d347bef77f1f4d1e1c" FOREIGN KEY ("account_id") REFERENCES "account"("id") ON DELETE CASCADE ON UPDATE NO ACTION`
        );
        await queryRunner.query(
            `ALTER TABLE "user_profile" ADD CONSTRAINT "FK_0850f469e017ce01896d785950c" FOREIGN KEY ("address_id") REFERENCES "address"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`
        );

        // Add indexes for FK columns (required for performance)
        await queryRunner.createIndex("user_profile", new TableIndex({
            name: "IDX_USER_PROFILE_ACCOUNT_ID",
            columnNames: ["account_id"]
        }));
        await queryRunner.createIndex("user_profile", new TableIndex({
            name: "IDX_USER_PROFILE_ADDRESS_ID",
            columnNames: ["address_id"]
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop indexes first
        await queryRunner.dropIndex("user_profile", "IDX_USER_PROFILE_ADDRESS_ID");
        await queryRunner.dropIndex("user_profile", "IDX_USER_PROFILE_ACCOUNT_ID");
        
        // Drop FK constraints
        await queryRunner.query(`ALTER TABLE "user_profile" DROP CONSTRAINT "FK_0850f469e017ce01896d785950c"`);
        await queryRunner.query(`ALTER TABLE "user_profile" DROP CONSTRAINT "FK_b0da23332d347bef77f1f4d1e1c"`);
        
        // Drop tables
        await queryRunner.query(`DROP TABLE "user_profile"`);
        await queryRunner.query(`DROP TABLE "address"`);
        await queryRunner.query(`DROP TABLE "account"`);
    }

}
