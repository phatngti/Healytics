import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { TreeRepository } from 'typeorm';
import { Location } from './entities/location.entity';
import { LocationLevel } from './entities/location-level.enum';

@Injectable()
export class LocationsService {
  constructor(
    @InjectRepository(Location)
    private readonly locationRepo: TreeRepository<Location>,
  ) { }

  /**
   * Get all provinces (root locations)
   */
  async getAllProvinces() {
    const provinces = await this.locationRepo.findRoots();
    return {
      data: provinces,
      total: provinces.length,
    };
  }

  /**
   * Get districts by province ID (children of a province)
   */
  async getDistrictsByProvinceId(provinceId: string) {
    const province = await this.locationRepo.findOne({
      where: { id: provinceId, level: LocationLevel.PROVINCE },
    });

    if (!province) {
      throw new NotFoundException(`Province with ID ${provinceId} not found`);
    }

    const districts = await this.locationRepo.find({
      where: {
        parent: { id: provinceId },
        level: LocationLevel.DISTRICT,
      },
      order: { name: 'ASC' },
    });

    return {
      data: districts,
      total: districts.length,
    };
  }

  /**
   * Get wards by district ID (children of a district)
   */
  async getWardsByDistrictId(districtId: string) {
    const district = await this.locationRepo.findOne({
      where: { id: districtId, level: LocationLevel.DISTRICT },
    });

    if (!district) {
      throw new NotFoundException(`District with ID ${districtId} not found`);
    }

    const wards = await this.locationRepo.find({
      where: {
        parent: { id: districtId },
        level: LocationLevel.WARD,
      },
      order: { name: 'ASC' },
    });

    return {
      data: wards,
      total: wards.length,
    };
  }

  /**
   * Validate that province, district, and ward IDs are valid and related
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
