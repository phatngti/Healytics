import { MigrationInterface, QueryRunner, Table, TableForeignKey } from "typeorm";

export class RemoveProductPhysicalDetailsTable1767550540000 implements MigrationInterface {
    name = 'RemoveProductPhysicalDetailsTable1767550540000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if table exists before dropping
        const tableExists = await queryRunner.hasTable("product_physical_details");
        if (tableExists) {
            await queryRunner.dropTable("product_physical_details", true);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Recreate table if it doesn't exist
        const tableExists = await queryRunner.hasTable("product_physical_details");
        if (!tableExists) {
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
        }
    }
}
