import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { Product } from './entities/product.entity';
import { ProductMedia } from './entities/product-media.entity';
import { ProductPhysicalDetails } from './entities/product-physical-details.entity';
import { ServiceDefinition } from './entities/service-definition.entity';
import { ServiceEmployeeEligibility } from './entities/service-employee-eligibility.entity';
import { ProductType } from './enums/product-type.enum';

@Injectable()
export class ProductsService {
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
    @InjectRepository(ProductMedia)
    private readonly mediaRepository: Repository<ProductMedia>,
    @InjectRepository(ProductPhysicalDetails)
    private readonly physicalDetailsRepository: Repository<ProductPhysicalDetails>,
    @InjectRepository(ServiceDefinition)
    private readonly serviceDefinitionRepository: Repository<ServiceDefinition>,
    @InjectRepository(ServiceEmployeeEligibility)
    private readonly serviceEmployeeEligibilityRepository: Repository<ServiceEmployeeEligibility>,
  ) {}

  async create(createProductDto: CreateProductDto): Promise<Product> {
    const { media, physicalDetails, serviceDefinition, employeeIds, ...productData } = createProductDto;

    // 1. Create Product
    const cleanedProductData = Object.fromEntries(
      Object.entries(productData).filter(([_, v]) => v != null),
    );
    const product = this.productRepository.create({
      ...cleanedProductData,
      currency: 'VND',
    });
    const savedProduct = await this.productRepository.save(product);

    // 2. Create Media if provided
    if (media && media.length > 0) {
      const mediaEntities = media.map((m) =>
        this.mediaRepository.create({
          ...m,
          productId: savedProduct.id,
        }),
      );
      await this.mediaRepository.save(mediaEntities);
    }

    // 3. Create Physical Details if type is physical
    if (product.type === ProductType.PHYSICAL && physicalDetails) {
      const details = this.physicalDetailsRepository.create({
        ...physicalDetails,
        productId: savedProduct.id,
      });
      await this.physicalDetailsRepository.save(details);
    }

    // 4. Create Service Definition if type is service
    if (product.type === ProductType.SERVICE && serviceDefinition) {
      const definition = this.serviceDefinitionRepository.create({
        ...serviceDefinition,
        productId: savedProduct.id,
      });
      await this.serviceDefinitionRepository.save(definition);
    }

    // 5. Assign Employees if provided
    if (employeeIds && employeeIds.length > 0) {
      const qualifications = employeeIds.map((employeeId) =>
        this.serviceEmployeeEligibilityRepository.create({
          productId: savedProduct.id,
          employeeId,
          isPrimary: false,
        }),
      );
      await this.serviceEmployeeEligibilityRepository.save(qualifications);
    }

    return this.findOne(savedProduct.id);
  }

  findAll(): Promise<Product[]> {
    return this.productRepository.find({
      relations: [
        'category',
        'media',
        'physicalDetails',
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
        'physicalDetails',
        'serviceDefinition',
        'serviceEmployeeEligibilities',
        'serviceEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
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
        'physicalDetails',
        'serviceDefinition',
        'serviceEmployeeEligibilities',
        'serviceEmployeeEligibilities.employee',
      ],
    });

    if (!product) {
      throw new NotFoundException(`Product with slug "${slug}" not found`);
    }

    return product;
  }

  async update(id: string, updateProductDto: UpdateProductDto): Promise<Product> {
    const product = await this.findOne(id);
    const { media, physicalDetails, serviceDefinition, ...productData } = updateProductDto;

    // Update Product
    Object.assign(product, productData);
    await this.productRepository.save(product);

    // Update Physical Details
    if (physicalDetails && product.type === ProductType.PHYSICAL) {
      let details = await this.physicalDetailsRepository.findOne({
        where: { productId: id },
      });
      if (details) {
        Object.assign(details, physicalDetails);
      } else {
        details = this.physicalDetailsRepository.create({
          ...physicalDetails,
          productId: id,
        });
      }
      await this.physicalDetailsRepository.save(details);
    }

    // Update Service Definition
    if (serviceDefinition && product.type === ProductType.SERVICE) {
      let definition = await this.serviceDefinitionRepository.findOne({
        where: { productId: id },
      });
      if (definition) {
        Object.assign(definition, serviceDefinition);
      } else {
        definition = this.serviceDefinitionRepository.create({
          ...serviceDefinition,
          productId: id,
        });
      }
      await this.serviceDefinitionRepository.save(definition);
    }

    // Update Media (replace all)
    if (media !== undefined) {
      // Remove existing media
      await this.mediaRepository.delete({ productId: id });
      // Add new media
      if (media.length > 0) {
        const mediaEntities = media.map((m) =>
          this.mediaRepository.create({
            ...m,
            productId: id,
          }),
        );
        await this.mediaRepository.save(mediaEntities);
      }
    }

    return this.findOne(id);
  }

  async remove(id: string): Promise<void> {
    const result = await this.productRepository.delete(id);
    if (result.affected === 0) {
      throw new NotFoundException(`Product with ID ${id} not found`);
    }
  }
}
