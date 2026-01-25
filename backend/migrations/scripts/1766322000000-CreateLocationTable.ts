import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateLocationTable1766322000000 implements MigrationInterface {
    name = 'CreateLocationTable1766322000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create location level enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."location_level_enum" AS ENUM('PROVINCE', 'DISTRICT', 'WARD');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create location table with materialized-path tree structure
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "location" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "code" character varying(10) NOT NULL,
                "name" character varying(100) NOT NULL,
                "name_en" character varying(100),
                "full_name" character varying(150) NOT NULL,
                "full_name_en" character varying(150),
                "code_name" character varying(100),
                "level" "public"."location_level_enum" NOT NULL,
                "mpath" character varying DEFAULT '',
                "parentId" uuid,
                CONSTRAINT "UQ_location_code" UNIQUE ("code"),
                CONSTRAINT "PK_location" PRIMARY KEY ("id")
            )
        `);

        // Create index on code
        await queryRunner.query(`CREATE INDEX IF NOT EXISTS "IDX_location_code" ON "location" ("code")`);

        // Add self-referencing foreign key for tree structure
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "location"
                ADD CONSTRAINT "FK_location_parent"
                FOREIGN KEY ("parentId")
                REFERENCES "location"("id")
                ON DELETE CASCADE ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "location" DROP CONSTRAINT IF EXISTS "FK_location_parent"`);
        await queryRunner.query(`DROP INDEX IF EXISTS "IDX_location_code"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "location"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."location_level_enum"`);
    }
}
