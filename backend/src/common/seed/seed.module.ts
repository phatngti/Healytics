import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SeedService } from './seed.service';
import { Location } from '@/locations/entities/location.entity';
import { DocumentRequirement } from '@/partners/entities/document-requirement.entity';

/**
 * Module that provides auto-seeding functionality on application startup.
 * Seeds locations and document requirements if tables are empty.
 */
@Module({
    imports: [
        TypeOrmModule.forFeature([Location, DocumentRequirement]),
    ],
    providers: [SeedService],
    exports: [SeedService],
})
export class SeedModule { }
