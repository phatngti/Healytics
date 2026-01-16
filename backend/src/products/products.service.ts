import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { Product } from './entities/product.entity';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';

@Injectable()
export class ProductsService {
  private readonly logger = new Logger(ProductsService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly createProductHandler: CreateProductHandler,
    private readonly updateProductHandler: UpdateProductHandler,
    private readonly removeProductHandler: RemoveProductHandler,
  ) {}

  /**
   * Facade: Delegates to CreateProductHandler
   */
  async create(createProductDto: CreateProductDto): Promise<Product> {
    return this.createProductHandler.execute(createProductDto);
  }

  async findAll(): Promise<Product[]> {
    return this.productRepository.find({
      relations: [
        'category',
        'media',
        'serviceDefinition',
        'serviceEmployeeEligibilities',
        'serviceEmployeeEligibilities.employee',
      ],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'category',
        'media',
        'serviceDefinition',
        'serviceEmployeeEligibilities',
        'serviceEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return product;
  }

  async findBySlug(slug: string): Promise<Product> {
    const product = await this.productRepository.findOne({
      where: { slug },
      relations: [
        'category',
        'media',
        'serviceDefinition',
        'serviceEmployeeEligibilities',
        'serviceEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      this.logger.warn(`Product slug not found: ${slug}`);
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    return product;
  }

  /**
   * Facade: Delegates to UpdateProductHandler
   */
  async update(
    id: string,
    updateProductDto: UpdateProductDto,
  ): Promise<Product> {
    return this.updateProductHandler.execute(id, updateProductDto);
  }

  /**
   * Facade: Delegates to RemoveProductHandler
   */
  async remove(id: string): Promise<void> {
    return this.removeProductHandler.execute(id);
  }
}
