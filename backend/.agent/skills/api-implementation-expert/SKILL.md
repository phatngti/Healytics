---
name: api-implementation-expert
description: Enterprise API implementation reference for Healytics backend — covers security model, controller/service/handler/entity/DTO patterns, pagination, error handling, and common anti-patterns following project-specific conventions.
category: architecture
displayName: API Implementation Expert
color: green
---

# API Implementation Expert (Healytics Backend)

You are an expert in enterprise API implementation for the Healytics NestJS backend. This skill provides the authoritative reference for all API-related patterns in this project.

## When Invoked

0. **Scope Check**: If a more specialized expert fits better, recommend switching:
   - Pure TypeScript type issues → typescript-type-expert
   - Database query optimization → postgres-expert
   - Node.js runtime issues → nodejs-expert
   - Test-specific issues → jest-testing-expert
   - General NestJS architecture → nestjs-expert

1. Detect request type: new endpoint, security concern, DTO design, service logic, etc.
2. Apply the correct pattern from the sections below
3. Reference real project imports and file paths
4. Validate: typecheck → unit tests → Swagger docs

---

## 1. Security Model

### Roles

```typescript
// src/account/enum/role.enum.ts
export enum Role {
  USER = 'user',           // Mobile app end users
  EMPLOYEE = 'employee',    // Clinic staff
  HEALTH_PARTNER = 'health_partner', // Clinic owners / partners
  ADMIN = 'admin',          // Platform administrators
}
```

### Role Groups

```typescript
// src/auth/constants/role-groups.ts
export const ADMIN_ROLES: Role[] = [Role.ADMIN, Role.HEALTH_PARTNER, Role.EMPLOYEE];
export const ALL_ROLES: Role[] = [Role.ADMIN, Role.HEALTH_PARTNER, Role.EMPLOYEE, Role.USER];
export const USER_ROLES: Role[] = [Role.USER];
```

### Composite API Decorators

These bundle auth guards, roles, Swagger config, route prefix, and serialization:

| Decorator | Role | Route Prefix | Import |
|-----------|------|-------------|--------|
| `@PublicApi('resource')` | None (public) | `/v1/{resource}` | `@/common/decorators/api/public-api.decorator` |
| `@PartnerApi('resource')` | `HEALTH_PARTNER` | `/v1/partner/{resource}` | `@/common/decorators/api/partner-api.decorator` |
| `@AdminApi('resource')` | `ADMIN_ROLES` | `/v1/admin/{resource}` | `@/common/decorators/api/admin-api.decorator` |
| `@UserApi('resource')` | `USER` | `/v1/user/{resource}` | `@/common/decorators/api/user-api.decorator` |

Each composite decorator applies:
- `@ApiTags()` — Swagger grouping
- `@ApiBearerAuth()` — JWT auth header in docs
- `@Controller({ path: '<prefix>/<resource>', version: '1' })` — versioned route
- `@UseGuards(JwtAuthGuard, RolesGuard)` — JWT + RBAC
- `@Roles(...)` — required role(s)
- `@UseInterceptors(ClassSerializerInterceptor)` — DTO serialization

### Auth Decorators

| Decorator | Purpose | Import |
|-----------|---------|--------|
| `@Public()` | Bypass JWT auth for specific routes | `@/common/decorators/auth/public.decorator` |
| `@Roles(Role.ADMIN)` | Restrict to specific role(s) | `@/common/decorators/auth/roles.decorator` |
| `@CurrentUser()` | Extract JWT payload from request | `@/common/decorators/auth/current-user.decorator` |
| `@CurrentUser('id')` | Extract specific field from JWT payload | Same as above |

### Guards

| Guard | Purpose | File |
|-------|---------|------|
| `JwtAuthGuard` | Validates JWT token, skips if `@Public()` | `src/auth/guards/jwt-auth.guard.ts` |
| `RolesGuard` | Checks user role against `@Roles()` metadata | `src/auth/guards/roles.guard.ts` |
| `LocalAuthGuard` | Email/password login (Passport local strategy) | `src/auth/guards/local-auth.guard.ts` |

### Rate Limiting

```typescript
import { Throttle, SkipThrottle } from '@nestjs/throttler';

// Override rate limit for sensitive endpoint
@Throttle({ default: { limit: 5, ttl: 60000 } }) // 5 req / 60s
@Post('sensitive-action')
sensitiveAction() { ... }

// Skip rate limiting for a specific endpoint
@SkipThrottle()
@Get('health')
healthCheck() { ... }
```

### Audit Logging (Admin Endpoints)

```typescript
import { Audit } from '@/audit/decorators/audit.decorator';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';

@AdminApi('partners')
@UseInterceptors(AuditInterceptor)
export class AdminPartnersController {
  @Put(':id/review')
  @Audit('PARTNER_REVIEW', 'Partner') // action name, entity type
  async review(@Param('id') id: string, @Body() dto: ReviewDto, @Req() req) { ... }
}
```

---

## 2. Controller Patterns

### Rules

1. **Controllers are dumb adapters** — zero business logic
   - ✅ `return this.service.doAction(dto);`
   - ❌ `if (dto.price > 100) { ... }`
2. **Never return database entities** — always use Response DTOs
3. **API versioning** is mandatory: `@Controller({ path: '...', version: '1' })`
4. **Use `ParseUUIDPipe`** for all UUID path parameters

### HTTP Verbs & Status Codes

| Operation | Verb | Success Status | Decorators |
|-----------|------|---------------|------------|
| Create | `POST` | `201 Created` | `@ApiCreatedResponse()` |
| Read one | `GET :id` | `200 OK` | `@ApiOkResponse()` + `@ApiNotFoundResponse()` |
| Read list | `GET` | `200 OK` | `@ApiOkResponse()` |
| Update | `PATCH :id` | `200 OK` | `@ApiOkResponse()` + `@ApiNotFoundResponse()` |
| Replace | `PUT :id` | `200 OK` | `@ApiOkResponse()` |
| Delete | `DELETE :id` | `204 No Content` | `@ApiNoContentResponse()` + `@HttpCode(HttpStatus.NO_CONTENT)` |
| Async job | `POST` | `202 Accepted` | `@ApiAcceptedResponse()` |

### Swagger Documentation

Every endpoint MUST have:
- `@ApiOperation({ summary: '...' })` — brief description
- Response type decorator(s) — `@ApiOkResponse({ type: ResponseDto })`
- Error responses — `@ApiNotFoundResponse()`, `@ApiBadRequestResponse()`, etc.

### Controller Naming

| Audience | File | Class | Route |
|----------|------|-------|-------|
| Public | `<module>.controller.ts` | `<Module>Controller` | `/v1/<resource>` |
| User | `user-<module>.controller.ts` | `User<Module>Controller` | `/v1/user/<resource>` |
| Partner | `partner-<module>.controller.ts` | `Partner<Module>Controller` | `/v1/partner/<resource>` |
| Admin | `admin-<module>.controller.ts` | `Admin<Module>Controller` | `/v1/admin/<resource>` |

### Real Example: Public Controller

```typescript
// src/health-service/health-service.controller.ts
@ApiTags('Health Services')
@Controller({ path: 'health-services', version: '1' })
@UseInterceptors(ClassSerializerInterceptor)
export class HealthServiceController {
  constructor(private readonly healthServiceService: HealthServiceService) {}

  @Get('premium-treatments')
  @Public()
  @ApiOperation({ summary: 'Get premium treatments' })
  @ApiOkResponse({ type: [PublicHealthServiceCardResponseDto] })
  getPremiumTreatments(): Promise<PublicHealthServiceCardResponseDto[]> {
    return this.healthServiceService.getPremiumTreatments();
  }
}
```

### Real Example: Partner Controller

```typescript
// src/health-service/partner-health-service.controller.ts
@PartnerApi('health-services') // → /v1/partner/health-services, HEALTH_PARTNER role
export class PartnerHealthServiceController {
  constructor(private readonly healthServiceService: HealthServiceService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new health service' })
  @ApiCreatedResponse({ type: PartnerHealthServiceResponseDto })
  create(@Body() dto: CreatePartnerHealthServiceDto) { ... }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiNoContentResponse()
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> { ... }
}
```

---

## 3. DTO Standards

### Directory Structure

DTOs are organized by **audience** — different consumers see different response shapes:

```
src/<module>/dto/
├── partner/                           # Partner-facing DTOs
│   ├── create-partner-<entity>.dto.ts
│   ├── update-partner-<entity>.dto.ts
│   └── partner-<entity>-response.dto.ts
├── public/                            # Public/user-facing DTOs
│   └── public-<entity>-response.dto.ts
└── admin/                             # Admin-facing DTOs
    └── admin-<entity>-response.dto.ts
```

### Request DTO Rules

1. Use `class-validator` decorators for ALL fields
2. **Every `@ApiProperty()` / `@ApiPropertyOptional()` MUST have explicit `type`** — see `dto-type-expert` skill
3. Use `@ValidateNested()` + `@Type(() => NestedClass)` for nested objects
4. Use `@IsArray()` + `@ValidateNested({ each: true })` + `@Type()` for arrays
5. Enum fields must have both `enum` and `enumName` to avoid inline anonymous enums

```typescript
export class CreateEntityDto {
  @ApiProperty({ type: String, example: 'Thai Massage' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;

  // Nested object — @Type() is MANDATORY
  @ApiPropertyOptional({ type: () => DefinitionDto })
  @IsOptional()
  @ValidateNested()
  @Type(() => DefinitionDto)
  definition?: DefinitionDto;

  // Nested array — @Type() is MANDATORY
  @ApiPropertyOptional({ type: [MediaDto] })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => MediaDto)
  media?: MediaDto[];
}
```

> ⚠️ **NEVER use bare `@ApiProperty()` or `@ApiPropertyOptional()` without `type`.** This causes Swagger to generate `"type": "object"` for primitive fields, breaking client SDK generation.

### Response DTO Rules

1. Use `@Expose()` for included fields, `@Exclude()` for hidden fields
2. **Every `@ApiProperty` must have explicit `type`** (String, Number, Boolean, Date, enum, or DTO class)
3. Use static `fromEntity()` factory method for entity-to-DTO conversion
4. Never expose internal fields like `deletedAt`, `password`, etc.
5. Nullable fields must include `nullable: true`

```typescript
export class EntityResponseDto {
  @ApiProperty({ type: String })
  @Expose()
  id: string;

  @ApiProperty({ type: String })
  @Expose()
  name: string;

  @ApiPropertyOptional({ type: String, nullable: true })
  @Expose()
  description!: string | null;

  static fromEntity(entity: SomeEntity): EntityResponseDto {
    const dto = new EntityResponseDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.description = entity.description ?? null;
    return dto;
  }

  static fromEntities(entities: SomeEntity[]): EntityResponseDto[] {
    return entities.map((e) => this.fromEntity(e));
  }
}
```

---

## 4. Service Facade Pattern

### Core Principle

Services act as facades — they delegate mutations to **handlers** and perform queries via the **repository**.

```typescript
@Injectable()
export class HealthServiceService {
  private readonly logger = new Logger(HealthServiceService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly createHandler: CreateHealthServiceHandler,
    private readonly updateHandler: UpdateHealthServiceHandler,
    private readonly removeHandler: RemoveHealthServiceHandler,
    private readonly partnersService: PartnersService, // cross-module injection
  ) {}

  // Mutations → delegate to handlers
  create(dto: CreateDto) { return this.createHandler.execute(dto); }
  update(id: string, dto: UpdateDto) { return this.updateHandler.execute(id, dto); }
  remove(id: string) { return this.removeHandler.execute(id); }

  // Queries → use repository directly
  async findOne(id: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: ['category', 'media'],
    });
    if (!product) {
      this.logger.warn(`Product not found: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
    return product;
  }
}
```

### Cross-Module Service Injection

To use services from other modules:
1. The **provider module** must `exports: [ServiceClass]`
2. The **consumer module** must `imports: [ProviderModule]`

```typescript
// health-service.module.ts
@Module({
  imports: [
    TypeOrmModule.forFeature([Product, ...]),
    PartnersModule,           // ← import module to access its exports
  ],
  providers: [HealthServiceService, ...handlers],
})
```

---

## 5. Handler Pattern (CQRS-Inspired)

### Core Principles

- **One handler = one semantic business intent** (e.g., `CreateHealthServiceHandler`)
- **Handlers own the transaction lifecycle** — controllers and services never manage transactions
- **Naming**: `VerbNounHandler` class, `verb-noun.handler.ts` file
- **Location**: `src/<module>/application/handlers/`

### Transaction Flow (5 Steps)

```typescript
@Injectable()
export class CreateEntityHandler {
  private readonly logger = new Logger(CreateEntityHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: CreateDto): Promise<Entity> {
    this.logger.log(`Creating entity: ${command.name}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();         // 1. CONNECT
    await queryRunner.startTransaction(); // 2. START TRANSACTION

    try {
      // 3. INVARIANT CHECK — fail fast
      if (invalidCondition) {
        throw new ConflictException('Business rule violated');
      }

      // 4. DOMAIN ACTION — create/mutate entities
      const entity = queryRunner.manager.create(Entity, { ...command });
      const saved = await queryRunner.manager.save(Entity, entity);

      // Handle relations within same transaction
      if (command.media?.length) {
        const mediaEntities = command.media.map((m) =>
          queryRunner.manager.create(Media, { ...m, entityId: saved.id }),
        );
        await queryRunner.manager.save(Media, mediaEntities);
      }

      // 5. COMMIT
      await queryRunner.commitTransaction();
      this.logger.log(`Entity created: ${saved.id}`);

      // Post-commit: reload with relations
      return await this.dataSource.manager.findOne(Entity, {
        where: { id: saved.id },
        relations: ['category', 'media'],
      });
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Failed: ${error.message}`, error.stack);
      // Re-throw domain exceptions; wrap unknown errors
      if (error instanceof ConflictException) throw error;
      if (error instanceof NotFoundException) throw error;
      throw new InternalServerErrorException('Transaction failed');
    } finally {
      await queryRunner.release(); // ALWAYS release
    }
  }
}
```

---

## 6. Entity Standards

### Location

All entities live in `src/common/entities/`. This is a **shared entity library** — modules import entities from here.

See `src/common/entities/index.ts` for the full barrel export.

### Column Rules

| Rule | Convention | Example |
|------|-----------|---------|
| DB column names | `snake_case` | `@Column({ name: 'base_price' })` |
| Property names | `camelCase` | `basePrice: number` |
| Primary key | UUID v4 | `@PrimaryGeneratedColumn('uuid')` |
| Timestamps | `timestamptz` | `@CreateDateColumn({ type: 'timestamptz' })` |
| Money | `decimal(15,2)` | `@Column({ type: 'decimal', precision: 15, scale: 2 })` |
| Soft delete | `@DeleteDateColumn` | `@DeleteDateColumn({ name: 'deleted_at' })` |
| Foreign keys | Always `@Index()` | `@Column({ name: 'category_id' }) @Index()` |
| Booleans | Default value | `@Column({ default: false })` |

### Relation Patterns

```typescript
// Many-to-One (FK side)
@ManyToOne(() => Category, { onDelete: 'SET NULL' })
@JoinColumn({ name: 'category_id' })
category: Category | null;

// One-to-Many (inverse side)
@OneToMany(() => ProductMedia, (media) => media.product, { cascade: true })
media: ProductMedia[];

// One-to-One
@OneToOne(() => ProductDefinition, (def) => def.product, { cascade: true, eager: false })
productDefinition: ProductDefinition | null;
```

### Anti-Patterns

- ❌ `@Column({ type: 'float' })` for money — use `decimal`
- ❌ `@Column('created_at')` — use `@Column({ name: 'created_at' })`
- ❌ Missing `@Index()` on foreign key columns
- ❌ `synchronize: true` in production

---

## 7. Pagination & Filtering

> **Note:** This project does not yet have standard pagination. Use the `/add-pagination` workflow to set it up.

### Standard DTOs

- **`BasePaginationDto`**: `page`, `limit`, `sortBy`, `sortOrder` — lives in `src/common/dto/`
- **`PaginatedResponseDto<T>`**: `data[]` + `meta { page, limit, total, totalPages, hasNext, hasPrevious }` — lives in `src/common/dto/`

### Usage

```typescript
// Domain query DTO extends BasePaginationDto
export class GetServicesQueryDto extends BasePaginationDto {
  @IsOptional() @IsString() search?: string;
  @IsOptional() @IsEnum(Status) status?: Status;
}

// Service uses QueryBuilder
const [items, total] = await qb.skip(query.skip).take(query.limit).getManyAndCount();
return PaginatedResponseDto.create(items, total, query.page, query.limit);
```

### Security: Sort Field Validation

**Always validate `sortBy`** against an allow-list:

```typescript
const allowedSortFields = ['createdAt', 'name', 'basePrice'];
const sortField = allowedSortFields.includes(query.sortBy)
  ? `entity.${query.sortBy}`
  : 'entity.createdAt';
```

---

## 8. Error Handling

### Global Setup (already configured)

- `ValidationPipe({ whitelist: true })` — strips unknown properties
- `AllExceptionsFilter` — catches all exceptions, formats response
- File: `src/common/filters/all-exceptions.filter.ts`

### Standard NestJS Exceptions

| Exception | HTTP Status | When to Use |
|-----------|------------|-------------|
| `NotFoundException` | 404 | Entity not found by ID/slug |
| `ConflictException` | 409 | Business rule violation, duplicate |
| `BadRequestException` | 400 | Invalid input (beyond validation) |
| `UnauthorizedException` | 401 | Invalid/missing JWT |
| `ForbiddenException` | 403 | Insufficient role/permission |
| `InternalServerErrorException` | 500 | Unexpected handler failure |

### Error Response Format

```json
{
  "statusCode": 404,
  "timestamp": "2025-01-01T00:00:00.000Z",
  "path": "/v1/health-services/invalid-uuid",
  "message": { "statusCode": 404, "message": "Product with ID ... not found" }
}
```

### Logging Rules

- ✅ Use `Logger` from `@nestjs/common` (class-scoped)
- ❌ Never use `console.log` / `console.error`
- Log at appropriate levels: `log()`, `warn()`, `error()`, `debug()`

```typescript
private readonly logger = new Logger(MyService.name);

this.logger.log(`Creating entity: ${id}`);      // INFO
this.logger.warn(`Entity not found: ${id}`);     // WARN
this.logger.error(`Failed: ${err.message}`, err.stack); // ERROR with stack
```

---

## 9. Global Setup Reference

### main.ts Configuration

```typescript
// Already configured in src/main.ts:
app.enableCors();
app.use(helmet());
app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
app.useGlobalFilters(new AllExceptionsFilter());
```

### Swagger Auto-Generation

- In development mode, Swagger UI at `http://localhost:8080/api/docs`
- OpenAPI spec auto-exported to `openapi/openapi.json`
- Restart dev server to regenerate after adding new endpoints

### Module Registration

New modules must be added to `src/app.module.ts`:
```typescript
@Module({
  imports: [
    AuthModule,
    HealthServiceModule,
    PartnersModule,
    NewModule,               // ← add new modules here
  ],
})
export class AppModule {}
```

---

## 10. Common Anti-Patterns & Fixes

| ❌ Anti-Pattern | ✅ Correct Pattern |
|-----------------|-------------------|
| Returning entity directly from controller | Use Response DTO with `fromEntity()` |
| Missing `@Type(() => Nested)` on nested DTOs | Always add for `@ValidateNested()` to work |
| Business logic in controller | Delegate to service/handler |
| `console.log()` for logging | Use `Logger` from `@nestjs/common` |
| `synchronize: true` in production | Use migrations (`/new-migration` workflow) |
| `float` for currency | `decimal(15,2)` |
| Unindexed foreign key columns | `@Index()` on every FK column |
| `@Column('column_name')` shorthand | `@Column({ name: 'column_name' })` explicit |
| Hardcoded role strings | Use `Role` enum from `@/account/enum/role.enum` |
| Transaction in service/controller | Handlers own transaction lifecycle |
| Missing `finally { queryRunner.release() }` | Always release in `finally` block |
| Direct `orderBy` from user input | Validate against allow-list of fields |

---

## Quick Reference: Import Map

```typescript
// === SECURITY ===
import { Public } from '@/common/decorators/auth/public.decorator';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { Role } from '@/account/enum/role.enum';
import { ADMIN_ROLES, ALL_ROLES, USER_ROLES } from '@/auth/constants/role-groups';

// === COMPOSITE API DECORATORS ===
import { PublicApi } from '@/common/decorators/api/public-api.decorator';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { UserApi } from '@/common/decorators/api/user-api.decorator';

// === GUARDS (manual setup) ===
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';

// === INTERCEPTORS ===
import { LogResponse } from '@/common/interceptors/response.interceptor';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';
import { Audit } from '@/audit/decorators/audit.decorator';

// === THROTTLING ===
import { Throttle, SkipThrottle } from '@nestjs/throttler';

// === ENTITIES (shared) ===
// All located in: src/common/entities/
import { Product } from '@/common/entities/product.entity';
import { Category } from '@/common/entities/category.entity';
import { Employee } from '@/common/entities/employee.entity';
// ... see src/common/entities/index.ts for full list
```

---

## Validation Checklist

### Before Submitting Any API Code

- [ ] Controller uses composite decorator OR manual guards (never no auth by accident)
- [ ] Controller has `@ApiOperation()` + response type on every endpoint
- [ ] DTOs use `class-validator` decorators on ALL fields
- [ ] **Every `@ApiProperty` has explicit `type`** (no bare decorators) — see `dto-type-expert` skill
- [ ] **Every nullable field has `nullable: true`** in `@ApiProperty`
- [ ] **Every enum field has both `enum` and `enumName`**
- [ ] Nested DTOs have `@Type(() => ClassName)` decorator
- [ ] Response DTOs are used (never raw entities)
- [ ] Handlers own transaction lifecycle with proper `finally { release }`
- [ ] Foreign keys have `@Index()` decorator
- [ ] Money uses `decimal`, never `float`
- [ ] `Logger` used instead of `console.log`
- [ ] New handlers registered in module `providers`
- [ ] Sorting validates `sortBy` against allow-list

### Workflow Commands

```bash
npm run build          # 1. Typecheck
npm run test           # 2. Unit tests
npm run start:dev      # 3. Regenerate OpenAPI + manual check
```

---

## 11. Request Lifecycle Pipeline

> Inspired by: **Spring Boot `HandlerInterceptor`** lifecycle, **Netflix Zuul** pre/routing/post/error filters, **Go** middleware chain pattern.

### NestJS Execution Order

Every HTTP request passes through this pipeline in **strict order**:

```
Client Request
  │
  ▼
┌──────────────────────┐
│  1. MIDDLEWARE        │  ← LoggingMiddleware (req/res logging, correlation ID)
│     (runs first)     │     Equivalent: Spring Filter / Go middleware
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  2. GUARDS            │  ← JwtAuthGuard → RolesGuard
│     (auth + authz)   │     Equivalent: Spring Security FilterChain / Go auth middleware
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  3. INTERCEPTORS      │  ← AuditInterceptor, ResponseInterceptor (PRE-handler)
│     (pre-processing) │     Equivalent: Spring HandlerInterceptor.preHandle() / Go defer
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  4. PIPES             │  ← ValidationPipe, ParseUUIDPipe, ParseIntPipe
│     (transform/valid) │     Equivalent: Spring @Valid / JSR-303 Bean Validation
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  5. CONTROLLER        │  ← Route handler method (dumb adapter)
│     (route handler)  │     Equivalent: Spring @RestController / Go http.Handler
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  6. INTERCEPTORS      │  ← AuditInterceptor, ResponseInterceptor (POST-handler)
│     (post-processing)│     Equivalent: Spring HandlerInterceptor.postHandle()
└──────────┬───────────┘
           ▼
┌──────────────────────┐
│  7. EXCEPTION FILTER  │  ← AllExceptionsFilter (if error thrown anywhere)
│     (error handling) │     Equivalent: Spring @ControllerAdvice / Go recover()
└──────────────────────┘
           ▼
        Response
```

### When to Use What

| Layer | Use Case | Example |
|-------|----------|---------|
| **Middleware** | Cross-cutting: logging, correlation ID, timing, IP whitelist | `LoggingMiddleware` |
| **Guard** | Authentication and authorization decisions (yes/no) | `JwtAuthGuard`, `RolesGuard` |
| **Interceptor** | Transform request/response, audit logging, caching, timing | `AuditInterceptor`, `ResponseInterceptor` |
| **Pipe** | Validate and transform input data | `ValidationPipe`, `ParseUUIDPipe` |
| **Filter** | Catch and format exceptions into error responses | `AllExceptionsFilter` |

### Key Difference from Spring Boot

In Spring Boot, `Filter → Interceptor → Controller` runs sequentially. In NestJS, **interceptors wrap the handler** — they have both pre- and post-processing via RxJS `Observable`:

```typescript
intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
  // PRE-processing (before controller)
  const startTime = Date.now();

  return next.handle().pipe(
    tap((data) => {
      // POST-processing (after controller returns)
      const duration = Date.now() - startTime;
      this.logger.log(`Response in ${duration}ms`);
    }),
  );
}
```

---

## 12. Middleware Patterns

> Inspired by: **Netflix Zuul** pre-filters, **Go** `func(next http.Handler) http.Handler` chain, **Spring** servlet `Filter`.

### Existing: LoggingMiddleware

File: `src/common/middleware/logging.middleware.ts`

- Logs `→ METHOD /url` on request entry
- Logs `← METHOD /url STATUS - SIZE - DURATION` on response
- Color-codes by status: `≥500` → error, `≥400` → warn, else → log
- Captures response body via `res.write`/`res.end` interception

### Creating New Middleware

```typescript
// src/common/middleware/correlation-id.middleware.ts
import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { randomUUID } from 'crypto';

@Injectable()
export class CorrelationIdMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    // Reuse incoming correlation ID or generate new one
    const correlationId = req.headers['x-correlation-id'] as string || randomUUID();

    // Attach to request for downstream use
    req['correlationId'] = correlationId;

    // Propagate back in response header
    res.setHeader('X-Correlation-Id', correlationId);

    next();
  }
}
```

### Registering Middleware

Middleware is registered in `AppModule.configure()`, NOT via decorators:

```typescript
// src/app.module.ts
import { MiddlewareConsumer, NestModule } from '@nestjs/common';
import { LoggingMiddleware } from '@/common/middleware/logging.middleware';
import { CorrelationIdMiddleware } from '@/common/middleware/correlation-id.middleware';

export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(CorrelationIdMiddleware, LoggingMiddleware) // order matters!
      .forRoutes('*'); // all routes

    // Or apply to specific routes only:
    // .forRoutes({ path: 'admin/*', method: RequestMethod.ALL });
  }
}
```

### Middleware vs Interceptor Decision Guide

| Concern | Middleware | Interceptor |
|---------|-----------|-------------|
| Runs before guards? | ✅ Yes | ❌ No |
| Access to route handler metadata? | ❌ No | ✅ Yes (via `Reflector`) |
| Can short-circuit request? | ✅ Yes (don't call `next()`) | ❌ No (guards do this) |
| Can transform response body? | ⚠️ Hacky | ✅ Yes (via `map()` operator) |
| Can read `@Roles()`, `@Audit()` metadata? | ❌ No | ✅ Yes |
| **Use for**: correlation ID, timing, raw logging | ✅ | ❌ |
| **Use for**: audit logging, response mapping, caching | ❌ | ✅ |

---

## 13. Decorator Composition

> Inspired by: **Spring AOP** `@Aspect`, **Java** custom annotations, **Go** middleware composition via `func()` wrapping.

### How Composite Decorators Work

The `@PartnerApi()`, `@AdminApi()`, `@UserApi()` decorators use `applyDecorators()` to bundle multiple decorators into one:

```typescript
// src/common/decorators/api/partner-api.decorator.ts
import { applyDecorators } from '@nestjs/common';

export function PartnerApi(resource: string) {
  return applyDecorators(
    ApiTags(`Partner ${resource.charAt(0).toUpperCase() + resource.slice(1)}`),
    ApiBearerAuth(),
    Controller({ path: `partner/${resource}`, version: '1' }),
    UseGuards(JwtAuthGuard, RolesGuard),
    Roles(Role.HEALTH_PARTNER),
    UseInterceptors(ClassSerializerInterceptor),
  );
}
```

### Creating Custom Decorators

#### Metadata Decorator (like `@Audit()`, `@LogResponse()`)

```typescript
import { SetMetadata } from '@nestjs/common';

export const MY_KEY = 'my_custom_key';
export const MyDecorator = (value: string) => SetMetadata(MY_KEY, value);

// Read in interceptor/guard:
const myValue = this.reflector.get<string>(MY_KEY, context.getHandler());
```

#### Parameter Decorator (like `@CurrentUser()`)

```typescript
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CorrelationId = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request['correlationId'];
  },
);

// Usage in controller:
@Get()
findAll(@CorrelationId() correlationId: string) { ... }
```

#### Composite Method Decorator

```typescript
import { applyDecorators, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiNoContentResponse, ApiNotFoundResponse, ApiOperation } from '@nestjs/swagger';

export function DeleteEndpoint(summary: string) {
  return applyDecorators(
    HttpCode(HttpStatus.NO_CONTENT),
    ApiOperation({ summary }),
    ApiNoContentResponse({ description: 'Deleted successfully.' }),
    ApiNotFoundResponse({ description: 'Not found.' }),
  );
}

// Usage:
@Delete(':id')
@DeleteEndpoint('Delete a health service')
remove(@Param('id', ParseUUIDPipe) id: string) { ... }
```

### Decorator Stacking Order

On a **controller class**, order matters for readability but not execution:
```typescript
@ApiTags('...')           // 1. Swagger tag
@ApiBearerAuth()          // 2. Auth in docs
@Controller(...)          // 3. Route
@UseGuards(...)           // 4. Security
@Roles(...)               // 5. Role requirement
@UseInterceptors(...)     // 6. Cross-cutting
```

On a **method**, order matters only for guards/interceptors:
```typescript
@Post()                   // 1. HTTP verb
@Roles(Role.ADMIN)        // 2. Role
@Throttle(...)            // 3. Rate limit
@Audit('ACTION', 'Ent')   // 4. Audit metadata
@ApiOperation(...)        // 5. Swagger docs
@ApiCreatedResponse(...)  // 6. Response docs
```

---

## 14. Structured Logging & Tracing

> Inspired by: **Google Dapper** distributed tracing, **Uber Jaeger** (now OpenTelemetry), **Spring Boot MDC** (Mapped Diagnostic Context), **Netflix** streaming session tracing.

### Correlation ID Pattern

Every request gets a unique ID that follows it through all service layers — essential for debugging in production.

**Flow:**
```
Client → [X-Correlation-Id: abc-123] → Middleware (generate/reuse)
  → Guard → Interceptor → Controller → Service → Handler → DB
  All log lines include: [abc-123]
  Response ← [X-Correlation-Id: abc-123]
```

**Implementation Strategy:**

1. `CorrelationIdMiddleware` generates/reuses UUID (see §12)
2. All `Logger` calls include correlation ID from request
3. Response includes `X-Correlation-Id` header for client debugging

### Logger Best Practices (Enterprise)

```typescript
// ALWAYS use class-scoped Logger with the class name
private readonly logger = new Logger(MyService.name);

// LOG LEVELS — use appropriately:
this.logger.log('Normal operation completed');           // INFO
this.logger.debug('Detailed debugging data');            // DEBUG (dev only)
this.logger.warn('Recoverable issue detected');          // WARN
this.logger.error('Operation failed', error.stack);      // ERROR (always include stack)
this.logger.verbose('Extremely detailed tracing info');  // VERBOSE

// ✅ Good: Structured with context
this.logger.log(`[${correlationId}] Created entity: ${id}`);
this.logger.error(`[${correlationId}] Failed to create entity: ${error.message}`, error.stack);

// ❌ Bad: No context, using console
console.log('something happened');
console.error(error);
```

### Structured Logging Format

When ready for production JSON logging, switch to Pino or Winston:

```typescript
// Structured log output (JSON):
{
  "level": "info",
  "timestamp": "2025-01-01T00:00:00.000Z",
  "context": "HealthServiceService",
  "correlationId": "abc-123",
  "message": "Created entity: uuid-456",
  "duration": 45,
  "userId": "user-789"
}
```

### OpenTelemetry Readiness

When ready to add distributed tracing:
1. Install `@opentelemetry/sdk-node`, `@opentelemetry/auto-instrumentations-node`
2. Correlation IDs naturally become W3C `traceparent` trace IDs
3. NestJS interceptors capture spans automatically
4. Export to Jaeger, Zipkin, or cloud provider (GCP Trace, AWS X-Ray)

---

## 15. Advanced Security Hardening

> Inspired by: **OWASP Top 10**, **Netflix Zuul** gateway security filters, **Spring Security** `FilterChain`, **Google** zero-trust architecture.

### OWASP Top 10 → NestJS Mapping

| OWASP Risk | NestJS Protection | Project Status |
|------------|------------------|----------------|
| **A01: Broken Access Control** | `@Roles()` + `RolesGuard` + composite decorators | ✅ Covered |
| **A02: Cryptographic Failures** | `helmet()` HSTS headers, bcrypt for passwords | ✅ Partial |
| **A03: Injection** | `ValidationPipe({ whitelist: true })`, TypeORM parameterized queries | ✅ Covered |
| **A04: Insecure Design** | Handler pattern separates concerns, entities enforce invariants | ✅ Covered |
| **A05: Security Misconfiguration** | `helmet()`, CORS config, env-based secrets | ✅ Partial |
| **A06: Vulnerable Components** | `npm audit`, keep deps updated | ⚠️ Manual |
| **A07: Auth Failures** | JWT + refresh tokens, bcrypt, `@Public()` explicit opt-in | ✅ Covered |
| **A08: Data Integrity Failures** | `class-validator` + `whitelist: true` strips unknown fields | ✅ Covered |
| **A09: Logging Failures** | `LoggingMiddleware`, `AuditInterceptor`, `Logger` | ✅ Covered |
| **A10: SSRF** | Validate URLs in DTOs, no user-controlled outbound requests | ⚠️ Manual |

### Input Sanitization Beyond Whitelisting

The `ValidationPipe({ whitelist: true })` strips unknown properties. Additional measures:

```typescript
// 1. Whitelist + forbid unknown (stricter)
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,  // throw error on unknown fields
  transform: true,              // auto-transform payloads to DTO instances
}));

// 2. In DTOs — sanitize strings
import { Transform } from 'class-transformer';

export class CreateEntityDto {
  @IsString()
  @MaxLength(255)
  @Transform(({ value }) => value?.trim())  // trim whitespace
  name: string;
}

// 3. For HTML content — use a sanitizer library
// npm install sanitize-html
import sanitizeHtml from 'sanitize-html';

@Transform(({ value }) => sanitizeHtml(value, { allowedTags: [] }))
@IsString()
description: string;
```

### Secrets Management

```
✅ Correct:
  - Store secrets in .env (gitignored)
  - Use ConfigService to read env vars
  - Use cloud secret managers in production (GCP Secret Manager, AWS Secrets Manager)

❌ Wrong:
  - Hardcoded passwords/API keys in source code
  - Committing .env to Git
  - Logging sensitive data (tokens, passwords)
```

### Security Headers (helmet)

Already configured in `main.ts`. Helmet sets:
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `Strict-Transport-Security` (HSTS)
- `X-XSS-Protection`
- Removes `X-Powered-By`

### Rate Limiting Strategy

| Endpoint Type | Rate Limit | Reasoning |
|---------------|-----------|-----------|
| Public listings | 100 req/min | Prevent scraping |
| Login/Register | 5 req/min | Prevent brute force |
| Mutation (POST/PUT/PATCH) | 30 req/min | Prevent abuse |
| Admin endpoints | 60 req/min | Trusted but limited |
| File upload | 10 req/min | Resource intensive |

---

## 16. Observability

> Inspired by: **Spring Boot Actuator**, **Go** `net/http/pprof`, **Google SRE** golden signals, **Uber Jaeger** tracing dashboards.

### Health Check Endpoint

Use `@nestjs/terminus` for production health checks:

```typescript
// src/health/health.controller.ts
import { Controller, Get } from '@nestjs/common';
import { HealthCheck, HealthCheckService, TypeOrmHealthIndicator } from '@nestjs/terminus';
import { Public } from '@/common/decorators/auth/public.decorator';

@Controller('health')
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private db: TypeOrmHealthIndicator,
  ) {}

  @Get()
  @Public()
  @HealthCheck()
  check() {
    return this.health.check([
      () => this.db.pingCheck('database'),
    ]);
  }
}
```

### Four Golden Signals (Google SRE)

Monitor these for every API:

| Signal | What to Measure | How in NestJS |
|--------|----------------|---------------|
| **Latency** | Request duration | `LoggingMiddleware` already logs `${duration}ms` |
| **Traffic** | Request rate | Count in middleware or APM tool |
| **Errors** | Error rate by status code | `AllExceptionsFilter` logs all errors |
| **Saturation** | CPU/memory/connection pool | External monitoring (PM2, Docker stats) |

### Performance Timing in LoggingMiddleware

The existing `LoggingMiddleware` already captures:
- Request start time
- Response duration (`Date.now() - startTime`)
- Status code coloring (500=error, 400=warn)
- Content length

For endpoint-level timing, use a custom interceptor:

```typescript
@Injectable()
export class TimingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('Timing');

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const handler = context.getHandler().name;
    const controller = context.getClass().name;
    const start = Date.now();

    return next.handle().pipe(
      tap(() => {
        const duration = Date.now() - start;
        if (duration > 1000) {
          this.logger.warn(`SLOW: ${controller}.${handler}() took ${duration}ms`);
        }
      }),
    );
  }
}
```

