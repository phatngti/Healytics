import { Test, TestingModule } from '@nestjs/testing';
import { AuditController } from './audit.controller';
import { AuditService } from './audit.service';
import { AuditLog } from '@/common/entities/audit-log.entity';
import { GetAuditLogsQueryDto } from './dto/get-audit-logs-query.dto';

describe('AuditController', () => {
  let controller: AuditController;
  let auditService: Record<string, jest.Mock>;

  const mockAuditService = {
    findAll: jest.fn(),
  };

  // Mock data
  const mockAuditLog: Partial<AuditLog> = {
    id: 'audit-uuid',
    actorId: 'actor-uuid',
    action: 'PARTNER_APPROVED',
    targetEntity: 'Partner',
    targetId: 'partner-uuid',
    ipAddress: '127.0.0.1',
    userAgent: 'Mozilla/5.0',
    metadata: { previousStatus: 'PENDING', newStatus: 'APPROVED' },
    createdAt: new Date('2026-01-20T00:00:00Z'),
  };

  const mockAuditLogs = [
    mockAuditLog,
    {
      ...mockAuditLog,
      id: 'audit-uuid-2',
      action: 'DOCUMENT_REVIEWED',
      targetEntity: 'PartnerDocument',
      targetId: 'doc-uuid',
    },
  ];

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuditController],
      providers: [
        {
          provide: AuditService,
          useValue: mockAuditService,
        },
      ],
    }).compile();

    controller = module.get<AuditController>(AuditController);
    auditService = module.get(AuditService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAuditLogs', () => {
    it('should return all audit logs when no filters provided', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue(mockAuditLogs);
      const query: GetAuditLogsQueryDto = {};

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(result).toEqual(mockAuditLogs);
      expect(mockAuditService.findAll).toHaveBeenCalledWith(query);
    });

    it('should filter by targetId when provided', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue([mockAuditLog]);
      const query: GetAuditLogsQueryDto = { targetId: 'partner-uuid' };

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(result).toEqual([mockAuditLog]);
      expect(mockAuditService.findAll).toHaveBeenCalledWith(query);
    });

    it('should filter by actorId when provided', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue([mockAuditLog]);
      const query: GetAuditLogsQueryDto = { actorId: 'actor-uuid' };

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(mockAuditService.findAll).toHaveBeenCalledWith(query);
    });

    it('should filter by action when provided', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue([mockAuditLog]);
      const query: GetAuditLogsQueryDto = { action: 'PARTNER_APPROVED' };

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(mockAuditService.findAll).toHaveBeenCalledWith(query);
    });

    it('should apply all filters when provided', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue([mockAuditLog]);
      const query: GetAuditLogsQueryDto = {
        targetId: 'partner-uuid',
        actorId: 'actor-uuid',
        action: 'PARTNER_APPROVED',
      };

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(mockAuditService.findAll).toHaveBeenCalledWith(query);
    });

    it('should return empty array when no audit logs match filters', async () => {
      // Arrange
      mockAuditService.findAll.mockResolvedValue([]);
      const query: GetAuditLogsQueryDto = { targetId: 'nonexistent-uuid' };

      // Act
      const result = await controller.getAuditLogs(query);

      // Assert
      expect(result).toEqual([]);
    });

    it('should propagate service errors', async () => {
      // Arrange
      mockAuditService.findAll.mockRejectedValue(new Error('Database error'));
      const query: GetAuditLogsQueryDto = {};

      // Act & Assert
      await expect(controller.getAuditLogs(query)).rejects.toThrow(
        'Database error',
      );
    });
  });
});
