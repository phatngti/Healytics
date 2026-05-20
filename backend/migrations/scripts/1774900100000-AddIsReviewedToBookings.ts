import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AddIsReviewedToBookings1774900100000 implements MigrationInterface {
    name = 'AddIsReviewedToBookings1774900100000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.addColumn("bookings", new TableColumn({
            name: "is_reviewed",
            type: "boolean",
            default: false,
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropColumn("bookings", "is_reviewed");
    }
}
