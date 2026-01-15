---
description: Debug and profile performance issues in the NestJS backend
---

# Debug Performance Workflow

Use this workflow when investigating slow endpoints, high memory usage, or database performance issues.

---

## 1. Identify the Slow Operation

Determine what is slow:
- **API Endpoint**: Note the route and HTTP method (e.g., `GET /v1/products`)
- **Database Query**: Identify the entity/repository involved
- **Background Job**: Identify the handler or service

---

## 2. Enable Debug Logging

Start the server in debug mode to capture detailed logs:

```bash
# Terminal 1: Start with debug watch mode
npm run start:debug
```

Then attach a debugger (VS Code or Chrome DevTools) at `chrome://inspect`.

---

## 3. Profile the Database

### 3.1 Enable TypeORM Query Logging

Temporarily modify `migrations/typeorm.config.ts` or the AppModule config:

```typescript
TypeOrmModule.forRoot({
  // ... existing config
  logging: ['query', 'error', 'slow'],
  maxQueryExecutionTime: 1000, // Log queries slower than 1 second
})
```

### 3.2 Analyze Slow Queries

Run the following SQL in PostgreSQL to find slow queries:

```sql
-- Top 10 slowest queries (requires pg_stat_statements extension)
SELECT
  calls,
  round(total_exec_time::numeric, 2) AS total_time_ms,
  round(mean_exec_time::numeric, 2) AS mean_time_ms,
  query
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;
```

### 3.3 Check for Missing Indexes

```sql
-- Find tables with sequential scans (missing indexes)
SELECT
  schemaname,
  relname AS table,
  seq_scan,
  idx_scan,
  n_live_tup AS row_count
FROM pg_stat_user_tables
WHERE seq_scan > idx_scan
  AND n_live_tup > 10000
ORDER BY seq_scan DESC;
```

---

## 4. Profile API Endpoints

### 4.1 Add Request Timing Interceptor

Create or use an existing timing interceptor:

```typescript
// src/common/interceptors/logging.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;
    const start = Date.now();

    return next.handle().pipe(
      tap(() => {
        const elapsed = Date.now() - start;
        this.logger.log(`${method} ${url} - ${elapsed}ms`);
        if (elapsed > 500) {
          this.logger.warn(`SLOW REQUEST: ${method} ${url} took ${elapsed}ms`);
        }
      }),
    );
  }
}
```

### 4.2 Use curl with Timing

```bash
# Measure response time of specific endpoint
curl -w "\n\nTime Total: %{time_total}s\nTime Connect: %{time_connect}s\nTime TTFB: %{time_starttransfer}s\n" \
  -H "Authorization: Bearer <TOKEN>" \
  http://localhost:8080/v1/<endpoint>
```

---

## 5. Profile Memory Usage

### 5.1 Start with Memory Profiling

```bash
# Start Node.js with heap profiling enabled
node --inspect --max-old-space-size=512 dist/main
```

### 5.2 Take Heap Snapshot

1. Open Chrome DevTools → `chrome://inspect`
2. Click "Open dedicated DevTools for Node"
3. Go to Memory tab → Take heap snapshot
4. Compare snapshots before/after suspicious operation

### 5.3 Check for Memory Leaks

Common causes in NestJS:
- Unclosed database connections
- Event listeners not removed
- Large objects held in closures
- Circular references in entities

---

## 6. Common Performance Fixes

### 6.1 N+1 Query Problem

**Problem**: Loading relations one-by-one in a loop.

**Solution**: Use eager loading with `relations` or QueryBuilder:

```typescript
// Before (N+1)
const products = await this.productRepo.find();
for (const product of products) {
  product.category = await this.categoryRepo.findOne({ where: { id: product.categoryId } });
}

// After (1 query with JOIN)
const products = await this.productRepo.find({ relations: ['category'] });
```

### 6.2 Pagination

**Problem**: Loading all records at once.

**Solution**: Always paginate large result sets:

```typescript
const [items, total] = await this.repo.findAndCount({
  take: pageSize,
  skip: (page - 1) * pageSize,
  order: { createdAt: 'DESC' },
});
```

### 6.3 Select Only Required Fields

```typescript
// Instead of loading entire entity
const products = await this.productRepo
  .createQueryBuilder('product')
  .select(['product.id', 'product.name', 'product.price'])
  .getMany();
```

### 6.4 Add Database Indexes

For frequently queried columns, add indexes in migration:

```typescript
// In migration file
await queryRunner.createIndex('products', new TableIndex({
  name: 'IDX_PRODUCTS_STATUS_CREATED',
  columnNames: ['status', 'created_at'],
}));
```

---

## 7. Load Testing

### 7.1 Quick Load Test with Apache Bench

```bash
# 100 requests, 10 concurrent
ab -n 100 -c 10 -H "Authorization: Bearer <TOKEN>" \
  http://localhost:8080/v1/<endpoint>
```

### 7.2 Use Artillery (if installed)

```bash
npx artillery quick --count 50 --num 10 http://localhost:8080/v1/<endpoint>
```

---

## 8. Cleanup After Debugging

- [ ] Remove or disable TypeORM query logging in production config
- [ ] Remove any temporary profiling interceptors
- [ ] Commit performance-related fixes (indexes, optimizations)
- [ ] Document any architectural changes in implementation plan

---

## Quick Reference Commands

```bash
# Start debug mode
npm run start:debug

# Run with memory limit
NODE_OPTIONS="--max-old-space-size=512" npm run start:dev

# Check database connection pool
npm run typeorm query "SELECT * FROM pg_stat_activity WHERE datname = 'healytics'"

# Run specific test with profiling
node --prof node_modules/.bin/jest src/products/products.service.spec.ts
```
