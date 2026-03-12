---
description: Create a new NestJS controller with correct security tier and patterns
---

# New Controller Workflow

Use this workflow when creating a **new controller** for an existing module, e.g., adding a partner-facing controller to a module that only has public endpoints.

---

## 1. Choose Security Tier

### Decision Tree

```
Does this controller need authentication?
├── NO → Plain @Controller() + @Public() per route
│         Example: HealthServiceController (public browsing)
│
└── YES → Which role?
    ├── USER (mobile app) → @UserApi('resource')
    │     Route: /v1/user/{resource}
    │     Example: UserEmployeesController
    │
    ├── HEALTH_PARTNER (clinic dashboard) → @PartnerApi('resource')
    │     Route: /v1/partner/{resource}
    │     Example: PartnerHealthServiceController
    │
    ├── ADMIN (admin panel) → @AdminApi('resource')
    │     Route: /v1/admin/{resource}
    │     Example: AdminPartnersController
    │
    └── MIXED (multiple roles per route) → Manual setup
          Use @UseGuards() + @Roles() per method
          Example: PartnersController (public + partner routes)
```

---

## 2. Create Controller File

### Option A: Composite Decorator (Recommended)

For controllers where **all endpoints share the same role:**

```typescript
// src/<module>/partner-<module>.controller.ts
import { Get, Post, Body, Param, Delete, ParseUUIDPipe, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiOperation, ApiCreatedResponse, ApiOkResponse, ApiNotFoundResponse, ApiNoContentResponse } from '@nestjs/swagger';
import { PartnerApi } from '@/common/decorators/api/partner-api.decorator';

/**
 * Partner controller for <resource> management.
 * All endpoints require HEALTH_PARTNER authentication.
 * Route prefix: /v1/partner/<resource>
 */
@PartnerApi('<resource>')
export class Partner<Module>Controller {
  constructor(private readonly service: <Module>Service) {}

  @Get()
  @ApiOperation({ summary: 'List all <resources>' })
  @ApiOkResponse({ type: [ResponseDto] })
  findAll(): Promise<ResponseDto[]> {
    return this.service.findAll();
  }

  @Post()
  @ApiOperation({ summary: 'Create <resource>' })
  @ApiCreatedResponse({ type: ResponseDto })
  create(@Body() dto: CreateDto): Promise<ResponseDto> {
    return this.service.create(dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete <resource>' })
  @ApiNoContentResponse()
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.service.remove(id);
  }
}
```

### Option B: Public Controller

For controllers where **all endpoints are publicly accessible:**

```typescript
// src/<module>/<module>.controller.ts
import { Controller, Get, Param, UseInterceptors, ClassSerializerInterceptor, ParseUUIDPipe } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiOkResponse, ApiNotFoundResponse } from '@nestjs/swagger';
import { Public } from '@/common/decorators/auth/public.decorator';

@ApiTags('<Resource>')
@Controller({ path: '<resource>', version: '1' })
@UseInterceptors(ClassSerializerInterceptor)
export class <Module>Controller {
  constructor(private readonly service: <Module>Service) {}

  @Get()
  @Public()
  @ApiOperation({ summary: 'List <resources>' })
  @ApiOkResponse({ type: [ResponseDto] })
  findAll(): Promise<ResponseDto[]> {
    return this.service.findAll();
  }

  @Get(':id')
  @Public()
  @ApiOperation({ summary: 'Get <resource> by ID' })
  @ApiOkResponse({ type: ResponseDto })
  @ApiNotFoundResponse({ description: '<Resource> not found.' })
  findOne(@Param('id', ParseUUIDPipe) id: string): Promise<ResponseDto> {
    return this.service.findOne(id);
  }
}
```

### Option C: Mixed Roles (Manual Guards)

For controllers where **different routes have different roles:**

```typescript
// src/<module>/<module>.controller.ts
import { Controller, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Public } from '@/common/decorators/auth/public.decorator';
import { Role } from '@/account/enum/role.enum';

@ApiTags('<Resource>')
@Controller('<resource>')
export class <Module>Controller {
  constructor(private readonly service: <Module>Service) {}

  // Public endpoint - no auth
  @Get('public-data')
  @Public()
  getPublicData() { ... }

  // Partner-only endpoint
  @Get('me')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.HEALTH_PARTNER)
  @ApiBearerAuth()
  getMyData(@Req() req) { ... }

  // Admin-only endpoint
  @Put(':id/review')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(Role.ADMIN)
  @ApiBearerAuth()
  review(@Param('id') id: string, @Body() dto: ReviewDto) { ... }
}
```

---

## 3. Apply Middleware (If Needed)

> Inspired by: **Netflix Zuul** pre-filters, **Go** middleware chain

If your new controller needs middleware applied to specific routes (beyond the global `LoggingMiddleware`):

```typescript
// src/app.module.ts
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(CorrelationIdMiddleware, LoggingMiddleware)
      .forRoutes('*');

    // Route-specific middleware:
    // consumer
    //   .apply(IpWhitelistMiddleware)
    //   .forRoutes({ path: 'admin/*', method: RequestMethod.ALL });
  }
}
```

See **§12 Middleware Patterns** in `api-implementation-expert` skill.

---

## 4. Add Rate Limiting (Sensitive Endpoints)

> Inspired by: **Netflix / Google API** quota management

```typescript
import { Throttle } from '@nestjs/throttler';

// Limit to 5 requests per 60 seconds
@Post()
@Throttle({ default: { limit: 5, ttl: 60000 } })
create(@Body() dto: CreateDto) { ... }
```

---

## 4. Add Audit Logging (Admin Write Endpoints)

```typescript
import { Audit } from '@/audit/decorators/audit.decorator';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';

@AdminApi('partners')
@UseInterceptors(AuditInterceptor)
export class AdminPartnersController {

  @Put(':id/review')
  @Audit('PARTNER_REVIEW', 'Partner')
  review(@Param('id') id: string, @Body() dto: ReviewDto, @Req() req) { ... }
}
```

---

## 5. Register in Module

```typescript
// <module>.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([Entity])],
  controllers: [
    <Module>Controller,            // existing controller
    Partner<Module>Controller,     // ← new controller
  ],
  providers: [<Module>Service, ...handlers],
  exports: [<Module>Service],
})
```

---

## 6. Add to AppModule (If New Module)

```typescript
// src/app.module.ts
@Module({
  imports: [
    // ... existing
    NewModule,   // ← add here
  ],
})
export class AppModule {}
```

---

## 7. Error Handling Guide

> Inspired by: **Spring `@ControllerAdvice`**, **Go** `error` return pattern

Choose the right exception for each scenario:

| Scenario | Exception | HTTP |
|----------|-----------|------|
| Entity not found | `NotFoundException` | 404 |
| Business rule violation | `ConflictException` | 409 |
| Invalid input (beyond validation) | `BadRequestException` | 400 |
| Missing/invalid JWT | `UnauthorizedException` | 401 |
| Insufficient role | `ForbiddenException` | 403 |
| Unexpected failure | `InternalServerErrorException` | 500 |

See **§8 Error Handling** in `api-implementation-expert` skill.

---

## 8. Verify Pipeline

> Inspired by: **Spring Boot `HandlerInterceptor`** lifecycle

Confirm the full request pipeline works for your new controller:
```
Middleware (LoggingMiddleware) → Guard (JwtAuthGuard → RolesGuard)
→ Interceptor (AuditInterceptor) → Pipe (ValidationPipe) → Controller
→ Interceptor (post) → Filter (AllExceptionsFilter if error)
```

See **§11 Request Lifecycle Pipeline** in `api-implementation-expert` skill.

---

## 9. Verify

// turbo
```bash
npm run build
```

// turbo
```bash
npm run test
```

---

## Naming Conventions

| Security Tier | File Name | Class Name | Route |
|--------------|-----------|------------|-------|
| Public | `<module>.controller.ts` | `<Module>Controller` | `/v1/<resource>` |
| User | `user-<module>.controller.ts` | `User<Module>Controller` | `/v1/user/<resource>` |
| Partner | `partner-<module>.controller.ts` | `Partner<Module>Controller` | `/v1/partner/<resource>` |
| Admin | `admin-<module>.controller.ts` | `Admin<Module>Controller` | `/v1/admin/<resource>` |

## Swagger Tag Naming

| Tier | Tag | Example |
|------|-----|---------|
| Public | `<Resource>` | `Health Services` |
| User | `User <Resource>` | `User Health Services` |
| Partner | `Partner <Resource>` | `Partner Health Services` |
| Admin | `Admin <Resource>` | `Admin Partners` |
