---
trigger: always_on
---

# Testing Rules (Enterprise Standard)

Ensure tests are fast, deterministic, and resistant to refactoring.

## Part 1: Unit Testing

### 1.1 Core Philosophy
* **Total Isolation:** Never touch database, network, file system, or system clock.
* **Speed:** Entire unit test suite must run in seconds.
* **Public API Only:** Test behavior of public methods only.

### 1.2 AAA Pattern
Every test must follow **Arrange-Act-Assert**, separated by newlines:
* **Arrange:** Setup mocks, inputs, and unit under test.
* **Act:** Execute the single method being tested.
* **Assert:** Verify output and side effects.

### 1.3 Mocking Strategy
* Use `Test.createTestingModule` with mocks for direct dependencies only.
* Use `jest.fn()` or `jest-mock-extended`. Never use partial implementations.
* Always use `jest.clearAllMocks()` in `afterEach`.

### 1.4 Naming Conventions
* Top-level `describe` = Class name.
* Nested `describe('methodName')` for each method.
* `it` must read as full sentence: `it('should return user when valid ID provided')`

### 1.5 File Conventions
Co-locate tests with source using `.spec.ts` suffix:

| Type | Source | Test |
|------|--------|------|
| Service | `src/{mod}/{mod}.service.ts` | `src/{mod}/{mod}.service.spec.ts` |
| Controller | `src/{mod}/{mod}.controller.ts` | `src/{mod}/{mod}.controller.spec.ts` |

### 1.6 Coverage Requirements
* Target 85%+ with priority on **Branch Coverage**.
* Cover: Happy path, edge cases (nulls, boundaries), error paths (404, 400).

### 1.7 Antipatterns
* ❌ Logic in tests (`if`, `for`) - use `it.each` instead.
* ❌ Testing internal state - test what returns, not how.
* ❌ `Math.random()` or `new Date()` - mock them.

### Unit Test Example

```typescript
// src/products/products.service.spec.ts
describe('ProductsService', () => {
  let service: ProductsService;
  let mockRepo: Record<string, jest.Mock>;

  beforeEach(async () => {
    mockRepo = { findOne: jest.fn(), save: jest.fn() };
    const module = await Test.createTestingModule({
      providers: [
        ProductsService,
        { provide: getRepositoryToken(Product), useValue: mockRepo },
      ],
    }).compile();
    service = module.get<ProductsService>(ProductsService);
  });

  afterEach(() => jest.clearAllMocks());

  describe('findOne', () => {
    it('should return product when exists', async () => {
      // Arrange
      const mockProduct = { id: 'uuid-123', name: 'Test' };
      mockRepo.findOne.mockResolvedValue(mockProduct);
      // Act
      const result = await service.findOne('uuid-123');
      // Assert
      expect(result).toEqual(mockProduct);
    });

    it('should throw NotFoundException when missing', async () => {
      mockRepo.findOne.mockResolvedValue(null);
      await expect(service.findOne('missing')).rejects.toThrow(NotFoundException);
    });
  });
});
```

---

## Part 2: E2E Testing

### 2.1 Core Philosophy
* Use actual test database and HTTP endpoints via supertest.
* Clean database state between suites. Each test must be independent.
* Use factories for consistent test data with unique identifiers.

### 2.2 File Conventions

| Type | Path |
|------|------|
| Module E2E | `test/e2e/{module}/{module}.e2e-spec.ts` |
| Helpers | `test/helpers/*.ts` |
| Fixtures | `test/fixtures/*.ts` |

### 2.3 Test Helpers

```typescript
// test/helpers/test-utils.ts
export async function createTestApp(): Promise<INestApplication> {
  const module = await Test.createTestingModule({ imports: [AppModule] }).compile();
  const app = module.createNestApplication();
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true }));
  await app.init();
  return app;
}

export function authRequest(app: INestApplication, token: string) {
  const server = app.getHttpServer();
  return {
    get: (url: string) => request(server).get(url).set('Authorization', `Bearer ${token}`),
    post: (url: string) => request(server).post(url).set('Authorization', `Bearer ${token}`),
  };
}
```

### 2.4 Data Factory

```typescript
// test/fixtures/test-data.factory.ts
export const FAKE_UUID = '00000000-0000-0000-0000-000000000000';

export function createProductDto(overrides = {}) {
  return { name: `Product-${Date.now()}`, slug: `slug-${Date.now()}`, ...overrides };
}
```

### 2.5 E2E Test Structure

```typescript
describe('Products (e2e)', () => {
  let app: INestApplication;
  let token: string;

  beforeAll(async () => {
    app = await createTestApp();
    token = (await authenticateTestUser(app)).accessToken;
  });
  afterAll(async () => await app?.close());

  describe('POST /products', () => {
    it('should create product', async () => {
      const data = createProductDto();
      const res = await authRequest(app, token).post('/products').send(data);
      expect([200, 201]).toContain(res.status);
      expect(res.body).toHaveProperty('id');
    });

    it('should fail with 400 for invalid data', async () => {
      const res = await authRequest(app, token).post('/products').send({});
      expect(res.status).toBe(400);
    });
  });

  describe('GET /products/:id', () => {
    it('should return 404 for non-existent id', async () => {
      const res = await authRequest(app, token).get(`/products/${FAKE_UUID}`);
      expect(res.status).toBe(404);
    });
  });
});
```

### 2.6 Best Practices
* Use timestamps for unique identifiers: `slug-${Date.now()}`
* Self-contained tests - create resources within tests.
* Flexible assertions: `expect([200, 201]).toContain(res.status)`

---

## Quick Checklist

### Unit Tests
- [ ] Co-located: `src/{mod}/{mod}.service.spec.ts`
- [ ] AAA pattern with separation
- [ ] All dependencies mocked
- [ ] `afterEach` clears mocks
- [ ] Sentence-style test names
- [ ] Happy/error/edge cases covered

### E2E Tests
- [ ] Location: `test/e2e/{mod}/{mod}.e2e-spec.ts`
- [ ] Unique identifiers (timestamps)
- [ ] Self-contained and order-independent
- [ ] Auth, validation, 404 cases tested
- [ ] App closed in `afterAll`
