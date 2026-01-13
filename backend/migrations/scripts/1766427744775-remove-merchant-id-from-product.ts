import { MigrationInterface, QueryRunner } from "typeorm";

export class RemoveMerchantIdFromProduct1766427744775 implements MigrationInterface {
    name = 'RemoveMerchantIdFromProduct1766427744775'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX IF EXISTS "public"."IDX_PRODUCT_MERCHANT_SLUG"`);
        await queryRunner.query(`ALTER TABLE "products" DROP COLUMN IF EXISTS "merchant_id"`);
        await queryRunner.query(`CREATE INDEX "IDX_PRODUCT_MERCHANT_SLUG" ON "products" ("slug") `);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP INDEX "public"."IDX_PRODUCT_MERCHANT_SLUG"`);
        await queryRunner.query(`ALTER TABLE "products" ADD "merchant_id" uuid NOT NULL`);
        await queryRunner.query(`CREATE INDEX "IDX_PRODUCT_MERCHANT_SLUG" ON "products" ("merchant_id", "slug") `);
    }

}
