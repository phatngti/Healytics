import {
  ConflictException,
  Injectable,
  Logger,
  NotFoundException,
  InternalServerErrorException,
  Optional,
} from '@nestjs/common';
import { DataSource, EntityManager } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { UpdateEmployeeDto } from '../../dto/update-employee.dto';
import { Role } from '@/account/enum/role.enum';
import { Account } from '@/common/entities/account.entity';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { EmployeeRole } from '../../enum/employee-role.enum';
import { SearchIndexOutboxService } from '@/search/services/search-index-outbox.service';

/**
 * Handler for updating employees with transactional boundaries.
 * Follows the domain handler pattern with single responsibility.
 */
@Injectable()
export class UpdateEmployeeHandler {
  private readonly logger = new Logger(UpdateEmployeeHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    @Optional()
    private readonly searchIndexOutboxService?: SearchIndexOutboxService,
  ) {}

  /**
   * Executes the update employee command within a transaction.
   * @param id - The employee ID to update
   * @param command - The update data
   * @returns The updated employee with relations
   */
  async execute(id: string, command: UpdateEmployeeDto): Promise<Employee> {
    this.logger.log(`Executing UpdateEmployeeHandler for: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration: Load employee
      const employee = await queryRunner.manager.findOne(Employee, {
        where: { id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      if (!employee) {
        throw new NotFoundException(`Employee with ID ${id} not found`);
      }

      const { doctorProfile, therapistProfile, password, ...employeeData } =
        command;

      // Strip null/undefined values so we never overwrite non-nullable DB columns
      // (e.g. employeeCode, fullName, email, role, status) with null.
      const sanitizedData = Object.fromEntries(
        Object.entries(employeeData).filter(
          ([, v]) => v !== null && v !== undefined,
        ),
      );
      if (typeof sanitizedData.email === 'string') {
        sanitizedData.email = sanitizedData.email.trim().toLowerCase();
      }

      await this.syncEmployeeAccount(
        queryRunner.manager,
        employee,
        typeof sanitizedData.email === 'string'
          ? sanitizedData.email
          : undefined,
        password,
      );

      // 2. Domain Action: Update Employee entity
      if (Object.keys(sanitizedData).length > 0) {
        Object.assign(employee, sanitizedData);
      }
      await queryRunner.manager.save(Employee, employee);

      // 3. Domain Action: Update Doctor Profile if applicable
      if (doctorProfile && employee.role === EmployeeRole.DOCTOR) {
        let profile = await queryRunner.manager.findOne(DoctorProfile, {
          where: { employeeId: id },
        });
        if (profile) {
          Object.assign(profile, doctorProfile);
        } else {
          profile = queryRunner.manager.create(DoctorProfile, {
            ...doctorProfile,
            employeeId: id,
          });
        }
        await queryRunner.manager.save(DoctorProfile, profile);
      }

      // 4. Domain Action: Update Therapist Profile if applicable
      if (therapistProfile && employee.role === EmployeeRole.THERAPIST) {
        let profile = await queryRunner.manager.findOne(TherapistProfile, {
          where: { employeeId: id },
        });
        if (profile) {
          Object.assign(profile, therapistProfile);
        } else {
          profile = queryRunner.manager.create(TherapistProfile, {
            ...therapistProfile,
            employeeId: id,
          });
        }
        await queryRunner.manager.save(TherapistProfile, profile);
      }

      await this.searchIndexOutboxService?.enqueueEmployee(
        queryRunner.manager,
        id,
      );

      // 5. Commit transaction
      await queryRunner.commitTransaction();
      this.logger.log(`Employee updated successfully: ${id}`);

      // 6. Return complete aggregate
      const completeEmployee = await this.dataSource.manager.findOne(Employee, {
        where: { id },
        relations: ['doctorProfile', 'therapistProfile'],
      });

      return completeEmployee!;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (
        error instanceof NotFoundException ||
        error instanceof ConflictException
      ) {
        throw error;
      }
      this.logger.error(
        `Failed to update employee: ${error.message}`,
        error.stack,
      );
      throw new InternalServerErrorException(
        'Transaction failed during employee update',
      );
    } finally {
      await queryRunner.release();
    }
  }

  private async syncEmployeeAccount(
    manager: EntityManager,
    employee: Employee,
    nextEmail?: string,
    nextPassword?: string,
  ): Promise<void> {
    if (!nextEmail && !nextPassword) return;

    let account: Account | null = null;
    if (employee.accountId) {
      account = await manager.findOne(Account, {
        where: { id: employee.accountId },
        withDeleted: true,
      });
    }

    const accountEmail = nextEmail ?? employee.email?.trim().toLowerCase();
    if (!accountEmail) return;

    if (!account && nextPassword) {
      const existingAccount = await manager.findOne(Account, {
        where: { email: accountEmail },
        withDeleted: true,
      });
      if (existingAccount) {
        throw new ConflictException(
          'An account with this email already exists',
        );
      }
      const passwordHash = await bcrypt.hash(nextPassword, 10);
      const created = manager.create(Account, {
        email: accountEmail,
        passwordHash,
        role: Role.EMPLOYEE,
        isActive: true,
      });
      const saved = await manager.save(Account, created);
      employee.accountId = saved.id;
      return;
    }

    if (!account) return;

    let shouldSaveAccount = false;
    if (nextEmail && nextEmail !== account.email) {
      const existingAccount = await manager.findOne(Account, {
        where: { email: nextEmail },
        withDeleted: true,
      });
      if (existingAccount && existingAccount.id !== account.id) {
        throw new ConflictException(
          'An account with this email already exists',
        );
      }
      account.email = nextEmail;
      shouldSaveAccount = true;
    }

    if (nextPassword) {
      account.passwordHash = await bcrypt.hash(nextPassword, 10);
      account.refreshTokenHash = null;
      shouldSaveAccount = true;
    }

    if (shouldSaveAccount) {
      await manager.save(Account, account);
    }
  }
}
