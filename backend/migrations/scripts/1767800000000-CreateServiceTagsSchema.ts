import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateServiceTagsSchema1767800000000 implements MigrationInterface {
    name = 'CreateServiceTagsSchema1767800000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ------------------------------------------------------------------
        // 1. CREATE TABLE: service_tags
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "service_tags",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "user_id", type: "uuid" },
                { name: "name", type: "varchar", length: "100" },
                { name: "description", type: "text", isNullable: true },
                { name: "color_value", type: "int", default: 0xFF6366F1 },
                { name: "usage", type: "int", default: 0 },
                { name: "is_active", type: "boolean", default: true },
                { name: "sort_order", type: "int", default: 0 },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Index for user_id FK
        await queryRunner.createIndex("service_tags", new TableIndex({
            name: "IDX_SERVICE_TAGS_USER_ID",
            columnNames: ["user_id"]
        }));

        // FK: service_tags -> account
        await queryRunner.createForeignKey("service_tags", new TableForeignKey({
            name: "FK_SERVICE_TAGS_USER_ID",
            columnNames: ["user_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "account",
            onDelete: "CASCADE"
        }));

        // Composite index for common queries (user + active status)
        await queryRunner.createIndex("service_tags", new TableIndex({
            name: "IDX_SERVICE_TAGS_USER_ACTIVE",
            columnNames: ["user_id", "is_active"]
        }));

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: product_tags (Junction table)
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "product_tags",
            columns: [
                { name: "product_id", type: "uuid", isPrimary: true },
                { name: "tag_id", type: "uuid", isPrimary: true },
                { name: "created_at", type: "timestamptz", default: "now()" },
            ]
        }), true);

        // Index for product_id FK
        await queryRunner.createIndex("product_tags", new TableIndex({
            name: "IDX_PRODUCT_TAGS_PRODUCT_ID",
            columnNames: ["product_id"]
        }));

        // Index for tag_id FK
        await queryRunner.createIndex("product_tags", new TableIndex({
            name: "IDX_PRODUCT_TAGS_TAG_ID",
            columnNames: ["tag_id"]
        }));

        // FK: product_tags -> products
        await queryRunner.createForeignKey("product_tags", new TableForeignKey({
            name: "FK_PRODUCT_TAGS_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // FK: product_tags -> service_tags
        await queryRunner.createForeignKey("product_tags", new TableForeignKey({
            name: "FK_PRODUCT_TAGS_TAG_ID",
            columnNames: ["tag_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "service_tags",
            onDelete: "CASCADE"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop tables in reverse order to avoid FK constraint errors

        // 2. product_tags
        await queryRunner.query("DROP INDEX IF EXISTS product_tags_idx_tag_id");
        await queryRunner.query("DROP INDEX IF EXISTS product_tags_idx_product_id");
        await queryRunner.query("DROP TABLE IF EXISTS product_tags");

        // 1. service_tags
        await queryRunner.query("DROP INDEX IF EXISTS service_tags_idx_user_active");
        await queryRunner.query("DROP INDEX IF EXISTS service_tags_idx_user_id");
        await queryRunner.query("DROP INDEX IF EXISTS service_tags_idx_user_id");
        await queryRunner.query("DROP TABLE IF EXISTS service_tags");
    }
}
