import {
    Controller,
    HttpCode,
    HttpStatus,
    Get,
    Put,
    Body,
    Req,
    UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { PartnersService } from './partners.service';
import { MyProfileResponseDto } from './dto/response/my-profile-response.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { Public } from '@/common/decorators/auth/public.decorator';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { LogResponse } from '@/common/interceptors/response.interceptor';
import { BusinessServicesResponseDto } from './dto/response/business-types-response.dto';

@ApiTags('partners')
@Controller('partners')
export class PartnersController {
    constructor(private readonly partnersService: PartnersService) { }

    @Get('business-services')
    @Public()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get all business services',
        description: 'Returns list of all business services with Vietnamese labels for dropdown selection',
    })
    @ApiResponse({
        status: 200,
        description: 'List of business services retrieved successfully',
        type: BusinessServicesResponseDto,
    })
    getBusinessServices(): BusinessServicesResponseDto {
        return this.partnersService.getBusinessServices();
    }

    // ============================================================================
    // Partner Self-Management Endpoints
    // ============================================================================

    @Get('me')
    @LogResponse()
    @UseGuards(JwtAuthGuard)
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @ApiBearerAuth()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get own business profile',
        description: 'Partner gets their own business entity information',
    })
    @ApiResponse({
        status: 200,
        description: 'Profile retrieved successfully',
        type: MyProfileResponseDto,
    })
    async getMyProfile(@Req() req): Promise<MyProfileResponseDto> {
        return this.partnersService.getMyProfile(req.user.id);
    }

    @Put('me')
    @LogResponse()
    @UseGuards(JwtAuthGuard)
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @ApiBearerAuth()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Update own business profile',
        description: 'Partner updates their business information (limited fields)',
    })
    @ApiResponse({
        status: 200,
        description: 'Profile updated successfully',
        type: MyProfileResponseDto,
    })
    async updateMyProfile(
        @Req() req,
        @Body() dto: UpdatePartnerDto,
    ): Promise<MyProfileResponseDto> {
        return this.partnersService.updateMyProfile(req.user.id, dto);
    }

    // ============================================================================
    // Admin Management Endpoints
    // ============================================================================



}
