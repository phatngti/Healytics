
import { DataSource } from 'typeorm';
import { Partner } from '../src/partners/entities/partner.entity';
import { Account } from '../src/account/entities/account.entity';
import { LegalRepresentative } from '../src/partners/entities/legal-representative.entity';
import { PartnerDocument } from '../src/partners/entities/partner-document.entity';
import { DocumentRequirement } from '../src/partners/entities/document-requirement.entity';
import { Location } from '../src/locations/entities/location.entity';
import { UserProfile } from '../src/account/entities/user-profile.entity';
import * as dotenv from 'dotenv';

dotenv.config();

const AppDataSource = new DataSource({
  type: 'postgres',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  username: process.env.DB_USERNAME || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  database: process.env.DB_NAME || 'healytics_db',
  entities: [
    Partner, Account, LegalRepresentative, PartnerDocument,
    DocumentRequirement, Location, UserProfile
  ],
  synchronize: false,
});

async function run() {
  try {
    console.log('Connecting to database...');
    await AppDataSource.initialize();
    console.log('Connected!');

    console.log('\n--- Table Row Counts ---');

    // 1. Check health_partner_profile (Correct Table)
    const profileCount = await AppDataSource.query('SELECT COUNT(*) FROM health_partner_profile');
    console.log(`health_partner_profile count: ${profileCount[0].count}`);

    // 2. Check business_entity (Old Table? Does it exist?)
    try {
        const businessEntityCount = await AppDataSource.query('SELECT COUNT(*) FROM business_entity');
        console.log(`business_entity count: ${businessEntityCount[0].count}`);
    } catch (e) {
        console.log('business_entity table does not exist (Good).');
    }

    // 3. Check Account
    const accountCount = await AppDataSource.query('SELECT COUNT(*) FROM account');
    console.log(`account count: ${accountCount[0].count}`);

    console.log('\n--- Repository Check ---');
    const partnerRepo = AppDataSource.getRepository(Partner);
    const partners = await partnerRepo.find({ take: 5 });
    console.log(`Repository found ${partners.length} partners.`);
    if (partners.length > 0) {
        console.log('Sample Partner:', JSON.stringify(partners[0], null, 2));
    } else {
        console.log('Repository returned empty list. If manual SQL showed rows, then Entity mapping might be wrong.');
        
        // Debug Schema
        const metadata = AppDataSource.getMetadata(Partner);
        console.log(`Entity ${metadata.name} maps to table: ${metadata.tableName}`);
    }

  } catch (error) {
    console.error('Error:', error);
  } finally {
    await AppDataSource.destroy();
  }
}

run();
