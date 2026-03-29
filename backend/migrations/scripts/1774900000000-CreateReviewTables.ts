import { MigrationInterface, QueryRunner, Table, TableForeignKey, TableIndex, TableUnique } from "typeorm";

export class CreateReviewTables1774900000000 implements MigrationInterface {
    name = 'CreateReviewTables1774900000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ------------------------------------------------------------------
        // 1. CREATE TABLE: treatment_reviews
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "treatment_reviews",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "appointment_id", type: "uuid" },
                { name: "user_id", type: "uuid" },
                { name: "rating", type: "int" },
                { name: "comment", type: "text", isNullable: true },
                { name: "tags", type: "jsonb", default: "'[]'" },
                { name: "photo_urls", type: "jsonb", default: "'[]'" },
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
            ]
        }), true);

        // Unique constraint: one treatment review per appointment
        await queryRunner.createUniqueConstraint("treatment_reviews", new TableUnique({
            name: "UQ_TREATMENT_REVIEWS_APPOINTMENT_ID",
            columnNames: ["appointment_id"],
        }));

        // Indexes
        await queryRunner.createIndex("treatment_reviews", new TableIndex({
            name: "IDX_TREATMENT_REVIEWS_APPOINTMENT_ID",
            columnNames: ["appointment_id"],
        }));

        await queryRunner.createIndex("treatment_reviews", new TableIndex({
            name: "IDX_TREATMENT_REVIEWS_USER_ID",
            columnNames: ["user_id"],
        }));

        // Foreign keys
        await queryRunner.createForeignKey("treatment_reviews", new TableForeignKey({
            name: "FK_TREATMENT_REVIEWS_BOOKING",
            columnNames: ["appointment_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "bookings",
            onDelete: "CASCADE",
        }));

        await queryRunner.createForeignKey("treatment_reviews", new TableForeignKey({
            name: "FK_TREATMENT_REVIEWS_ACCOUNT",
            columnNames: ["user_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "account",
            onDelete: "CASCADE",
        }));

        // ------------------------------------------------------------------
        // 2. CREATE TABLE: specialist_reviews
        // ------------------------------------------------------------------
        await queryRunner.createTable(new Table({
            name: "specialist_reviews",
            columns: [
                {
                    name: "id",
                    type: "uuid",
                    isPrimary: true,
                    isGenerated: true,
                    generationStrategy: "uuid",
                    default: "uuid_generate_v4()",
                },
                { name: "appointment_id", type: "uuid" },
                { name: "specialist_id", type: "uuid" },
                { name: "user_id", type: "uuid" },
                { name: "rating", type: "int" },
                { name: "comment", type: "text", isNullable: true },
                { name: "tags", type: "jsonb", default: "'[]'" },
                { name: "would_recommend", type: "boolean", default: true },
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
            ]
        }), true);

        // Unique constraint: one specialist review per appointment
        await queryRunner.createUniqueConstraint("specialist_reviews", new TableUnique({
            name: "UQ_SPECIALIST_REVIEWS_APPOINTMENT_ID",
            columnNames: ["appointment_id"],
        }));

        // Indexes
        await queryRunner.createIndex("specialist_reviews", new TableIndex({
            name: "IDX_SPECIALIST_REVIEWS_APPOINTMENT_ID",
            columnNames: ["appointment_id"],
        }));

        await queryRunner.createIndex("specialist_reviews", new TableIndex({
            name: "IDX_SPECIALIST_REVIEWS_SPECIALIST_ID",
            columnNames: ["specialist_id"],
        }));

        await queryRunner.createIndex("specialist_reviews", new TableIndex({
            name: "IDX_SPECIALIST_REVIEWS_USER_ID",
            columnNames: ["user_id"],
        }));

        // Foreign keys
        await queryRunner.createForeignKey("specialist_reviews", new TableForeignKey({
            name: "FK_SPECIALIST_REVIEWS_BOOKING",
            columnNames: ["appointment_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "bookings",
            onDelete: "CASCADE",
        }));

        await queryRunner.createForeignKey("specialist_reviews", new TableForeignKey({
            name: "FK_SPECIALIST_REVIEWS_EMPLOYEE",
            columnNames: ["specialist_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "employees",
            onDelete: "CASCADE",
        }));

        await queryRunner.createForeignKey("specialist_reviews", new TableForeignKey({
            name: "FK_SPECIALIST_REVIEWS_ACCOUNT",
            columnNames: ["user_id"],
            referencedColumnNames: ["id"],
            referencedTableName: "account",
            onDelete: "CASCADE",
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order

        // 2. specialist_reviews
        await queryRunner.dropForeignKey("specialist_reviews", "FK_SPECIALIST_REVIEWS_ACCOUNT");
        await queryRunner.dropForeignKey("specialist_reviews", "FK_SPECIALIST_REVIEWS_EMPLOYEE");
        await queryRunner.dropForeignKey("specialist_reviews", "FK_SPECIALIST_REVIEWS_BOOKING");
        await queryRunner.dropIndex("specialist_reviews", "IDX_SPECIALIST_REVIEWS_USER_ID");
        await queryRunner.dropIndex("specialist_reviews", "IDX_SPECIALIST_REVIEWS_SPECIALIST_ID");
        await queryRunner.dropIndex("specialist_reviews", "IDX_SPECIALIST_REVIEWS_APPOINTMENT_ID");
        await queryRunner.dropUniqueConstraint("specialist_reviews", "UQ_SPECIALIST_REVIEWS_APPOINTMENT_ID");
        await queryRunner.dropTable("specialist_reviews", true);

        // 1. treatment_reviews
        await queryRunner.dropForeignKey("treatment_reviews", "FK_TREATMENT_REVIEWS_ACCOUNT");
        await queryRunner.dropForeignKey("treatment_reviews", "FK_TREATMENT_REVIEWS_BOOKING");
        await queryRunner.dropIndex("treatment_reviews", "IDX_TREATMENT_REVIEWS_USER_ID");
        await queryRunner.dropIndex("treatment_reviews", "IDX_TREATMENT_REVIEWS_APPOINTMENT_ID");
        await queryRunner.dropUniqueConstraint("treatment_reviews", "UQ_TREATMENT_REVIEWS_APPOINTMENT_ID");
        await queryRunner.dropTable("treatment_reviews", true);
    }
}
