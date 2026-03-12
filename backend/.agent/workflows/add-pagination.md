---
description: Add pagination, filtering, and sorting to listing endpoints
---

# Add Pagination Workflow

Use this workflow to add enterprise-grade **pagination, filtering, and sorting** to listing endpoints. This project currently lacks standard pagination — use this workflow to add it.

---

## 1. Create Base Pagination DTO (One-Time Setup)

If `BasePaginationDto` does not exist yet, create it:

```typescript
// src/common/dto/base-pagination.dto.ts
import { IsOptional, IsInt, Min, Max, IsString, IsEnum } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export enum SortOrder {
  ASC = 'ASC',
  DESC = 'DESC',
}

export class BasePaginationDto {
  @ApiPropertyOptional({ example: 1, description: 'Page number (1-indexed)' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ example: 20, description: 'Items per page (max 100)' })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @ApiPropertyOptional({ example: 'createdAt', description: 'Field to sort by' })
  @IsOptional()
  @IsString()
  sortBy?: string = 'createdAt';

  @ApiPropertyOptional({ enum: SortOrder, example: SortOrder.DESC })
  @IsOptional()
  @IsEnum(SortOrder)
  sortOrder?: SortOrder = SortOrder.DESC;

  /**
   * Computed skip value for TypeORM.
   */
  get skip(): number {
    return ((this.page ?? 1) - 1) * (this.limit ?? 20);
  }
}
```

---

## 2. Create Paginated Response DTO (One-Time Setup)

```typescript
// src/common/dto/paginated-response.dto.ts
import { ApiProperty } from '@nestjs/swagger';

export class PaginationMeta {
  @ApiProperty({ example: 1 })
  page: number;

  @ApiProperty({ example: 20 })
  limit: number;

  @ApiProperty({ example: 100 })
  total: number;

  @ApiProperty({ example: 5 })
  totalPages: number;

  @ApiProperty({ example: true })
  hasNext: boolean;

  @ApiProperty({ example: false })
  hasPrevious: boolean;
}

export class PaginatedResponseDto<T> {
  data: T[];
  meta: PaginationMeta;

  static create<T>(
    data: T[],
    total: number,
    page: number,
    limit: number,
  ): PaginatedResponseDto<T> {
    const totalPages = Math.ceil(total / limit);
    return {
      data,
      meta: {
        page,
        limit,
        total,
        totalPages,
        hasNext: page < totalPages,
        hasPrevious: page > 1,
      },
    };
  }
}
```

---

## 3. Create Domain Query DTO

Extend `BasePaginationDto` with domain-specific filters:

```typescript
// src/<module>/dto/<audience>/get-<entities>-query.dto.ts
import { IsOptional, IsString, IsUUID, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { BasePaginationDto } from '@/common/dto/base-pagination.dto';
import { HealthServiceStatus } from '@/<module>/enums/health-service-status.enum';

export class GetHealthServicesQueryDto extends BasePaginationDto {
  @ApiPropertyOptional({ example: 'massage' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ enum: HealthServiceStatus })
  @IsOptional()
  @IsEnum(HealthServiceStatus)
  status?: HealthServiceStatus;

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID()
  categoryId?: string;
}
```

---

## 4. Implement Service Method

Use `QueryBuilder` for complex queries with dynamic filters:

```typescript
// In <module>.service.ts

async findAllPaginated(
  query: GetHealthServicesQueryDto,
): Promise<PaginatedResponseDto<ResponseDto>> {
  const qb = this.repo
    .createQueryBuilder('entity')
    .leftJoinAndSelect('entity.category', 'category')
    .leftJoinAndSelect('entity.media', 'media');

  // Dynamic filters
  if (query.search) {
    qb.andWhere('entity.name ILIKE :search', { search: `%${query.search}%` });
  }
  if (query.status) {
    qb.andWhere('entity.status = :status', { status: query.status });
  }
  if (query.categoryId) {
    qb.andWhere('entity.categoryId = :categoryId', { categoryId: query.categoryId });
  }

  // Soft-delete filter
  qb.andWhere('entity.deletedAt IS NULL');

  // Sorting (validate sortBy against allowed fields!)
  const allowedSortFields = ['createdAt', 'name', 'basePrice'];
  const sortField = allowedSortFields.includes(query.sortBy ?? '')
    ? `entity.${query.sortBy}`
    : 'entity.createdAt';
  qb.orderBy(sortField, query.sortOrder ?? 'DESC');

  // Pagination
  qb.skip(query.skip).take(query.limit);

  // Execute
  const [items, total] = await qb.getManyAndCount();

  return PaginatedResponseDto.create(
    ResponseDto.fromEntities(items),
    total,
    query.page ?? 1,
    query.limit ?? 20,
  );
}
```

### For Simple Queries (No Dynamic Filters)

Use the repository directly:

```typescript
async findAllPaginated(
  query: BasePaginationDto,
): Promise<PaginatedResponseDto<ResponseDto>> {
  const [items, total] = await this.repo.findAndCount({
    relations: ['category', 'media'],
    order: { [query.sortBy ?? 'createdAt']: query.sortOrder ?? 'DESC' },
    skip: query.skip,
    take: query.limit,
  });

  return PaginatedResponseDto.create(
    ResponseDto.fromEntities(items),
    total,
    query.page ?? 1,
    query.limit ?? 20,
  );
}
```

---

## 5. Add Controller Endpoint

```typescript
@Get()
@ApiOperation({ summary: 'List <resources> with pagination' })
@ApiOkResponse({ description: 'Paginated list of <resources>' })
findAll(@Query() query: GetHealthServicesQueryDto) {
  return this.service.findAllPaginated(query);
}
```

---

## 6. Verify

// turbo
```bash
npm run build
```

Test with curl or Swagger:
```bash
# Page 1, 10 items, sorted by name ascending, filtered by status
curl "http://localhost:8080/v1/partner/health-services?page=1&limit=10&sortBy=name&sortOrder=ASC&status=active"
```

Expected response shape:
```json
{
  "data": [{ "id": "...", "name": "..." }],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 42,
    "totalPages": 5,
    "hasNext": true,
    "hasPrevious": false
  }
}
```

---

## Security: Sort Field Validation

> [!WARNING]
> **Always validate `sortBy`** against an allow-list of fields. Never pass user input directly to `orderBy()` — this prevents SQL injection via dynamic column names.

```typescript
const allowedSortFields = ['createdAt', 'name', 'basePrice', 'status'];
const sortField = allowedSortFields.includes(query.sortBy ?? '')
  ? `entity.${query.sortBy}`
  : 'entity.createdAt'; // fallback to safe default
```
