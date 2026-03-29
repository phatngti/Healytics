import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { RecommendedServiceResponseDto } from '../../dto/recommended-service-response.dto';

@Injectable()
export class ListRecommendedServicesHandler {
  private readonly logger = new Logger(ListRecommendedServicesHandler.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  async execute(): Promise<RecommendedServiceResponseDto[]> {
    this.logger.log('Listing recommended services');

    const products = await this.productRepository.find({
      where: {
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: ['media', 'productDefinition'],
      take: 10,
      order: { createdAt: 'DESC' },
    });

    this.logger.log(`Found ${products.length} recommended services`);
    return RecommendedServiceResponseDto.fromEntities(products);
  }
}
