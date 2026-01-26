import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateLocationTable1769427300000 implements MigrationInterface {
    name = 'CreateLocationTable1769427300000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."location_level_enum" AS ENUM('PROVINCE', 'DISTRICT', 'WARD')`);
        await queryRunner.query(`CREATE TABLE "location" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "code" character varying(10) NOT NULL, "name" character varying(100) NOT NULL, "name_en" character varying(100), "full_name" character varying(150) NOT NULL, "full_name_en" character varying(150), "code_name" character varying(100), "level" "public"."location_level_enum" NOT NULL, "mpath" character varying DEFAULT '', "parentId" uuid, CONSTRAINT "UQ_LOCATION_CODE" UNIQUE ("code"), CONSTRAINT "PK_LOCATION" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_LOCATION_CODE" ON "location" ("code")`);
        await queryRunner.query(`ALTER TABLE "location" ADD CONSTRAINT "FK_LOCATION_PARENT_ID" FOREIGN KEY ("parentId") REFERENCES "location"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "location" DROP CONSTRAINT "FK_LOCATION_PARENT_ID"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_LOCATION_CODE"`);
        await queryRunner.query(`DROP TABLE "location"`);
        await queryRunner.query(`DROP TYPE "public"."location_level_enum"`);
    }
}
