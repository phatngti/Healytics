import { Injectable, Logger, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateSpaTherapistDto, CreateMassageTherapistDto } from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { Employee } from '@/common/entities/employee.entity';
import { Partner } from '@/common/entities/partner.entity';
import { CreateDoctorHandler } from './application/handlers/create-doctor.handler';
import { CreateTherapistHandler } from './application/handlers/create-therapist.handler';
import { UpdateEmployeeHandler } from './application/handlers/update-employee.handler';
import { RemoveEmployeeHandler } from './application/handlers/remove-employee.handler';

/**
 * Service facade for managing employees (doctors, therapists, staff).
 * Delegates mutation operations to dedicated handlers.
 */
@Injectable()
export class EmployeesService {
  private readonly logger = new Logger(EmployeesService.name);

  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(Partner)
    private readonly partnerRepository: Repository<Partner>,
    private readonly createDoctorHandler: CreateDoctorHandler,
    private readonly createTherapistHandler: CreateTherapistHandler,
    private readonly updateEmployeeHandler: UpdateEmployeeHandler,
    private readonly removeEmployeeHandler: RemoveEmployeeHandler,
  ) {}

  // ──────────────────────────────────────────────────────────────
  // Partner resolution
  // ──────────────────────────────────────────────────────────────

  /**
   * Resolves the partner ID from the authenticated account ID.
   * @throws NotFoundException if no partner profile exists for the account
   */
  async getPartnerIdByAccountId(accountId: string): Promise<string> {
    const partner = await this.partnerRepository.findOne({
      where: { accountId },
      select: ['id'],
    });
    if (!partner) {
      this.logger.warn(`Partner not found for account: ${accountId}`);
      throw new NotFoundException(
        `Partner profile not found for account ${accountId}`,
      );
    }
    return partner.id;
  }

  // ──────────────────────────────────────────────────────────────
  // Create operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Facade: Delegates to CreateDoctorHandler.
   */
  async createDoctor(
    createDoctorDto: CreateDoctorDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId
      ? { ...createDoctorDto, partnerId }
      : createDoctorDto;
    return this.createDoctorHandler.execute(dtoWithPartner as CreateDoctorDto);
  }

  /**
   * Facade: Delegates to CreateTherapistHandler for SPA type.
   */
  async createSpaTherapist(
    dto: CreateSpaTherapistDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId ? { ...dto, partnerId } : dto;
    return this.createTherapistHandler.execute(
      dtoWithPartner as CreateSpaTherapistDto,
      'SPA',
    );
  }

  /**
   * Facade: Delegates to CreateTherapistHandler for MASSAGE type.
   */
  async createMassageTherapist(
    dto: CreateMassageTherapistDto,
    partnerId?: string,
  ): Promise<Employee> {
    const dtoWithPartner = partnerId ? { ...dto, partnerId } : dto;
    return this.createTherapistHandler.execute(
      dtoWithPartner as CreateMassageTherapistDto,
      'MASSAGE',
    );
  }

  // ──────────────────────────────────────────────────────────────
  // Read operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Retrieves all employees with optional role filter.
   */
  async findAll(
    query?: GetEmployeesQueryDto,
    partnerId?: string,
  ): Promise<Employee[]> {
    const { role } = query || {};
    const where: FindOptionsWhere<Employee> = {};
    if (role) {
      where.role = role;
    }
    if (partnerId) {
      where.partnerId = partnerId;
    }
    return this.employeeRepository.find({
      where,
      relations: ['doctorProfile', 'therapistProfile'],
    });
  }

  /**
   * Finds an employee by ID.
   */
  async findOne(id: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id },
      relations: ['doctorProfile', 'therapistProfile'],
    });
    if (!employee) {
      this.logger.warn(`Employee not found: ${id}`);
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return employee;
  }

  /**
   * Finds an employee by ID scoped to a specific partner.
   */
  async findOneForPartner(id: string, partnerId: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id, partnerId },
      relations: ['doctorProfile', 'therapistProfile'],
    });
    if (!employee) {
      this.logger.warn(
        `Employee ${id} not found for partner ${partnerId}`,
      );
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
    return employee;
  }

  // ──────────────────────────────────────────────────────────────
  // Mutation operations
  // ──────────────────────────────────────────────────────────────

  /**
   * Facade: Delegates to UpdateEmployeeHandler.
   */
  async update(
    id: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    return this.updateEmployeeHandler.execute(id, updateEmployeeDto);
  }

  /**
   * Updates an employee scoped to a specific partner.
   * Verifies ownership before delegating to the handler.
   */
  async updateForPartner(
    id: string,
    partnerId: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    await this.findOneForPartner(id, partnerId);
    return this.updateEmployeeHandler.execute(id, updateEmployeeDto);
  }

  /**
   * Facade: Delegates to RemoveEmployeeHandler.
   */
  async remove(id: string): Promise<void> {
    return this.removeEmployeeHandler.execute(id);
  }

  /**
   * Removes an employee scoped to a specific partner.
   * Verifies ownership before delegating to the handler.
   */
  async removeForPartner(id: string, partnerId: string): Promise<void> {
    await this.findOneForPartner(id, partnerId);
    return this.removeEmployeeHandler.execute(id);
  }
}
