import { Test, TestingModule } from '@nestjs/testing';
import { AuditInterceptor } from './audit.interceptor';
import { AuditService } from '../audit.service';
import { Reflector } from '@nestjs/core';
import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of } from 'rxjs';
import {
  AUDIT_ACTION_KEY,
  AUDIT_TARGET_ENTITY_KEY,
} from '../decorators/audit.decorator';

describe('AuditInterceptor', () => {
  let interceptor: AuditInterceptor;
  let auditService: AuditService;
  let reflector: Reflector;

  const mockAuditService = {
    logAction: jest.fn(),
  };

  const mockReflector = {
    get: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuditInterceptor,
        {
          provide: AuditService,
          useValue: mockAuditService,
        },
        {
          provide: Reflector,
          useValue: mockReflector,
        },
      ],
    }).compile();

    interceptor = module.get<AuditInterceptor>(AuditInterceptor);
    auditService = module.get<AuditService>(AuditService);
    reflector = module.get<Reflector>(Reflector);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(interceptor).toBeDefined();
  });

  it('should log action with correct metadata including IP and User Agent', async () => {
    // Arrange
    const context = {
      getHandler: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({
          user: { id: 'user-123' },
          params: { id: 'target-123' },
          body: { some: 'da-ta' },
          ip: '127.0.0.1',
          headers: {
            'user-agent': 'TestAgent/1.0',
          },
        }),
      }),
    } as unknown as ExecutionContext;

    const next: CallHandler = {
      handle: () => of('success'),
    };

    mockReflector.get.mockImplementation((key) => {
      if (key === AUDIT_ACTION_KEY) return 'TEST_ACTION';
      if (key === AUDIT_TARGET_ENTITY_KEY) return 'TEST_ENTITY';
      return null;
    });

    // Act
    interceptor.intercept(context, next).subscribe();

    // Allow async operations to complete
    await new Promise((resolve) => setTimeout(resolve, 0));

    // Assert
    expect(auditService.logAction).toHaveBeenCalledWith({
      actorId: 'user-123',
      action: 'TEST_ACTION',
      targetEntity: 'TEST_ENTITY',
      targetId: 'target-123',
      metadata: { some: 'da-ta' },
      ipAddress: '127.0.0.1',
      userAgent: 'TestAgent/1.0',
    });
  });

  it('should fallback to connection remoteAddress if ip is missing', async () => {
    // Arrange
    const context = {
      getHandler: jest.fn(),
      switchToHttp: jest.fn().mockReturnValue({
        getRequest: jest.fn().mockReturnValue({
          user: { id: 'user-123' },
          params: { id: 'target-123' },
          body: {},
          connection: { remoteAddress: '::1' },
          headers: {},
        }),
      }),
    } as unknown as ExecutionContext;

    const next: CallHandler = {
      handle: () => of('success'),
    };

    mockReflector.get.mockImplementation((key) => {
      if (key === AUDIT_ACTION_KEY) return 'TEST_ACTION';
      if (key === AUDIT_TARGET_ENTITY_KEY) return 'TEST_ENTITY';
      return null;
    });

    // Act
    interceptor.intercept(context, next).subscribe();

    // Allow async operations to complete
    await new Promise((resolve) => setTimeout(resolve, 0));

    // Assert
    expect(auditService.logAction).toHaveBeenCalledWith(
      expect.objectContaining({
        ipAddress: '::1',
      }),
    );
  });
});
