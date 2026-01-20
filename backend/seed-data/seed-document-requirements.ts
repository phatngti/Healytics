import { DataSource } from 'typeorm';
import { config } from 'dotenv';
import 'reflect-metadata';
import { seedDocumentRequirements } from '../src/partners/seeds/document-requirements.seed';

config();

const dataSource = new DataSource({
    type: 'postgres',
    host: process.env.POSTGRES_HOST,
    port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
    username: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB,
    entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
    synchronize: true, // Enable to create new tables for document system
});

async function runSeed() {
    console.log('Connecting to database...');
    await dataSource.initialize();
    console.log('Connected!');

    try {
        await seedDocumentRequirements(dataSource);
        console.log('🎉 Seeding completed successfully!');
    } catch (error: any) {
        console.error('❌ Error during seeding:', error.message);
        if (error.stack) console.error(error.stack);
        process.exit(1);
    } finally {
        await dataSource.destroy();
        console.log('🔌 Database connection closed');
    }
}

runSeed();
