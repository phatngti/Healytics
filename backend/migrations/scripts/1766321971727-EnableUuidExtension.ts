import { MigrationInterface, QueryRunner } from "typeorm";

export class EnableUuidExtension1766321971727 implements MigrationInterface {
    name = 'EnableUuidExtension1766321971727'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // Enable UUID extension for PostgreSQL (required for uuid_generate_v4())
        await queryRunner.query(`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Note: We don't drop the extension as other tables may depend on it
        // In a real scenario, only drop if you're certain no other dependencies exist
    }
}
