import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { Product } from '@/common/entities/product.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
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
    @InjectRepository(TreatmentReview)
    private readonly treatmentReviewRepository: Repository<TreatmentReview>,
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
        'category',
        'media',
        'productDefinition',
        'partner',
        'partner.province',
        'partner.district',
        'partner.ward',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
    });

    this.logger.log(
      `Found ${products.length} of ${serviceIds.length} requested services`,
    );

    // Use each product's own partner for clinic data. Keep the legacy first
    // partner fallback only for orphaned/old product rows without partner loaded.
    const needsFallbackPartner = products.some((product) => !product.partner);
    const [fallbackPartner, ratingsMap] = await Promise.all([
      needsFallbackPartner
        ? this.partnersService.getFirstHealthPartner()
        : Promise.resolve(null),
      this.buildRatingsMap(products.map((product) => product.id)),
    ]);

    return AiRecommendationsResponseDto.create(
      products,
      fallbackPartner,
      ratingsMap,
    );
  }

  private async buildRatingsMap(
    productIds: string[],
  ): Promise<Map<string, { rating: number; count: number }>> {
    if (!productIds.length) return new Map();

    const rows = await this.treatmentReviewRepository
      .createQueryBuilder('tr')
      .innerJoin('tr.booking', 'b')
      .where('b.product_id IN (:...productIds)', { productIds })
      .select('b.product_id', 'productId')
      .addSelect('AVG(tr.rating)', 'avg')
      .addSelect('COUNT(tr.id)', 'count')
      .groupBy('b.product_id')
      .getRawMany<{ productId: string; avg: string; count: string }>();

    const map = new Map<string, { rating: number; count: number }>();
    for (const row of rows) {
      const count = parseInt(row.count, 10);
      const rating = count > 0 ? Math.round(parseFloat(row.avg) * 10) / 10 : 0;
      map.set(row.productId, { rating, count });
    }
    return map;
  }
}
