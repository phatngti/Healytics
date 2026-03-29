import {
  Entity,
  Column,
  ManyToOne,
  JoinColumn,
  PrimaryGeneratedColumn,
  Index,
} from 'typeorm';
import { Product } from './product.entity';
import { Employee } from './employee.entity';

@Entity('product_employee_eligibility')
@Index('UQ_PRODUCT_EMPLOYEE_ELIGIBILITY', ['productId', 'employeeId'], { unique: true })
export class ProductEmployeeEligibility {
  /**
   * Surrogate primary key — enables direct lookup by eligibility ID
   * (e.g., GET /user/health-services/eligibilities/:id).
   */
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index()
  @Column({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Index()
  @Column({ name: 'employee_id', type: 'uuid' })
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
