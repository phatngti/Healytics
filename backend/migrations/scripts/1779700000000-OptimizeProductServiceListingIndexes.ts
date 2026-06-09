import { MigrationInterface, QueryRunner } from 'typeorm';

export class OptimizeProductServiceListingIndexes1779700000000 implements MigrationInterface {
  name = 'OptimizeProductServiceListingIndexes1779700000000';

  transaction = false;

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_TYPE_CREATED"
      ON "products" ("type", "created_at" DESC, "id" DESC)
      WHERE "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_CREATED"
      ON "products" ("created_at" DESC, "id" DESC)
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_CATEGORY_CREATED"
      ON "products" ("category_id", "created_at" DESC, "id" DESC)
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_CATEGORY_CREATED"
      ON "products" ("category_id", "created_at" DESC, "id" DESC)
      WHERE "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CREATED"
      ON "products" ("partner_id", "created_at" DESC, "id" DESC)
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CATEGORY_CREATED"
      ON "products" ("partner_id", "category_id", "created_at" DESC, "id" DESC)
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PARTNER_CREATED"
      ON "products" ("partner_id", "created_at" DESC, "id" DESC)
      WHERE "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_PRICE"
      ON "products" ((COALESCE("sale_price", "base_price")), "id")
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_CATEGORY_PRICE"
      ON "products" (
        "category_id",
        (COALESCE("sale_price", "base_price")),
        "id"
      )
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_PRICE"
      ON "products" (
        "partner_id",
        (COALESCE("sale_price", "base_price")),
        "id"
      )
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CATEGORY_PRICE"
      ON "products" (
        "partner_id",
        "category_id",
        (COALESCE("sale_price", "base_price")),
        "id"
      )
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCTS_PUBLIC_DISCOUNT_CREATED"
      ON "products" ("partner_id", "created_at" DESC, "id" DESC)
      WHERE "status" = 'active'
        AND "is_visible_online" = true
        AND "sale_price" IS NOT NULL
        AND "sale_price" < "base_price"
        AND "deleted_at" IS NULL
    `);

    await queryRunner.query(`
      CREATE INDEX CONCURRENTLY IF NOT EXISTS "IDX_PRODUCT_DEFINITIONS_DURATION_PRODUCT"
      ON "product_definitions" ("duration_minutes", "product_id")
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCT_DEFINITIONS_DURATION_PRODUCT"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_DISCOUNT_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CATEGORY_PRICE"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_PRICE"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_CATEGORY_PRICE"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_PRICE"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PARTNER_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CATEGORY_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_PARTNER_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_CATEGORY_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_CATEGORY_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_PUBLIC_CREATED"`,
    );
    await queryRunner.query(
      `DROP INDEX CONCURRENTLY IF EXISTS "IDX_PRODUCTS_TYPE_CREATED"`,
    );
  }
}
