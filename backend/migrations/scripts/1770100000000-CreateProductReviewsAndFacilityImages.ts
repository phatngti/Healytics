import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateProductReviewsAndFacilityImages1770100000000 implements MigrationInterface {
    name = 'CreateProductReviewsAndFacilityImages1770100000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ------------------------------------------------------------------
        // 1. CREATE TABLE: product_reviews
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "product_reviews",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "product_id", type: "uuid" },
                { name: "reviewer_name", type: "varchar", length: "100" },
                { name: "avatar_url", type: "text", isNullable: true },
                { name: "rating", type: "int" },
                { name: "status", type: "varchar", length: "20", default: "'Completed'" },
                { name: "date", type: "timestamptz" },
                { name: "text", type: "text" },
                { name: "image_urls", type: "jsonb", default: "'[]'" },
                // Audit columns
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Index for product_id FK
        await queryRunner.createIndex("product_reviews", new TableIndex({
            name: "IDX_PRODUCT_REVIEWS_PRODUCT_ID",
            columnNames: ["product_id"]
        }));

        // FK: product_reviews -> products
        await queryRunner.createForeignKey("product_reviews", new TableForeignKey({
            name: "FK_PRODUCT_REVIEWS_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: product_facility_images
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "product_facility_images",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "product_id", type: "uuid" },
                { name: "image_url", type: "varchar", length: "500" },
                { name: "label", type: "varchar", length: "100" },
                { name: "sort_order", type: "int", default: 0 },
            ]
        }), true);

        // Index for product_id FK
        await queryRunner.createIndex("product_facility_images", new TableIndex({
            name: "IDX_PRODUCT_FACILITY_IMAGES_PRODUCT_ID",
            columnNames: ["product_id"]
        }));

        // FK: product_facility_images -> products
        await queryRunner.createForeignKey("product_facility_images", new TableForeignKey({
            name: "FK_PRODUCT_FACILITY_IMAGES_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order

        // 2. product_facility_images
        await queryRunner.dropForeignKey("product_facility_images", "FK_PRODUCT_FACILITY_IMAGES_PRODUCT_ID");
        await queryRunner.dropIndex("product_facility_images", "IDX_PRODUCT_FACILITY_IMAGES_PRODUCT_ID");
        await queryRunner.dropTable("product_facility_images", true);

        // 1. product_reviews
        await queryRunner.dropForeignKey("product_reviews", "FK_PRODUCT_REVIEWS_PRODUCT_ID");
        await queryRunner.dropIndex("product_reviews", "IDX_PRODUCT_REVIEWS_PRODUCT_ID");
        await queryRunner.dropTable("product_reviews", true);
    }
}
