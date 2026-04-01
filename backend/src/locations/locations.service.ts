import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TreeRepository } from 'typeorm';
import { Location } from '@/common/entities/location.entity';
import { LocationLevel } from '@/common/entities/location-level.enum';
import { LocationListResponseDto } from './dto/response/location-response.dto';

/**
 * Service for querying Vietnam administrative locations.
 * Read-only reference data — no mutation handlers needed.
 */
@Injectable()
export class LocationsService {
  private readonly logger = new Logger(LocationsService.name);

  constructor(
    @InjectRepository(Location)
    private readonly locationRepo: TreeRepository<Location>,
  ) {}

  /**
   * Get all provinces (root locations).
   * @returns Location list response DTO
   */
  async getAllProvinces(): Promise<LocationListResponseDto> {
    this.logger.log('Fetching all provinces');
    const provinces = await this.locationRepo.findRoots();
    return LocationListResponseDto.create(provinces);
  }

  /**
   * Get districts by province ID (children of a province).
   * @param provinceId - The province UUID
   * @returns Location list response DTO
   * @throws NotFoundException if province not found
   */
  async getDistrictsByProvinceId(
    provinceId: string,
  ): Promise<LocationListResponseDto> {
    const province = await this.locationRepo.findOne({
      where: { id: provinceId, level: LocationLevel.PROVINCE },
    });

    if (!province) {
      this.logger.warn(`Province not found: ${provinceId}`);
      throw new NotFoundException(`Province with ID ${provinceId} not found`);
    }

    const districts = await this.locationRepo.find({
      where: {
        parent: { id: provinceId },
        level: LocationLevel.DISTRICT,
      },
      order: { name: 'ASC' },
    });

    return LocationListResponseDto.create(districts);
  }

  /**
   * Get wards by district ID (children of a district).
   * @param districtId - The district UUID
   * @returns Location list response DTO
   * @throws NotFoundException if district not found
   */
  async getWardsByDistrictId(
    districtId: string,
  ): Promise<LocationListResponseDto> {
    const district = await this.locationRepo.findOne({
      where: { id: districtId, level: LocationLevel.DISTRICT },
    });

    if (!district) {
      this.logger.warn(`District not found: ${districtId}`);
      throw new NotFoundException(`District with ID ${districtId} not found`);
    }

    const wards = await this.locationRepo.find({
      where: {
        parent: { id: districtId },
        level: LocationLevel.WARD,
      },
      order: { name: 'ASC' },
    });

    return LocationListResponseDto.create(wards);
  }

  /**
   * Validate that province, district, and ward IDs are valid and related.
   * @param provinceId - Province UUID
   * @param districtId - District UUID
   * @param wardId - Ward UUID
   * @returns true if valid
   * @throws NotFoundException if any part of the hierarchy is invalid
   */
  async validateAddress(
    provinceId: string,
    districtId: string,
    wardId: string,
  ): Promise<boolean> {
    // Find ward with its ancestors
    const ward = await this.locationRepo.findOne({
      where: { id: wardId, level: LocationLevel.WARD },
      relations: ['parent', 'parent.parent'],
    });

    if (!ward) {
      this.logger.warn(`Ward not found: ${wardId}`);
      throw new NotFoundException(`Ward with ID ${wardId} not found`);
    }

    if (!ward.parent || ward.parent.id !== districtId) {
      throw new NotFoundException(
        `Ward ${wardId} does not belong to district ${districtId}`,
      );
    }

    if (!ward.parent.parent || ward.parent.parent.id !== provinceId) {
      throw new NotFoundException(
        `District ${districtId} does not belong to province ${provinceId}`,
      );
    }

    return true;
  }
}
