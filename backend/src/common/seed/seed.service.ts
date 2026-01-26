import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { InjectRepository, InjectDataSource } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { Location } from '@/locations/entities/location.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';
import { seedLocations } from '@/locations/seeds/location.seed';
import { seedDocumentRequirements } from '@/partners/seeds/document-requirements.seed';

/**
 * Service that automatically seeds essential data on application startup.
 * Only seeds if the tables are empty to avoid duplicate data.
 */
@Injectable()
export class SeedService implements OnModuleInit {
    private readonly logger = new Logger(SeedService.name);

    constructor(
        @InjectRepository(Location)
        private readonly locationRepository: Repository<Location>,
        @InjectRepository(DocumentRequirement)
        private readonly documentRequirementRepository: Repository<DocumentRequirement>,
        @InjectDataSource()
        private readonly dataSource: DataSource,
    ) { }

    async onModuleInit() {
        this.logger.log('🌱 Checking if seeding is needed...');
        await this.seedLocationsIfEmpty();
        await this.seedDocumentRequirementsIfEmpty();
    }

    private async seedLocationsIfEmpty() {
        try {
            const count = await this.locationRepository.count();
            if (count === 0) {
                this.logger.log('📍 Location table is empty. Starting seed...');
                await seedLocations(this.dataSource);
                this.logger.log('✅ Locations seeded successfully!');
            } else {
                this.logger.log(`📍 Locations already exist (${count} records). Skipping seed.`);
            }
        } catch (error) {
            this.logger.error('❌ Failed to seed locations:', error.message);
        }
    }

    private async seedDocumentRequirementsIfEmpty() {
        try {
            const count = await this.documentRequirementRepository.count();
            if (count === 0) {
                this.logger.log('📄 Document requirements table is empty. Starting seed...');
                await seedDocumentRequirements(this.dataSource);
                this.logger.log('✅ Document requirements seeded successfully!');
            } else {
                this.logger.log(`📄 Document requirements already exist (${count} records). Skipping seed.`);
            }
        } catch (error) {
            this.logger.error('❌ Failed to seed document requirements:', error.message);
        }
    }
}
