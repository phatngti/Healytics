---
description: Create a new NestJS module following enterprise architecture
---

# New Module Workflow

Use this workflow when creating a new domain module with full enterprise architecture.

---

## 1. Create Module Structure

Create the following directory structure in `src/<module-name>/`:

```
src/<module-name>/
├── application/
│   └── handlers/           # Domain handlers for mutations
├── dto/
│   ├── create-<entity>.dto.ts
│   ├── update-<entity>.dto.ts
│   └── <entity>-response.dto.ts
├── entities/
│   └── <entity>.entity.ts
├── <module-name>.controller.ts
├── <module-name>.service.ts    # Service facade
└── <module-name>.module.ts
```

---

## 2. Create the Entity

```typescript
// src/<module-name>/entities/<entity>.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, DeleteDateColumn, Index } from 'typeorm';

@Entity('<table_name>')
export class YourEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'name', type: 'varchar', length: 255 })
  name: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @DeleteDateColumn({ name: 'deleted_at', type: 'timestamptz' })
  deletedAt: Date;
}
```

---

## 3. Create DTOs

Follow class-validator patterns:

```typescript
// dto/create-<entity>.dto.ts
import { IsString, IsNotEmpty, MaxLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateEntityDto {
  @ApiProperty({ description: 'Name of the entity' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name: string;
}
```

```typescript
// dto/<entity>-response.dto.ts
import { Expose } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export class EntityResponseDto {
  @ApiProperty()
  @Expose()
  id: string;

  @ApiProperty()
  @Expose()
  name: string;

  @ApiProperty()
  @Expose()
  createdAt: Date;
}
```

---

## 4. Create Handlers

// turbo
```bash
mkdir -p src/<module-name>/application/handlers
```

Create handlers for each mutation:

```typescript
// application/handlers/create-<entity>.handler.ts
import { Injectable, Logger } from '@nestjs/common';
import { DataSource, QueryRunner } from 'typeorm';

@Injectable()
export class CreateEntityHandler {
  private readonly logger = new Logger(CreateEntityHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(dto: CreateEntityDto): Promise<EntityResponseDto> {
    const queryRunner: QueryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      this.logger.log('Creating entity...');
      const entity = queryRunner.manager.create(YourEntity, dto);
      const saved = await queryRunner.manager.save(entity);
      await queryRunner.commitTransaction();
      this.logger.log(`Entity created with id: ${saved.id}`);
      return saved;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error('Failed to create entity', error);
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
```

---

## 5. Create Service Facade

```typescript
// <module-name>.service.ts
@Injectable()
export class ModuleService {
  constructor(
    @InjectRepository(YourEntity)
    private readonly repo: Repository<YourEntity>,
    private readonly createHandler: CreateEntityHandler,
  ) {}

  create(dto: CreateEntityDto) { return this.createHandler.execute(dto); }
  
  findAll(): Promise<YourEntity[]> {
    return this.repo.find({ where: { deletedAt: IsNull() } });
  }
}
```

---

## 6. Create Controller

```typescript
// <module-name>.controller.ts
@ApiTags('<module-name>')
@ApiBearerAuth()
@Controller({ path: '<module-name>', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@UseInterceptors(ClassSerializerInterceptor)
export class ModuleController {
  constructor(private readonly service: ModuleService) {}

  @Post()
  @Roles('admin')
  @ApiOperation({ summary: 'Create new entity' })
  @ApiCreatedResponse({ type: EntityResponseDto })
  create(@Body() dto: CreateEntityDto): Promise<EntityResponseDto> {
    return this.service.create(dto);
  }
}
```

---

## 7. Register Module

```typescript
// <module-name>.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([YourEntity])],
  controllers: [ModuleController],
  providers: [ModuleService, CreateEntityHandler],
  exports: [ModuleService],
})
export class ModuleNameModule {}
```

---

## 8. Add to AppModule

```typescript
// app.module.ts
@Module({
  imports: [
    // ... existing imports
    ModuleNameModule,
  ],
})
export class AppModule {}
```

---

## 9. Create Migration

// turbo
```bash
npm run migration:generate --name=Create<EntityName>Table
```

---

## 10. Run Migration

// turbo
```bash
npm run migration:run
```

---

## 11. Verify

// turbo
```bash
npm run build
npm run test
```
