import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Product } from './product.entity';
import { ResourceType } from './resource-type.entity';

@Entity('service_resource_requirements')
export class ServiceResourceRequirement {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Column({ name: 'resource_type_id', type: 'uuid' })
  resourceTypeId: string;

  @Column({ name: 'quantity_required', type: 'int', default: 1 })
  quantityRequired: number;

  // Relations
  @ManyToOne(() => Product, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;

  @ManyToOne(() => ResourceType, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'resource_type_id' })
  resourceType: ResourceType;
}
