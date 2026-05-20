import {
  Injectable,
  Logger,
  NotFoundException,
  Optional,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { SearchIndexOperation } from '@/search/entities/search-index-outbox.entity';
import { SearchIndexOutboxService } from '@/search/services/search-index-outbox.service';

@Injectable()
export class RemoveHealthServiceHandler {
  private readonly logger = new Logger(RemoveHealthServiceHandler.name);

  constructor(
    private readonly dataSource: DataSource,
    @Optional()
    private readonly searchIndexOutboxService?: SearchIndexOutboxService,
  ) {}

  async execute(id: string): Promise<void> {
    this.logger.log(`Executing RemoveHealthServiceHandler for ID: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      const exists = await queryRunner.manager.findOne(Product, {
        where: { id },
        select: ['id'],
      });

      if (!exists) {
        this.logger.warn(`Product not found for deletion: ${id}`);
        throw new NotFoundException(`Product with ID ${id} not found`);
      }

      const eligibilities = await queryRunner.manager.find(
        ProductEmployeeEligibility,
        { where: { productId: id }, select: ['employeeId'] },
      );
      const employeeIds = eligibilities.map(
        (eligibility) => eligibility.employeeId,
      );

      await queryRunner.manager.softDelete(Product, id);
      await this.searchIndexOutboxService?.enqueueProduct(
        queryRunner.manager,
        id,
        SearchIndexOperation.DELETE,
        { employeeIds },
      );
      await this.searchIndexOutboxService?.enqueueEmployees(
        queryRunner.manager,
        employeeIds,
      );

      await queryRunner.commitTransaction();
      this.logger.log(`Product soft-deleted: ${id}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      if (error instanceof NotFoundException) throw error;
      throw error;
    } finally {
      await queryRunner.release();
    }
  }
}
