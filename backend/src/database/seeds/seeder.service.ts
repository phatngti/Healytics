import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UserSeeder } from './users/user.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { AppointmentSeeder } from './appointments/appointment.seeder';
import { ISeeder } from './seeder.interface';

/**
 * Tables populated by migrations/master-data/ — never truncated by clearAll().
 * Also preserves the TypeORM `migrations` table so migration history stays intact.
 */
const PRESERVED_TABLES = [
  'migrations',
  'location',
  'health_partner_document_requirement',
];

/**
 * Orchestrates seed execution order.
 * Seeders are run sequentially to respect cross-module dependencies.
 *
 * Dependency graph:
 *   UserSeeder        ← no deps
 *   PartnerSeeder     ← depends on Account (UserSeeder)
 *   EmployeeSeeder    ← depends on Partner (PartnerSeeder)
 *   ServiceTagSeeder  ← depends on Account (UserSeeder)
 *   CategorySeeder    ← no deps
 *   ProductSeeder     ← depends on Category, ServiceTag, Employee, ResourceType
 *   AppointmentSeeder ← depends on User, Employee, Product
 */
@Injectable()
export class SeederService {
  private readonly logger = new Logger(SeederService.name);
  private readonly seeders: ISeeder[];

  constructor(
    private readonly dataSource: DataSource,
    private readonly userSeeder: UserSeeder,
    private readonly employeeSeeder: EmployeeSeeder,
    private readonly serviceTagSeeder: ServiceTagSeeder,
    private readonly productSeeder: ProductSeeder,
    private readonly partnerSeeder: PartnerSeeder,
    private readonly categorySeeder: CategorySeeder,
    private readonly appointmentSeeder: AppointmentSeeder,
  ) {
    // ⚠️ ORDER MATTERS — seeders with dependencies come AFTER their dependencies
    this.seeders = [
      this.userSeeder,         // 1. no deps
      this.partnerSeeder,      // 2. depends on users
      this.employeeSeeder,     // 3. depends on partners
      this.serviceTagSeeder,   // 4. depends on users
      this.categorySeeder,     // 5. no deps (but logically before products)
      this.productSeeder,      // 6. depends on categories, tags, employees
      this.appointmentSeeder,  // 7. depends on users, employees, products
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

  /**
   * Truncates ALL application tables except master-data tables
   * (location, health_partner_document_requirement) and the migrations table.
   * Uses TRUNCATE ... CASCADE to handle foreign key dependencies automatically.
   */
  async clearAll(): Promise<void> {
    this.logger.log('🗑️ Clearing ALL data (preserving master-data)...');
    const startTime = Date.now();

    // Query all user-created table names from the public schema
    const tables: { table_name: string }[] = await this.dataSource.query(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);

    const tablesToTruncate = tables
      .map((t) => t.table_name)
      .filter((name) => !PRESERVED_TABLES.includes(name));

    if (tablesToTruncate.length === 0) {
      this.logger.warn('No tables to truncate');
      return;
    }

    this.logger.log(`Preserving: ${PRESERVED_TABLES.join(', ')}`);
    this.logger.log(`Truncating ${tablesToTruncate.length} table(s)...`);

    // Truncate all tables in a single statement with CASCADE
    const quoted = tablesToTruncate.map((t) => `"${t}"`).join(', ');
    await this.dataSource.query(
      `TRUNCATE TABLE ${quoted} RESTART IDENTITY CASCADE`,
    );

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    this.logger.log(`🎉 Cleared all data in ${duration}s (${tablesToTruncate.length} tables truncated)`);
  }
}
