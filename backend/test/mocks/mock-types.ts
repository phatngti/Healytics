/**
 * Typed mock interfaces for Jest testing.
 * Provides type-safe mocks for common services and repositories.
 */

/**
 * Creates a typed mock object with all methods as jest.Mock.
 * @example
 * const mockRepo = createMockRepository<UserRepository>();
 */
export type MockType<T> = {
  [P in keyof T]?: jest.Mock;
};

/**
 * Repository mock interface for TypeORM repositories.
 */
export interface MockRepository<T = any> {
  find: jest.Mock;
  findOne: jest.Mock;
  findOneBy: jest.Mock;
  save: jest.Mock;
  create: jest.Mock;
  update: jest.Mock;
  delete: jest.Mock;
  remove: jest.Mock;
  count: jest.Mock;
  softDelete: jest.Mock;
  softRemove: jest.Mock;
  increment: jest.Mock;
  decrement: jest.Mock;
}

/**
 * Creates a mock repository with all common methods.
 */
export const createMockRepository = <T = any>(): MockRepository<T> => ({
  find: jest.fn(),
  findOne: jest.fn(),
  findOneBy: jest.fn(),
  save: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
  remove: jest.fn(),
  count: jest.fn(),
  softDelete: jest.fn(),
  softRemove: jest.fn(),
  increment: jest.fn(),
  decrement: jest.fn(),
});

/**
 * Handler mock interface for domain handlers.
 */
export interface MockHandler {
  execute: jest.Mock;
}

/**
 * Creates a mock handler.
 */
export const createMockHandler = (): MockHandler => ({
  execute: jest.fn(),
});

/**
 * DataSource mock for transaction testing.
 */
export interface MockDataSource {
  createQueryRunner: jest.Mock;
}

/**
 * QueryRunner mock for transaction testing.
 */
export interface MockQueryRunner {
  connect: jest.Mock;
  startTransaction: jest.Mock;
  commitTransaction: jest.Mock;
  rollbackTransaction: jest.Mock;
  release: jest.Mock;
  manager: {
    findOne: jest.Mock;
    save: jest.Mock;
    create: jest.Mock;
    update: jest.Mock;
    delete: jest.Mock;
    remove: jest.Mock;
    increment: jest.Mock;
    decrement: jest.Mock;
  };
}

/**
 * Creates a mock QueryRunner for transaction tests.
 */
export const createMockQueryRunner = (): MockQueryRunner => ({
  connect: jest.fn(),
  startTransaction: jest.fn(),
  commitTransaction: jest.fn(),
  rollbackTransaction: jest.fn(),
  release: jest.fn(),
  manager: {
    findOne: jest.fn(),
    save: jest.fn(),
    create: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
    remove: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
  },
});

/**
 * Creates a mock DataSource for transaction tests.
 */
export const createMockDataSource = (
  queryRunner: MockQueryRunner = createMockQueryRunner(),
): MockDataSource => ({
  createQueryRunner: jest.fn().mockReturnValue(queryRunner),
});
