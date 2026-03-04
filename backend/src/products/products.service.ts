import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Not, Repository } from 'typeorm';
import { CreatePartnerProductDto } from './dto/partner/create-partner-product.dto';
import { UpdatePartnerProductDto } from './dto/partner/update-partner-product.dto';
import { Product } from '@/common/entities/product.entity';
import { CreateProductHandler } from './application/handlers/create-product.handler';
import { UpdateProductHandler } from './application/handlers/update-product.handler';
import { RemoveProductHandler } from './application/handlers/remove-product.handler';
import { PartnerProductDetailResponseDto } from './dto/partner/partner-product-detail-response.dto';
import { PublicProductInfoResponseDto } from './dto/public/public-product-info-response.dto';
import { PublicProductEmployeeResponseDto } from './dto/public/public-product-employee-response.dto';
import { PublicProductReviewResponseDto } from './dto/public/public-product-review-response.dto';
import { PublicProductRecommendedResponseDto } from './dto/public/public-product-recommended-response.dto';
import { PublicProductCardResponseDto } from './dto/public/public-product-card-response.dto';
import { PartnersService } from '@/partners/partners.service';
import { ProductStatus } from './enums/product-status.enum';


@Injectable()
export class ProductsService {
  private readonly logger = new Logger(ProductsService.name);

  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    private readonly createProductHandler: CreateProductHandler,
    private readonly updateProductHandler: UpdateProductHandler,
    private readonly removeProductHandler: RemoveProductHandler,
    private readonly partnersService: PartnersService,
  ) {}

  /**
   * Facade: Delegates to CreateProductHandler
   */
  async create(createProductDto: CreatePartnerProductDto): Promise<Product> {
    return this.createProductHandler.execute(createProductDto);
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
   * Returns an enriched product detail response by slug.
   * Loads all relations and queries recommended services from the same category.
   */
  async getProductDetails(slug: string): Promise<PartnerProductDetailResponseDto> {
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

    return PartnerProductDetailResponseDto.fromEntity(product, recommended);
  }

  // ─── User-facing Product Detail Endpoints ───────────────────

  /**
   * Returns product info (service info) for the user detail screen.
   * Loads the health_partner's profile to populate clinic info.
   */
  async getProductInfo(id: string): Promise<PublicProductInfoResponseDto> {
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

    return PublicProductInfoResponseDto.fromEntity(product, partner);
  }

  /**
   * Returns the list of eligible employees for a product/service.
   */
  async getProductEmployees(id: string): Promise<PublicProductEmployeeResponseDto[]> {
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

    return PublicProductEmployeeResponseDto.fromEntities(employees);
  }

  /**
   * Returns the list of reviews for a product.
   */
  async getProductReviews(id: string): Promise<PublicProductReviewResponseDto[]> {
    const product = await this.productRepository.findOne({
      where: { id },
      relations: ['reviews'],
    });

    if (!product) {
      this.logger.warn(`Product not found for reviews: ${id}`);
      throw new NotFoundException(`Product with ID ${id} not found`);
    }

    return PublicProductReviewResponseDto.fromEntities(product.reviews ?? []);
  }

  /**
   * Returns recommended products from the same category.
   */
  async getRecommendedProducts(id: string): Promise<PublicProductRecommendedResponseDto[]> {
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

    return PublicProductRecommendedResponseDto.fromEntities(recommended);
  }

  // ─── Public Listing Endpoints ───────────────────────────────

  /** Common relations needed for product card DTO mapping. */
  private readonly cardRelations = [
    'category',
    'media',
    'productDefinition',
    'productEmployeeEligibilities',
    'productEmployeeEligibilities.employee',
    'reviews',
  ];

  /**
   * Returns premium treatment products (active, visible, highest rated).
   */
  async getPremiumTreatments(): Promise<PublicProductCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: ProductStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const partner = await this.partnersService.getFirstHealthPartner();
    return PublicProductCardResponseDto.fromEntities(products, partner);
  }

  /**
   * Returns home-recommended products (active, visible, newest first).
   */
  async getHomeRecommend(): Promise<PublicProductCardResponseDto[]> {
    const products = await this.productRepository.find({
      where: {
        status: ProductStatus.ACTIVE,
        isVisibleOnline: true,
      },
      relations: this.cardRelations,
      take: 10,
      order: { createdAt: 'DESC' },
    });

    const partner = await this.partnersService.getFirstHealthPartner();
    return PublicProductCardResponseDto.fromEntities(products, partner);
  }

  /**
   * Facade: Delegates to UpdateProductHandler
   */
  async update(
    id: string,
    updateProductDto: UpdatePartnerProductDto,
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
