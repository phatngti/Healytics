/**
 * Test Data Factory
 * Provides factory functions for generating consistent test data
 */

// ============================================================================
// Category Factories
// ============================================================================

export interface CategoryTestData {
  name: string;
  slug: string;
  description?: string;
  isActive?: boolean;
  parentId?: string;
}

/**
 * Creates category test data
 */
export function createCategoryDto(overrides: Partial<CategoryTestData> = {}): CategoryTestData {
  const timestamp = Date.now();
  return {
    name: `Test Category ${timestamp}`,
    slug: `test-category-${timestamp}`,
    description: 'A test category for e2e testing',
    isActive: true,
    ...overrides,
  };
}

// ============================================================================
// Product Factories
// ============================================================================

export interface ProductTestData {
  merchantId: string;
  name: string;
  slug: string;
  type: 'service' | 'physical';
  description?: string;
  categoryId?: string;
  basePrice?: number;
  salePrice?: number;
  currency?: string;
  status?: 'draft' | 'active' | 'archived';
  isVisibleOnline?: boolean;
  serviceDefinition?: {
    durationMinutes: number;
    bufferMinutes?: number;
    maxCapacity?: number;
  };
  physicalDetails?: {
    sku?: string;
    barcode?: string;
    stockQuantity?: number;
    costPerItem?: number;
    weightGram?: number;
    dimensions?: string;
  };
  media?: Array<{
    url: string;
    mediaType?: string;
    isThumbnail?: boolean;
    sortOrder?: number;
  }>;
}

const DEFAULT_MERCHANT_ID = '00000000-0000-0000-0000-000000000001';

/**
 * Creates service product test data
 */
export function createServiceProductDto(overrides: Partial<ProductTestData> = {}): ProductTestData {
  const timestamp = Date.now();
  return {
    merchantId: DEFAULT_MERCHANT_ID,
    name: `Test Service ${timestamp}`,
    slug: `test-service-${timestamp}`,
    type: 'service',
    description: 'A test service for e2e testing',
    basePrice: 500000,
    currency: 'VND',
    status: 'active',
    isVisibleOnline: true,
    serviceDefinition: {
      durationMinutes: 60,
      bufferMinutes: 15,
      maxCapacity: 1,
    },
    ...overrides,
  };
}

/**
 * Creates physical product test data
 */
export function createPhysicalProductDto(overrides: Partial<ProductTestData> = {}): ProductTestData {
  const timestamp = Date.now();
  return {
    merchantId: DEFAULT_MERCHANT_ID,
    name: `Test Product ${timestamp}`,
    slug: `test-product-${timestamp}`,
    type: 'physical',
    description: 'A test physical product for e2e testing',
    basePrice: 150000,
    currency: 'VND',
    status: 'draft',
    physicalDetails: {
      sku: `SKU-${timestamp}`,
      barcode: '1234567890123',
      stockQuantity: 100,
      costPerItem: 80000,
      weightGram: 500,
      dimensions: '10x5x5 cm',
    },
    ...overrides,
  };
}

// ============================================================================
// Employee Factories
// ============================================================================

export interface EmployeeTestData {
  employeeCode: string;
  fullName: string;
  email: string;
  role: 'DOCTOR' | 'THERAPIST' | 'RECEPTIONIST' | 'MANAGER';
  displayName?: string;
  phone?: string;
  avatarUrl?: string;
  dob?: string;
  gender?: 'MALE' | 'FEMALE' | 'OTHER';
  status?: 'ACTIVE' | 'INACTIVE' | 'ON_LEAVE';
  doctorProfile?: {
    title?: string;
    medicalLicense: string;
    experienceYears?: number;
    consultationFee?: number;
    specializations?: string[];
    education?: any[];
    certifications?: any[];
  };
  therapistProfile?: {
    level?: 'JUNIOR' | 'SENIOR' | 'LEAD';
    type?: string;
    strengthLevel?: 'LIGHT' | 'MEDIUM' | 'STRONG';
    commissionRate?: number;
    healthCheckDate?: string;
    skills?: string[];
  };
}

/**
 * Creates doctor employee test data
 */
export function createDoctorDto(overrides: Partial<EmployeeTestData> = {}): EmployeeTestData {
  const timestamp = Date.now();
  return {
    employeeCode: `EMP-DR-${timestamp}`,
    fullName: `Dr. Test Doctor ${timestamp}`,
    displayName: 'Dr. Test',
    email: `dr.test+${timestamp}@example.com`,
    phone: '+1234567890',
    dob: '1985-05-15',
    gender: 'MALE',
    role: 'DOCTOR',
    status: 'ACTIVE',
    doctorProfile: {
      title: 'Dr.',
      medicalLicense: `MED-${timestamp}`,
      experienceYears: 10,
      consultationFee: 150.0,
      specializations: ['Cardiology', 'Internal Medicine'],
    },
    ...overrides,
  };
}

/**
 * Creates therapist employee test data
 */
export function createTherapistDto(overrides: Partial<EmployeeTestData> = {}): EmployeeTestData {
  const timestamp = Date.now();
  return {
    employeeCode: `EMP-TH-${timestamp}`,
    fullName: `Test Therapist ${timestamp}`,
    displayName: 'Therapist',
    email: `therapist+${timestamp}@example.com`,
    phone: '+0987654321',
    dob: '1990-03-20',
    gender: 'FEMALE',
    role: 'THERAPIST',
    status: 'ACTIVE',
    therapistProfile: {
      level: 'SENIOR',
      type: 'Massage Therapist',
      strengthLevel: 'STRONG',
      commissionRate: 15.5,
      healthCheckDate: '2024-01-15',
      skills: ['Thai Massage', 'Swedish Massage', 'Aromatherapy'],
    },
    ...overrides,
  };
}

/**
 * Creates receptionist employee test data
 */
export function createReceptionistDto(overrides: Partial<EmployeeTestData> = {}): EmployeeTestData {
  const timestamp = Date.now();
  return {
    employeeCode: `EMP-RC-${timestamp}`,
    fullName: `Test Receptionist ${timestamp}`,
    email: `receptionist+${timestamp}@example.com`,
    role: 'RECEPTIONIST',
    status: 'ACTIVE',
    ...overrides,
  };
}

/**
 * Creates manager employee test data
 */
export function createManagerDto(overrides: Partial<EmployeeTestData> = {}): EmployeeTestData {
  const timestamp = Date.now();
  return {
    employeeCode: `EMP-MG-${timestamp}`,
    fullName: `Test Manager ${timestamp}`,
    email: `manager+${timestamp}@example.com`,
    role: 'MANAGER',
    status: 'ACTIVE',
    ...overrides,
  };
}

// ============================================================================
// Survey Factories
// ============================================================================

export interface SurveyTestData {
  survey: Record<string, any>;
}

/**
 * Creates survey test data
 */
export function createSurveyDto(overrides: Partial<Record<string, any>> = {}): SurveyTestData {
  return {
    survey: {
      healthGoals: ['weight_loss', 'stress_relief'],
      preferredServices: ['massage', 'acupuncture'],
      frequencyPreference: 'weekly',
      ...overrides,
    },
  };
}

// ============================================================================
// Booking Factories
// ============================================================================

export interface BookingEntityData {
  id: string;
  userId: string;
  staffId: string;
  productId: string | null;
  startTime: Date;
  endTime: Date | null;
  status: string;
  paymentUrl: string | null;
  paymentExpiresAt: Date | null;
  notes: string | null;
  version: number;
  createdAt: Date;
  updatedAt: Date;
  deletedAt: Date | null;
}

/**
 * Creates a mock Booking entity
 */
export function createBookingEntity(overrides: Partial<BookingEntityData> = {}): BookingEntityData {
  const now = new Date();
  return {
    id: `bk-${Date.now()}`,
    userId: FAKE_UUID,
    staffId: 'a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5',
    productId: null,
    startTime: new Date('2025-10-25T14:00:00Z'),
    endTime: null,
    status: 'PENDING_PAYMENT',
    paymentUrl: null,
    paymentExpiresAt: null,
    notes: null,
    version: 1,
    createdAt: now,
    updatedAt: now,
    deletedAt: null,
    ...overrides,
  };
}

export interface CheckoutTicketEntityData {
  id: string;
  userId: string;
  staffId: string;
  productId: string | null;
  startTime: Date;
  idempotencyKey: string;
  status: string;
  webhookUrl: string | null;
  bookingId: string | null;
  errorMessage: string | null;
  createdAt: Date;
  updatedAt: Date;
}

/**
 * Creates a mock CheckoutTicket entity
 */
export function createCheckoutTicketEntity(overrides: Partial<CheckoutTicketEntityData> = {}): CheckoutTicketEntityData {
  const now = new Date();
  return {
    id: `tk-${Date.now()}`,
    userId: FAKE_UUID,
    staffId: 'a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5',
    productId: null,
    startTime: new Date('2025-10-25T14:00:00Z'),
    idempotencyKey: `idem-${Date.now()}`,
    status: 'QUEUED',
    webhookUrl: null,
    bookingId: null,
    errorMessage: null,
    createdAt: now,
    updatedAt: now,
    ...overrides,
  };
}

export interface AsyncCheckoutTestData {
  userId: string;
  staffId: string;
  startTime: string;
  productId?: string;
  idempotencyKey: string;
  webhookUrl?: string;
}

/**
 * Creates async checkout DTO test data
 */
export function createAsyncCheckoutDto(overrides: Partial<AsyncCheckoutTestData> = {}): AsyncCheckoutTestData {
  return {
    userId: FAKE_UUID,
    staffId: 'a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5',
    startTime: '2025-10-25T14:00:00Z',
    idempotencyKey: `idem-${Date.now()}`,
    ...overrides,
  };
}

export interface MicroLockTestData {
  staffId: string;
  startTime: string;
  productId?: string;
}

/**
 * Creates micro lock DTO test data
 */
export function createMicroLockDto(overrides: Partial<MicroLockTestData> = {}): MicroLockTestData {
  return {
    staffId: 'a1b2c3d4-e5f6-4a7b-8c9d-e0f1a2b3c4d5',
    startTime: '2025-10-25T14:00:00Z',
    ...overrides,
  };
}

// ============================================================================
// Utility Constants
// ============================================================================

export const FAKE_UUID = '00000000-0000-0000-0000-000000000000';
export const TEST_MERCHANT_ID = DEFAULT_MERCHANT_ID;
