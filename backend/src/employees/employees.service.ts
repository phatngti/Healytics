import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { Employee } from './entities/employee.entity';
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
    private readonly createDoctorHandler: CreateDoctorHandler,
    private readonly createTherapistHandler: CreateTherapistHandler,
    private readonly updateEmployeeHandler: UpdateEmployeeHandler,
    private readonly removeEmployeeHandler: RemoveEmployeeHandler,
  ) {}

  /**
   * Facade: Delegates to CreateDoctorHandler.
   * @param createDoctorDto - The doctor data
   * @returns The created employee with doctor profile
   */
  async createDoctor(createDoctorDto: CreateDoctorDto): Promise<Employee> {
    return this.createDoctorHandler.execute(createDoctorDto);
  }

  /**
   * Facade: Delegates to CreateTherapistHandler.
   * @param createTherapistDto - The therapist data
   * @returns The created employee with therapist profile
   */
  async createTherapist(
    createTherapistDto: CreateTherapistDto,
  ): Promise<Employee> {
    return this.createTherapistHandler.execute(createTherapistDto);
  }

  /**
   * Retrieves all employees with optional role filter.
   * @param query - Query parameters
   * @returns Array of employees
   */
  async findAll(query?: GetEmployeesQueryDto): Promise<Employee[]> {
    const { role } = query || {};
    const where: FindOptionsWhere<Employee> = {};
    if (role) {
      where.role = role;
    }
    return this.employeeRepository.find({
      where,
      relations: ['doctorProfile', 'therapistProfile'],
    });
  }

  /**
   * Finds an employee by ID.
   * @param id - The employee ID
   * @returns The employee with relations
   * @throws NotFoundException if not found
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
   * Facade: Delegates to UpdateEmployeeHandler.
   * @param id - The employee ID
   * @param updateEmployeeDto - The update data
   * @returns The updated employee
   */
  async update(
    id: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    return this.updateEmployeeHandler.execute(id, updateEmployeeDto);
  }

  /**
   * Facade: Delegates to RemoveEmployeeHandler.
   * @param id - The employee ID
   */
  async remove(id: string): Promise<void> {
    return this.removeEmployeeHandler.execute(id);
  }
}
