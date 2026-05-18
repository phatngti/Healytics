import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { BookingSpecialistResponseDto } from '@/categories/dto/booking-specialist-response.dto';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { BookingServiceResponseDto } from '@/employees/dto/booking-service-response.dto';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import {
  SearchIndexEntityType,
  SearchIndexOperation,
} from '../entities/search-index-outbox.entity';
import { BookingSearchDocument } from '../types';
import { ElasticsearchBookingService } from './elasticsearch-booking.service';

@Injectable()
export class BookingSearchIndexerService {
  private readonly logger = new Logger(BookingSearchIndexerService.name);

  constructor(
    private readonly dataSource: DataSource,
    private readonly elasticsearch: ElasticsearchBookingService,
  ) {}

  async syncEntity(
    entityType: SearchIndexEntityType,
    entityId: string,
    operation: SearchIndexOperation,
    payload?: Record<string, unknown> | null,
  ): Promise<void> {
    if (entityType === SearchIndexEntityType.PRODUCT) {
      await this.syncProduct(entityId, operation, payload);
      return;
    }

    if (entityType === SearchIndexEntityType.EMPLOYEE) {
      await this.syncEmployee(entityId, operation);
    }
  }

  async refreshAll(): Promise<void> {
    await this.elasticsearch.deleteAllBookingDocuments();

    const productIds = await this.dataSource
      .getRepository(Product)
      .createQueryBuilder('product')
      .select('product.id', 'id')
      .where('product.status = :status', { status: HealthServiceStatus.ACTIVE })
      .andWhere('product.is_visible_online = true')
      .andWhere('product.deleted_at IS NULL')
      .getRawMany<{ id: string }>();

    for (const row of productIds) {
      await this.syncProduct(row.id, SearchIndexOperation.UPSERT);
    }

    const employeeIds = await this.dataSource
      .getRepository(ProductEmployeeEligibility)
      .createQueryBuilder('eligibility')
      .select('DISTINCT employee.id', 'id')
      .innerJoin('eligibility.employee', 'employee')
      .innerJoin('eligibility.product', 'product')
      .where('employee.status = :employeeStatus', {
        employeeStatus: EmployeeStatus.ACTIVE,
      })
      .andWhere('employee.deleted_at IS NULL')
      .andWhere('product.status = :productStatus', {
        productStatus: HealthServiceStatus.ACTIVE,
      })
      .andWhere('product.is_visible_online = true')
      .andWhere('product.deleted_at IS NULL')
      .getRawMany<{ id: string }>();

    for (const row of employeeIds) {
      await this.syncEmployee(row.id, SearchIndexOperation.UPSERT);
    }
  }

  private async syncProduct(
    productId: string,
    operation: SearchIndexOperation,
    payload?: Record<string, unknown> | null,
  ): Promise<void> {
    if (operation === SearchIndexOperation.DELETE) {
      await this.elasticsearch.deleteDocument('service', productId);
      await this.syncPayloadEmployees(payload);
      return;
    }

    const document = await this.buildServiceDocument(productId);
    if (!document) {
      await this.elasticsearch.deleteDocument('service', productId);
    } else {
      await this.elasticsearch.indexDocument(document);
    }

    const employeeIds = await this.getEmployeeIdsForProduct(productId);
    await this.syncEmployees(employeeIds);
    await this.syncPayloadEmployees(payload);
  }

  private async syncEmployee(
    employeeId: string,
    operation: SearchIndexOperation,
  ): Promise<void> {
    if (operation === SearchIndexOperation.DELETE) {
      await this.elasticsearch.deleteDocument('specialist', employeeId);
      return;
    }

    const document = await this.buildSpecialistDocument(employeeId);
    if (!document) {
      await this.elasticsearch.deleteDocument('specialist', employeeId);
    } else {
      await this.elasticsearch.indexDocument(document);
    }
  }

  private async buildServiceDocument(
    productId: string,
  ): Promise<BookingSearchDocument | null> {
    const product = await this.dataSource.getRepository(Product).findOne({
      where: {
        id: productId,
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: ['media', 'productDefinition', 'partner'],
    });

    if (!product || product.deletedAt) return null;

    const dto = BookingServiceResponseDto.fromEntity(product, product.partner);
    return {
      type: 'service',
      entityId: product.id,
      serviceId: product.id,
      name: dto.title,
      description: product.description,
      imageUrl: dto.imageUrl,
      duration: dto.duration,
      durationMinutes: dto.durationMinutes,
      price: dto.price,
      priceVnd: dto.priceVnd,
      clinicName: dto.clinicName,
      clinicAddress: dto.clinicAddress,
      updatedAt: product.updatedAt.toISOString(),
    };
  }

  private async buildSpecialistDocument(
    employeeId: string,
  ): Promise<BookingSearchDocument | null> {
    const eligibilities = await this.dataSource
      .getRepository(ProductEmployeeEligibility)
      .createQueryBuilder('eligibility')
      .innerJoinAndSelect('eligibility.employee', 'employee')
      .innerJoinAndSelect('eligibility.product', 'product')
      .where('employee.id = :employeeId', { employeeId })
      .andWhere('employee.status = :employeeStatus', {
        employeeStatus: EmployeeStatus.ACTIVE,
      })
      .andWhere('employee.deleted_at IS NULL')
      .andWhere('product.status = :productStatus', {
        productStatus: HealthServiceStatus.ACTIVE,
      })
      .andWhere('product.is_visible_online = true')
      .andWhere('product.deleted_at IS NULL')
      .orderBy('eligibility.isPrimary', 'DESC')
      .addOrderBy('product.updatedAt', 'DESC')
      .getMany();

    if (eligibilities.length === 0) return null;

    const primaryEligibility = eligibilities[0];
    const employee = primaryEligibility.employee;
    const dto = BookingSpecialistResponseDto.fromEntity(
      employee,
      primaryEligibility.id,
    );

    return {
      type: 'specialist',
      entityId: employee.id,
      specialistId: employee.id,
      eligibilityId: dto.eligibilityId,
      name: dto.name,
      specialty: dto.specialty,
      role: employee.role,
      serviceNames: eligibilities.map(
        (eligibility) => eligibility.product.name,
      ),
      avatarUrl: dto.avatarUrl,
      updatedAt: employee.updatedAt.toISOString(),
    };
  }

  private async getEmployeeIdsForProduct(productId: string): Promise<string[]> {
    const rows = await this.dataSource
      .getRepository(ProductEmployeeEligibility)
      .createQueryBuilder('eligibility')
      .select('eligibility.employeeId', 'employeeId')
      .where('eligibility.productId = :productId', { productId })
      .getRawMany<{ employeeId: string }>();

    return rows.map((row) => row.employeeId);
  }

  private async syncEmployees(employeeIds: string[]): Promise<void> {
    for (const employeeId of [...new Set(employeeIds.filter(Boolean))]) {
      await this.syncEmployee(employeeId, SearchIndexOperation.UPSERT);
    }
  }

  private async syncPayloadEmployees(
    payload?: Record<string, unknown> | null,
  ): Promise<void> {
    const employeeIds = payload?.employeeIds;
    if (!Array.isArray(employeeIds)) return;
    await this.syncEmployees(
      employeeIds.filter((id): id is string => typeof id === 'string'),
    );
  }
}
