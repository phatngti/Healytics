/**
 * Contract for all feature seeders.
 * Each seeder is responsible for populating data for a specific domain.
 */
export interface ISeeder {
  /** Populate seed data for this feature */
  seed(): Promise<void>;

  /** Remove all seed data for this feature */
  clear(): Promise<void>;
}
