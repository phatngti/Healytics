import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { EmployeeStatus } from '@/employees/enum/employee-status.enum';
import { CheckSlotAvailabilityHandler } from '@/booking/application/handlers/check-slot-availability.handler';

export interface AutoStaffAssignmentResult {
  staffId: string;
  available: boolean;
}

@Injectable()
export class AutoStaffAssignmentService {
  private readonly logger = new Logger(AutoStaffAssignmentService.name);

  constructor(
    @InjectRepository(ProductEmployeeEligibility)
    private readonly eligibilityRepository: Repository<ProductEmployeeEligibility>,
    private readonly slotChecker: CheckSlotAvailabilityHandler,
  ) {}

  async resolveBestStaff(
    productId: string | undefined | null,
    startTime: Date,
  ): Promise<AutoStaffAssignmentResult> {
    if (!productId) {
      throw new BadRequestException(
        'productId is required when auto assigning specialist',
      );
    }

    const candidates = await this.eligibilityRepository
      .createQueryBuilder('eligibility')
      .innerJoinAndSelect('eligibility.employee', 'employee')
      .innerJoin('eligibility.product', 'product')
      .where('eligibility.product_id = :productId', { productId })
      .andWhere('employee.status = :status', { status: EmployeeStatus.ACTIVE })
      .andWhere('product.id = :productId', { productId })
      .orderBy('eligibility.is_primary', 'DESC')
      .addOrderBy('employee.rating', 'DESC')
      .addOrderBy('employee.review_count', 'DESC')
      .addOrderBy('employee.id', 'ASC')
      .getMany();

    if (candidates.length === 0) {
      this.logger.warn(`No eligible staff found for product ${productId}`);
      throw new BadRequestException(
        'No specialist is eligible for this service.',
      );
    }

    for (const candidate of candidates) {
      const available = await this.slotChecker.execute(
        candidate.employeeId,
        startTime,
      );
      if (available) {
        return { staffId: candidate.employeeId, available: true };
      }
    }

    return {
      staffId: candidates[0].employeeId,
      available: false,
    };
  }
}
