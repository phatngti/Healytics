import { ForbiddenException } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { RedisService } from '@/redis/redis.service';
import { Category } from '@/common/entities/category.entity';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { CreateHealthServiceHandler } from './create-health-service.handler';
import { HealthServiceType } from '../../enums/health-service-type.enum';

describe('CreateHealthServiceHandler', () => {
  const createQueryRunner = () => ({
    connect: jest.fn(),
    startTransaction: jest.fn(),
    commitTransaction: jest.fn(),
    rollbackTransaction: jest.fn(),
    release: jest.fn(),
    manager: {
      findOne: jest.fn(),
      find: jest.fn(),
      create: jest.fn((_: unknown, payload: Record<string, unknown>) => ({
        ...payload,
      })),
      save: jest.fn(
        async (entity: unknown, payload: Record<string, unknown>) =>
          entity === Product ? { ...payload, id: 'product-uuid' } : payload,
      ),
    },
  });

  const createHandler = (queryRunner: ReturnType<typeof createQueryRunner>) => {
    const dataSource = {
      createQueryRunner: jest.fn().mockReturnValue(queryRunner),
      manager: {
        findOne: jest.fn().mockResolvedValue({
          id: 'product-uuid',
          partnerId: 'partner-uuid',
        }),
      },
    } as unknown as DataSource;
    const redisService = {
      publish: jest.fn().mockResolvedValue(undefined),
    } as unknown as RedisService;

    return {
      handler: new CreateHealthServiceHandler(dataSource, redisService),
      dataSource,
    };
  };

  it('assigns the authenticated partner and de-duplicates employee eligibility', async () => {
    const queryRunner = createQueryRunner();
    queryRunner.manager.findOne.mockImplementation(async (entity) => {
      if (entity === Partner)
        return { id: 'partner-uuid', brandName: 'Test Partner' };
      if (entity === Category) return { id: 'category-uuid', parentId: 'parent-category-uuid' };
      return null;
    });
    queryRunner.manager.find.mockResolvedValue([
      { id: 'employee-1', partnerId: 'partner-uuid' },
      { id: 'employee-2', partnerId: 'partner-uuid' },
    ] satisfies Pick<Employee, 'id' | 'partnerId'>[]);

    const { handler } = createHandler(queryRunner);

    await handler.execute({
      name: 'Thai Massage',
      slug: 'thai-massage',
      type: HealthServiceType.SERVICE,
      categoryId: 'category-uuid',
      partnerId: 'partner-uuid',
      employeeIds: ['employee-1', 'employee-1', 'employee-2'],
      productDefinition: { durationMinutes: 60 },
    });

    expect(queryRunner.manager.create).toHaveBeenCalledWith(
      Product,
      expect.objectContaining({
        partnerId: 'partner-uuid',
        categoryId: 'category-uuid',
      }),
    );
    expect(queryRunner.manager.save).toHaveBeenCalledWith(
      ProductEmployeeEligibility,
      [
        expect.objectContaining({ employeeId: 'employee-1' }),
        expect.objectContaining({ employeeId: 'employee-2' }),
      ],
    );
    expect(queryRunner.manager.save).toHaveBeenCalledWith(
      ProductDefinition,
      expect.objectContaining({ productId: 'product-uuid' }),
    );
    expect(queryRunner.commitTransaction).toHaveBeenCalledTimes(1);
  });

  it('rejects employees that do not belong to the authenticated partner', async () => {
    const queryRunner = createQueryRunner();
    queryRunner.manager.findOne.mockImplementation(async (entity) => {
      if (entity === Partner)
        return { id: 'partner-uuid', brandName: 'Test Partner' };
      return null;
    });
    queryRunner.manager.find.mockResolvedValue([
      { id: 'employee-1', partnerId: 'other-partner' },
    ] satisfies Pick<Employee, 'id' | 'partnerId'>[]);

    const { handler } = createHandler(queryRunner);

    await expect(
      handler.execute({
        name: 'Thai Massage',
        slug: 'thai-massage',
        type: HealthServiceType.SERVICE,
        partnerId: 'partner-uuid',
        employeeIds: ['employee-1'],
        productDefinition: { durationMinutes: 60 },
      }),
    ).rejects.toThrow(ForbiddenException);

    expect(queryRunner.rollbackTransaction).toHaveBeenCalledTimes(1);
    expect(queryRunner.commitTransaction).not.toHaveBeenCalled();
  });
});
