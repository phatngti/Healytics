import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateAccountTables1766322617959 implements MigrationInterface {
    name = 'CreateAccountTables1766322617959'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(
            `CREATE TABLE "account" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "email" character varying NOT NULL,
                "passwordHash" character varying,
                "refreshTokenHash" text,
                "role" "public"."account_role_enum" NOT NULL DEFAULT 'user',
                "survey" jsonb,
                "isActive" boolean NOT NULL DEFAULT true,
                "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
                "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
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
                "cityOrProvince" character varying NOT NULL,
                CONSTRAINT "PK_d92de1f82754668b5f5f5dd4fd5" PRIMARY KEY ("id")
            )`
        );
        await queryRunner.query(
            `CREATE TABLE "user_profile" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "firstName" character varying,
                "lastName" character varying,
                "phone" character varying,
                "bio" text,
                "dateOfBirth" date,
                "profileCompleted" boolean NOT NULL DEFAULT false,
                "isUsed" boolean NOT NULL DEFAULT false,
                "accountId" uuid,
                "addressId" uuid,
                CONSTRAINT "REL_b0da23332d347bef77f1f4d1e1" UNIQUE ("accountId"),
                CONSTRAINT "REL_0850f469e017ce01896d785950" UNIQUE ("addressId"),
                CONSTRAINT "PK_f44d0cd18cfd80b0fed7806c3b7" PRIMARY KEY ("id")
            )`
        );
        await queryRunner.query(
            `ALTER TABLE "user_profile" ADD CONSTRAINT "FK_b0da23332d347bef77f1f4d1e1c" FOREIGN KEY ("accountId") REFERENCES "account"("id") ON DELETE CASCADE ON UPDATE NO ACTION`
        );
        await queryRunner.query(
            `ALTER TABLE "user_profile" ADD CONSTRAINT "FK_0850f469e017ce01896d785950c" FOREIGN KEY ("addressId") REFERENCES "address"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "user_profile" DROP CONSTRAINT "FK_0850f469e017ce01896d785950c"`);
        await queryRunner.query(`ALTER TABLE "user_profile" DROP CONSTRAINT "FK_b0da23332d347bef77f1f4d1e1c"`);
        await queryRunner.query(`DROP TABLE "user_profile"`);
        await queryRunner.query(`DROP TABLE "address"`);
        await queryRunner.query(`DROP TABLE "account"`);
    }

}
