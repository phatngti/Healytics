---
trigger: always_on
---

# TypeORM Migration & Entity Rules (Enterprise Standard)

Adhere to these strict guidelines to ensure database integrity, zero-downtime deployments, and high-performance querying.

## 1. Golden Rules of Safety (Zero Downtime)
* **No Synchronization:** `synchronize: true` is strictly forbidden in production, staging, or shared development environments. Changes typically occur *only* via migration files.
* **The "Expand-Contract" Pattern:** Never rename columns in a single step.
    1.  **Expand:** Add the new column (nullable).
    2.  **Migrate:** Copy data from old to new.
    3.  **Deprecate:** Code reads from new, writes to both.
    4.  **Contract:** Drop the old column in a future release.
* **Immutable History:** Never edit an existing migration file after it has been merged/deployed. Always create a new migration to fix or revert changes.

## 2. Entity Definition Standards
* **Base Class:** All entities must extend a common `AbstractEntity` containing standard audit fields.
    * `id`: UUID (Primary Key)
    * `createdAt`: `CreateDateColumn`
    * `updatedAt`: `UpdateDateColumn`
    * `deletedAt`: `DeleteDateColumn` (Soft Delete is mandatory for auditing).
* **Column Options:**
    * **Names:** Explicitly define database column names in `snake_case` while keeping class properties in `camelCase`.
        * `@Column({ name: 'first_name' }) firstName: string;`
    * **Types:** Be explicit.
        * Use `timestamptz` (with timezone) instead of `timestamp`.
        * Use `decimal` or `int` for currency (never `float`).
        * Use `text` for unbounded strings, `varchar(n)` for bounded.
* **Relations:**
    * Always use `@JoinColumn` explicitly on the owning side of the relationship (usually the "Many" side).
    * Define `cascade` options carefully. Default to `false` to prevent accidental mass deletions.

## 3. Migration File Best Practices
* **Descriptive Naming:** Migration names must describe the *intent*.
    * ✅ `CreateUserTable167234...`
    * ✅ `AddIndexToUserEmail167234...`
    * ❌ `UpdateSchema167234...`
* **Idempotency (Create if Not Exists):** Migrations should be resilient to partial re-runs.
    * **Tables:** Always use the `ifNotExists: true` flag when creating tables.
        * `await queryRunner.createTable(table, true);`
    * **Indexes/Columns:** Check for existence (`hasTable`, `hasColumn`) before creating if relying on raw SQL, or ensure naming conventions prevent collisions.
* **QueryRunner Usage:**
    * Use `queryRunner` methods (e.g., `createTable`, `addColumn`) preferred over raw SQL strings for readability.
* **Down Migrations:** Every `up` method **MUST** have a perfectly corresponding `down` method to revert changes.
    * *Test:* Can you run `migration:run` followed by `migration:revert` without errors?

## 4. Performance & Indexing
* **Foreign Keys:** TypeORM does not automatically index Foreign Keys. You **MUST** manually add `@Index()` to all foreign key columns (e.g., `userId` in an `Order` entity).
* **Composite Indexes:** Use composite indexes for queries that filter by multiple fields often (e.g., `@Index(['status', 'createdAt'])`).
* **Concurrent Creation:** For very large tables in Postgres, standard migrations lock the table.
    * *FAANG Rule:* For tables > 10M rows, use `CONCURRENTLY` in raw SQL for index creation (cannot be done inside a transaction).

## 5. Safe Column Modifications (The "Parallel Change" Pattern)
* **Never `ALTER` Type Directly:** Changing a column's data type (e.g., `int` to `bigint` or `string` to `json`) locks the table and is risky.
    * **Rule:** Treat type changes exactly like Renames. Use the **Expand-Contract** strategy:
        1.  **Add** new column with the correct type.
        2.  **Dual Write** to both columns in code.
        3.  **Backfill** old data to new column.
        4.  **Switch Read** to new column.
        5.  **Drop** old column.
* **Changing Nullability (True -> False):**
    * **Procedure:**
        1.  **Update Data:** Run a migration to fill `NULL` values with a default.
        2.  **Apply Constraint:** Only *after* data is clean, run `ALTER TABLE ... ALTER COLUMN ... SET NOT NULL`.
* **Renaming Columns:**
    * **Strictly Forbidden:** Do not use `RENAME COLUMN` in a live environment. It breaks active queries immediately.

## 6. Migration Logic for Data Changes
* **Data Migration vs Schema Migration:**
    * If a migration modifies *data* (e.g., backfilling), do **not** use the same transaction as the schema change if the table is large.
    * **Batching:** When updating >10k rows, use batched updates (`UPDATE ... LIMIT 1000`) to avoid locking.

## 7. Refactoring Checklist
Before submitting a Pull Request with database changes:
- [ ] Does every new table have a Primary Key and Audit columns?
- [ ] Are all Foreign Keys indexed?
- [ ] Are `nullable` properties explicitly defined?
- [ ] Is `createTable` using `ifNotExists: true`?

---

## Example Implementation

### Entity (Standard)
```typescript
import { Entity, Column, PrimaryGeneratedColumn, Index, CreateDateColumn, UpdateDateColumn, DeleteDateColumn, ManyToOne, JoinColumn } from 'typeorm';

@Entity('orders')
@Index(['userId', 'status'])
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  totalAmount: number;

  @Column({ name: 'user_id' })
  @Index()
  userId: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date;
}
```
### Migration (Idempotent Creation)
```typescript
import { MigrationInterface, QueryRunner, Table, TableIndex } from "typeorm";

export class CreateOrdersTable1680000000000 implements MigrationInterface {
    name = 'CreateOrdersTable1680000000000'

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Create Table Safely (IF NOT EXISTS)
        await queryRunner.createTable(new Table({
            name: "orders",
            columns: [
                { name: "id", type: "uuid", isPrimary: true, generationStrategy: "uuid", default: "uuid_generate_v4()" },
                { name: "total_amount", type: "decimal", precision: 10, scale: 2, default: 0 },
                { name: "user_id", type: "uuid" },
                { name: "created_at", type: "timestamptz", default: "now()" },
                { name: "updated_at", type: "timestamptz", default: "now()" },
                { name: "deleted_at", type: "timestamptz", isNullable: true }
            ]
        }), true); // <--- TRUE checks "IF NOT EXISTS"

        // 2. Create Index Safely (Manual Check)
        // Note: queryRunner.createIndex does not have a simple "ifNotExists" flag in all versions.
        const table = await queryRunner.getTable("orders");
        const foreignKeyIndex = table.indices.find(idx => idx.columnNames.includes("user_id"));
        
        if (!foreignKeyIndex) {
            await queryRunner.createIndex("orders", new TableIndex({
                name: "IDX_ORDERS_USER_ID",
                columnNames: ["user_id"]
            }));
        }
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.dropTable("orders", true); // true = IF EXISTS
    }
}
```