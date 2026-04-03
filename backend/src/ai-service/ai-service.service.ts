import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { PartnersService } from '@/partners/partners.service';
import { AiRecommendationsResponseDto } from './dto/ai-recommendation-response.dto';

/**
 * Service for AI-facing endpoints.
 * Queries health services by IDs and maps them to the AI recommendation response shape.
 */
@Injectable()
export class AiServiceService {
  private readonly logger = new Logger(AiServiceService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly partnersService: PartnersService,
  ) {}

  /**
   * Retrieve enriched recommendation data for the given service IDs.
   *
   * Loads products with all relations needed for the AI recommendation DTO
   * (media, employee eligibilities, reviews) and the partner for location data.
   */
  async getRecommendations(
    serviceIds: string[],
  ): Promise<AiRecommendationsResponseDto> {
    this.logger.log(
      `Fetching recommendations for ${serviceIds.length} service(s)`,
    );

    const products = await this.productRepository.find({
      where: { id: In(serviceIds) },
      relations: [
        'media',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
    });

    this.logger.log(
      `Found ${products.length} of ${serviceIds.length} requested services`,
    );

    // Load partner for location data
    const partner = await this.partnersService.getFirstHealthPartner();

    return AiRecommendationsResponseDto.create(products, partner);
  }
}
