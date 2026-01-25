import { MigrationInterface, QueryRunner } from 'typeorm';

export class MigrateBusinessEntityToHealthPartnerProfile1737251227000
    implements MigrationInterface {
    public async up(queryRunner: QueryRunner): Promise<void> {
        // Check if this is a legacy database migration
        const businessEntityExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'business_entity'
            );
        `);

        // If business_entity doesn't exist, this is a fresh database - skip migration
        if (!businessEntityExists[0]?.exists) {
            console.log('No business_entity table found - skipping legacy migration');
            return;
        }

        // Step 1: Drop existing health_partner_profile table if it has old structure
        await queryRunner.query(`DROP TABLE IF EXISTS health_partner_profile CASCADE;`);

        // Step 2: Rename business_entity to health_partner_profile
        await queryRunner.query(`ALTER TABLE business_entity RENAME TO health_partner_profile;`);

        // Step 3: Update foreign key column names in related tables (if they exist)

        // Check and update partner_document table
        const partnerDocumentHasOldColumn = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.columns 
                WHERE table_name = 'partner_document' 
                AND column_name = 'business_entity_id'
            );
        `);

        if (partnerDocumentHasOldColumn[0]?.exists) {
            await queryRunner.query(`
                ALTER TABLE partner_document 
                RENAME COLUMN business_entity_id TO partner_id;
            `);
        }

        // Check and update legal_representative table
        const legalRepHasOldColumn = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.columns 
                WHERE table_name = 'legal_representative' 
                AND column_name = 'business_entity_id'
            );
        `);

        if (legalRepHasOldColumn[0]?.exists) {
            await queryRunner.query(`
                ALTER TABLE legal_representative 
                RENAME COLUMN business_entity_id TO partner_id;
            `);
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Check if we actually ran the migration forward
        const healthPartnerExists = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = 'health_partner_profile'
            );
        `);

        if (!healthPartnerExists[0]?.exists) {
            return; // Nothing to rollback
        }

        // Rollback: Rename back to business_entity
        await queryRunner.query(`ALTER TABLE health_partner_profile RENAME TO business_entity;`);

        // Rollback: Restore foreign key column names if they exist
        const partnerDocumentHasNewColumn = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.columns 
                WHERE table_name = 'partner_document' 
                AND column_name = 'partner_id'
            );
        `);

        if (partnerDocumentHasNewColumn[0]?.exists) {
            await queryRunner.query(`
                ALTER TABLE partner_document 
                RENAME COLUMN partner_id TO business_entity_id;
            `);
        }

        const legalRepHasNewColumn = await queryRunner.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.columns 
                WHERE table_name = 'legal_representative' 
                AND column_name = 'partner_id'
            );
        `);

        if (legalRepHasNewColumn[0]?.exists) {
            await queryRunner.query(`
                ALTER TABLE legal_representative 
                RENAME COLUMN partner_id TO business_entity_id;
            `);
        }
    }
}
