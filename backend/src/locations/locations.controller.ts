import {
    Controller,
    Post,
    Get,
    Param,
    HttpCode,
    HttpStatus,
    ParseUUIDPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { LocationsService } from './locations.service';
import { GetProvincesResponseDto } from './dto/response/get-provinces-response.dto';
import { GetDistrictsResponseDto } from './dto/response/get-districts-response.dto';
import { GetWardsResponseDto } from './dto/response/get-wards-response.dto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { DataSource } from 'typeorm';
import { seedLocations } from './seeds/location.seed';

@ApiTags('locations')
@Controller('locations')
@Public()
export class LocationsController {
    constructor(
        private readonly locationsService: LocationsService,
        private readonly dataSource: DataSource,
    ) { }

    @Get('provinces')
    @ApiOperation({ summary: 'Get all provinces in Vietnam' })
    @ApiResponse({
        status: 200,
        description: 'List of all provinces',
        type: GetProvincesResponseDto,
    })
    async getProvinces(): Promise<GetProvincesResponseDto> {
        return this.locationsService.getAllProvinces();
    }

    @Get('provinces/:provinceId/districts')
    @ApiOperation({ summary: 'Get all districts in a province' })
    @ApiParam({ name: 'provinceId', type: 'string', example: 'uuid' })
    @ApiResponse({
        status: 200,
        description: 'List of districts in the province',
        type: GetDistrictsResponseDto,
    })
    @ApiResponse({ status: 404, description: 'Province not found' })
    async getDistricts(
        @Param('provinceId', ParseUUIDPipe) provinceId: string,
    ): Promise<GetDistrictsResponseDto> {
        return this.locationsService.getDistrictsByProvinceId(provinceId);
    }

    @Get('districts/:districtId/wards')
    @ApiOperation({ summary: 'Get all wards in a district' })
    @ApiParam({ name: 'districtId', type: 'string', example: 'uuid' })
    @ApiResponse({
        status: 200,
        description: 'List of wards in the district',
        type: GetWardsResponseDto,
    })
    @ApiResponse({ status: 404, description: 'District not found' })
    async getWards(
        @Param('districtId', ParseUUIDPipe) districtId: string,
    ): Promise<GetWardsResponseDto> {
        return this.locationsService.getWardsByDistrictId(districtId);
    }

    @Post('seed')
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Seed Vietnam administrative divisions data' })
    @ApiResponse({
        status: 200,
        description: 'Seeding completed successfully',
    })
    async seedData() {
        try {
            await seedLocations(this.dataSource);
            return {
                message: 'Seeding completed successfully',
                status: 'success',
            };
        } catch (error) {
            throw new Error(`Seeding failed: ${error.message}`);
        }
    }
}
