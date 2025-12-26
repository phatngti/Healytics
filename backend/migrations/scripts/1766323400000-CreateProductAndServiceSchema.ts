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
                { name: "parent_id", type: "uuid", isNullable: true }, // Cho phép null nếu là danh mục gốc
                { name: "name", type: "varchar", length: "255" },
                { name: "slug", type: "varchar", length: "255", isUnique: true },
                { name: "description", type: "text", isNullable: true },
                { name: "image_url", type: "varchar", length: "500", isNullable: true },
                { name: "is_active", type: "boolean", default: true },
                { name: "created_at", type: "timestamp", default: "CURRENT_TIMESTAMP" },
                { name: "updated_at", type: "timestamp", default: "CURRENT_TIMESTAMP", onUpdate: "CURRENT_TIMESTAMP" }
            ]
        }), true);

        // Add FK for parent_id (Self-referencing)
        await queryRunner.createForeignKey("categories", new TableForeignKey({
            columnNames: ["parent_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "categories",
            onDelete: "SET NULL" // Nếu xóa cha, con sẽ thành danh mục gốc
        }));

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: resource_types (For Service Requirements like Rooms/Machines)
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
                { name: "total_quantity", type: "int", default: 1 }
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
                { name: "merchant_id", type: "uuid" }, // Giả định hệ thống có multi-tenant
                { name: "category_id", type: "uuid", isNullable: true },
                { name: "name", type: "varchar", length: "255" },
                { name: "slug", type: "varchar", length: "255", isUnique: true },
                { name: "description", type: "text", isNullable: true },
                // Type: 'physical' or 'service'
                { name: "type", type: "varchar", length: "50" }, 
                // Pricing
                { name: "base_price", type: "decimal", precision: 15, scale: 2, default: 0 },
                { name: "sale_price", type: "decimal", precision: 15, scale: 2, isNullable: true },
                { name: "currency", type: "varchar", length: "3", default: "'VND'" },
                // Status & Visibility
                { name: "status", type: "varchar", length: "20", default: "'draft'" }, // draft, active, archived
                { name: "is_visible_online", type: "boolean", default: false },
                { name: "vendor_name", type: "varchar", length: "100", isNullable: true },
                
                { name: "created_at", type: "timestamp", default: "CURRENT_TIMESTAMP" },
                { name: "updated_at", type: "timestamp", default: "CURRENT_TIMESTAMP", onUpdate: "CURRENT_TIMESTAMP" }
            ]
        }), true);

        // Index for faster search
        await queryRunner.createIndex("products", new TableIndex({
            name: "IDX_PRODUCT_MERCHANT_SLUG",
            columnNames: ["merchant_id", "slug"]
        }));

        // FK: Products -> Categories
        await queryRunner.createForeignKey("products", new TableForeignKey({
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
                { name: "media_type", type: "varchar", length: "20", default: "'image'" }, // image, video
                { name: "is_thumbnail", type: "boolean", default: false },
                { name: "sort_order", type: "int", default: 0 }
            ]
        }), true);

        await queryRunner.createForeignKey("product_media", new TableForeignKey({
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE" // Xóa product thì xóa luôn ảnh
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
                { name: "staff_assignment_type", type: "varchar", length: "20", default: "'any'" } // any, specific
            ]
        }), true);

        await queryRunner.createForeignKey("service_definitions", new TableForeignKey({
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // ------------------------------------------------------------------
        // 7. JUNCTION TABLE: service_employee_eligibility (Renamed from service_eligible_staff)
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "service_employee_eligibility",
            columns: [
                { name: "product_id", type: "uuid", isPrimary: true },
                { name: "employee_id", type: "uuid", isPrimary: true }, // Renamed from staff_id to be clearer
                { name: "is_primary", type: "boolean", default: false } // Added from old employee_services table
            ]
        }), true);

        await queryRunner.createForeignKey("service_employee_eligibility", new TableForeignKey({
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        // FK to Employees table (assumes table 'employees' exists from previous migration)
        await queryRunner.createForeignKey("service_employee_eligibility", new TableForeignKey({
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

        await queryRunner.createForeignKey("service_resource_requirements", new TableForeignKey({
            columnNames: ["product_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "products",
            onDelete: "CASCADE"
        }));

        await queryRunner.createForeignKey("service_resource_requirements", new TableForeignKey({
            columnNames: ["resource_type_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "resource_types",
            onDelete: "CASCADE"
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop tables in reverse order to avoid FK constraint errors
        await queryRunner.dropTable("service_resource_requirements");
        await queryRunner.dropTable("service_employee_eligibility");
        await queryRunner.dropTable("service_definitions");
        await queryRunner.dropTable("product_physical_details");
        await queryRunner.dropTable("product_media");
        await queryRunner.dropTable("products"); // Will auto drop FKs linked to it
        await queryRunner.dropTable("resource_types");
        await queryRunner.dropTable("categories");
    }
}
