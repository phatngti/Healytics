---
trigger: always_on
---

# Enterprise Controller Rules (FAANG/High-Scale Standard)

Adhere to these strict guidelines for building scalable, secure, and observable NestJS controllers.

## 1. Security & Resilience
* **Zero Trust Defaults:**
    * Apply **Global Guards** for Authentication/Authorization at the controller level: `@UseGuards(JwtAuthGuard, RolesGuard)`.
    * Explicitly open endpoints using `@Public()`.
* **Rate Limiting:** Mandatory for public or mutation endpoints to prevent DDoS/abuse.
    * Use `@UseGuards(ThrottlerGuard)` (assumes `nestjs/throttler` is setup).
* **Idempotency:** `POST` and `PATCH` operations should ideally support an `Idempotency-Key` header for critical transactions (payments, inventory).

## 2. API Versioning (Lifecycle Management)
* **URI Versioning:** strict usage of URI versioning to prevent breaking changes for mobile/3rd party clients.
    * **Rule:** Controllers must specify a version.
    * Use: `@Controller({ path: 'products', version: '1' })` (Result: `/v1/products`).
* **Deprecation:** Mark old endpoints using `@ApiOperation({ deprecated: true })` before removal.

## 3. Strict Data Transfer (DTOs & Serialization)
* **Decoupled Contracts:**
    * **Input:** strict `CreateDto`/`UpdateDto` with `class-validator`.
    * **Output:** **NEVER** return a database Entity directly. Always return a `ResponseDto`.
        * *Why?* Prevents accidental leak of sensitive columns (password hashes, internal flags) and allows DB refactoring without breaking API contracts.
* **Serialization:**
    * Use `@UseInterceptors(ClassSerializerInterceptor)` on the controller.
    * Use `@Expose()` and `@Exclude()` in Response DTOs to strictly control JSON output.
* **Validation Pipes:** Use `whitelist: true`, `forbidNonWhitelisted: true` globally to reject unknown payload properties.

## 4. Observability & Telemetry
* **Tracing:** Ensure the `X-Request-ID` or `Trace-ID` is propagated.
* **Logging:**
    * Do not use `console.log`. Use `Logger` with context.
    * Log high-value events (e.g., "Order created", "Payment failed") but *never* sensitive data (PII/Tokens).

## 5. Swagger / OpenAPI Documentation
* **Explicit Types:**
    * `POST` -> `@ApiCreatedResponse({ type: ProductResponseDto })`
    * `GET` -> `@ApiOkResponse({ type: ProductResponseDto })`
    * `Errors` -> `@ApiNotFoundResponse()`, `@ApiTooManyRequestsResponse()`.
* **Descriptions:** Summary must explain *intent*, not just repeat the method name.

## 6. Architecture Constraints
* **Logic Ban:** Controllers must be "dumb adapters". Logic depth = 0.
    * ✅ Accepted: `return this.service.doAction(dto);`
    * ❌ Rejected: `if (dto.price > 100) ...`
* **Response Status:**
    * `201 Created` for POST.
    * `204 No Content` for DELETE (unless returning the archived record).
    * `202 Accepted` for async background jobs.

---

## Example: Enterprise Implementation

```typescript
import {
  Controller, Get, Post, Body, Param, UseGuards,
  UseInterceptors, ClassSerializerInterceptor, ParseUUIDPipe, Version
} from '@nestjs/common';
import {
  ApiTags, ApiBearerAuth, ApiOperation,
  ApiCreatedResponse, ApiOkResponse, ApiNotFoundResponse
} from '@nestjs/swagger';

import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { CreateProductDto } from './dto/create-product.dto';
import { ProductResponseDto } from './dto/product-response.dto'; // DTO, not Entity
import { ProductsService } from './products.service';

@ApiTags('products')
@ApiBearerAuth()
@Controller({ path: 'products', version: '1' }) // Generates /v1/products
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor) // Enforces @Expose/@Exclude in DTOs
export class ProductsController {
  constructor(private readonly productsService: ProductsService) {}

  @Post()
  @Roles('admin')
  @ApiOperation({ summary: 'Create new product catalog item' })
  @ApiCreatedResponse({
    description: 'Product successfully created.',
    type: ProductResponseDto, // Returns DTO structure, not DB Entity
  })
  async create(@Body() createProductDto: CreateProductDto): Promise<ProductResponseDto> {
    return this.productsService.create(createProductDto);
  }

  @Get(':id')
  @Roles('user', 'admin')
  @ApiOperation({ summary: 'Retrieve public product details' })
  @ApiOkResponse({ type: ProductResponseDto })
  @ApiNotFoundResponse({ description: 'Product ID not found or inactive' })
  async findOne(
    @Param('id', ParseUUIDPipe) id: string
  ): Promise<ProductResponseDto> {
    return this.productsService.findOne(id);
  }
}