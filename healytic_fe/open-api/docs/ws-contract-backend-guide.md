# WS Contract Backend Guide

## Why this guide exists

The current `ws-contract.json` is good enough for simple scalar DTOs, but it does not preserve full DTO fidelity the way the REST OpenAPI generation does.

Two concrete issues are already visible:

1. `WsNewNotificationEventDto.data` is declared as `Record<string, any> | null` in [`notification/dto/ws-docs.dto.ts`](../../backend/src/notification/dto/ws-docs.dto.ts), but the generated [`ws-contract.json`](../ws-contract.json) flattens it to `"type": "String"`.
2. `WsMessagesReadEventDto.receiverId?: string` is optional in TypeScript in [`chat/dto/ws-docs.dto.ts`](../../backend/src/chat/dto/ws-docs.dto.ts), but it uses `@ApiProperty(...)` instead of `@ApiPropertyOptional(...)`, so the contract currently marks it as required.

That mismatch propagates into the Dart WS generator and produces DTOs that are structurally less accurate than the REST DTOs generated from Swagger/OpenAPI.

## Files that need to be reviewed

- [`backend/src/common/decorators/ws/ws-contract.generator.ts`](../../backend/src/common/decorators/ws/ws-contract.generator.ts)
- [`backend/scripts/generate-ws-contract.ts`](../../backend/scripts/generate-ws-contract.ts)
- [`backend/src/common/services/ws-contract-bootstrap.service.ts`](../../backend/src/common/services/ws-contract-bootstrap.service.ts)
- [`backend/src/chat/dto/ws-docs.dto.ts`](../../backend/src/chat/dto/ws-docs.dto.ts)
- [`backend/src/notification/dto/ws-docs.dto.ts`](../../backend/src/notification/dto/ws-docs.dto.ts)

## Current limitation in the backend generator

Today, `resolveType()` in [`ws-contract.generator.ts`](../../backend/src/common/decorators/ws/ws-contract.generator.ts) only recognizes:

- enums
- `Date`
- `Number`
- `Boolean`

Everything else falls back to `String`.

That means the contract currently loses:

- object/map fields
- nested DTO references
- array item types
- explicit nullable-vs-required distinction
- any non-string scalar nuance not covered by the small hardcoded set

## Recommended target contract shape

The frontend WS generator now expects richer, Dart-friendly type strings and can already consume these safely:

- `String`
- `bool`
- `num`
- `int`
- `double`
- `DateTime`
- `Map<String, dynamic>`
- `List<T>`
- `WsSomeModel` for nested DTO references

Add `nullable: true` when a property may legally be `null` even if it is present in the payload.

### Example: object field

Current incorrect output:

```json
"data": {
  "type": "String",
  "required": false,
  "description": "Deep-link data for frontend routing"
}
```

Target output:

```json
"data": {
  "type": "Map<String, dynamic>",
  "required": false,
  "nullable": true,
  "description": "Deep-link data for frontend routing"
}
```

### Example: nested DTO field

```json
"participant": {
  "type": "WsParticipantInfo",
  "required": true,
  "description": "Participant details"
}
```

### Example: list field

```json
"messages": {
  "type": "List<WsConversationMessage>",
  "required": true,
  "description": "Conversation messages"
}
```

## Backend implementation plan

### 1. Extend the contract property model

Update `ContractProperty` in [`ws-contract.generator.ts`](../../backend/src/common/decorators/ws/ws-contract.generator.ts) to support at least:

```ts
interface ContractProperty {
  type: string;
  required: boolean;
  description: string;
  isEnum?: boolean;
  default?: string;
  nullable?: boolean;
}
```

`nullable` is important because `required: false` and `nullable: true` are not the same thing.

### 2. Replace the current `resolveType()` with a recursive type resolver

Instead of collapsing all unknown shapes to `String`, the resolver should:

1. Detect enums from `enumName` / `enum` metadata.
2. Map primitive constructors:
   - `String` -> `String`
   - `Boolean` -> `bool`
   - `Number` -> `num`
   - `Date` -> `DateTime`
3. Detect `type: 'object'` or `additionalProperties` and emit `Map<String, dynamic>`.
4. Detect arrays and emit `List<...>`.
5. Detect class references and emit the WS contract model name, e.g. `WsParticipantInfo`.

If Swagger metadata exposes arrays through `isArray`, `type: [Class]`, or `items`, handle all of those cases explicitly.

### 3. Recursively register nested DTO classes

Right now the generator only includes DTOs that are directly attached to:

- `@WsEventDoc(... payload: ...)`
- `@WsEventDoc(... ack: ...)`
- `@WsNamespace({ serverEvents: [...] })`

That is not enough once a WS DTO contains another DTO.

The generator should keep a queue of discovered DTO classes:

1. Seed the queue from gateway event payloads and ACK DTOs.
2. While reading DTO properties, if a property type is another class DTO, add that DTO to the queue.
3. Continue until no new DTOs are discovered.

Without this step, the contract may reference model names that are never emitted in `models`.

### 4. Keep DTO decorators honest

The contract generator can only be as correct as the Swagger metadata it reads.

Backend DTO authors should follow these rules:

- Use `@ApiPropertyOptional(...)` for `foo?: string` or `foo: string | null`.
- Use `@ApiProperty({ type: Date })` for date fields.
- Use `enumName` consistently for enums that must map into WS enum registrations.
- Use `type: 'object'` for free-form JSON objects.
- Use explicit array metadata for list fields.

Concrete fix needed now:

- In [`backend/src/chat/dto/ws-docs.dto.ts`](../../backend/src/chat/dto/ws-docs.dto.ts), either:
  - change `receiverId?: string` to `receiverId: string`, or
  - keep it optional and switch `@ApiProperty(...)` to `@ApiPropertyOptional(...)`.

### 5. Add regression tests for the contract generator

At minimum, add tests that assert these cases:

- object field becomes `Map<String, dynamic>`
- optional nullable field emits `nullable: true`
- nested DTO reference emits the nested model name
- list of nested DTOs emits `List<WsNestedModel>`
- optional property in DTO metadata becomes `required: false`

Recommended first regression case:

- `WsNewNotificationEventDto.data` must not become `String`

### 6. Regeneration workflow

After backend changes:

1. Run `yarn generate:ws-contract` in `backend/`
2. Confirm `backend/openapi/ws-contract.json` contains the richer types
3. Sync that file into `open-api/ws-contract.json`
4. Run `./bin/generate-integration.sh ws` in `open-api/`
5. Run Flutter analysis:
   - `/Volumes/WD850X/Users/develop/flutter/bin/flutter analyze lib/core/services/ws` in `user_app/`
   - `/Volumes/WD850X/Users/develop/flutter/bin/flutter analyze lib/core/services/ws` in `admin_panel/`

## Definition of done

This work is complete when:

- `ws-contract.json` preserves object/list/nested DTO types
- the WS Dart generator no longer has to guess DTO structure
- generated WS DTOs match backend DTO intent as closely as REST OpenAPI DTOs do
- both Flutter apps analyze cleanly after regeneration
