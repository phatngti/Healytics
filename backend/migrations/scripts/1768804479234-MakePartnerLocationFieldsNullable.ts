import { MigrationInterface, QueryRunner } from "typeorm";

export class MakePartnerLocationFieldsNullable1768804479234 implements MigrationInterface {
    name = 'MakePartnerLocationFieldsNullable1768804479234'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_aa49b97e7d565a79ed2a81ca9a0"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_c844e3d3d3b7be6c48e7b3a6a2f"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_8a66f166bee8a99711c7e5cb252"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "province_id" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "district_id" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "ward_id" DROP NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_8a66f166bee8a99711c7e5cb252" FOREIGN KEY ("province_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_c844e3d3d3b7be6c48e7b3a6a2f" FOREIGN KEY ("district_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_aa49b97e7d565a79ed2a81ca9a0" FOREIGN KEY ("ward_id") REFERENCES "location"("id") ON DELETE SET NULL ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_aa49b97e7d565a79ed2a81ca9a0"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_c844e3d3d3b7be6c48e7b3a6a2f"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" DROP CONSTRAINT "FK_8a66f166bee8a99711c7e5cb252"`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "ward_id" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "district_id" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ALTER COLUMN "province_id" SET NOT NULL`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_8a66f166bee8a99711c7e5cb252" FOREIGN KEY ("province_id") REFERENCES "location"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_c844e3d3d3b7be6c48e7b3a6a2f" FOREIGN KEY ("district_id") REFERENCES "location"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "health_partner_profile" ADD CONSTRAINT "FK_aa49b97e7d565a79ed2a81ca9a0" FOREIGN KEY ("ward_id") REFERENCES "location"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

}
