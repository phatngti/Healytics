import {
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Product } from '@/common/entities/product.entity';

@Injectable()
export class RemoveProductHandler {
  private readonly logger = new Logger(RemoveProductHandler.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async execute(id: string): Promise<void> {
    this.logger.log(`Executing RemoveProductHandler for ID: ${id}`);
    
    // Soft Delete
    const result = await this.productRepository.softDelete(id);
    
    if (result.affected === 0) {
      this.logger.warn(`Product not found for deletion: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    this.logger.log(`Product soft-deleted: ${id}`);
  }
}
