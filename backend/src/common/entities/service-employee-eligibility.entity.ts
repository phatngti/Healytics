import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  PrimaryColumn,
} from 'typeorm';
import { Product } from './product.entity';
import { Employee } from './employee.entity';

@Entity('service_employee_eligibility')
export class ServiceEmployeeEligibility {
  @PrimaryColumn({ name: 'product_id', type: 'uuid' })
  productId: string;

  @PrimaryColumn({ name: 'employee_id', type: 'uuid' })
  employeeId: string;

  @Column({ name: 'is_primary', default: false })
  isPrimary: boolean;

  // Relations
  @ManyToOne(() => Product, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;

  @ManyToOne(() => Employee, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'employee_id' })
  employee: Employee;
}
