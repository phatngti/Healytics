import { Injectable, Logger } from '@nestjs/common';
import { UserSeeder } from './users/user.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { ISeeder } from './seeder.interface';

/**
 * Orchestrates seed execution order.
 * Seeders are run sequentially to respect cross-module dependencies.
 *
 * Dependency graph:
 *   UserSeeder       ← no deps
 *   CategorySeeder   ← no deps
 *   EmployeeSeeder   ← no deps
 *   ServiceTagSeeder ← depends on Account (UserSeeder)
 *   ProductSeeder    ← depends on Category, ServiceTag, Employee, ResourceType
 *   PartnerSeeder    ← depends on Account (UserSeeder)
 */
@Injectable()
export class SeederService {
  private readonly logger = new Logger(SeederService.name);
  private readonly seeders: ISeeder[];

  constructor(
    private readonly userSeeder: UserSeeder,
    private readonly categorySeeder: CategorySeeder,
    private readonly employeeSeeder: EmployeeSeeder,
    private readonly serviceTagSeeder: ServiceTagSeeder,
    private readonly productSeeder: ProductSeeder,
    private readonly partnerSeeder: PartnerSeeder,
  ) {
    // ⚠️ ORDER MATTERS — seeders with dependencies come AFTER their dependencies
    this.seeders = [
      this.userSeeder,        // 1. no deps
      this.categorySeeder,    // 2. no deps
      this.employeeSeeder,    // 3. no deps
      this.serviceTagSeeder,  // 4. depends on users
      this.productSeeder,     // 5. depends on categories
      this.partnerSeeder,     // 6. depends on users
    ];
  }

  async seed(): Promise<void> {
    this.logger.log('🌱 Starting database seeding...');
    const startTime = Date.now();

    for (const seeder of this.seeders) {
      await seeder.seed();
    }

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    this.logger.log(`🎉 Database seeding completed in ${duration}s`);
  }

  async clear(): Promise<void> {
    this.logger.log('🗑️ Clearing seed data...');

    // Clear in reverse order to respect foreign key constraints
    for (const seeder of [...this.seeders].reverse()) {
      await seeder.clear();
    }

    this.logger.log('🗑️ Seed data cleared');
  }
}
