import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ProductType } from '@/products/enums/product-type.enum';
import { Category } from './category.entity';
import { ProductMedia } from './product-media.entity';
import { ProductStatus } from '@/products/enums/product-status.enum';
import { ServiceDefinition } from './service-definition.entity';
import { ServiceEmployeeEligibility } from './service-employee-eligibility.entity';
import { ProductTag } from './product-tag.entity';
import { ProductReview } from './product-review.entity';
import { ProductFacilityImage } from './product-facility-image.entity';

@Entity('products')
@Index('IDX_PRODUCT_MERCHANT_SLUG', ['slug'])
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id: string;



  @Column({ name: 'category_id', type: 'uuid', nullable: true })
  categoryId: string | null;

  @Column({ length: 255 })
  name: string;

  @Column({ length: 255 })
  slug: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ length: 50 })
  type: ProductType;

  // Pricing
  @Column({ name: 'base_price', type: 'decimal', precision: 15, scale: 2, default: 0 })
  basePrice: number;

  @Column({ name: 'sale_price', type: 'decimal', precision: 15, scale: 2, nullable: true })
  salePrice: number | null;

  @Column({ length: 3, default: 'VND' })
  currency: string;

  // Status & Visibility
  @Column({ length: 20, default: ProductStatus.DRAFT })
  status: ProductStatus;

  @Column({ name: 'is_visible_online', default: false })
  isVisibleOnline: boolean;

  @Column({ type: 'varchar', name: 'vendor_name', length: 100, nullable: true })
  vendorName: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date | null;

  // Relations
  @ManyToOne(() => Category, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'category_id' })
  category: Category | null;

  @OneToMany(() => ProductMedia, (media) => media.product, { cascade: true })
  media: ProductMedia[];



  @OneToOne(() => ServiceDefinition, (definition) => definition.product, {
    cascade: true,
    eager: false,
  })
  serviceDefinition: ServiceDefinition | null;

  @OneToMany(
    () => ServiceEmployeeEligibility,
    (eligibility) => eligibility.product,
    { cascade: true },
  )
  serviceEmployeeEligibilities: ServiceEmployeeEligibility[];

  @OneToMany(() => ProductTag, (pt) => pt.product)
  productTags: ProductTag[];

  @OneToMany(() => ProductReview, (review) => review.product, { cascade: true })
  reviews: ProductReview[];

  @OneToMany(() => ProductFacilityImage, (fi) => fi.product, { cascade: true })
  facilityImages: ProductFacilityImage[];
}

