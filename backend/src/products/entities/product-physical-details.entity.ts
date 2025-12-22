import {
  Entity,
  Column,
  OneToOne,
  JoinColumn,
  PrimaryColumn,
} from 'typeorm';
import { Product } from './product.entity';

@Entity('product_physical_details')
export class ProductPhysicalDetails {
  @PrimaryColumn({ name: 'product_id', type: 'uuid' })
  productId: string;

  @Column({ type: 'varchar', length: 50, unique: true, nullable: true })
  sku: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  barcode: string | null;

  @Column({ name: 'stock_quantity', type: 'int', default: 0 })
  stockQuantity: number;

  @Column({ name: 'cost_per_item', type: 'decimal', precision: 15, scale: 2, default: 0 })
  costPerItem: number;

  @Column({ name: 'weight_gram', type: 'int', nullable: true })
  weightGram: number | null;

  @Column({ type: 'varchar', length: 50, nullable: true })
  dimensions: string | null;

  // Relations
  @OneToOne(() => Product, (product) => product.physicalDetails, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'product_id' })
  product: Product;
}
