import { MigrationInterface, QueryRunner } from 'typeorm';

export class CreateUserFollowWishlistTables1777300000000 implements MigrationInterface {
  name = 'CreateUserFollowWishlistTables1777300000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE TABLE "user_clinic_follows" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "user_id" uuid NOT NULL,
        "partner_id" uuid NOT NULL,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_user_clinic_follows" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(
      `CREATE UNIQUE INDEX "IDX_UCF_USER_PARTNER" ON "user_clinic_follows" ("user_id", "partner_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_UCF_PARTNER_ID" ON "user_clinic_follows" ("partner_id")`,
    );
    await queryRunner.query(`
      ALTER TABLE "user_clinic_follows"
      ADD CONSTRAINT "FK_user_clinic_follows_user"
      FOREIGN KEY ("user_id") REFERENCES "account"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);
    await queryRunner.query(`
      ALTER TABLE "user_clinic_follows"
      ADD CONSTRAINT "FK_user_clinic_follows_partner"
      FOREIGN KEY ("partner_id") REFERENCES "health_partner_profile"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);

    await queryRunner.query(`
      CREATE TABLE "user_wishlist_items" (
        "id" uuid DEFAULT uuid_generate_v4() NOT NULL,
        "user_id" uuid NOT NULL,
        "product_id" uuid NOT NULL,
        "created_at" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
        CONSTRAINT "PK_user_wishlist_items" PRIMARY KEY ("id")
      )
    `);
    await queryRunner.query(
      `CREATE UNIQUE INDEX "IDX_UWI_USER_PRODUCT" ON "user_wishlist_items" ("user_id", "product_id")`,
    );
    await queryRunner.query(
      `CREATE INDEX "IDX_UWI_PRODUCT_ID" ON "user_wishlist_items" ("product_id")`,
    );
    await queryRunner.query(`
      ALTER TABLE "user_wishlist_items"
      ADD CONSTRAINT "FK_user_wishlist_items_user"
      FOREIGN KEY ("user_id") REFERENCES "account"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);
    await queryRunner.query(`
      ALTER TABLE "user_wishlist_items"
      ADD CONSTRAINT "FK_user_wishlist_items_product"
      FOREIGN KEY ("product_id") REFERENCES "products"("id")
      ON DELETE CASCADE ON UPDATE NO ACTION
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "user_wishlist_items" DROP CONSTRAINT "FK_user_wishlist_items_product"`,
    );
    await queryRunner.query(
      `ALTER TABLE "user_wishlist_items" DROP CONSTRAINT "FK_user_wishlist_items_user"`,
    );
    await queryRunner.query(`DROP INDEX "IDX_UWI_PRODUCT_ID"`);
    await queryRunner.query(`DROP INDEX "IDX_UWI_USER_PRODUCT"`);
    await queryRunner.query(`DROP TABLE "user_wishlist_items"`);

    await queryRunner.query(
      `ALTER TABLE "user_clinic_follows" DROP CONSTRAINT "FK_user_clinic_follows_partner"`,
    );
    await queryRunner.query(
      `ALTER TABLE "user_clinic_follows" DROP CONSTRAINT "FK_user_clinic_follows_user"`,
    );
    await queryRunner.query(`DROP INDEX "IDX_UCF_PARTNER_ID"`);
    await queryRunner.query(`DROP INDEX "IDX_UCF_USER_PARTNER"`);
    await queryRunner.query(`DROP TABLE "user_clinic_follows"`);
  }
}
