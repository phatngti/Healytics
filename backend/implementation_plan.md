# Clinic Info Feature — Backend API Specification (Final)

## Overview

The **Clinic Info** feature provides a full clinic profile page in the user app with three tab views: **Shop** (clinic overview), **Services** (product catalog), and **Reviews** (paginated user reviews with server-side filtering).

All clinic endpoints are implemented in a **new dedicated `src/clinic/` NestJS module** (`@UserApi('clinics')`). The existing `GET /v1/user/health-services/clinics/:id/info` endpoint in `UserHealthServiceController` is **kept as-is** (no refactoring/removal).

---

## Decisions (Locked)

| # | Decision | Answer |
|---|----------|--------|
| 1 | Old `health-service` clinic endpoint | **Keep it**. New clinic module is independent, not a migration |
| 2 | `clinic_review_responses` table | **Create now**. Submit review response endpoint deferred |
| 3 | Products filtering/sorting | **Server-side** via query parameters |
| 4 | Follower count | Read from database (`follower_count` column, default `0`) |
| 5 | Member badges | `null` for MVP — no loyalty tier system yet |

---

## Current Database Schema (Verified from 42 Migration Scripts)

### `health_partner_profile` — Current Columns

| Column | Type | Nullable | Source Migration |
|--------|------|----------|-----------------|
| `id` | UUID PK | No | `1769427310000-CreatePartnerTables` |
| `tax_code` | varchar(20) UNIQUE | No | `1769427310000` |
| `legal_name` | varchar(200) | No | `1769427310000` |
| `brand_name` | varchar(150) | No | `1769427310000` |
| `business_type` | varchar(500) | No | `1770000000000-RefactorBusinessTypeToVarchar` |
| `province_id` | UUID FK→location | Yes | `1769427310000` |
| `district_id` | UUID FK→location | Yes | `1769427310000` |
| `ward_id` | UUID FK→location | Yes | `1769427310000` |
| `street_address` | varchar(300) | No | `1769427310000` |
| `coordinates` | text | Yes | `1773600000000-RefactorGeoToCoordinatesAndPostgisLocation` |
| `location` | geography(Point, 4326) | Yes | `1773600000000` |
| `phone_number` | varchar(20) | Yes | `1769427310000` |
| `account_id` | UUID FK→account UNIQUE | No | `1769427310000` |
| `verification_status` | enum(PENDING,APPROVED,REJECTED) | No | `1769427310000` |
| `verification_completed_at` | timestamptz | Yes | `1769427310000` |
| `created_at`, `updated_at`, `deleted_at` | timestamptz | — | `1769427310000` |

**Missing columns** (needed by frontend, currently hardcoded as null/empty):
- `cover_image_url`, `logo_image_url`, `gallery`, `description`, `follower_count`

### Existing Columns We Can Reuse (No Migration Needed)

| Frontend Need | Existing Column | Table |
|---------------|----------------|-------|
| Specialist experience label | `start_date` (date) | `employees` |
| Doctor experience years | `experience_years` (int) | `doctor_profiles` |
| Service duration label | `duration_minutes` (int) | `product_definitions` |
| Service sold count | COUNT query on `product_id` | `bookings` (status=COMPLETED) |
| Specialist role/title | `role` (enum), `job_title` (varchar) | `employees` |
| Specialist avatar | `avatar_url` (text) | `employees` |
| Clinic age (trust metric) | `created_at` (timestamptz) | `health_partner_profile` |
| Product pricing/discount | `base_price`, `sale_price` (decimal) | `products` |
| Review photos | `photo_urls` (jsonb) | `product_treatment_reviews` |

### Tables That Do NOT Exist Yet

| Table | Purpose |
|-------|---------|
| ❌ `partner_certifications` | Clinic certifications/awards for Shop tab |
| ❌ `clinic_review_responses` | Clinic replies to user reviews |

---

## Database Migrations (3 Total — All Additive-Only)

### Migration 1: `AddClinicProfileColumnsToPartner` 🟡

**Action**: ADD 5 nullable columns to existing `health_partner_profile` table.

**Risk**: Medium — alters core table, but adding nullable columns with defaults is a **non-locking DDL** in PostgreSQL ≥11. No table rewrite.

```typescript
import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddClinicProfileColumnsToPartner1776000000000
  implements MigrationInterface
{
  name = 'AddClinicProfileColumnsToPartner1776000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'cover_image_url'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN cover_image_url TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'logo_image_url'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN logo_image_url TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'gallery'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN gallery JSONB DEFAULT '[]';
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'description'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN description TEXT;
        END IF;

        IF NOT EXISTS (
          SELECT 1 FROM information_schema.columns
          WHERE table_name = 'health_partner_profile'
            AND column_name = 'follower_count'
        ) THEN
          ALTER TABLE health_partner_profile
            ADD COLUMN follower_count INT DEFAULT 0;
        END IF;
      END $$;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE health_partner_profile
        DROP COLUMN IF EXISTS follower_count,
        DROP COLUMN IF EXISTS description,
        DROP COLUMN IF EXISTS gallery,
        DROP COLUMN IF EXISTS logo_image_url,
        DROP COLUMN IF EXISTS cover_image_url;
    `);
  }
}
```

**Pattern**: Follows the established `IF NOT EXISTS` pattern from [1773500000000-AddGeoColumnsToPartnerProfile](file:///Volumes/WD850X/Users/workspace/datn/Healytics/backend/migrations/scripts/1773500000000-AddGeoColumnsToPartnerProfile.ts).

---

### Migration 2: `CreatePartnerCertificationsTable` 🟢

**Action**: Create new `partner_certifications` table. Zero risk — no existing tables modified.

```typescript
import {
  MigrationInterface, QueryRunner,
  Table, TableForeignKey, TableIndex,
} from 'typeorm';

export class CreatePartnerCertificationsTable1776000100000
  implements MigrationInterface
{
  name = 'CreatePartnerCertificationsTable1776000100000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(new Table({
      name: 'partner_certifications',
      columns: [
        {
          name: 'id', type: 'uuid', isPrimary: true,
          isGenerated: true, generationStrategy: 'uuid',
          default: 'uuid_generate_v4()',
        },
        { name: 'partner_id', type: 'uuid' },
        { name: 'title', type: 'varchar', length: '200' },
        {
          name: 'subtitle', type: 'varchar',
          length: '200', isNullable: true,
        },
        {
          name: 'icon_name', type: 'varchar',
          length: '50', default: "'workspace_premium'",
        },
        { name: 'sort_order', type: 'int', default: 0 },
        {
          name: 'created_at', type: 'timestamptz',
          default: 'now()',
        },
      ],
    }), true);

    await queryRunner.createIndex(
      'partner_certifications',
      new TableIndex({
        name: 'IDX_PARTNER_CERTIFICATIONS_PARTNER_ID',
        columnNames: ['partner_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'partner_certifications',
      new TableForeignKey({
        name: 'FK_PARTNER_CERTIFICATIONS_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'partner_certifications',
      'FK_PARTNER_CERTIFICATIONS_PARTNER',
    );
    await queryRunner.dropIndex(
      'partner_certifications',
      'IDX_PARTNER_CERTIFICATIONS_PARTNER_ID',
    );
    await queryRunner.dropTable('partner_certifications', true);
  }
}
```

---

### Migration 3: `CreateClinicReviewResponsesTable` 🟢

**Action**: Create new `clinic_review_responses` table. Zero risk — no existing tables modified.

```typescript
import {
  MigrationInterface, QueryRunner,
  Table, TableForeignKey, TableIndex, TableUnique,
} from 'typeorm';

export class CreateClinicReviewResponsesTable1776000200000
  implements MigrationInterface
{
  name = 'CreateClinicReviewResponsesTable1776000200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(new Table({
      name: 'clinic_review_responses',
      columns: [
        {
          name: 'id', type: 'uuid', isPrimary: true,
          isGenerated: true, generationStrategy: 'uuid',
          default: 'uuid_generate_v4()',
        },
        { name: 'review_id', type: 'uuid' },
        { name: 'partner_id', type: 'uuid' },
        { name: 'response_text', type: 'text' },
        {
          name: 'created_at', type: 'timestamptz',
          default: 'now()',
        },
        {
          name: 'updated_at', type: 'timestamptz',
          default: 'now()',
        },
      ],
    }), true);

    // One response per review
    await queryRunner.createUniqueConstraint(
      'clinic_review_responses',
      new TableUnique({
        name: 'UQ_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
        columnNames: ['review_id'],
      }),
    );

    await queryRunner.createIndex(
      'clinic_review_responses',
      new TableIndex({
        name: 'IDX_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
        columnNames: ['review_id'],
      }),
    );

    await queryRunner.createForeignKey(
      'clinic_review_responses',
      new TableForeignKey({
        name: 'FK_CLINIC_REVIEW_RESPONSES_REVIEW',
        columnNames: ['review_id'],
        referencedTableName: 'product_treatment_reviews',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );

    await queryRunner.createForeignKey(
      'clinic_review_responses',
      new TableForeignKey({
        name: 'FK_CLINIC_REVIEW_RESPONSES_PARTNER',
        columnNames: ['partner_id'],
        referencedTableName: 'health_partner_profile',
        referencedColumnNames: ['id'],
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropForeignKey(
      'clinic_review_responses',
      'FK_CLINIC_REVIEW_RESPONSES_PARTNER',
    );
    await queryRunner.dropForeignKey(
      'clinic_review_responses',
      'FK_CLINIC_REVIEW_RESPONSES_REVIEW',
    );
    await queryRunner.dropIndex(
      'clinic_review_responses',
      'IDX_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
    );
    await queryRunner.dropUniqueConstraint(
      'clinic_review_responses',
      'UQ_CLINIC_REVIEW_RESPONSES_REVIEW_ID',
    );
    await queryRunner.dropTable('clinic_review_responses', true);
  }
}
```

---

### Final Schema After Migrations

```mermaid
erDiagram
    health_partner_profile ||--o{ partner_certifications : "has many"
    health_partner_profile ||--o{ products : "has many"
    health_partner_profile ||--o{ employees : "has many"
    products ||--o{ bookings : "has many"
    bookings ||--o| product_treatment_reviews : "has review"
    product_treatment_reviews ||--o| clinic_review_responses : "has response"
    clinic_review_responses }o--|| health_partner_profile : "from partner"

    health_partner_profile {
        uuid id PK
        varchar brand_name
        varchar street_address
        text cover_image_url "NEW ← Migration 1"
        text logo_image_url "NEW ← Migration 1"
        jsonb gallery "NEW ← Migration 1"
        text description "NEW ← Migration 1"
        int follower_count "NEW ← Migration 1"
        timestamptz created_at "used for experience label"
    }

    employees {
        uuid id PK
        varchar full_name
        varchar job_title
        text avatar_url
        date start_date "EXISTING ← experience calc"
        uuid partner_id FK
    }

    doctor_profiles {
        uuid employee_id PK_FK
        int experience_years "EXISTING ← experience label"
        jsonb specializations
    }

    products {
        uuid id PK
        uuid partner_id FK
        uuid category_id FK
        varchar name
        decimal base_price
        decimal sale_price
        varchar status
        boolean is_visible_online
    }

    product_definitions {
        uuid product_id PK_FK
        int duration_minutes "EXISTING ← duration label"
    }

    bookings {
        uuid id PK
        uuid product_id FK
        uuid user_id FK
        varchar status "COMPLETED for sold count"
    }

    product_treatment_reviews {
        uuid id PK
        uuid appointment_id FK_UNIQUE
        uuid user_id FK
        int rating
        text comment
        jsonb tags
        jsonb photo_urls
    }

    partner_certifications {
        uuid id PK "NEW TABLE ← Migration 2"
        uuid partner_id FK
        varchar title
        varchar subtitle
        varchar icon_name
        int sort_order
    }

    clinic_review_responses {
        uuid id PK "NEW TABLE ← Migration 3"
        uuid review_id FK_UNIQUE
        uuid partner_id FK
        text response_text
    }
```

---

## New `clinic` Backend Module

### Module Structure

```
src/clinic/
├── clinic.module.ts
├── clinic.service.ts
├── user-clinic.controller.ts
├── dto/
│   ├── clinic-info-response.dto.ts
│   ├── clinic-products-response.dto.ts
│   └── clinic-reviews-response.dto.ts
└── entities/
    ├── partner-certification.entity.ts
    └── clinic-review-response.entity.ts
```

### Module Registration

```typescript
// src/clinic/clinic.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClinicService } from './clinic.service';
import { UserClinicController } from './user-clinic.controller';
import { Product } from '@/common/entities/product.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Booking } from '@/common/entities/booking.entity';
import { PartnerCertification } from './entities/partner-certification.entity';
import { ClinicReviewResponse } from './entities/clinic-review-response.entity';
import { PartnersModule } from '@/partners/partners.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Product,
      ProductMedia,
      ProductDefinition,
      ProductEmployeeEligibility,
      TreatmentReview,
      Employee,
      Booking,
      PartnerCertification,
      ClinicReviewResponse,
    ]),
    PartnersModule,
  ],
  controllers: [UserClinicController],
  providers: [ClinicService],
  exports: [ClinicService],
})
export class ClinicModule {}
```

```diff
// src/app.module.ts
 import { CartModule } from './cart/cart.module';
+import { ClinicModule } from './clinic/clinic.module';

 @Module({
   imports: [
     ...
     CartModule,
+    ClinicModule,
   ],
```

---

## API Endpoints (3 Total)

### Controller

```typescript
// src/clinic/user-clinic.controller.ts
import {
  Get, Param, Query,
  ParseUUIDPipe, DefaultValuePipe, ParseIntPipe,
  ParseBoolPipe,
} from '@nestjs/common';
import {
  ApiOperation, ApiOkResponse,
  ApiNotFoundResponse, ApiQuery,
} from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { ClinicService } from './clinic.service';
import { ClinicInfoResponseDto } from './dto/clinic-info-response.dto';
import { ClinicProductsResponseDto } from './dto/clinic-products-response.dto';
import { ClinicReviewsResponseDto } from './dto/clinic-reviews-response.dto';

@UserApi('clinics')
export class UserClinicController {
  constructor(
    private readonly clinicService: ClinicService,
  ) {}

  @Get(':id/info')
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicInfo',
    summary: 'Get public clinic profile',
  })
  @ApiOkResponse({ type: ClinicInfoResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  getClinicInfo(
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<ClinicInfoResponseDto> {
    return this.clinicService.getClinicInfo(id);
  }

  @Get(':id/products')
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicProducts',
    summary: 'Get clinic products/services catalog',
  })
  @ApiOkResponse({ type: ClinicProductsResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  @ApiQuery({
    name: 'categoryId', required: false, type: String,
    description: 'Filter by category UUID',
  })
  @ApiQuery({
    name: 'sort', required: false, type: String,
    enum: ['popular', 'latest', 'top_sales', 'price_asc', 'price_desc'],
  })
  @ApiQuery({
    name: 'search', required: false, type: String,
    description: 'Case-insensitive service name search',
  })
  @ApiQuery({
    name: 'page', required: false, type: Number,
  })
  @ApiQuery({
    name: 'limit', required: false, type: Number,
  })
  getClinicProducts(
    @Param('id', ParseUUIDPipe) id: string,
    @Query('categoryId') categoryId?: string,
    @Query('sort') sort?: string,
    @Query('search') search?: string,
    @Query('page', new DefaultValuePipe(1), ParseIntPipe)
    page?: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe)
    limit?: number,
  ): Promise<ClinicProductsResponseDto> {
    return this.clinicService.getClinicProducts(
      id, { categoryId, sort, search, page, limit },
    );
  }

  @Get(':id/reviews')
  @ApiOperation({
    operationId: 'userClinicControllerGetClinicReviews',
    summary: 'Get paginated clinic reviews',
  })
  @ApiOkResponse({ type: ClinicReviewsResponseDto })
  @ApiNotFoundResponse({ description: 'Clinic not found.' })
  @ApiQuery({
    name: 'page', required: false, type: Number,
  })
  @ApiQuery({
    name: 'limit', required: false, type: Number,
  })
  @ApiQuery({
    name: 'starCount', required: false, type: Number,
    description: 'Filter: only reviews with this rating (1–5)',
  })
  @ApiQuery({
    name: 'hasMedia', required: false, type: Boolean,
    description: 'Filter: only reviews with photos',
  })
  getClinicReviews(
    @Param('id', ParseUUIDPipe) id: string,
    @Query('page', new DefaultValuePipe(1), ParseIntPipe)
    page: number,
    @Query('limit', new DefaultValuePipe(10), ParseIntPipe)
    limit: number,
    @Query('starCount') starCount?: number,
    @Query('hasMedia') hasMedia?: boolean,
  ): Promise<ClinicReviewsResponseDto> {
    return this.clinicService.getClinicReviews(
      id, page, limit, starCount, hasMedia,
    );
  }
}
```

---

### Endpoint 1: `GET /v1/user/clinics/:id/info`

**Response DTO**: `ClinicInfoResponseDto`

```typescript
class ClinicTrustMetricsDto {
  @ApiProperty({ example: 4.9 })
  rating: number;

  @ApiProperty({ example: 2500 })
  reviewCount: number;

  @ApiProperty({ example: '5+ Yrs' })
  experienceLabel: string;

  @ApiProperty({ example: '15k' })
  clientsLabel: string;
}

class ClinicCertificationDto {
  @ApiProperty({ example: 'ISO 9001:2015' })
  title: string;

  @ApiPropertyOptional({ example: 'Quality Management' })
  subtitle: string | null;

  @ApiProperty({ example: 'workspace_premium' })
  iconName: string;
}

class ClinicSpecialistPreviewDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Dr. Sarah' })
  name: string;

  @ApiProperty({ example: 'Senior Therapist' })
  role: string;

  @ApiPropertyOptional()
  imageUrl: string | null;

  @ApiPropertyOptional({ example: '5 Yrs Exp' })
  experienceLabel: string | null;
}

class ClinicInfoResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Healytics Wellness Center' })
  name: string;

  @ApiPropertyOptional()
  coverImageUrl: string | null;

  @ApiPropertyOptional()
  logoImageUrl: string | null;

  @ApiProperty({ type: [String] })
  gallery: string[];

  @ApiProperty({ example: '15k' })
  followersLabel: string;

  @ApiProperty({ example: '2.5k' })
  reviewsLabel: string;

  @ApiPropertyOptional()
  description: string | null;

  @ApiProperty()
  trustMetrics: ClinicTrustMetricsDto;

  @ApiProperty({ type: [ClinicCertificationDto] })
  certifications: ClinicCertificationDto[];

  @ApiProperty({ type: [ClinicSpecialistPreviewDto] })
  specialists: ClinicSpecialistPreviewDto[];

  @ApiProperty({ type: [String] })
  businessTypes: string[];

  @ApiPropertyOptional()
  address: string | null;

  @ApiPropertyOptional()
  phoneNumber: string | null;
}
```

**Service mapping logic**:

```typescript
async getClinicInfo(partnerId: string): Promise<ClinicInfoResponseDto> {
  const partner = await this.partnersService.findOneById(partnerId);
  if (!partner) throw new NotFoundException();

  // Load partner with new relations
  // (load certifications via new entity relation)

  const [employees, products, ratingsMap, certifications] =
    await Promise.all([
      this.employeeRepo.find({
        where: { partnerId, status: EmployeeStatus.ACTIVE },
        relations: ['doctorProfile'],
        take: 5,
      }),
      this.productRepo.find({
        where: {
          partnerId,
          status: HealthServiceStatus.ACTIVE,
        },
        select: ['id'],
      }),
      this.buildRatingsMap(productIds),
      this.certificationRepo.find({
        where: { partnerId },
        order: { sortOrder: 'ASC' },
      }),
    ]);

  // Trust metrics
  const yearsActive = Math.floor(
    (Date.now() - partner.createdAt.getTime())
    / (365.25 * 86400000),
  );

  // Specialist experience: doctor_profiles.experience_years
  // or compute from employees.start_date
  const specialists = employees.map(e => {
    let expLabel: string | null = null;
    if (e.doctorProfile?.experienceYears) {
      expLabel = `${e.doctorProfile.experienceYears} Yrs Exp`;
    } else if (e.startDate) {
      const years = Math.floor(
        (Date.now() - new Date(e.startDate).getTime())
        / (365.25 * 86400000),
      );
      if (years > 0) expLabel = `${years} Yrs Exp`;
    }
    return {
      id: e.id,
      name: e.fullName,
      role: e.jobTitle ?? e.role,
      imageUrl: e.avatarUrl ?? null,
      experienceLabel: expLabel,
    };
  });

  return {
    id: partner.id,
    name: partner.brandName,
    coverImageUrl: partner.coverImageUrl ?? null,
    logoImageUrl: partner.logoImageUrl ?? null,
    gallery: partner.gallery ?? [],
    followersLabel: formatCount(partner.followerCount ?? 0),
    reviewsLabel: formatCount(totalReviewCount),
    description: partner.description ?? null,
    trustMetrics: {
      rating: avgRating,
      reviewCount: totalReviewCount,
      experienceLabel: `${yearsActive}+ Yrs`,
      clientsLabel: formatCount(uniqueBookingUsers),
    },
    certifications: certifications.map(c => ({
      title: c.title,
      subtitle: c.subtitle,
      iconName: c.iconName,
    })),
    specialists,
    businessTypes: partner.businessType,
    address: partner.streetAddress,
    phoneNumber: partner.phoneNumber,
  };
}
```

---

### Endpoint 2: `GET /v1/user/clinics/:id/products`

**Query Parameters** (server-side filtering):

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `categoryId` | UUID | — | Filter by category. Omit or `'all'` for all categories |
| `sort` | string | `'popular'` | `popular` / `latest` / `top_sales` / `price_asc` / `price_desc` |
| `search` | string | — | Case-insensitive ILIKE on `products.name` |
| `page` | int | `1` | Page number (1-indexed) |
| `limit` | int | `20` | Items per page |

**Response DTO**: `ClinicProductsResponseDto`

```typescript
class ClinicProductCategoryDto {
  @ApiProperty({ example: 'a1b2c3d4-...' })
  id: string;

  @ApiProperty({ example: 'Massage Therapy' })
  label: string;
}

class ClinicProductDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ example: 'Premium CO2 Laser' })
  title: string;

  @ApiPropertyOptional()
  imageUrl: string | null;

  @ApiProperty({ example: '990.000đ' })
  price: string;

  @ApiProperty({ example: 990000 })
  priceAmount: number;

  @ApiPropertyOptional({ example: '1.250.000đ' })
  originalPrice: string | null;

  @ApiPropertyOptional({ example: '-20%' })
  discountLabel: string | null;

  @ApiPropertyOptional({ example: 'HOT' })
  badgeLabel: string | null;

  @ApiPropertyOptional({ example: '60 min' })
  durationLabel: string | null;

  @ApiPropertyOptional({ example: 'Specialist' })
  specialistLabel: string | null;

  @ApiProperty()
  categoryId: string;

  @ApiProperty({ example: 320 })
  soldCount: number;

  @ApiProperty({ example: 1743465600000 })
  createdAtMs: number;
}

class ClinicProductsResponseDto {
  @ApiProperty({ type: [ClinicProductCategoryDto] })
  categories: ClinicProductCategoryDto[];

  @ApiProperty({ type: [ClinicProductDto] })
  products: ClinicProductDto[];

  @ApiProperty({ example: 45 })
  totalCount: number;

  @ApiProperty({ example: true })
  hasMore: boolean;
}
```

**Service logic**:

```typescript
async getClinicProducts(
  partnerId: string,
  options: {
    categoryId?: string;
    sort?: string;
    search?: string;
    page?: number;
    limit?: number;
  },
): Promise<ClinicProductsResponseDto> {
  const partner =
    await this.partnersService.findOneById(partnerId);
  if (!partner) throw new NotFoundException();

  const { categoryId, sort = 'popular', search } = options;
  const page = options.page ?? 1;
  const limit = options.limit ?? 20;

  // 1. Build query
  let qb = this.productRepo.createQueryBuilder('p')
    .leftJoinAndSelect('p.category', 'c')
    .leftJoinAndSelect('p.media', 'm')
    .leftJoinAndSelect('p.productDefinition', 'pd')
    .where('p.partner_id = :partnerId', { partnerId })
    .andWhere('p.status = :status', {
      status: HealthServiceStatus.ACTIVE,
    })
    .andWhere('p.is_visible_online = true');

  // 2. Apply filters
  if (categoryId && categoryId !== 'all') {
    qb = qb.andWhere('p.category_id = :categoryId', {
      categoryId,
    });
  }
  if (search) {
    qb = qb.andWhere('p.name ILIKE :search', {
      search: `%${search}%`,
    });
  }

  // 3. Get total count before pagination
  const totalCount = await qb.getCount();

  // 4. Apply sort
  switch (sort) {
    case 'latest':
      qb = qb.orderBy('p.created_at', 'DESC');
      break;
    case 'price_asc':
      qb = qb.orderBy(
        'COALESCE(p.sale_price, p.base_price)', 'ASC',
      );
      break;
    case 'price_desc':
      qb = qb.orderBy(
        'COALESCE(p.sale_price, p.base_price)', 'DESC',
      );
      break;
    // 'popular' and 'top_sales' use sold count
    // — apply after fetching
    default:
      qb = qb.orderBy('p.created_at', 'DESC');
  }

  // 5. Paginate
  qb = qb.skip((page - 1) * limit).take(limit);
  const products = await qb.getMany();

  // 6. Build sold counts + categories
  const productIds = products.map(p => p.id);
  const soldMap = await this.buildSoldCountMap(productIds);

  // 7. Extract unique categories
  const categoryMap = new Map<string, string>();
  for (const p of products) {
    if (p.category) {
      categoryMap.set(p.categoryId, p.category.name);
    }
  }
  const categories = [
    { id: 'all', label: 'All Services' },
    ...Array.from(categoryMap, ([id, label]) => ({
      id,
      label,
    })),
  ];

  // 8. Map to DTOs
  const productDtos = products.map(p => {
    const currentPrice = p.salePrice ?? p.basePrice;
    const hasDiscount =
      p.salePrice != null && p.basePrice !== p.salePrice;
    const pct = hasDiscount
      ? Math.round(
          (1 - Number(p.salePrice) / Number(p.basePrice))
          * 100,
        )
      : null;

    return {
      id: p.id,
      title: p.name,
      imageUrl: p.media?.find(m => m.isThumbnail)?.url
        ?? p.media?.[0]?.url ?? null,
      price: formatVND(currentPrice) + 'đ',
      priceAmount: Number(currentPrice),
      originalPrice: hasDiscount
        ? formatVND(p.basePrice) + 'đ'
        : null,
      discountLabel: pct ? `-${pct}%` : null,
      badgeLabel: null,
      durationLabel: p.productDefinition?.durationMinutes
        ? `${p.productDefinition.durationMinutes} min`
        : null,
      specialistLabel: null,
      categoryId: p.categoryId ?? 'all',
      soldCount: soldMap.get(p.id) ?? 0,
      createdAtMs: p.createdAt.getTime(),
    };
  });

  // 9. Re-sort by soldCount for 'popular'/'top_sales'
  if (sort === 'popular' || sort === 'top_sales') {
    productDtos.sort((a, b) => b.soldCount - a.soldCount);
  }

  return {
    categories,
    products: productDtos,
    totalCount,
    hasMore: page * limit < totalCount,
  };
}
```

---

### Endpoint 3: `GET /v1/user/clinics/:id/reviews`

**Query Parameters** (server-side filtering):

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `page` | int | `1` | Page number |
| `limit` | int | `10` | Items per page |
| `starCount` | int | — | Filter: only this star rating (1–5) |
| `hasMedia` | boolean | `false` | Filter: only reviews with photos |

**Response DTO**: `ClinicReviewsResponseDto`

```typescript
class ClinicReviewSummaryDto {
  @ApiProperty({ example: 4.9 })
  averageRating: number;

  @ApiProperty({ example: 2500 })
  totalReviewCount: number;

  @ApiProperty({ example: 'Excellent' })
  ratingLabel: string;

  @ApiProperty({
    example: { 5: 0.92, 4: 0.06, 3: 0.01, 2: 0.005, 1: 0.005 },
  })
  starDistribution: Record<number, number>;
}

class ClinicReviewFilterDto {
  @ApiProperty({ example: 'all' })
  id: string;

  @ApiProperty({ example: 'All (2.5k)' })
  label: string;

  @ApiPropertyOptional({ example: 5 })
  starCount: number | null;

  @ApiProperty({ example: false })
  requiresMedia: boolean;
}

class ClinicReviewResponseSubDto {
  @ApiPropertyOptional()
  responseText: string | null;
}

class ClinicReviewDto {
  @ApiProperty()
  id: string;

  @ApiProperty({
    example: 'n***a',
    description: 'Masked name for privacy',
  })
  reviewerName: string;

  @ApiProperty({ example: 'N' })
  reviewerInitial: string;

  @ApiProperty({ example: 5, minimum: 1, maximum: 5 })
  starCount: number;

  @ApiPropertyOptional({ description: 'null for MVP' })
  memberBadge: string | null;

  @ApiProperty({ example: '04-04-2026' })
  dateLabel: string;

  @ApiPropertyOptional({ example: 'Salt Stone Massage (90 min)' })
  serviceName: string | null;

  @ApiPropertyOptional({ example: 'spa' })
  serviceIcon: string | null;

  @ApiProperty()
  reviewText: string;

  @ApiProperty({ type: [String] })
  mediaUrls: string[];

  @ApiPropertyOptional({ type: ClinicReviewResponseSubDto })
  clinicResponse: ClinicReviewResponseSubDto | null;
}

class ClinicReviewsResponseDto {
  @ApiProperty()
  summary: ClinicReviewSummaryDto;

  @ApiProperty({ type: [ClinicReviewFilterDto] })
  filters: ClinicReviewFilterDto[];

  @ApiProperty({ type: [ClinicReviewDto] })
  reviews: ClinicReviewDto[];

  @ApiProperty({ example: 150 })
  totalCount: number;

  @ApiProperty({ example: true })
  hasMore: boolean;
}
```

**Service logic**:

```typescript
async getClinicReviews(
  partnerId: string,
  page: number,
  limit: number,
  starCount?: number,
  hasMedia?: boolean,
): Promise<ClinicReviewsResponseDto> {
  const partner =
    await this.partnersService.findOneById(partnerId);
  if (!partner) throw new NotFoundException();

  // 1. Get all product IDs for this partner
  const productIds = await this.productRepo
    .find({ where: { partnerId }, select: ['id'] })
    .then(ps => ps.map(p => p.id));

  if (productIds.length === 0) {
    return this.emptyReviewsResponse();
  }

  // 2. Build filtered query
  let qb = this.treatmentReviewRepo
    .createQueryBuilder('tr')
    .innerJoinAndSelect('tr.booking', 'b')
    .leftJoinAndSelect('b.product', 'p')
    .innerJoinAndSelect('tr.user', 'u')
    .leftJoinAndSelect('u.userProfile', 'up')
    .leftJoinAndSelect(
      'clinic_review_responses', 'crr',
      'crr.review_id = tr.id',
    )
    .where('b.product_id IN (:...productIds)', {
      productIds,
    });

  if (starCount) {
    qb = qb.andWhere('tr.rating = :starCount', {
      starCount,
    });
  }
  if (hasMedia) {
    qb = qb.andWhere(
      "jsonb_array_length(tr.photo_urls) > 0",
    );
  }

  // 3. Count + paginate
  const totalCount = await qb.getCount();
  const reviews = await qb
    .orderBy('tr.createdAt', 'DESC')
    .skip((page - 1) * limit)
    .take(limit)
    .getMany();

  // 4. Build summary (always unfiltered)
  const summary = await this.buildReviewSummary(productIds);

  // 5. Build filter pills
  const filters = await this.buildReviewFilters(productIds);

  // 6. Map to DTOs
  const reviewDtos = reviews.map(tr => {
    const userName =
      tr.user?.userProfile?.name
      ?? tr.user?.email
      ?? 'Anonymous';
    return {
      id: tr.id,
      reviewerName: maskName(userName),
      reviewerInitial: userName[0].toUpperCase(),
      starCount: tr.rating,
      memberBadge: null, // MVP: no loyalty tiers
      dateLabel: formatDate(tr.createdAt),
      serviceName: tr.booking?.product?.name ?? null,
      serviceIcon: null,
      reviewText: tr.comment ?? '',
      mediaUrls: tr.photoUrls ?? [],
      clinicResponse: tr.clinicResponse
        ? { responseText: tr.clinicResponse.responseText }
        : null,
    };
  });

  return {
    summary,
    filters,
    reviews: reviewDtos,
    totalCount,
    hasMore: page * limit < totalCount,
  };
}
```

**Helper: `buildReviewSummary`**:

```typescript
private async buildReviewSummary(
  productIds: string[],
): Promise<ClinicReviewSummaryDto> {
  // Get star distribution in a single query
  const rows = await this.treatmentReviewRepo
    .createQueryBuilder('tr')
    .innerJoin('tr.booking', 'b')
    .where('b.product_id IN (:...productIds)', { productIds })
    .select('tr.rating', 'star')
    .addSelect('COUNT(tr.id)', 'count')
    .groupBy('tr.rating')
    .getRawMany<{ star: number; count: string }>();

  let total = 0;
  let sum = 0;
  const dist: Record<number, number> = {
    5: 0, 4: 0, 3: 0, 2: 0, 1: 0,
  };
  for (const r of rows) {
    const c = parseInt(r.count, 10);
    dist[r.star] = c;
    total += c;
    sum += r.star * c;
  }

  const avg = total > 0
    ? Math.round((sum / total) * 10) / 10
    : 0;

  // Normalize to 0.0–1.0 proportions
  const starDistribution: Record<number, number> = {};
  for (const s of [5, 4, 3, 2, 1]) {
    starDistribution[s] = total > 0
      ? Math.round((dist[s] / total) * 1000) / 1000
      : 0;
  }

  return {
    averageRating: avg,
    totalReviewCount: total,
    ratingLabel: ratingLabel(avg),
    starDistribution,
  };
}
```

**Helper: `buildReviewFilters`**:

```typescript
private async buildReviewFilters(
  productIds: string[],
): Promise<ClinicReviewFilterDto[]> {
  // Same summary query reused
  const rows = await this.treatmentReviewRepo
    .createQueryBuilder('tr')
    .innerJoin('tr.booking', 'b')
    .where('b.product_id IN (:...productIds)', { productIds })
    .select('tr.rating', 'star')
    .addSelect('COUNT(tr.id)', 'count')
    .groupBy('tr.rating')
    .getRawMany<{ star: number; count: string }>();

  const total = rows.reduce(
    (s, r) => s + parseInt(r.count, 10), 0,
  );
  const starMap = new Map(
    rows.map(r => [r.star, parseInt(r.count, 10)]),
  );

  // Count reviews with media
  const mediaCount = await this.treatmentReviewRepo
    .createQueryBuilder('tr')
    .innerJoin('tr.booking', 'b')
    .where('b.product_id IN (:...productIds)', { productIds })
    .andWhere("jsonb_array_length(tr.photo_urls) > 0")
    .getCount();

  const filters: ClinicReviewFilterDto[] = [
    {
      id: 'all',
      label: `All (${formatCount(total)})`,
      starCount: null,
      requiresMedia: false,
    },
  ];
  for (const s of [5, 4, 3, 2, 1]) {
    const c = starMap.get(s) ?? 0;
    if (c > 0) {
      filters.push({
        id: `${s}star`,
        label: `${s} Star (${formatCount(c)})`,
        starCount: s,
        requiresMedia: false,
      });
    }
  }
  if (mediaCount > 0) {
    filters.push({
      id: 'media',
      label: `With Photos (${formatCount(mediaCount)})`,
      starCount: null,
      requiresMedia: true,
    });
  }

  return filters;
}
```

---

## Helper Functions

```typescript
/** "Nguyen An" → "n***n" */
function maskName(name: string): string {
  if (!name || name.length < 2) return '***';
  const f = name[0].toLowerCase();
  const l = name[name.length - 1].toLowerCase();
  return `${f}***${l}`;
}

/** 4.5+ → "Excellent", 4.0+ → "Very Good", etc. */
function ratingLabel(avg: number): string {
  if (avg >= 4.5) return 'Excellent';
  if (avg >= 4.0) return 'Very Good';
  if (avg >= 3.5) return 'Good';
  if (avg >= 3.0) return 'Average';
  return 'Below Average';
}

/** Format date as DD-MM-YYYY */
function formatDate(date: Date): string {
  const d = String(date.getDate()).padStart(2, '0');
  const m = String(date.getMonth() + 1).padStart(2, '0');
  return `${d}-${m}-${date.getFullYear()}`;
}

/** 990000 → "990.000" */
function formatVND(amount: number | string): string {
  return new Intl.NumberFormat('vi-VN').format(Number(amount));
}

/** 15234 → "15k", 2500 → "2.5k", 42 → "42" */
function formatCount(n: number): string {
  if (n >= 1000) {
    const k = n / 1000;
    return k % 1 === 0 ? `${k}k` : `${k.toFixed(1)}k`;
  }
  return String(n);
}
```

---

## Entity Definitions (New TypeORM Entities)

### `partner-certification.entity.ts`

```typescript
import {
  Entity, PrimaryGeneratedColumn, Column,
  CreateDateColumn, ManyToOne, JoinColumn,
} from 'typeorm';
import { Partner } from '@/common/entities/partner.entity';

@Entity('partner_certifications')
export class PartnerCertification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ length: 200 })
  title: string;

  @Column({ length: 200, nullable: true })
  subtitle: string | null;

  @Column({
    name: 'icon_name', length: 50,
    default: 'workspace_premium',
  })
  iconName: string;

  @Column({ name: 'sort_order', type: 'int', default: 0 })
  sortOrder: number;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
```

### `clinic-review-response.entity.ts`

```typescript
import {
  Entity, PrimaryGeneratedColumn, Column,
  CreateDateColumn, UpdateDateColumn,
  OneToOne, ManyToOne, JoinColumn,
} from 'typeorm';
import {
  TreatmentReview,
} from '@/common/entities/treatment-review.entity';
import { Partner } from '@/common/entities/partner.entity';

@Entity('clinic_review_responses')
export class ClinicReviewResponse {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'review_id', type: 'uuid', unique: true })
  reviewId: string;

  @Column({ name: 'partner_id', type: 'uuid' })
  partnerId: string;

  @Column({ name: 'response_text', type: 'text' })
  responseText: string;

  @CreateDateColumn({
    name: 'created_at', type: 'timestamptz',
  })
  createdAt: Date;

  @UpdateDateColumn({
    name: 'updated_at', type: 'timestamptz',
  })
  updatedAt: Date;

  @OneToOne(() => TreatmentReview, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'review_id' })
  review: TreatmentReview;

  @ManyToOne(() => Partner, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'partner_id' })
  partner: Partner;
}
```

---

## Partner Entity Update

Add the new columns and relation to the existing [Partner entity](file:///Volumes/WD850X/Users/workspace/datn/Healytics/backend/src/common/entities/partner.entity.ts):

```diff
 // In partner.entity.ts — add after phoneNumber column:

+@Column({ name: 'cover_image_url', type: 'text', nullable: true })
+coverImageUrl: string | null;
+
+@Column({ name: 'logo_image_url', type: 'text', nullable: true })
+logoImageUrl: string | null;
+
+@Column({ type: 'jsonb', default: '[]' })
+gallery: string[];
+
+@Column({ type: 'text', nullable: true })
+description: string | null;
+
+@Column({ name: 'follower_count', type: 'int', default: 0 })
+followerCount: number;

 // Add relation (after products relation):
+@OneToMany(() => PartnerCertification, (cert) => cert.partner)
+certifications: PartnerCertification[];
```

---

## Implementation Checklist

### Phase 1: Database Migrations

| # | Task | Risk |
|---|------|------|
| 1 | Create migration: `AddClinicProfileColumnsToPartner` | 🟡 |
| 2 | Create migration: `CreatePartnerCertificationsTable` | 🟢 |
| 3 | Create migration: `CreateClinicReviewResponsesTable` | 🟢 |
| 4 | Run migrations on dev database and verify | — |

### Phase 2: Entities & Module

| # | Task |
|---|------|
| 5 | Create `PartnerCertification` entity |
| 6 | Create `ClinicReviewResponse` entity |
| 7 | Update `Partner` entity with new columns + `certifications` relation |
| 8 | Create `src/clinic/` directory structure |
| 9 | Create `ClinicModule` and register in `AppModule` |

### Phase 3: DTOs & Service

| # | Task |
|---|------|
| 10 | Create `ClinicInfoResponseDto` |
| 11 | Create `ClinicProductsResponseDto` |
| 12 | Create `ClinicReviewsResponseDto` |
| 13 | Implement `ClinicService.getClinicInfo()` |
| 14 | Implement `ClinicService.getClinicProducts()` with server-side filtering |
| 15 | Implement `ClinicService.getClinicReviews()` with summary, filters, pagination |
| 16 | Implement helper functions (maskName, formatVND, formatCount, etc.) |

### Phase 4: Controller & Integration

| # | Task |
|---|------|
| 17 | Create `UserClinicController` with 3 endpoints |
| 18 | Regenerate `openapi.json` spec |
| 19 | Verify all 3 endpoints appear under `/v1/user/clinics/` tag |

### Phase 5: Frontend Integration

| # | Task |
|---|------|
| 20 | Regenerate OpenAPI Dart client |
| 21 | Implement `ClinicInfoRemoteDatasourceImpl` (replace `UnimplementedError`) |
| 22 | Update datasource route comments to `/clinics/:id/...` |
| 23 | Toggle `AppEnvironment.useMock` to `false` and verify |

---

## Verification Plan

### Automated Tests
- Controller spec: all 3 endpoints (200 + 404)
- Service spec: `getClinicProducts()` — filtering, sorting, pagination, sold count
- Service spec: `getClinicReviews()` — summary, star distribution, name masking, pagination, clinic responses
- Migration test: run `up()` + `down()` on clean test database

### Manual Verification
- Regenerate OpenAPI spec → 3 new endpoints visible
- Seed partner with cover image, certifications, and reviews with responses
- Compare rendered frontend UI with mock data to confirm visual parity
