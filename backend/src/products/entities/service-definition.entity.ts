import {
  Entity,
  Column,
  OneToOne,
  JoinColumn,
  PrimaryColumn,
} from 'typeorm';
import { AvailabilityMode } from '@/products/enums/availability-mode.enum';
import { StaffAssignmentType } from '@/products/enums/staff-assignment-type.enum';
import { Product } from './product.entity';

@Entity('service_definitions')
export class ServiceDefinition {
  @PrimaryColumn({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Column({ name: 'duration_minutes', type: 'int' })
  durationMinutes: number;

  @Column({ name: 'buffer_minutes', type: 'int', default: 0 })
  bufferMinutes: number;

  @Column({ name: 'max_capacity', type: 'int', default: 1 })
  maxCapacity: number;

  @Column({ name: 'min_lead_time_hours', type: 'int', default: 0 })
  minLeadTimeHours: number;

  @Column({ name: 'availability_mode', length: 50, default: AvailabilityMode.BUSINESS_HOURS })
  availabilityMode: AvailabilityMode;

  @Column({ name: 'staff_assignment_type', length: 20, default: StaffAssignmentType.ANY })
  staffAssignmentType: StaffAssignmentType;

  // Relations
  @OneToOne(() => Product, (product) => product.serviceDefinition, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;
}
