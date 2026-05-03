---
description: Audit and fix DTO files to ensure all @ApiProperty decorators have explicit types — prevents Swagger from generating object types
---

# Fix DTO Types Workflow

Use this workflow to **audit and fix** all DTO files that have bare `@ApiProperty()` or `@ApiPropertyOptional()` decorators missing explicit `type` declarations. This prevents the Swagger/OpenAPI spec from generating `"type": "object"` for what should be primitive fields.

---

## 1. Audit — Find Bare Decorators

Search for all DTOs with bare `@ApiProperty()` or `@ApiPropertyOptional()` (no arguments or missing `type`):

// turbo
```bash
grep -rn '@ApiProperty()' src/ --include='*.dto.ts'
```

// turbo
```bash
grep -rn '@ApiPropertyOptional()' src/ --include='*.dto.ts'
```

Also catch decorators that have arguments but no `type` key:

// turbo
```bash
grep -rn '@ApiProperty({' src/ --include='*.dto.ts' | grep -v 'type:'
```

// turbo
```bash
grep -rn '@ApiPropertyOptional({' src/ --include='*.dto.ts' | grep -v 'type:'
```

---

## 2. Fix — Apply Type Declarations

For each flagged property, determine the correct `type` based on the TypeScript property type:

### Type Mapping Quick Reference

| TS Property Type    | `@ApiProperty` `type` value      | Extra keys                        |
|---------------------|----------------------------------|-----------------------------------|
| `string`            | `type: String`                   |                                   |
| `number`            | `type: Number`                   |                                   |
| `boolean`           | `type: Boolean`                  |                                   |
| `Date`              | `type: Date`                     |                                   |
| `string \| null`    | `type: String`                   | `nullable: true`                  |
| `number \| null`    | `type: Number`                   | `nullable: true`                  |
| `SomeEnum`          | `enum: SomeEnum`                 | `enumName: 'SomeEnum'`           |
| `NestedDto`         | `type: () => NestedDto`          |                                   |
| `NestedDto[]`       | `type: [NestedDto]`              |                                   |
| `string[]`          | `type: [String]`                 |                                   |

### Examples of Fixes

```diff
- @ApiProperty()
+ @ApiProperty({ type: String })
  id: string;

- @ApiProperty()
+ @ApiProperty({ type: Number })
  price: number;

- @ApiPropertyOptional()
+ @ApiPropertyOptional({ type: String, nullable: true })
  description: string | null;

- @ApiProperty({ example: '2025-01-01' })
+ @ApiProperty({ type: Date, example: '2025-01-01' })
  createdAt: Date;

- @ApiProperty({ enum: MyEnum })
+ @ApiProperty({ enum: MyEnum, enumName: 'MyEnum' })
  status: MyEnum;

- @ApiProperty()
+ @ApiProperty({ type: () => CategoryResponseDto })
  category: CategoryResponseDto;

- @ApiProperty()
+ @ApiProperty({ type: [MediaDto] })
  media: MediaDto[];
```

---

## 3. Verify — Check OpenAPI Spec

// turbo
```bash
npm run build
```

Start the dev server to regenerate the OpenAPI spec:

// turbo
```bash
npm run start:dev &
sleep 5
```

Verify no primitive fields are typed as `object` in the generated spec:

// turbo
```bash
cat openapi/openapi.json | python3 -c "
import json, sys
spec = json.load(sys.stdin)
schemas = spec.get('components', {}).get('schemas', {})
issues = []
for name, schema in schemas.items():
    props = schema.get('properties', {})
    for pname, pval in props.items():
        if pval.get('type') == 'object' and '\$ref' not in json.dumps(pval):
            issues.append(f'  {name}.{pname}: type is object (should be string/number/boolean/etc)')
if issues:
    print('⚠️  Found properties typed as object:')
    print('\n'.join(issues))
    sys.exit(1)
else:
    print('✅ No bare object types found in OpenAPI spec')
"
```

---

## 4. Cross-Check with Generated Client

If the project uses OpenAPI client generation (e.g., for Flutter), regenerate the client and verify:

// turbo
```bash
ls openapi/openapi.json && echo "OpenAPI spec exists at openapi/openapi.json"
```

Check that generated model classes have proper typed fields (not `Object` or `dynamic`).

---

## Priority Files to Check

These modules historically have the most bare decorators:

1. `src/chat/dto/` — conversation and message response DTOs
2. `src/clinic/dto/` — clinic info, products, reviews DTOs
3. `src/booking/dto/` — booking response DTO
4. `src/categories/dto/` — category response DTOs
5. `src/health-service/dto/` — all audience-specific DTOs
6. `src/admin/dto/` — admin partner detail response
7. `src/partners/dto/` — my profile response
