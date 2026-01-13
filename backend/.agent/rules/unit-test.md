---
trigger: always_on
---

# Unit Testing Rules (FAANG/Enterprise Standard)

Adhere to these strict guidelines to ensure unit tests are fast, deterministic, and resistant to refactoring.

## 1. Core Philosophy: Hermetic & Fast
* **Total Isolation:** Unit tests must **NEVER** touch the database, network, file system, or system clock.
    * **Rule:** If it touches a real dependency, it is an Integration Test, not a Unit Test.
* **Speed:** The entire unit test suite must run in seconds.
* **Public API Only:** Test the *behavior* of public methods. Do not test private methods directly; test them via the public methods that call them.

## 2. The Structure: AAA Pattern
Every test case must follow the **Arrange-Act-Assert** pattern, strictly separated by newlines.
* **Arrange:** Setup mocks, inputs, and the unit under test.
* **Act:** Execute the single method being tested.
* **Assert:** Verify the output and side effects (e.g., "was the repository called?").

## 3. Mocking Strategy
* **Strict Dependency Injection:** Use NestJS `Test.createTestingModule` but **ONLY** provide the class under test and mocks for its direct dependencies.
* **Mock Objects:**
    * Use `jest.fn()` or libraries like `jest-mock-extended` / `@golevelup/ts-jest`.
    * **Never** use "Partial" implementations that contain real logic. Mocks must be dumb.
* **Resetting:** Always use `jest.clearAllMocks()` in `beforeEach` to prevent pollution between tests.

## 4. Naming Conventions ("The Sentence Rule")
* **Describe:** The top-level `describe` matches the Class name.
* **Nested Describe:** Use `describe('methodName')` for each method being tested.
* **It:** Must read like a full English sentence when combined with the describe block.
    * ✅ `it('should return a user when a valid ID is provided')`
    * ✅ `it('should throw NotFoundException when user does not exist')`
    * ❌ `it('success')`
    * ❌ `it('throws error')`

## 5. Coverage Requirements
* **Standard:** Aim for high coverage (85%+) but prioritize **Branch Coverage** over Line Coverage.
* **Mandatory Cases:**
    * **Happy Path:** The standard success scenario.
    * **Edge Cases:** Nulls, empty strings, boundaries (0, -1).
    * **Error Paths:** Verify that the correct Exceptions (HTTP 404, 400) are thrown, not just generic Errors.

## 6. Antipatterns to Avoid
* **Logic in Tests:** Tests should have no control flow (`if`, `for`, `while`). If you need a loop, you probably need a Data Driven Test (`it.each`).
* **Overspecification:** Do not test *how* the method works (internal state), test *what* it returns.
* **Randomness:** Never use `Math.random()` or `new Date()` directly. Mock the Date provider or use fixed seed data.

## Example Implementation (Service Test)

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { ProductsRepository } from './products.repository';
import { NotFoundException } from '@nestjs/common';

describe('ProductsService', () => {
  let service: ProductsService;
  let repository: Record<keyof ProductsRepository, jest.Mock>;

  // 1. Setup (Arrange Global)
  beforeEach(async () => {
    // Create "dumb" mocks for all dependencies
    const mockRepository = {
      findOne: jest.fn(),
      save: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        { provide: ProductsRepository, useValue: mockRepository },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
    repository = module.get(ProductsRepository);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findById', () => {
    // Case 1: Happy Path
    it('should return the product when it exists', async () => {
      // Arrange
      const productId = 'uuid-123';
      const mockProduct = { id: productId, name: 'Test Product' };
      repository.findOne.mockResolvedValue(mockProduct);

      // Act
      const result = await service.findById(productId);

      // Assert
      expect(result).toEqual(mockProduct);
      expect(repository.findOne).toHaveBeenCalledWith({ where: { id: productId } });
    });

    // Case 2: Error Path
    it('should throw NotFoundException when product is missing', async () => {
      // Arrange
      const productId = 'uuid-missing';
      repository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findById(productId)).rejects.toThrow(NotFoundException);
    });
  });
});
```