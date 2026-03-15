---
description: Add a new API endpoint to an existing module following enterprise patterns
---

# New API Endpoint Workflow

Use this workflow when adding a **new API endpoint** to an existing module.

---

## 1. Choose Security Tier

Decide which audience this endpoint serves:

| Tier | Decorator | Route Prefix | When to Use |
|------|-----------|-------------|-------------|
| **Public** | `@Public()` on method | `/v1/{resource}` | Guest browsing, listings, health checks |
| **User** | `@UserApi('resource')` | `/v1/user/{resource}` | Mobile app user actions |
| **Partner** | `@PartnerApi('resource')` | `/v1/partner/{resource}` | Partner dashboard operations |
| **Admin** | `@AdminApi('resource')` | `/v1/admin/{resource}` | Admin panel management |
| **Mixed** | Manual `@UseGuards()` + `@Roles()` | Custom | Endpoints serving multiple roles |

**Decision Tree:**
- Does it need authentication? → No → `@Public()`
- Is it for mobile app users? → `@UserApi()`
- Is it for clinic/partner dashboard? → `@PartnerApi()`
- Is it for admin panel? → `@AdminApi()`
- Multiple roles? → Manual guards per method

---

## 2. Input Sanitization & DTO Design

> Inspired by: **Spring `@Valid` + JSR-303**, **OWASP Input Validation Cheat Sheet**

### Sanitization Rules

- Always `@Transform(({ value }) => value?.trim())` on string fields
- Use `forbidNonWhitelisted: true` globally (already in `main.ts`)
- For HTML content: use `sanitize-html` via `@Transform()` 
- See **§15 Advanced Security Hardening** in `api-implementation-expert` skill

### Create Request DTO (Input)

```typescript
// src/<module>/dto/<audience>/create-<entity>.dto.ts
import { IsString, IsNotEmpty, IsOptional, MaxLength, IsUUID, IsNumber, Min, IsEnum, IsArray, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateEntityDto {
  @ApiProperty({ example: 'Example Name', description: 'Name of the entity' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;

  @ApiPropertyOptional({ example: 'uuid-category-id' })
  @IsUUID()
  @IsOptional()
  categoryId?: string;

  // For nested objects:
  @ApiPropertyOptional({ type: NestedDto })
  @IsOptional()
  @ValidateNested()
  @Type(() => NestedDto)          // ⚠️ REQUIRED - without this, validation fails silently
  nested?: NestedDto;

  // For nested arrays:
  @ApiPropertyOptional({ type: [NestedItemDto] })
  @IsArray()
  @IsOptional()
  @ValidateNested({ each: true })
  @Type(() => NestedItemDto)      // ⚠️ REQUIRED for arrays too
  items?: NestedItemDto[];
}
```

### Query DTO (for listing endpoints)

```typescript
// src/<module>/dto/<audience>/get-<entities>-query.dto.ts
import { BasePaginationDto } from '@/common/dto/base-pagination.dto';

export class GetEntitiesQueryDto extends BasePaginationDto {
  @ApiPropertyOptional({ example: 'active' })
  @IsOptional()
  @IsString()
  status?: string;

  @ApiPropertyOptional({ example: 'uuid' })
  @IsOptional()
  @IsUUID()
  categoryId?: string;
}
```

> **Note:** If `BasePaginationDto` doesn't exist yet, see the `/add-pagination` workflow.

---

## 3. Create Response DTO (Output)

```typescript
// src/<module>/dto/<audience>/<entity>-response.dto.ts
import { Expose, Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class EntityResponseDto {
  @ApiProperty()
  @Expose()
  id: string;

  @ApiProperty()
  @Expose()
  name: string;

  @ApiPropertyOptional()
  @Expose()
  @Type(() => CategoryResponseDto)
  category?: CategoryResponseDto;

  @ApiProperty()
  @Expose()
  createdAt: Date;

  /**
   * Factory method - preferred pattern for converting Entity → ResponseDto.
   */
  static fromEntity(entity: SomeEntity): EntityResponseDto {
    const dto = new EntityResponseDto();
    dto.id = entity.id;
    dto.name = entity.name;
    dto.category = entity.category
      ? CategoryResponseDto.fromEntity(entity.category)
      : undefined;
    dto.createdAt = entity.createdAt;
    return dto;
  }

  static fromEntities(entities: SomeEntity[]): EntityResponseDto[] {
    return entities.map((e) => EntityResponseDto.fromEntity(e));
  }
}
```

### DTO Directory Structure

Organize DTOs by audience:
```
dto/
├── partner/           # Partner-facing DTOs
│   ├── create-partner-<entity>.dto.ts
│   ├── update-partner-<entity>.dto.ts
│   └── partner-<entity>-response.dto.ts
├── public/            # Public-facing DTOs (different shape from partner)
│   └── public-<entity>-response.dto.ts
└── admin/             # Admin-facing DTOs (if needed)
    └── admin-<entity>-response.dto.ts
```

---

## 4. Create Handler (Mutations Only)

Only create a handler if the endpoint **mutates data** (POST, PUT, PATCH, DELETE).
For read-only endpoints, add the query directly in the service.

```typescript
// src/<module>/application/handlers/create-<entity>.handler.ts
import { Injectable, Logger, ConflictException, InternalServerErrorException } from '@nestjs/common';
import { DataSource } from 'typeorm';

@Injectable()
export class CreateEntityHandler {
  private readonly logger = new Logger(CreateEntityHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(command: CreateEntityDto): Promise<SomeEntity> {
    this.logger.log(`Creating entity: ${command.name}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Invariant Check - fail fast
      // if (invalidCondition) throw new ConflictException('...');

      // 2. Domain Action - prepare entity
      const entity = queryRunner.manager.create(SomeEntity, { ...command });

      // 3. Persistence
      const saved = await queryRunner.manager.save(SomeEntity, entity);

      // 4. Handle Relations (media, tags, etc.)
      // ...

      // 5. Commit
      await queryRunner.commitTransaction();
      this.logger.log(`Entity created: ${saved.id}`);

      // 6. Post-commit reload with relations
      return await this.dataSource.manager.findOne(SomeEntity, {
        where: { id: saved.id },
        relations: ['category', 'media'],
      });
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(`Failed: ${error.message}`, error.stack);
      if (error instanceof ConflictException) throw error;
      throw new InternalServerErrorException('Transaction failed');
    } finally {
      await queryRunner.release();
    }
  }
}
```

---

## 5. Add Service Facade Method

```typescript
// In <module>.service.ts

// For mutations — delegate to handler:
async create(dto: CreateEntityDto): Promise<SomeEntity> {
  return this.createEntityHandler.execute(dto);
}

// For queries — use repository directly:
async findOne(id: string): Promise<SomeEntity> {
  const entity = await this.repo.findOne({
    where: { id },
    relations: ['category', 'media'],
  });
  if (!entity) {
    this.logger.warn(`Entity not found: ${id}`);
    throw new NotFoundException(`Entity with ID ${id} not found`);
  }
  return entity;
}
```

---

## 6. Add Rate Limiting (Mutation/Sensitive Endpoints)

> Inspired by: **Netflix Zuul** rate limiting filters, **Google API** quota management

```typescript
import { Throttle } from '@nestjs/throttler';

// For sensitive mutations (create, update)
@Throttle({ default: { limit: 30, ttl: 60000 } })  // 30 req/min

// For login/registration
@Throttle({ default: { limit: 5, ttl: 60000 } })   // 5 req/min

// For file uploads
@Throttle({ default: { limit: 10, ttl: 60000 } })  // 10 req/min
```

See **§15 Rate Limiting Strategy** in `api-implementation-expert` skill for full table.

---

## 7. Add Controller Method

```typescript
// Mutation endpoint (POST)
@Post()
@ApiOperation({ summary: 'Create a new entity' })
@ApiCreatedResponse({ description: 'Entity created.', type: EntityResponseDto })
create(@Body() dto: CreateEntityDto): Promise<EntityResponseDto> {
  return this.service.create(dto);
}

// Read endpoint (GET by ID)
@Get(':id')
@ApiOperation({ summary: 'Get entity by ID' })
@ApiOkResponse({ description: 'Return entity.', type: EntityResponseDto })
@ApiNotFoundResponse({ description: 'Entity not found.' })
findOne(@Param('id', ParseUUIDPipe) id: string): Promise<EntityResponseDto> {
  return this.service.findOne(id);
}

// Delete endpoint
@Delete(':id')
@HttpCode(HttpStatus.NO_CONTENT)
@ApiOperation({ summary: 'Delete entity' })
@ApiNoContentResponse({ description: 'Entity deleted.' })
remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
  return this.service.remove(id);
}
```

### HTTP Status Code Guide

| Verb | Success Status | Decorator |
|------|---------------|-----------|
| `GET` | `200 OK` | `@ApiOkResponse()` |
| `POST` | `201 Created` | `@ApiCreatedResponse()` |
| `PUT/PATCH` | `200 OK` | `@ApiOkResponse()` |
| `DELETE` | `204 No Content` | `@ApiNoContentResponse()` + `@HttpCode(HttpStatus.NO_CONTENT)` |
| Async job | `202 Accepted` | `@ApiAcceptedResponse()` |

---

## 8. Add Cross-Cutting Concerns

> Inspired by: **Spring AOP** `@Aspect`, **Uber Jaeger** tracing, **Netflix** audit filters

### Audit Logging (Admin Write Endpoints)

```typescript
// For admin controllers with write operations:
import { UseInterceptors } from '@nestjs/common';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';
import { Audit } from '@/audit/decorators/audit.decorator';

@AdminApi('partners')
@UseInterceptors(AuditInterceptor)
export class AdminPartnersController {
  @Put(':id/review')
  @Audit('PARTNER_REVIEW', 'Partner')  // action, entity type
  review(...) { ... }
}
```

### Response Logging (Debugging)

```typescript
import { LogResponse } from '@/common/interceptors/response.interceptor';

@Get(':id')
@LogResponse()  // Logs full response body for debugging
findOne(...) { ... }
```

### Decorator Stacking Order

Follow this order on methods for consistency:
```typescript
@Post()                   // 1. HTTP verb
@Roles(Role.ADMIN)        // 2. Role (if manual guards)
@Throttle(...)            // 3. Rate limit
@Audit('ACTION', 'Ent')   // 4. Audit metadata
@ApiOperation(...)        // 5. Swagger docs
@ApiCreatedResponse(...)  // 6. Response docs
```

See **§13 Decorator Composition** in `api-implementation-expert` skill.

---

## 9. Register in Module

```typescript
// <module>.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([SomeEntity])],
  controllers: [ModuleController],
  providers: [
    ModuleService,
    CreateEntityHandler,  // ← Don't forget to register handlers!
  ],
  exports: [ModuleService],
})
```

---

## 10. Verify Request Pipeline

> Inspired by: **Spring Boot `HandlerInterceptor`** lifecycle — verify the full pipeline works

Confirm request flows through the full pipeline:
```
Middleware (LoggingMiddleware) → Guard (JwtAuthGuard → RolesGuard)
→ Interceptor (AuditInterceptor) → Pipe (ValidationPipe) → Controller
→ Interceptor (post) → Filter (AllExceptionsFilter if error)
```

See **§11 Request Lifecycle Pipeline** in `api-implementation-expert` skill.

---

## 11. Build & Test

// turbo
```bash
npm run build
```

// turbo
```bash
npm run test
```

---

## 12. Rebuild OpenAPI Spec

// turbo
```bash
npm run start:dev
```

Then check Swagger at `http://localhost:8080/api/docs` and verify the new endpoint appears.

---

## Quick Reference: Common Imports

```typescript
// Guards & Decorators
import { Public } from '@/common/decorators/auth/public.decorator';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';
import { AdminApi } from '@/common/decorators/api/admin-api.decorator';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { LogResponse } from '@/common/interceptors/response.interceptor';
import { Role } from '@/account/enum/role.enum';

// Guards (if not using composite decorators)
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';

// Entities are in:
import { Product } from '@/common/entities/product.entity';
// See: src/common/entities/index.ts for full list

// Throttling
import { Throttle } from '@nestjs/throttler';

// Audit (admin endpoints)
import { Audit } from '@/audit/decorators/audit.decorator';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';
```

---

## 13. Update Module Todos

After verifying, run the `/update-todos` workflow to document this implementation in `todos/<module-name>/`.
