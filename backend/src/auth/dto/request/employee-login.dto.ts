import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

/**
 * Login DTO for employee authentication.
 * Used by the employee_app for dedicated employee login.
 */
export class EmployeeLoginDto {
  @ApiProperty({ type: String, example: 'employee@clinic.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ type: String, example: 'password123' })
  @IsString()
  @IsNotEmpty()
  password: string;
}
