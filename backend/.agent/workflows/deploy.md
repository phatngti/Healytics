---
description: Pre-deployment verification and build preparation
---

# Deployment Workflow

Use this workflow before deploying to staging or production.

---

## 1. Pre-Deployment Checklist

Before deploying, ensure all checks pass:

- [ ] Code compiles without errors
- [ ] All tests pass
- [ ] Linting passes
- [ ] Database migrations are ready
- [ ] Environment variables configured

---

## 2. Run Full Verification

### Step 2.1: Lint Code

// turbo
```bash
npm run lint
```

### Step 2.2: Run Unit Tests

// turbo
```bash
npm run test
```

### Step 2.3: Run E2E Tests

// turbo
```bash
npm run test:e2e
```

### Step 2.4: Build Production Bundle

// turbo
```bash
npm run build
```

---

## 3. Verify Build Output

// turbo
```bash
ls -la dist/
```

Ensure `dist/main.js` exists.

---

## 4. Test Production Start (Local)

// turbo
```bash
npm run start:prod
```

Verify the server starts without errors, then stop with `Ctrl+C`.

---

## 5. Database Migrations

### Check Pending Migrations

// turbo
```bash
npm run typeorm migration:show -d ./migrations/typeorm.config.ts
```

### Run Migrations

// turbo
```bash
npm run migration:run
```

---

## 6. Environment Configuration

### Required Environment Variables

Ensure these are set in production:

```bash
# Database
DATABASE_HOST=
DATABASE_PORT=
DATABASE_USERNAME=
DATABASE_PASSWORD=
DATABASE_NAME=

# Auth
JWT_SECRET=           # Strong random string
JWT_EXPIRES_IN=

# AWS S3 (if using file uploads)
AWS_REGION=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKET=
```

### Verify .env.sample is Updated

// turbo
```bash
cat .env.sample
```

Ensure all new environment variables are documented.

---

## 7. Docker Deployment (If Applicable)

### Build Docker Image

```bash
docker build -t healytics-backend:latest .
```

### Run with Docker Compose

// turbo
```bash
docker-compose up -d
```

### Check Container Logs

// turbo
```bash
docker-compose logs -f backend
```

---

## 8. Post-Deployment Verification

After deployment:

1. Check health endpoint: `GET /health` or `GET /`
2. Verify authentication works
3. Test critical API endpoints
4. Monitor logs for errors
