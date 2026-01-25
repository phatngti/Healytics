import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateLegalRepresentativeTable1766323100000 implements MigrationInterface {
    name = 'CreateLegalRepresentativeTable1766323100000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Create id type enum
        await queryRunner.query(`
            DO $$ BEGIN
                CREATE TYPE "public"."legal_representative_id_type_enum" AS ENUM('CITIZEN_ID', 'PASSPORT', 'MILITARY_ID');
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);

        // Create legal_representative table
        await queryRunner.query(`
            CREATE TABLE IF NOT EXISTS "legal_representative" (
                "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
                "full_name" character varying(150) NOT NULL,
                "position" character varying(100) NOT NULL,
                "id_type" "public"."legal_representative_id_type_enum" NOT NULL,
                "id_number" character varying(20) NOT NULL,
                "id_issue_date" date NOT NULL,
                "id_front_img_url" text NOT NULL,
                "id_back_img_url" text NOT NULL,
                "is_authorized_user" boolean NOT NULL DEFAULT false,
                "auth_letter_doc_url" text,
                "phone_number" character varying(20),
                "partner_id" uuid NOT NULL,
                "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "updated_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                "deleted_at" TIMESTAMP WITH TIME ZONE,
                CONSTRAINT "PK_legal_representative" PRIMARY KEY ("id"),
                CONSTRAINT "UQ_legal_representative_partner" UNIQUE ("partner_id")
            )
        `);

        // Add foreign key constraint to health_partner_profile
        await queryRunner.query(`
            DO $$ BEGIN
                ALTER TABLE "legal_representative"
                ADD CONSTRAINT "FK_legal_representative_partner"
                FOREIGN KEY ("partner_id")
                REFERENCES "health_partner_profile"("id")
                ON DELETE CASCADE ON UPDATE NO ACTION;
            EXCEPTION
                WHEN duplicate_object THEN null;
            END $$;
        `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "legal_representative" DROP CONSTRAINT IF EXISTS "FK_legal_representative_partner"`);
        await queryRunner.query(`DROP TABLE IF EXISTS "legal_representative"`);
        await queryRunner.query(`DROP TYPE IF EXISTS "public"."legal_representative_id_type_enum"`);
    }
}
