import {
    Controller,
    HttpCode,
    HttpStatus,
    Get,
    Put,
    Body,
    Query,
    Param,
    Req,
    UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { PartnersService } from './partners.service';
import { BusinessTypesResponseDto } from './dto/response/business-types-response.dto';
import { MyProfileResponseDto } from './dto/response/my-profile-response.dto';
import { PartnersResponseDto } from './dto/response/partners-response.dto';
import { PartnerDetailResponseDto } from './dto/response/partner-detail-response.dto';
import { UpdatePartnerDto } from './dto/request/update-partner.dto';
import { GetPartnersQueryDto } from './dto/request/get-partners-query.dto';
import { Public } from '@/auth/decorators/public.decorator';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { RolesGuard } from '@/auth/guards/roles.guard';

@ApiTags('partners')
@Controller('partners')
export class PartnersController {
    constructor(private readonly partnersService: PartnersService) { }

    @Get('business-types')
    @Public()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get all business types',
        description: 'Returns list of all business types with Vietnamese labels for dropdown selection',
    })
    @ApiResponse({
        status: 200,
        description: 'List of business types retrieved successfully',
        type: BusinessTypesResponseDto,
    })
    getBusinessTypes(): BusinessTypesResponseDto {
        return this.partnersService.getBusinessTypes();
    }

    // ============================================================================
    // Partner Self-Management Endpoints
    // ============================================================================

    @Get('me')
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

    @Get()
    @UseGuards(JwtAuthGuard)
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @ApiBearerAuth()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'List all partners',
        description: 'Admin gets list of all partners with pagination and filters',
    })
    @ApiResponse({
        status: 200,
        description: 'Partners list retrieved successfully',
        type: PartnersResponseDto,
    })
    async getPartners(
        @Query() query: GetPartnersQueryDto,
    ): Promise<PartnersResponseDto> {
        return this.partnersService.getPartners(query);
    }

    @Get(':id')
    @UseGuards(JwtAuthGuard)
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @ApiBearerAuth()
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get partner details',
        description: 'Admin views detailed information of a specific partner',
    })
    @ApiResponse({
        status: 200,
        description: 'Partner details retrieved successfully',
        type: PartnerDetailResponseDto,
    })
    @ApiResponse({
        status: 404,
        description: 'Partner not found',
    })
    async getPartnerDetail(
        @Param('id') id: string,
    ): Promise<PartnerDetailResponseDto> {
        return this.partnersService.getPartnerDetail(id);
    }

}
