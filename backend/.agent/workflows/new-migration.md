---
description: Create and manage TypeORM database migrations
---

# Database Migration Workflow

Use this workflow when creating, running, or reverting TypeORM migrations.

---

## 1. Create a New Migration

### Option A: Generate from Entity Changes (Recommended)

When you've modified entity files and want to generate a migration:

// turbo
```bash
npm run migration:generate --name=<MigrationName>
```

Example: `npm run migration:generate --name=AddStatusToProducts`

### Option B: Create Empty Migration

For custom SQL or complex schema changes:

// turbo
```bash
npm run migration:create --name=<MigrationName>
```

---

## 2. Write Migration (If Created Empty)

Follow the enterprise migration rules:

```typescript
import { MigrationInterface, QueryRunner, Table, TableIndex, TableForeignKey } from "typeorm";

export class CreateProductsTable1700000000000 implements MigrationInterface {
  name = 'CreateProductsTable1700000000000'

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. Create table with IF NOT EXISTS
    await queryRunner.createTable(new Table({
      name: "products",
      columns: [
        { name: "id", type: "uuid", isPrimary: true, default: "uuid_generate_v4()" },
        { name: "name", type: "varchar", length: "255" },
        { name: "status", type: "varchar", length: "50", default: "'active'" },
        { name: "created_at", type: "timestamptz", default: "now()" },
        { name: "updated_at", type: "timestamptz", default: "now()" },
        { name: "deleted_at", type: "timestamptz", isNullable: true }
      ]
    }), true); // true = IF NOT EXISTS

    // 2. Add indexes for frequently queried columns
    await queryRunner.createIndex("products", new TableIndex({
      name: "IDX_PRODUCTS_STATUS",
      columnNames: ["status"]
    }));
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop in reverse order
    await queryRunner.dropIndex("products", "IDX_PRODUCTS_STATUS");
    await queryRunner.dropTable("products", true); // true = IF EXISTS
  }
}
```

---

## 3. Run Migrations

### Run All Pending Migrations

// turbo
```bash
npm run migration:run
```

### Check Migration Status

// turbo
```bash
npm run typeorm migration:show -d ./migrations/typeorm.config.ts
```

---

## 4. Revert Migrations

### Revert Last Migration

// turbo
```bash
npm run migration:revert
```

### Revert All Migrations

// turbo
```bash
npm run migration:revert:all
```

---

## 5. Best Practices Checklist

Before committing a migration:

- [ ] Every new table has `id`, `created_at`, `updated_at`, `deleted_at` columns
- [ ] All foreign key columns have indexes (`@Index()`)
- [ ] Using `timestamptz` instead of `timestamp`
- [ ] Using `createTable(..., true)` for IF NOT EXISTS
- [ ] `down()` method correctly reverses all `up()` changes
- [ ] No use of `synchronize: true` in config

---

## 6. Common Patterns

### Adding a Column

```typescript
public async up(queryRunner: QueryRunner): Promise<void> {
  await queryRunner.addColumn("products", new TableColumn({
    name: "description",
    type: "text",
    isNullable: true
  }));
}

public async down(queryRunner: QueryRunner): Promise<void> {
  await queryRunner.dropColumn("products", "description");
}
```

### Adding a Foreign Key

```typescript
public async up(queryRunner: QueryRunner): Promise<void> {
  // 1. Add the column
  await queryRunner.addColumn("products", new TableColumn({
    name: "category_id",
    type: "uuid",
    isNullable: true
  }));

  // 2. Add index (REQUIRED for FK columns)
  await queryRunner.createIndex("products", new TableIndex({
    name: "IDX_PRODUCTS_CATEGORY_ID",
    columnNames: ["category_id"]
  }));

  // 3. Add foreign key constraint
  await queryRunner.createForeignKey("products", new TableForeignKey({
    name: "FK_PRODUCTS_CATEGORY",
    columnNames: ["category_id"],
    referencedTableName: "categories",
    referencedColumnNames: ["id"],
    onDelete: "SET NULL"
  }));
}

public async down(queryRunner: QueryRunner): Promise<void> {
  // Drop in reverse order: FK -> Index -> Column
  await queryRunner.dropForeignKey("products", "FK_PRODUCTS_CATEGORY");
  await queryRunner.dropIndex("products", "IDX_PRODUCTS_CATEGORY_ID");
  await queryRunner.dropColumn("products", "category_id");
}
```

---

## 7. Troubleshooting

### Migration Not Found Error

If you see "No migration X was found in the source code":

1. Check if the migration class name matches exactly (case-sensitive)
2. Ensure the file is in `migrations/scripts/`
3. Run `npm run build` to recompile

### Foreign Key Drop Order

Always drop foreign keys before dropping tables/columns they reference.
