import { MigrationInterface, QueryRunner } from "typeorm";

export class RefactorBusinessTypeToVarchar1770000000000 implements MigrationInterface {
    name = 'RefactorBusinessTypeToVarchar1770000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Alter column from enum to varchar(500)
        // Using USING clause to convert existing enum values to text
        await queryRunner.query(`
            ALTER TABLE "health_partner_profile" 
            ALTER COLUMN "business_type" TYPE varchar(500) 
            USING "business_type"::text
        `);

        // 2. Optionally drop the old enum type if no longer used elsewhere
        // Note: Keeping the enum type in case it's used by document_requirement table
        // await queryRunner.query(`DROP TYPE IF EXISTS "public"."health_partner_profile_business_type_enum"`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Convert back to enum - this will only work if all values are valid enum values
        // For comma-separated values, this will fail, so we take the first value
        await queryRunner.query(`
            ALTER TABLE "health_partner_profile" 
            ALTER COLUMN "business_type" TYPE "public"."health_partner_profile_business_type_enum" 
            USING (SPLIT_PART("business_type", ',', 1))::"public"."health_partner_profile_business_type_enum"
        `);
    }
}
