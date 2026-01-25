import { MigrationInterface, QueryRunner } from 'typeorm';

export class MigrateBusinessEntityToHealthPartnerProfile1737251227000
    implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        // Step 1: Drop existing health_partner_profile table if it has old structure
        await queryRunner.query(`DROP TABLE IF EXISTS health_partner_profile CASCADE;`);

        // Step 2: Rename business_entity to health_partner_profile
        await queryRunner.query(`ALTER TABLE business_entity RENAME TO health_partner_profile;`);

        // Step 3: Update foreign key column names in related tables

        // Update partner_document table
        await queryRunner.query(`
            ALTER TABLE partner_document 
            RENAME COLUMN business_entity_id TO partner_id;
        `);

        // Update legal_representative table
        await queryRunner.query(`
            ALTER TABLE legal_representative 
            RENAME COLUMN business_entity_id TO partner_id;
        `);

        // Step 4: Update constraint names for clarity (optional but recommended)
        // Note: TypeORM will recreate constraints based on entity definitions
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Rollback: Rename back to business_entity
        await queryRunner.query(`ALTER TABLE health_partner_profile RENAME TO business_entity;`);

        // Rollback: Restore foreign key column names
        await queryRunner.query(`
            ALTER TABLE partner_document 
            RENAME COLUMN partner_id TO business_entity_id;
        `);

        await queryRunner.query(`
            ALTER TABLE legal_representative 
            RENAME COLUMN partner_id TO business_entity_id;
        `);
    }
}
