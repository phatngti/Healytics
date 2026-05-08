import { MigrationInterface, QueryRunner } from "typeorm";

export class AddOnboardingStatus1769427340000 implements MigrationInterface {
    name = 'AddOnboardingStatus1769427340000'
    public async up(queryRunner: QueryRunner): Promise<void> {
        // ONBOARDING status was removed - this migration is now a no-op.
        // The default verification_status remains 'PENDING'.
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // No-op: ONBOARDING status no longer exists.
    }
}
