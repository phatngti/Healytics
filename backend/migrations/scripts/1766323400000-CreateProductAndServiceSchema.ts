import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex } from "typeorm";

export class CreateProductAndServiceSchema1766323400000 implements MigrationInterface {
    name = 'CreateProductAndServiceSchema1766323400000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ------------------------------------------------------------------
        // 1. CREATE TABLE: categories (Self-referencing for hierarchy)
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "categories",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "parent_id", type: "uuid", isNullable: true },
                { name: "name", type: "varchar", length: "255" },
                { name: "slug", type: "varchar", length: "255", isUnique: true },
                { name: "description", type: "text", isNullable: true },
                { name: "image_url", type: "varchar", length: "500", isNullable: true },
                { name: "is_active", type: "boolean", default: true },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Add FK for parent_id (Self-referencing) with named constraint
        await queryRunner.createForeignKey("categories", new TableForeignKey({
            name: "FK_CATEGORIES_PARENT_ID",
            columnNames: ["parent_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "categories",
            onDelete: "SET NULL"
        }));

        // Index for parent_id FK
        await queryRunner.createIndex("categories", new TableIndex({
            name: "IDX_CATEGORIES_PARENT_ID",
            columnNames: ["parent_id"]
        }));

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: resource_types (For Service Requirements)
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "resource_types",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "name", type: "varchar", length: "100" },
                { name: "total_quantity", type: "int", default: 1 },
                // Audit columns
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true },
            ]
        }), true);

        // ------------------------------------------------------------------
        // 3. CREATE TABLE: products (Core Table)
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "products",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "category_id", type: "uuid", isNullable: true },
                { name: "name", type: "varchar", length: "255" },
                { name: "slug", type: "varchar", length: "255", isUnique: true },
                { name: "description", type: "text", isNullable: true },
                { name: "type", type: "varchar", length: "50" }, // 'physical' or 'service'
                // Pricing
                { name: "base_price", type: "decimal", precision: 15, scale: 2, default: 0 },
                { name: "sale_price", type: "decimal", precision: 15, scale: 2, isNullable: true },
                { name: "currency", type: "varchar", length: "3", default: "'VND'" },
                // Status & Visibility
                { name: "status", type: "varchar", length: "20", default: "'draft'" },
                { name: "is_visible_online", type: "boolean", default: false },
                { name: "vendor_name", type: "varchar", length: "100", isNullable: true },
                // Audit columns with timezone (Enterprise Standard)
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }, // Soft Delete
            ]
        }), true);

        // Index for slug search
        await queryRunner.createIndex("products", new TableIndex({
            name: "IDX_PRODUCTS_SLUG",
            columnNames: ["slug"]
        }));

        // Index for category_id FK
        await queryRunner.createIndex("products", new TableIndex({
            name: "IDX_PRODUCTS_CATEGORY_ID",
            columnNames: ["category_id"]
        }));

        // FK: Products -> Categories
        await queryRunner.createForeignKey("products", new TableForeignKey({
            name: "FK_PRODUCTS_CATEGORY_ID",
            columnNames: ["category_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "categories",
            onDelete: "SET NULL"
        }));

        // ------------------------------------------------------------------
        // 4. CREATE TABLE: product_media
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "product_media",
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
                { name: "url", type: "varchar", length: "500" },
                { name: "media_type", type: "varchar", length: "20", default: "'image'" },
                { name: "is_thumbnail", type: "boolean", default: false },
                { name: "sort_order", type: "int", default: 0 }
            ]
        }), true);

        // Index for product_id FK
        await queryRunner.createIndex("product_media", new TableIndex({
            name: "IDX_PRODUCT_MEDIA_PRODUCT_ID",
            columnNames: ["product_id"]
        }));

        await queryRunner.createForeignKey("product_media", new TableForeignKey({
            name: "FK_PRODUCT_MEDIA_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 5. EXTENSION TABLE: product_physical_details
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "product_physical_details",
            columns: [
                { name: "product_id", type: "uuid", isPrimary: true },
                { name: "sku", type: "varchar", length: "50", isUnique: true, isNullable: true },
                { name: "barcode", type: "varchar", length: "100", isNullable: true },
                { name: "stock_quantity", type: "int", default: 0 },
                { name: "cost_per_item", type: "decimal", precision: 15, scale: 2, default: 0 },
                { name: "weight_gram", type: "int", isNullable: true },
                { name: "dimensions", type: "varchar", length: "50", isNullable: true }
            ]
        }), true);

        await queryRunner.createForeignKey("product_physical_details", new TableForeignKey({
            name: "FK_PRODUCT_PHYSICAL_DETAILS_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 6. EXTENSION TABLE: service_definitions
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "service_definitions",
            columns: [
                { name: "product_id", type: "uuid", isPrimary: true },
                { name: "duration_minutes", type: "int" },
                { name: "buffer_minutes", type: "int", default: 0 },
                { name: "max_capacity", type: "int", default: 1 },
                { name: "min_lead_time_hours", type: "int", default: 0 },
                { name: "staff_assignment_type", type: "varchar", length: "20", default: "'any'" }
            ]
        }), true);

        await queryRunner.createForeignKey("service_definitions", new TableForeignKey({
            name: "FK_SERVICE_DEFINITIONS_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 7. JUNCTION TABLE: service_employee_eligibility
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "service_employee_eligibility",
            columns: [
                { name: "product_id", type: "uuid", isPrimary: true },
                { name: "employee_id", type: "uuid", isPrimary: true },
                { name: "is_primary", type: "boolean", default: false }
            ]
        }), true);

        // Indexes for junction table FKs
        await queryRunner.createIndex("service_employee_eligibility", new TableIndex({
            name: "IDX_SERVICE_EMPLOYEE_PRODUCT_ID",
            columnNames: ["product_id"]
        }));
        await queryRunner.createIndex("service_employee_eligibility", new TableIndex({
            name: "IDX_SERVICE_EMPLOYEE_EMPLOYEE_ID",
            columnNames: ["employee_id"]
        }));

        await queryRunner.createForeignKey("service_employee_eligibility", new TableForeignKey({
            name: "FK_SERVICE_EMPLOYEE_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        await queryRunner.createForeignKey("service_employee_eligibility", new TableForeignKey({
            name: "FK_SERVICE_EMPLOYEE_EMPLOYEE_ID",
            columnNames: ["employee_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 8. JUNCTION TABLE: service_resource_requirements
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "service_resource_requirements",
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
                { name: "resource_type_id", type: "uuid" },
                { name: "quantity_required", type: "int", default: 1 }
            ]
        }), true);

        // Indexes for FKs
        await queryRunner.createIndex("service_resource_requirements", new TableIndex({
            name: "IDX_SERVICE_RESOURCE_PRODUCT_ID",
            columnNames: ["product_id"]
        }));
        await queryRunner.createIndex("service_resource_requirements", new TableIndex({
            name: "IDX_SERVICE_RESOURCE_TYPE_ID",
            columnNames: ["resource_type_id"]
        }));

        await queryRunner.createForeignKey("service_resource_requirements", new TableForeignKey({
            name: "FK_SERVICE_RESOURCE_PRODUCT_ID",
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        await queryRunner.createForeignKey("service_resource_requirements", new TableForeignKey({
            name: "FK_SERVICE_RESOURCE_TYPE_ID",
            columnNames: ["resource_type_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "resource_types",
            onDelete: "CASCADE"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop tables in reverse order to avoid FK constraint errors
        
        // 8. service_resource_requirements
        await queryRunner.dropForeignKey("service_resource_requirements", "FK_SERVICE_RESOURCE_TYPE_ID");
        await queryRunner.dropForeignKey("service_resource_requirements", "FK_SERVICE_RESOURCE_PRODUCT_ID");
        await queryRunner.dropIndex("service_resource_requirements", "IDX_SERVICE_RESOURCE_TYPE_ID");
        await queryRunner.dropIndex("service_resource_requirements", "IDX_SERVICE_RESOURCE_PRODUCT_ID");
        await queryRunner.dropTable("service_resource_requirements");

        // 7. service_employee_eligibility
        await queryRunner.dropForeignKey("service_employee_eligibility", "FK_SERVICE_EMPLOYEE_EMPLOYEE_ID");
        await queryRunner.dropForeignKey("service_employee_eligibility", "FK_SERVICE_EMPLOYEE_PRODUCT_ID");
        await queryRunner.dropIndex("service_employee_eligibility", "IDX_SERVICE_EMPLOYEE_EMPLOYEE_ID");
        await queryRunner.dropIndex("service_employee_eligibility", "IDX_SERVICE_EMPLOYEE_PRODUCT_ID");
        await queryRunner.dropTable("service_employee_eligibility");

        // 6. service_definitions
        await queryRunner.dropForeignKey("service_definitions", "FK_SERVICE_DEFINITIONS_PRODUCT_ID");
        await queryRunner.dropTable("service_definitions");

        // 5. product_physical_details
        await queryRunner.dropForeignKey("product_physical_details", "FK_PRODUCT_PHYSICAL_DETAILS_PRODUCT_ID");
        await queryRunner.dropTable("product_physical_details");

        // 4. product_media
        await queryRunner.dropForeignKey("product_media", "FK_PRODUCT_MEDIA_PRODUCT_ID");
        await queryRunner.dropIndex("product_media", "IDX_PRODUCT_MEDIA_PRODUCT_ID");
        await queryRunner.dropTable("product_media");

        // 3. products
        await queryRunner.dropForeignKey("products", "FK_PRODUCTS_CATEGORY_ID");
        await queryRunner.dropIndex("products", "IDX_PRODUCTS_CATEGORY_ID");
        await queryRunner.dropIndex("products", "IDX_PRODUCTS_SLUG");
        await queryRunner.dropTable("products");

        // 2. resource_types
        await queryRunner.dropTable("resource_types");

        // 1. categories
        await queryRunner.dropIndex("categories", "IDX_CATEGORIES_PARENT_ID");
        await queryRunner.dropForeignKey("categories", "FK_CATEGORIES_PARENT_ID");
        await queryRunner.dropTable("categories");
    }
}
