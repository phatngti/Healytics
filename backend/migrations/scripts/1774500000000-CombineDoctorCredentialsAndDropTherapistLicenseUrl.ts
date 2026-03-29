import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class CombineDoctorCredentialsAndDropTherapistLicenseUrl1774500000000
  implements MigrationInterface
{
  name = "CombineDoctorCredentialsAndDropTherapistLicenseUrl1774500000000";

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ── 1. doctor_profiles: combine medical_titles + medical_licenses → medical_credentials ──

    // 1a. Add new JSONB column

    const isExistedColumn = await queryRunner.hasColumn("doctor_profiles", "medical_credentials");
    if (!isExistedColumn) {
      await queryRunner.addColumn(
        "doctor_profiles",
        new TableColumn({
          name: "medical_credentials",
          type: "jsonb",
        isNullable: true,
      }),
    );
    }

    // 1b. Migrate existing data: zip the two arrays into [{title, license}]

    if (!isExistedColumn) {
      await queryRunner.query(`
      UPDATE doctor_profiles
      SET medical_credentials = (
        SELECT COALESCE(
          jsonb_agg(
            jsonb_build_object(
              'title',   COALESCE(t.title, ''),
              'license', COALESCE(l.license, '')
            )
          ),
          '[]'::jsonb
        )
        FROM (
          SELECT
            ROW_NUMBER() OVER () AS rn,
            value::text AS title
          FROM jsonb_array_elements_text(COALESCE(medical_titles, '[]'::jsonb))
        ) t
        FULL OUTER JOIN (
          SELECT
            ROW_NUMBER() OVER () AS rn,
            value::text AS license
          FROM jsonb_array_elements_text(COALESCE(medical_licenses, '[]'::jsonb))
        ) l ON t.rn = l.rn
      )
      WHERE medical_titles IS NOT NULL OR medical_licenses IS NOT NULL
    `);
    }

    // 1c. Drop old columns
    if (!isExistedColumn) {
      await queryRunner.dropColumn("doctor_profiles", "medical_titles");
      await queryRunner.dropColumn("doctor_profiles", "medical_licenses");
    }

    // ── 2. therapist_profiles: drop license_url ──
    const isExistedLicenseUrlColumn = await queryRunner.hasColumn("therapist_profiles", "license_url");
    if (isExistedLicenseUrlColumn) {
      await queryRunner.dropColumn("therapist_profiles", "license_url");
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // ── 1. therapist_profiles: restore license_url ──
    await queryRunner.addColumn(
      "therapist_profiles",
      new TableColumn({
        name: "license_url",
        type: "text",
        isNullable: true,
      }),
    );

    // ── 2. doctor_profiles: restore medical_titles + medical_licenses ──
    await queryRunner.addColumn(
      "doctor_profiles",
      new TableColumn({
        name: "medical_titles",
        type: "jsonb",
        isNullable: true,
      }),
    );

    await queryRunner.addColumn(
      "doctor_profiles",
      new TableColumn({
        name: "medical_licenses",
        type: "jsonb",
        isNullable: true,
      }),
    );

    // Extract data back from medical_credentials
    await queryRunner.query(`
      UPDATE doctor_profiles
      SET
        medical_titles = (
          SELECT COALESCE(jsonb_agg(elem->>'title'), '[]'::jsonb)
          FROM jsonb_array_elements(medical_credentials) AS elem
        ),
        medical_licenses = (
          SELECT COALESCE(jsonb_agg(elem->>'license'), '[]'::jsonb)
          FROM jsonb_array_elements(medical_credentials) AS elem
        )
      WHERE medical_credentials IS NOT NULL
    `);

    // Drop the combined column
    await queryRunner.dropColumn("doctor_profiles", "medical_credentials");
  }
}
