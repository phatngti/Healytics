import {
    Controller,
    Get,
    Post,
    Put,
    Body,
    Param,
    UseGuards,
    Req,
    HttpCode,
    HttpStatus,
    UseInterceptors,
    UploadedFile,
    BadRequestException,
} from '@nestjs/common';
import {
    ApiTags,
    ApiOperation,
    ApiResponse,
    ApiBearerAuth,
    ApiParam,
    ApiBody,
    ApiConsumes,
} from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { DocumentsService } from './documents.service';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { SubmitDocumentDto } from './dto/request/submit-document.dto';
import { ReviewDocumentDto } from './dto/request/review-document.dto';
import { GetUploadUrlRequestDto } from './dto/request/get-upload-url-request.dto';
import { GetDocumentStatusResponseDto } from './dto/response/get-document-status-response.dto';
import { GetUploadUrlResponseDto } from './dto/response/get-upload-url-response.dto';
import { GetDocumentUrlResponseDto } from './dto/response/get-document-url-response.dto';
import { SubmitDocumentResponseDto } from './dto/response/submit-document-response.dto';
import { ReviewDocumentResponseDto } from './dto/response/review-document-response.dto';
import { GetPartnerDocumentsResponseDto } from './dto/response/get-partner-documents-response.dto';
import { Roles } from '@/auth/decorators/roles.decorator';
import { Role } from '@/account/enum/role.enum';
import { RolesGuard } from '@/auth/guards/roles.guard';

/**
 * Documents Controller
 * Handles document upload and verification workflow for partners
 */
@ApiTags('Partner Documents')
@Controller('partners')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class DocumentsController {
    constructor(private readonly documentsService: DocumentsService) { }

    /**
     * Get document status for logged-in partner
     * Shows which documents are required, submitted, approved, or rejected
     */
    @Get('me/documents')
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get partner document status',
        description:
            'Returns required documents with submission status and admin feedback',
    })
    @ApiResponse({
        status: 200,
        description: 'Document status retrieved successfully',
        type: GetDocumentStatusResponseDto,
    })
    async getMyDocuments(@Req() req): Promise<GetDocumentStatusResponseDto> {
        return this.documentsService.getPartnerDocumentStatus(req.user.id);
    }

    /**
     * Get presigned URL for document upload
     */
    @Post('me/documents/upload-url')
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get presigned upload URL',
        description: 'Returns R2 presigned URL for direct upload',
    })
    @ApiBody({ type: GetUploadUrlRequestDto })
    @ApiResponse({
        status: 200,
        description: 'Presigned URL generated',
        type: GetUploadUrlResponseDto,
    })
    async getUploadUrl(
        @Req() req,
        @Body() dto: GetUploadUrlRequestDto,
    ): Promise<GetUploadUrlResponseDto> {
        return this.documentsService.getUploadUrl(
            req.user.id,
            dto.fileName,
            dto.contentType,
        );
    }

    /**
     * Get signed URL to view a document
     */
    @Get('me/documents/:id/url')
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get document URL',
        description: 'Returns signed URL to view/download a document',
    })
    @ApiParam({ name: 'id', description: 'Document ID' })
    @ApiResponse({
        status: 200,
        description: 'Signed URL generated',
        type: GetDocumentUrlResponseDto,
    })
    @ApiResponse({
        status: 404,
        description: 'Document not found',
    })
    async getDocumentUrl(
        @Req() req,
        @Param('id') id: string,
    ): Promise<GetDocumentUrlResponseDto> {
        return this.documentsService.getDocumentUrl(id, req.user.id);
    }

    /**
     * Submit or update a document
     * UPSERT logic: creates new or updates existing document
     */
    @Post('me/documents')
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @HttpCode(HttpStatus.CREATED)
    @ApiOperation({
        summary: 'Submit/Update a document',
        description:
            'Submit new document or re-submit after rejection. Resets status to PENDING.',
    })
    @ApiBody({ type: SubmitDocumentDto })
    @ApiResponse({
        status: 201,
        description: 'Document submitted successfully',
        type: SubmitDocumentResponseDto,
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid document type or URL',
    })
    async submitDocument(
        @Req() req,
        @Body() dto: SubmitDocumentDto,
    ): Promise<SubmitDocumentResponseDto> {
        return this.documentsService.submitDocument(req.user.id, dto);
    }

    /**
     * Upload document file directly (for Swagger testing)
     */
    @Post('me/documents/upload')
    @UseGuards(RolesGuard)
    @Roles(Role.HEALTH_PARTNER)
    @UseInterceptors(FileInterceptor('file'))
    @HttpCode(HttpStatus.CREATED)
    @ApiConsumes('multipart/form-data')
    @ApiOperation({
        summary: 'Upload document file directly (Swagger UI)',
        description:
            'Upload a document file directly. The file will be uploaded to S3 and a document record created.',
    })
    @ApiBody({
        description: 'Document file upload',
        schema: {
            type: 'object',
            required: ['file', 'documentType'],
            properties: {
                file: {
                    type: 'string',
                    format: 'binary',
                    description: 'Document file (image or PDF)',
                },
                documentType: {
                    type: 'string',
                    enum: ['BUSINESS_LICENSE', 'TAX_CODE', 'IDENTITY_CARD_FRONT', 'IDENTITY_CARD_BACK', 'AUTHORIZATION_LETTER'],
                    description: 'Type of document',
                    example: 'BUSINESS_LICENSE',
                },
            },
        },
    })
    @ApiResponse({
        status: 201,
        description: 'File uploaded and document created successfully',
        type: SubmitDocumentResponseDto,
    })
    @ApiResponse({
        status: 400,
        description: 'Invalid file or document type',
    })
    async uploadDocument(
        @Req() req,
        @UploadedFile() file: Express.Multer.File,
        @Body('documentType') documentType: string,
    ): Promise<SubmitDocumentResponseDto> {
        if (!file) {
            throw new BadRequestException('File is required');
        }

        if (!documentType) {
            throw new BadRequestException('documentType is required');
        }

        // Validate file type
        const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
            throw new BadRequestException(
                'Invalid file type. Only JPEG, PNG, and PDF files are allowed.',
            );
        }

        // Validate file size (e.g., 5MB limit)
        const maxSize = 5 * 1024 * 1024; // 5MB
        if (file.size > maxSize) {
            throw new BadRequestException(
                'File size exceeds 5MB limit',
            );
        }

        // Get partner to construct the file path
        const partner = await this.documentsService['partnersService'].getPartnerByAccountId(req.user.id);
        if (!partner) {
            throw new BadRequestException('Partner not found');
        }

        // Generate unique file key
        const fileKey = `documents/${partner.id}/${Date.now()}-${file.originalname}`;

        // Upload file directly to S3 using the new uploadFile method
        await this.documentsService['s3Service'].uploadFile(
            fileKey,
            file.buffer,
            file.mimetype,
        );

        // Submit document record with the uploaded file key
        return this.documentsService.submitDocument(req.user.id, {
            documentType: documentType as any,
            documentUrl: fileKey,
        });
    }


    /**
     * Review a partner document (Admin only)
     */
    @Put('documents/:id/review')
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Review partner document (Admin)',
        description:
            'Approve or reject document. Feedback required when rejecting. Auto-activates partner when all documents approved.',
    })
    @ApiParam({ name: 'id', description: 'Document ID' })
    @ApiBody({ type: ReviewDocumentDto })
    @ApiResponse({
        status: 200,
        description: 'Document reviewed successfully',
        type: ReviewDocumentResponseDto,
    })
    @ApiResponse({
        status: 400,
        description: 'Feedback required when rejecting',
    })
    @ApiResponse({
        status: 404,
        description: 'Document not found',
    })
    async reviewDocument(
        @Param('id') id: string,
        @Body() dto: ReviewDocumentDto,
        @Req() req,
    ): Promise<ReviewDocumentResponseDto> {
        return this.documentsService.reviewDocument(id, dto, req.user.id);
    }

    /**
     * Get partner document status with MISSING indicators (Admin only)
     */
    @Get(':accountId/document-status')
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get partner document status (Admin)',
        description: 'Shows all required documents with status including MISSING for documents not yet uploaded',
    })
    @ApiParam({ name: 'accountId', description: 'Account ID' })
    @ApiResponse({
        status: 200,
        description: 'Document status retrieved successfully',
        type: GetDocumentStatusResponseDto,
    })
    async getPartnerDocumentStatusAdmin(
        @Param('accountId') accountId: string,
    ): Promise<GetDocumentStatusResponseDto> {
        // Reuses the exact same logic partner uses
        return this.documentsService.getPartnerDocumentStatus(accountId);
    }

    /**
     * Get all documents for a specific partner (Admin only)
     */
    @Get(':accountId/documents')
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get partner documents (Admin)',
        description: 'View all submitted documents for a partner',
    })
    @ApiParam({ name: 'accountId', description: 'Account ID' })
    @ApiResponse({
        status: 200,
        description: 'Documents retrieved successfully',
        type: GetPartnerDocumentsResponseDto,
    })
    async getPartnerDocuments(
        @Param('accountId') accountId: string,
    ): Promise<GetPartnerDocumentsResponseDto> {
        const documents = await this.documentsService.getPartnerDocuments(accountId);
        return { documents };
    }

    /**
     * Get signed URL to view a document (Admin only)
     */
    @Get('documents/:id/url')
    @UseGuards(RolesGuard)
    @Roles(Role.ADMIN)
    @HttpCode(HttpStatus.OK)
    @ApiOperation({
        summary: 'Get document URL (Admin)',
        description: 'Returns signed URL to view/download any document',
    })
    @ApiParam({ name: 'id', description: 'Document ID' })
    @ApiResponse({
        status: 200,
        description: 'Signed URL generated',
        type: GetDocumentUrlResponseDto,
    })
    @ApiResponse({
        status: 404,
        description: 'Document not found',
    })
    async getDocumentUrlAdmin(@Param('id') id: string): Promise<GetDocumentUrlResponseDto> {
        return this.documentsService.getDocumentUrl(id);
    }
}
