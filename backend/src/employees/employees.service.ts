import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateEmployeeDto } from './dto/create-employee.dto';
import { CreateDoctorDto } from './dto/create-doctor.dto';
import { CreateTherapistDto } from './dto/create-therapist.dto';
import { UpdateEmployeeDto } from './dto/update-employee.dto';
import { GetEmployeesQueryDto } from './dto/get-employees-query.dto';
import { Employee } from './entities/employee.entity';
import { DoctorProfile } from './entities/doctor-profile.entity';
import { TherapistProfile } from './entities/therapist-profile.entity';
import { EmployeeRole } from './enum/employee-role.enum';

@Injectable()
export class EmployeesService {
  constructor(
    @InjectRepository(Employee)
    private readonly employeeRepository: Repository<Employee>,
    @InjectRepository(DoctorProfile)
    private readonly doctorProfileRepository: Repository<DoctorProfile>,
    @InjectRepository(TherapistProfile)
    private readonly therapistProfileRepository: Repository<TherapistProfile>,
  ) {}

  async create(createEmployeeDto: CreateEmployeeDto): Promise<Employee> {
    const { doctorProfile, therapistProfile, ...employeeData } =
      createEmployeeDto;

    // 1. Create Employee
    const employee = this.employeeRepository.create(employeeData);
    const savedEmployee = await this.employeeRepository.save(employee);

    // 2. Create Profile based on Role
    if (employee.role === EmployeeRole.DOCTOR && doctorProfile) {
      const doctor = this.doctorProfileRepository.create({
        ...doctorProfile,
        employeeId: savedEmployee.id,
      });
      await this.doctorProfileRepository.save(doctor);
    } else if (employee.role === EmployeeRole.THERAPIST && therapistProfile) {
      const therapist = this.therapistProfileRepository.create({
        ...therapistProfile,
        employeeId: savedEmployee.id,
      });
      await this.therapistProfileRepository.save(therapist);
    }

    return this.findOne(savedEmployee.id);
  }

  async createDoctor(createDoctorDto: CreateDoctorDto): Promise<Employee> {
    const { profile, ...employeeData } = createDoctorDto;

    // 1. Create Employee with DOCTOR role
    const employee = this.employeeRepository.create({
      ...employeeData,
      role: EmployeeRole.DOCTOR,
    });
    const savedEmployee = await this.employeeRepository.save(employee);

    // 2. Create Doctor Profile
    const doctorProfile = this.doctorProfileRepository.create({
      ...profile,
      employeeId: savedEmployee.id,
    });
    await this.doctorProfileRepository.save(doctorProfile);

    return this.findOne(savedEmployee.id);
  }

  async createTherapist(createTherapistDto: CreateTherapistDto): Promise<Employee> {
    const { profile, ...employeeData } = createTherapistDto;

    // 1. Create Employee with THERAPIST role
    const employee = this.employeeRepository.create({
      ...employeeData,
      role: EmployeeRole.THERAPIST,
    });
    const savedEmployee = await this.employeeRepository.save(employee);

    // 2. Create Therapist Profile
    const therapistProfile = this.therapistProfileRepository.create({
      ...profile,
      employeeId: savedEmployee.id,
    });
    await this.therapistProfileRepository.save(therapistProfile);

    return this.findOne(savedEmployee.id);
  }

  findAll(query?: GetEmployeesQueryDto): Promise<Employee[]> {
    const { role } = query || {};
    const where: any = {};

    if (role) {
      where.role = role;
    }

    return this.employeeRepository.find({
      where,
      relations: ['doctorProfile', 'therapistProfile'],
    });
  }

  async findOne(id: string): Promise<Employee> {
    const employee = await this.employeeRepository.findOne({
      where: { id },
      relations: ['doctorProfile', 'therapistProfile'],
    });

    if (!employee) {
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }

    return employee;
  }

  async update(
    id: string,
    updateEmployeeDto: UpdateEmployeeDto,
  ): Promise<Employee> {
    const employee = await this.findOne(id);
    const { doctorProfile, therapistProfile, ...employeeData } =
      updateEmployeeDto;

    // Update Employee
    Object.assign(employee, employeeData);
    await this.employeeRepository.save(employee);

    // Update Doctor Profile
    if (doctorProfile && employee.role === EmployeeRole.DOCTOR) {
      let profile = await this.doctorProfileRepository.findOne({
        where: { employeeId: id },
      });
      if (profile) {
        Object.assign(profile, doctorProfile);
      } else {
        profile = this.doctorProfileRepository.create({
          ...doctorProfile,
          employeeId: id,
        });
      }
      await this.doctorProfileRepository.save(profile);
    }

    // Update Therapist Profile
    if (therapistProfile && employee.role === EmployeeRole.THERAPIST) {
      let profile = await this.therapistProfileRepository.findOne({
        where: { employeeId: id },
      });
      if (profile) {
        Object.assign(profile, therapistProfile);
      } else {
        profile = this.therapistProfileRepository.create({
          ...therapistProfile,
          employeeId: id,
        });
      }
      await this.therapistProfileRepository.save(profile);
    }

    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.employeeRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Employee with ID ${id} not found`);
    }
  }
}
