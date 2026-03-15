import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddEmployeeNameFields1766400000000 implements MigrationInterface {
  name = 'AddEmployeeNameFields1766400000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ── employees table ──────────────────────────────────────────
    await queryRunner.query(
      `ALTER TABLE "employees" ADD "first_name" character varying(50)`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" ADD "last_name" character varying(50)`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" ADD "password" character varying(255)`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" ADD "schedule" jsonb`,
    );

    // Backfill: copy fullName → firstName (as-is) for existing rows
    await queryRunner.query(
      `UPDATE "employees" SET "first_name" = "full_name" WHERE "first_name" IS NULL`,
    );

    // ── doctor_profiles table ────────────────────────────────────
    // Convert single medical_license → medical_licenses (jsonb array)
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" ADD "medical_titles" jsonb`,
    );
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" ADD "medical_licenses" jsonb`,
    );

    // Backfill: wrap existing medical_license value into a jsonb array
    await queryRunner.query(
      `UPDATE "doctor_profiles" SET "medical_licenses" = jsonb_build_array("medical_license") WHERE "medical_license" IS NOT NULL`,
    );

    // Drop old column and its unique constraint
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" DROP CONSTRAINT IF EXISTS "UQ_doctor_profiles_medical_license"`,
    );
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" DROP COLUMN IF EXISTS "medical_license"`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // ── doctor_profiles revert ───────────────────────────────────
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" ADD "medical_license" character varying(50)`,
    );
    // Backfill: take first element from medical_licenses array
    await queryRunner.query(
      `UPDATE "doctor_profiles" SET "medical_license" = "medical_licenses"->>0 WHERE "medical_licenses" IS NOT NULL`,
    );
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" DROP COLUMN "medical_licenses"`,
    );
    await queryRunner.query(
      `ALTER TABLE "doctor_profiles" DROP COLUMN "medical_titles"`,
    );

    // ── employees revert ─────────────────────────────────────────
    await queryRunner.query(
      `ALTER TABLE "employees" DROP COLUMN "schedule"`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" DROP COLUMN "password"`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" DROP COLUMN "last_name"`,
    );
    await queryRunner.query(
      `ALTER TABLE "employees" DROP COLUMN "first_name"`,
    );
  }
}
