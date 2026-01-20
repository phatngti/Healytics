import { Test, TestingModule } from '@nestjs/testing';
import { AuditService } from './audit.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AuditLog } from './entities/audit-log.entity';
import { CreateAuditLogDto } from './dto/create-audit-log.dto';

describe('AuditService', () => {
    let service: AuditService;
    let auditLogRepository: Record<string, jest.Mock>;

    const mockAuditLogRepository = {
        create: jest.fn(),
        save: jest.fn(),
        find: jest.fn(),
        createQueryBuilder: jest.fn(),
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

    const mockCreateDto: CreateAuditLogDto = {
        actorId: 'actor-uuid',
        action: 'PARTNER_APPROVED',
        targetEntity: 'Partner',
        targetId: 'partner-uuid',
        ipAddress: '127.0.0.1',
        userAgent: 'Mozilla/5.0',
        metadata: { previousStatus: 'PENDING', newStatus: 'APPROVED' },
    };

    beforeEach(async () => {
        jest.clearAllMocks();

        const module: TestingModule = await Test.createTestingModule({
            providers: [
                AuditService,
                {
                    provide: getRepositoryToken(AuditLog),
                    useValue: mockAuditLogRepository,
                },
            ],
        }).compile();

        service = module.get<AuditService>(AuditService);
        auditLogRepository = module.get(getRepositoryToken(AuditLog));
    });

    afterEach(() => {
        jest.clearAllMocks();
    });

    describe('logAction', () => {
        it('should create and save an audit log entry', async () => {
            // Arrange
            mockAuditLogRepository.create.mockReturnValue(mockAuditLog);
            mockAuditLogRepository.save.mockResolvedValue(mockAuditLog);

            // Act
            const result = await service.logAction(mockCreateDto);

            // Assert
            expect(result).toEqual(mockAuditLog);
            expect(mockAuditLogRepository.create).toHaveBeenCalledWith(mockCreateDto);
            expect(mockAuditLogRepository.save).toHaveBeenCalledWith(mockAuditLog);
        });

        it('should handle audit log without optional fields', async () => {
            // Arrange
            const minimalDto: CreateAuditLogDto = {
                actorId: 'actor-uuid',
                action: 'DOCUMENT_REVIEWED',
                targetEntity: 'PartnerDocument',
                targetId: 'doc-uuid',
            };
            const minimalLog = { id: 'log-uuid', ...minimalDto };
            mockAuditLogRepository.create.mockReturnValue(minimalLog);
            mockAuditLogRepository.save.mockResolvedValue(minimalLog);

            // Act
            const result = await service.logAction(minimalDto);

            // Assert
            expect(result.id).toBeDefined();
            expect(mockAuditLogRepository.create).toHaveBeenCalledWith(minimalDto);
        });

        it('should propagate database errors', async () => {
            // Arrange
            mockAuditLogRepository.create.mockReturnValue(mockAuditLog);
            mockAuditLogRepository.save.mockRejectedValue(new Error('Database connection failed'));

            // Act & Assert
            await expect(service.logAction(mockCreateDto)).rejects.toThrow('Database connection failed');
        });
    });

    describe('findAll', () => {
        const mockQueryBuilder = {
            andWhere: jest.fn().mockReturnThis(),
            orderBy: jest.fn().mockReturnThis(),
            getMany: jest.fn(),
        };

        beforeEach(() => {
            mockAuditLogRepository.createQueryBuilder.mockReturnValue(mockQueryBuilder);
        });

        it('should return all audit logs when no filters provided', async () => {
            // Arrange
            const auditLogs = [mockAuditLog];
            mockQueryBuilder.getMany.mockResolvedValue(auditLogs);

            // Act
            const result = await service.findAll({});

            // Assert
            expect(result).toEqual(auditLogs);
            expect(mockAuditLogRepository.createQueryBuilder).toHaveBeenCalledWith('audit');
            expect(mockQueryBuilder.orderBy).toHaveBeenCalledWith('audit.createdAt', 'DESC');
            expect(mockQueryBuilder.andWhere).not.toHaveBeenCalled();
        });

        it('should filter by targetId when provided', async () => {
            // Arrange
            mockQueryBuilder.getMany.mockResolvedValue([mockAuditLog]);

            // Act
            await service.findAll({ targetId: 'partner-uuid' });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.targetId = :targetId',
                { targetId: 'partner-uuid' },
            );
        });

        it('should filter by actorId when provided', async () => {
            // Arrange
            mockQueryBuilder.getMany.mockResolvedValue([mockAuditLog]);

            // Act
            await service.findAll({ actorId: 'actor-uuid' });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.actorId = :actorId',
                { actorId: 'actor-uuid' },
            );
        });

        it('should filter by action when provided', async () => {
            // Arrange
            mockQueryBuilder.getMany.mockResolvedValue([mockAuditLog]);

            // Act
            await service.findAll({ action: 'PARTNER_APPROVED' });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.action = :action',
                { action: 'PARTNER_APPROVED' },
            );
        });

        it('should apply multiple filters when provided', async () => {
            // Arrange
            mockQueryBuilder.getMany.mockResolvedValue([mockAuditLog]);

            // Act
            await service.findAll({
                targetId: 'partner-uuid',
                actorId: 'actor-uuid',
                action: 'PARTNER_APPROVED',
            });

            // Assert
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledTimes(3);
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.targetId = :targetId',
                { targetId: 'partner-uuid' },
            );
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.actorId = :actorId',
                { actorId: 'actor-uuid' },
            );
            expect(mockQueryBuilder.andWhere).toHaveBeenCalledWith(
                'audit.action = :action',
                { action: 'PARTNER_APPROVED' },
            );
        });

        it('should return empty array when no logs match filters', async () => {
            // Arrange
            mockQueryBuilder.getMany.mockResolvedValue([]);

            // Act
            const result = await service.findAll({ targetId: 'nonexistent-uuid' });

            // Assert
            expect(result).toEqual([]);
        });
    });

    describe('getLogsByTarget', () => {
        it('should return audit logs for a specific target', async () => {
            // Arrange
            const targetId = 'partner-uuid';
            const auditLogs = [mockAuditLog];
            mockAuditLogRepository.find.mockResolvedValue(auditLogs);

            // Act
            const result = await service.getLogsByTarget(targetId);

            // Assert
            expect(result).toEqual(auditLogs);
            expect(mockAuditLogRepository.find).toHaveBeenCalledWith({
                where: { targetId },
                order: { createdAt: 'DESC' },
            });
        });

        it('should return empty array when no logs exist for target', async () => {
            // Arrange
            mockAuditLogRepository.find.mockResolvedValue([]);

            // Act
            const result = await service.getLogsByTarget('nonexistent-uuid');

            // Assert
            expect(result).toEqual([]);
        });

        it('should return logs ordered by createdAt descending', async () => {
            // Arrange
            const olderLog = { ...mockAuditLog, createdAt: new Date('2026-01-01') };
            const newerLog = { ...mockAuditLog, createdAt: new Date('2026-01-15') };
            mockAuditLogRepository.find.mockResolvedValue([newerLog, olderLog]);

            // Act
            const result = await service.getLogsByTarget('partner-uuid');

            // Assert
            expect(result[0].createdAt).toEqual(newerLog.createdAt);
            expect(mockAuditLogRepository.find).toHaveBeenCalledWith(
                expect.objectContaining({
                    order: { createdAt: 'DESC' },
                }),
            );
        });
    });
});
