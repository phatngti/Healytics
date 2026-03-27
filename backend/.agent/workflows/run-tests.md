---
description: Run unit tests, E2E tests, and coverage reports
---

# Testing Workflow

Use this workflow when running and debugging tests.

---

## 1. Run All Unit Tests

// turbo
```bash
npm run test
```

---

## 2. Run Tests in Watch Mode

Useful during development - re-runs on file changes:

// turbo
```bash
npm run test:watch
```

---

## 3. Run Specific Test File

// turbo
```bash
npm run test -- src/products/products.service.spec.ts
```

---

## 4. Run Tests Matching Pattern

// turbo
```bash
npm run test -- --testNamePattern="should create product"
```

---

## 5. Run E2E Tests

// turbo
```bash
npm run test:e2e
```

---

## 6. Run Tests with Coverage

// turbo
```bash
npm run test:cov
```

Coverage report will be in `coverage/` directory.

---

## 7. Debug Tests

Run tests with debugger attached:

// turbo
```bash
npm run test:debug
```

Then attach VS Code debugger or open `chrome://inspect`.

---

## 8. Run Single E2E Test File

// turbo
```bash
npm run test:e2e -- test/e2e/products/products.e2e-spec.ts
```

---

## 9. Test Writing Checklist

### Unit Tests (`*.spec.ts`)

- [ ] Co-located with source: `src/{mod}/{mod}.service.spec.ts`
- [ ] AAA pattern: Arrange → Act → Assert
- [ ] All dependencies mocked
- [ ] `afterEach(() => jest.clearAllMocks())`
- [ ] Descriptive test names: `it('should return user when valid ID')`

### E2E Tests (`*.e2e-spec.ts`)

- [ ] Located in `test/e2e/{module}/`
- [ ] Using test helpers from `test/helpers/`
- [ ] Self-contained (each test creates its own data)
- [ ] Cleaning up in `afterAll`

---

## 10. Common Patterns

### Mock a Repository

```typescript
const mockRepo = {
  find: jest.fn(),
  findOne: jest.fn(),
  save: jest.fn(),
  create: jest.fn(),
};

const module = await Test.createTestingModule({
  providers: [
    ProductsService,
    { provide: getRepositoryToken(Product), useValue: mockRepo },
  ],
}).compile();
```

### Test an Exception

```typescript
it('should throw NotFoundException when not found', async () => {
  mockRepo.findOne.mockResolvedValue(null);
  
  await expect(service.findOne('bad-id'))
    .rejects.toThrow(NotFoundException);
});
```
