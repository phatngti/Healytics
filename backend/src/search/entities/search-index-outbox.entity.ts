import {
  Column,
  CreateDateColumn,
  Entity,
  Index,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

export enum SearchIndexEntityType {
  PRODUCT = 'product',
  EMPLOYEE = 'employee',
  CATEGORY = 'category',
}

export enum SearchIndexOperation {
  UPSERT = 'upsert',
  DELETE = 'delete',
}

export enum SearchIndexEnvironment {
  PRODUCTION = 'production',
  DEV = 'dev',
  UAT = 'uat',
}

export enum SearchIndexOutboxStatus {
  PENDING = 'pending',
  PROCESSING = 'processing',
  DONE = 'done',
  FAILED = 'failed',
}

@Entity('search_index_outbox')
@Index('IDX_SEARCH_INDEX_OUTBOX_ENV_STATUS_CREATED', [
  'targetEnvironment',
  'status',
  'createdAt',
])
@Index('IDX_SEARCH_INDEX_OUTBOX_ENTITY', ['entityType', 'entityId'])
export class SearchIndexOutbox {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'entity_type', type: 'varchar', length: 50 })
  entityType: SearchIndexEntityType;

  @Column({ name: 'entity_id', type: 'uuid' })
  entityId: string;

  @Column({ type: 'varchar', length: 20 })
  operation: SearchIndexOperation;

  @Column({
    name: 'target_environment',
    type: 'varchar',
    length: 20,
    default: SearchIndexEnvironment.PRODUCTION,
  })
  targetEnvironment: SearchIndexEnvironment;

  @Column({ type: 'jsonb', nullable: true })
  payload: Record<string, unknown> | null;

  @Column({
    type: 'varchar',
    length: 20,
    default: SearchIndexOutboxStatus.PENDING,
  })
  status: SearchIndexOutboxStatus;

  @Column({ name: 'attempt_count', type: 'int', default: 0 })
  attemptCount: number;

  @Column({ name: 'last_error', type: 'text', nullable: true })
  lastError: string | null;

  @Column({ name: 'processed_at', type: 'timestamptz', nullable: true })
  processedAt: Date | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}
