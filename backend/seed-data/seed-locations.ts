import { DataSource } from 'typeorm';
import * as dotenv from 'dotenv';
import { seedLocations } from '../src/locations/seeds/location.seed';

// Load environment variables
dotenv.config();

async function runSeed() {
    // Create data source
    const dataSource = new DataSource({
        type: 'postgres',
        host: process.env.POSTGRES_HOST || 'localhost',
        port: parseInt(process.env.POSTGRES_PORT || '5432', 10),
        username: process.env.POSTGRES_USER,
        password: process.env.POSTGRES_PASSWORD,
        database: process.env.POSTGRES_DB,
        entities: [__dirname + '/../src/**/*.entity{.ts,.js}'],
        synchronize: true, // Enable synchronize to auto-create tables
        logging: false,
    });

    try {
        console.log('🔌 Connecting to database...');
        console.log(`   Host: ${process.env.POSTGRES_HOST}:${process.env.POSTGRES_PORT}`);
        console.log(`   Database: ${process.env.POSTGRES_DB}`);

        await dataSource.initialize();
        console.log('✅ Database connected');
        console.log('🔄 Synchronizing schema (will drop old tables)...\n');

        // Run tree-based seed
        await seedLocations(dataSource);

        console.log('\n✨ Seeding completed successfully!');
    } catch (error) {
        console.error('\n❌ Error during seeding:');
        if (error instanceof Error) {
            console.error('Message:', error.message);
            console.error('Stack:', error.stack);
        } else {
            console.error(error);
        }
        process.exit(1);
    } finally {
        if (dataSource.isInitialized) {
            await dataSource.destroy();
            console.log('🔌 Database connection closed');
        }
    }
}

runSeed();
