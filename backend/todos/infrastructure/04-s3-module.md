# 04 — S3 Module

**Status:** ✅ COMPLETED

## Context

The S3 module handles file uploads (partner documents, employee avatars, product media) using AWS S3 or compatible storage (MinIO). Provides both presigned URL generation and direct upload.

## Prerequisites

- ✅ AWS S3 bucket or MinIO instance provisioned
- ✅ `@aws-sdk/client-s3`, `@aws-sdk/s3-request-presigner` installed
- ✅ Env vars: `S3_ENDPOINT`, `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_BUCKET`

## Tasks

### 1. Create `src/s3/s3.module.ts`
```typescript
@Module({
  controllers: [S3Controller],
  providers: [S3Service],
  exports: [S3Service],
})
```

### 2. Create `src/s3/s3.service.ts`
Methods:
- `generatePresignedUploadUrl(key, contentType, expiresIn)` — presigned PUT URL
- `generatePresignedDownloadUrl(key, expiresIn)` — presigned GET URL
- `uploadFile(key, buffer, contentType)` — direct upload
- `deleteFile(key)` — delete object

### 3. Create `src/s3/s3.controller.ts`
Upload endpoint for direct file upload via multipart form.

### 4. Create spec files
- `s3.controller.spec.ts`
- `s3.service.spec.ts`

## Completed

S3 module with presigned URL generation and direct upload. Used by PartnersModule for document uploads and EmployeesModule for avatar uploads. Full spec coverage.
