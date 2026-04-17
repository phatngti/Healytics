---
activation: always_on
---

# DTO Type Strictness — Swagger/OpenAPI Compliance

Every `@ApiProperty()` and `@ApiPropertyOptional()` decorator in request and response DTOs **MUST** specify an explicit `type` property. Bare decorators without a `type` cause the Swagger/OpenAPI spec generator to infer `object` types, producing broken client SDKs.

## Mandatory Rules

### 1. Always Specify `type` in `@ApiProperty()` / `@ApiPropertyOptional()`

```typescript
// ✅ CORRECT — explicit type
@ApiProperty({ type: String, example: 'Thai Massage' })
name: string;

@ApiProperty({ type: Number, example: 100.50 })
price: number;

@ApiProperty({ type: Boolean, example: true })
isActive: boolean;

@ApiProperty({ type: Date, example: '2025-10-25T14:00:00Z' })
createdAt: Date;

// ❌ WRONG — bare decorator, Swagger infers `object`
@ApiProperty()
name: string;

@ApiPropertyOptional()
description: string | null;
```

### 2. Type Mapping Reference

| TypeScript Type         | `@ApiProperty` `type` value     | Notes                                                   |
|-------------------------|---------------------------------|---------------------------------------------------------|
| `string`                | `String`                        |                                                         |
| `number`                | `Number`                        |                                                         |
| `boolean`               | `Boolean`                       |                                                         |
| `Date`                  | `Date`                          | Serialized as ISO 8601 string in JSON                   |
| `string \| null`        | `String` + `nullable: true`     |                                                         |
| `number \| null`        | `Number` + `nullable: true`     |                                                         |
| `SomeEnum`              | `String` + `enum: SomeEnum`     | Use `enumName` for named enum schema                    |
| `NestedDto`             | `() => NestedDto`               | Lazy reference for nested class                         |
| `NestedDto[]`           | `[NestedDto]`                   | Array of nested class                                   |
| `string[]`              | `[String]`                      |                                                         |

### 3. Nullable Properties

Always use `nullable: true` when a property can be `null`:

```typescript
// ✅ CORRECT
@ApiProperty({ type: String, nullable: true, example: null })
@Expose()
paymentUrl!: string | null;

@ApiPropertyOptional({ type: String, nullable: true })
description: string | null;

// ❌ WRONG — missing type and nullable
@ApiPropertyOptional()
description: string | null;
```

### 4. Enum Properties

Use `enum` + `enumName` for proper schema generation (avoids inline anonymous enum objects):

```typescript
// ✅ CORRECT — named enum schema
@ApiProperty({
  enum: AppointmentStatus,
  enumName: 'AppointmentStatus',
  example: AppointmentStatus.UPCOMING,
})
status: AppointmentStatus;

// ❌ WRONG — missing enumName, generates inline object
@ApiProperty({ enum: AppointmentStatus })
status: AppointmentStatus;
```

### 5. Nested Object Properties

Use lazy `type` callback `() => ClassName` to avoid circular dependency issues:

```typescript
// ✅ CORRECT — lazy type reference
@ApiProperty({ type: () => CategoryResponseDto })
@Type(() => CategoryResponseDto)
@Expose()
category: CategoryResponseDto;

// ✅ CORRECT — nested array
@ApiProperty({ type: [MediaResponseDto] })
@Type(() => MediaResponseDto)
@Expose()
media: MediaResponseDto[];

// ❌ WRONG — bare decorator, generates `object` in spec
@ApiProperty()
@Expose()
category: CategoryResponseDto;
```

### 6. Request DTO Properties

Request DTOs must ALSO have explicit types. Combine `class-validator` with typed `@ApiProperty`:

```typescript
// ✅ CORRECT
@ApiProperty({ type: String, example: 'Thai Massage' })
@IsString()
@IsNotEmpty()
@MaxLength(255)
name: string;

@ApiPropertyOptional({ type: Number, example: 10.7769, description: 'User latitude' })
@IsOptional()
@Type(() => Number)
@IsNumber()
latitude?: number;

// ❌ WRONG — missing type
@ApiProperty({ example: 'Thai Massage' })
@IsString()
name: string;
```

## Anti-Patterns

| ❌ Anti-Pattern | ✅ Correct Pattern |
|-----------------|-------------------|
| `@ApiProperty()` (bare) | `@ApiProperty({ type: String })` |
| `@ApiPropertyOptional()` (bare) | `@ApiPropertyOptional({ type: String, nullable: true })` |
| `@ApiProperty({ example: 'foo' })` (no type) | `@ApiProperty({ type: String, example: 'foo' })` |
| `@ApiProperty({ enum: MyEnum })` (no enumName) | `@ApiProperty({ enum: MyEnum, enumName: 'MyEnum' })` |
| Nested DTO with bare `@ApiProperty()` | `@ApiProperty({ type: () => NestedDto })` |
| Array DTO with bare `@ApiProperty()` | `@ApiProperty({ type: [ItemDto] })` |

## Validation Checklist

Before submitting any DTO code:

- [ ] Every `@ApiProperty` has an explicit `type` (String, Number, Boolean, Date, enum, or DTO class)
- [ ] Every nullable field has `nullable: true`
- [ ] Every enum field has both `enum` and `enumName`
- [ ] Every nested DTO field has `type: () => NestedDto` or `type: [NestedDto]`
- [ ] No bare `@ApiProperty()` or `@ApiPropertyOptional()` without arguments
- [ ] The generated `openapi.json` contains no `"type": "object"` for primitive fields
