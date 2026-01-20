import {
    Controller,
    Get,
    Put,
    Body,
    Param,
    UseGuards,
    HttpCode,
    HttpStatus,
    Query,
    Req,
    UseInterceptors
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiParam } from '@nestjs/swagger';
import { AdminPartnersService } from '../services/admin-partners.service';
import { GetPartnersQueryDto } from '@/partners/dto/request/get-partners-query.dto';
import { DocumentsService } from '@/partners/documents.service';
import { AuditInterceptor } from '@/audit/interceptors/audit.interceptor';
import { AdminPartnerDetailResponseDto } from '../dto/admin-partner-detail-response.dto';
import { ReviewPartnerProfileDto } from '../dto/review-partner-profile.dto';
import { ReviewPartnerResponseDto } from '../dto/review-partner-response.dto';
import { ReviewDocumentDto } from '@/partners/dto/request/review-document.dto';
import { DocumentStatusResponseDto } from '@/partners/dto/response/document-status-response.dto';
import { DocumentUrlResponseDto } from '@/partners/dto/response/document-url-response.dto';
import { ReviewDocumentResponseDto } from '@/partners/dto/response/review-document-response.dto';
import { PartnerDocumentsResponseDto } from '@/partners/dto/response/partner-documents-response.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/auth/decorators/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { Audit } from '@/audit/decorators/audit.decorator';

@ApiTags('Admin Partners')
@Controller('admin/partners')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.ADMIN)
@ApiBearerAuth()
@UseInterceptors(AuditInterceptor)
export class AdminPartnersController {
    constructor(
        private readonly adminPartnersService: AdminPartnersService,
        private readonly documentsService: DocumentsService,
    ) { }

    @Get()
    @ApiOperation({ summary: 'List all partners' })
    async getPartners(@Query() query: GetPartnersQueryDto) {
        return this.adminPartnersService.getPartners(query);
    }

    @Get(':id')
    @ApiOperation({ summary: 'Get partner details including documents' })
    @ApiParam({ name: 'id', description: 'Partner ID' })
    @ApiResponse({ status: 200, type: AdminPartnerDetailResponseDto })
    async getPartnerDetail(@Param('id') id: string): Promise<AdminPartnerDetailResponseDto> {
        return this.adminPartnersService.getPartnerDetail(id);
    }

    @Put(':id/review')
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Review partner profile' })
    @ApiParam({ name: 'id', description: 'Partner ID' })
    @ApiResponse({ status: 200, type: ReviewPartnerResponseDto })
    @Audit('PARTNER_REVIEW', 'Partner')
    async reviewPartner(
        @Param('id') id: string,
        @Body() dto: ReviewPartnerProfileDto,
        @Req() req
    ): Promise<ReviewPartnerResponseDto> {
        await this.adminPartnersService.reviewPartner(id, dto, req.user.id);
        return { message: 'Review submitted successfully' };
    }

    // ============== DOCUMENT ADMIN ENDPOINTS ==============

    @Get(':partnerId/documents')
    @ApiOperation({ summary: 'Get document status for a partner' })
    @ApiParam({ name: 'partnerId', description: 'Partner ID' })
    @ApiResponse({ status: 200, type: DocumentStatusResponseDto })
    async getPartnerDocumentStatus(
        @Param('partnerId') partnerId: string
    ): Promise<DocumentStatusResponseDto> {
        return this.documentsService.getPartnerDocumentStatusByPartnerId(partnerId);
    }

    @Get(':partnerId/documents/:documentId/url')
    @ApiOperation({ summary: 'Get signed URL to view a document' })
    @ApiParam({ name: 'partnerId', description: 'Partner ID' })
    @ApiParam({ name: 'documentId', description: 'Document ID' })
    @ApiResponse({ status: 200, type: DocumentUrlResponseDto })
    async getDocumentUrl(
        @Param('documentId') documentId: string
    ): Promise<DocumentUrlResponseDto> {
        // Admin doesn't need ownership check
        return this.documentsService.getDocumentUrl(documentId);
    }

    @Put(':partnerId/documents/:documentId/review')
    @HttpCode(HttpStatus.OK)
    @ApiOperation({ summary: 'Review a partner document' })
    @ApiParam({ name: 'partnerId', description: 'Partner ID' })
    @ApiParam({ name: 'documentId', description: 'Document ID' })
    @ApiResponse({ status: 200, type: ReviewDocumentResponseDto })
    @Audit('DOCUMENT_REVIEW', 'PartnerDocument')
    async reviewDocument(
        @Param('documentId') documentId: string,
        @Body() dto: ReviewDocumentDto,
        @Req() req
    ): Promise<ReviewDocumentResponseDto> {
        return this.documentsService.reviewDocument(documentId, dto, req.user.id);
    }
}
