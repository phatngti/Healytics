import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Employee } from '@/common/entities/employee.entity';

/**
 * Handler to retrieve the authenticated employee's own profile.
 * Resolves Employee from Account ID via the account_id FK.
 */
@Injectable()
export class GetEmployeeProfileHandler {
  private readonly logger = new Logger(GetEmployeeProfileHandler.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
  ) {}

  /**
   * Loads the employee record linked to the authenticated account.
   * @param accountId - The authenticated account ID from JWT
   * @returns The Employee entity with profile relations
   * @throws NotFoundException if no employee is linked to this account
   */
  async execute(accountId: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { accountId },
      relations: ['doctorProfile', 'therapistProfile', 'partner'],
    });

    if (!employee) {
      this.logger.warn(`No employee profile found for account: ${accountId}`);
      throw new NotFoundException(
        `Employee profile not found for this account`,
      );
    }

    return employee;
  }
}
