import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';
import { CreatePartnerHealthServiceDto } from './dto/partner/create-partner-health-service.dto';
import { UpdatePartnerHealthServiceDto } from './dto/partner/update-partner-health-service.dto';
import { Product } from '@/common/entities/product.entity';
import { CreateHealthServiceHandler } from './application/handlers/create-health-service.handler';
import { UpdateHealthServiceHandler } from './application/handlers/update-health-service.handler';
import { RemoveHealthServiceHandler } from './application/handlers/remove-health-service.handler';
import { PartnerHealthServiceDetailResponseDto } from './dto/partner/partner-health-service-detail-response.dto';
import { PublicHealthServiceInfoResponseDto } from './dto/public/public-health-service-info-response.dto';
import { PublicHealthServiceEmployeeResponseDto } from './dto/public/public-health-service-employee-response.dto';
import { PublicHealthServiceReviewResponseDto } from './dto/public/public-health-service-review-response.dto';
import { PublicHealthServiceRecommendedResponseDto } from './dto/public/public-health-service-recommended-response.dto';
import { PublicHealthServiceCardResponseDto } from './dto/public/public-health-service-card-response.dto';
import { PartnersService } from '@/partners/partners.service';
import { HealthServiceStatus } from './enums/health-service-status.enum';


@Injectable()
export class HealthServiceService {
  private readonly logger = new Logger(HealthServiceService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly createHealthServiceHandler: CreateHealthServiceHandler,
    private readonly updateHealthServiceHandler: UpdateHealthServiceHandler,
    private readonly removeHealthServiceHandler: RemoveHealthServiceHandler,
    private readonly partnersService: PartnersService,
  ) {}

  /**
   * Facade: Delegates to CreateHealthServiceHandler
   */
  async create(createDto: CreatePartnerHealthServiceDto): Promise<Product> {
    return this.createHealthServiceHandler.execute(createDto);
  }

  async findAll(): Promise<Product[]> {
    return this.productRepository.find({
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
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
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
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
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      this.logger.warn(`Product slug not found: ${slug}`);
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    return product;
  }

  /**
   * Returns an enriched detail response by slug.
   * Loads all relations and queries recommended services from the same category.
   */
  async getProductDetails(slug: string): Promise<PartnerHealthServiceDetailResponseDto> {
    const product = await this.productRepository.findOne({
      where: { slug },
      relations: [
        'category',
        'media',
        'productDefinition',
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
        'productEmployeeEligibilities.employee.doctorProfile',
        'productTags',
        'productTags.tag',
        'reviews',
        'facilityImages',
      ],
    });

    if (!product) {
      this.logger.warn(`Product slug not found for details: ${slug}`);
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    // Query recommended services (same category, exclude self, limit 3)
    let recommended: Product[] = [];
    if (product.categoryId) {
      recommended = await this.productRepository.find({
        where: {
          categoryId: product.categoryId,
          id: Not(product.id),
        },
        relations: ['media'],
        take: 3,
        order: { createdAt: 'DESC' },
      });
    }

    return PartnerHealthServiceDetailResponseDto.fromEntity(product, recommended);
  }

  // ─── User-facing Detail Endpoints ───────────────────

  /**
   * Returns info (service info) for the user detail screen.
   * Loads the health_partner's profile to populate clinic info.
   */
  async getProductInfo(id: string): Promise<PublicHealthServiceInfoResponseDto> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'category',
        'media',
        'productTags',
        'productTags.tag',
        'reviews',
        'facilityImages',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found for info: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    // Load health partner's profile for clinic info
    const partner = await this.partnersService.getFirstHealthPartner();

    return PublicHealthServiceInfoResponseDto.fromEntity(product, partner);
  }

  /**
   * Returns the list of eligible employees for a service.
   */
  async getProductEmployees(id: string): Promise<PublicHealthServiceEmployeeResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: [
        'productEmployeeEligibilities',
        'productEmployeeEligibilities.employee',
        'productEmployeeEligibilities.employee.doctorProfile',
        'productEmployeeEligibilities.employee.therapistProfile',
      ],
    });

    if (!product) {
      this.logger.warn(`Product not found for employees: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    const employees = (product.productEmployeeEligibilities ?? [])
      .map((elig) => elig.employee)
      .filter(Boolean);

    return PublicHealthServiceEmployeeResponseDto.fromEntities(employees);
  }

  /**
   * Returns the list of reviews.
   */
  async getProductReviews(id: string): Promise<PublicHealthServiceReviewResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: ['reviews'],
    });

    if (!product) {
      this.logger.warn(`Product not found for reviews: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return PublicHealthServiceReviewResponseDto.fromEntities(product.reviews ?? []);
  }

  /**
   * Returns recommended services from the same category.
   */
  async getRecommendedProducts(id: string): Promise<PublicHealthServiceRecommendedResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      select: ['id', 'categoryId'],
    });

    if (!product) {
      this.logger.warn(`Product not found for recommendations: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    if (!product.categoryId) {
      return [];
    }

    const recommended = await this.productRepository.find({
      where: {
        categoryId: product.categoryId,
        id: Not(product.id),
      },
      relations: ['media', 'reviews'],
      take: 5,
      order: { createdAt: 'DESC' },
    });

    return PublicHealthServiceRecommendedResponseDto.fromEntities(recommended);
  }

  // ─── Public Listing Endpoints ───────────────────────────────

  /** Common relations needed for card DTO mapping. */
  private readonly cardRelations = [
    'category',
    'media',
    'productDefinition',
    'productEmployeeEligibilities',
    'productEmployeeEligibilities.employee',
    'reviews',
  ];

  /**
   * Returns premium treatment services (active, visible, highest rated).
   */
  async getPremiumTreatments(): Promise<PublicHealthServiceCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const partner = await this.partnersService.getFirstHealthPartner();
    return PublicHealthServiceCardResponseDto.fromEntities(products, partner);
  }

  /**
   * Returns home-recommended services (active, visible, newest first).
   */
  async getHomeRecommend(): Promise<PublicHealthServiceCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: HealthServiceStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const partner = await this.partnersService.getFirstHealthPartner();
    return PublicHealthServiceCardResponseDto.fromEntities(products, partner);
  }

  /**
   * Facade: Delegates to UpdateHealthServiceHandler
   */
  async update(
    id: string,
    updateDto: UpdatePartnerHealthServiceDto,
  ): Promise<Product> {
    return this.updateHealthServiceHandler.execute(id, updateDto);
  }

  /**
   * Facade: Delegates to RemoveHealthServiceHandler
   */
  async remove(id: string): Promise<void> {
    return this.removeHealthServiceHandler.execute(id);
  }
}
