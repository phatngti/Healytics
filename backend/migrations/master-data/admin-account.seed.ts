import { MigrationInterface, QueryRunner } from 'typeorm';
import * as bcrypt from 'bcryptjs';
import { config } from 'dotenv';

// Ensure .env is loaded when running via TypeORM CLI
config();

const ADMIN_EMAIL = process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn';
const ADMIN_USERNAME = 'admin';
const ADMIN_PASSWORD = process.env.DEFAULT_ADMIN_PASSWORD || 'admin@123';
const ADMIN_ROLE = 'admin'; // matches Role.ADMIN enum value in DB

/**
 * Creates the default admin account if it does not already exist.
 *
 * This runs as part of master-data migrations so the admin account is
 * always available after a fresh `migration:run`, independent of the
 * NestJS seeder pipeline (which is intended for dev/test data).
 *
 * Credentials are read from environment variables:
 *   - DEFAULT_ADMIN_EMAIL   (default: admin@healytics.vn)
 *   - DEFAULT_ADMIN_PASSWORD (default: admin@123)
 */
export class SeedAdminAccount1770100000002 implements MigrationInterface {
    name = 'SeedAdminAccount1770100000002';

    public async up(queryRunner: QueryRunner): Promise<void> {
        console.log('🌱 Seeding default admin account...');

        // Check if the admin account already exists
        const existing = await queryRunner.query(
            `SELECT "id" FROM "account" WHERE "email" = $1 LIMIT 1`,
            [ADMIN_EMAIL],
        );

        if (existing.length > 0) {
            console.log(
                `  ⏭ Admin account "${ADMIN_EMAIL}" already exists, skipping`,
            );
            return;
        }

        // Hash the password using bcryptjs (same as UserSeeder)
        const passwordHash = await bcrypt.hash(ADMIN_PASSWORD, 10);

        await queryRunner.query(
            `INSERT INTO "account"
                ("id", "email", "username", "password_hash", "role", "is_active", "created_at", "updated_at")
             VALUES
                (uuid_generate_v4(), $1, $2, $3, $4, true, NOW(), NOW())`,
            [ADMIN_EMAIL, ADMIN_USERNAME, passwordHash, ADMIN_ROLE],
        );

        console.log(
            `  ✅ Created admin account "${ADMIN_EMAIL}" (role: ${ADMIN_ROLE})`,
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const { rowCount } = await queryRunner.query(
            `DELETE FROM "account" WHERE "email" = $1 AND "role" = $2`,
            [ADMIN_EMAIL, ADMIN_ROLE],
        );

        if (rowCount) {
            console.log(`🗑️ Deleted admin account "${ADMIN_EMAIL}"`);
        } else {
            console.log(`⚠ Admin account "${ADMIN_EMAIL}" not found, nothing to delete`);
        }
    }
}
