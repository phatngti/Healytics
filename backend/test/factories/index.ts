/**
 * Test data factories for consistent test data generation.
 * Provides factory functions to create test entities with sensible defaults.
 */

import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { Role } from '@/account/enum/role.enum';

// ============================================================
// ID Generation
// ============================================================

let idCounter = 0;

/**
 * Generates a unique test ID.
 */
export const generateTestId = (): string => {
  idCounter++;
  return `test-uuid-${idCounter}`;
};

/**
 * Resets the ID counter (call in afterEach).
 */
export const resetTestIdCounter = (): void => {
  idCounter = 0;
};

// ============================================================
// Product Factories
// ============================================================

export interface TestProductData {
  id?: string;
  name?: string;
  slug?: string;
  description?: string;
  type?: HealthServiceType;
  basePrice?: number;
  salePrice?: number | null;
  currency?: string;
  status?: HealthServiceStatus;
  isVisibleOnline?: boolean;
  categoryId?: string | null;
  createdAt?: Date;
  updatedAt?: Date;
}

/**
 * Creates a test product with sensible defaults.
 */
export const createTestProduct = (overrides: TestProductData = {}): TestProductData => ({
  id: generateTestId(),
  name: 'Test Product',
  slug: 'test-product',
  description: 'A test product description',
  type: HealthServiceType.PHYSICAL,
  basePrice: 100.00,
  salePrice: null,
  currency: 'VND',
  status: HealthServiceStatus.DRAFT,
  isVisibleOnline: false,
  categoryId: null,
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
});

// ============================================================
// Category Factories
// ============================================================

export interface TestCategoryData {
  id?: string;
  name?: string;
  slug?: string;
  description?: string | null;
  imageUrl?: string | null;
  isActive?: boolean;
  parentId?: string | null;
  createdAt?: Date;
  updatedAt?: Date;
}

/**
 * Creates a test category with sensible defaults.
 */
export const createTestCategory = (overrides: TestCategoryData = {}): TestCategoryData => ({
  id: generateTestId(),
  name: 'Test Category',
  slug: 'test-category',
  description: null,
  imageUrl: null,
  isActive: true,
  parentId: null,
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
});

// ============================================================
// Employee Factories
// ============================================================

export interface TestEmployeeData {
  id?: string;
  employeeCode?: string;
  fullName?: string;
  displayName?: string | null;
  email?: string;
  phone?: string | null;
  role?: EmployeeRole;
  status?: EmployeeStatus;
  createdAt?: Date;
  updatedAt?: Date;
}

/**
 * Creates a test employee with sensible defaults.
 */
export const createTestEmployee = (overrides: TestEmployeeData = {}): TestEmployeeData => ({
  id: generateTestId(),
  employeeCode: `EMP-${Date.now()}`,
  fullName: 'Test Employee',
  displayName: null,
  email: `test-${Date.now()}@example.com`,
  phone: null,
  role: EmployeeRole.STAFF,
  status: EmployeeStatus.ACTIVE,
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
});

/**
 * Creates a test doctor employee.
 */
export const createTestDoctor = (overrides: TestEmployeeData = {}): TestEmployeeData =>
  createTestEmployee({
    role: EmployeeRole.DOCTOR,
    fullName: 'Dr. Test Doctor',
    ...overrides,
  });

/**
 * Creates a test therapist employee.
 */
export const createTestTherapist = (overrides: TestEmployeeData = {}): TestEmployeeData =>
  createTestEmployee({
    role: EmployeeRole.THERAPIST,
    fullName: 'Test Therapist',
    ...overrides,
  });

// ============================================================
// Account Factories
// ============================================================

export interface TestAccountData {
  id?: string;
  email?: string;
  passwordHash?: string;
  role?: Role;
  isActive?: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}

/**
 * Creates a test account with sensible defaults.
 */
export const createTestAccount = (overrides: TestAccountData = {}): TestAccountData => ({
  id: generateTestId(),
  email: `test-${Date.now()}@example.com`,
  passwordHash: 'hashed-password',
  role: Role.USER,
  isActive: true,
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
});

/**
 * Creates a test admin account.
 */
export const createTestAdminAccount = (overrides: TestAccountData = {}): TestAccountData =>
  createTestAccount({
    role: Role.ADMIN,
    email: 'admin@example.com',
    ...overrides,
  });

// ============================================================
// Service Tag Factories
// ============================================================

export interface TestServiceTagData {
  id?: string;
  name?: string;
  colorValue?: number;
  isActive?: boolean;
  sortOrder?: number;
  usage?: number;
  userId?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

/**
 * Creates a test service tag with sensible defaults.
 */
export const createTestServiceTag = (overrides: TestServiceTagData = {}): TestServiceTagData => ({
  id: generateTestId(),
  name: 'Test Tag',
  colorValue: 0xFF6366F1,
  isActive: true,
  sortOrder: 0,
  usage: 0,
  userId: generateTestId(),
  createdAt: new Date(),
  updatedAt: new Date(),
  ...overrides,
});
