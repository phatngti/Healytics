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
import { DocumentType } from './enum/document-type.enum';
import { DocumentStatusResponseDto } from './dto/response/document-status-response.dto';
import { UploadUrlResponseDto } from './dto/response/upload-url-response.dto';
import { DocumentUrlResponseDto } from './dto/response/document-url-response.dto';
import { SubmitDocumentResponseDto } from './dto/response/submit-document-response.dto';
import { ReviewDocumentResponseDto } from './dto/response/review-document-response.dto';
import { PartnerDocumentsResponseDto } from './dto/response/partner-documents-response.dto';
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
        type: DocumentStatusResponseDto,
    })
    async getMyDocuments(@Req() req): Promise<DocumentStatusResponseDto> {
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
        type: UploadUrlResponseDto,
    })
    async getUploadUrl(
        @Req() req,
        @Body() dto: GetUploadUrlRequestDto,
    ): Promise<UploadUrlResponseDto> {
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
        type: DocumentUrlResponseDto,
    })
    @ApiResponse({
        status: 404,
        description: 'Document not found',
    })
    async getDocumentUrl(
        @Req() req,
        @Param('id') id: string,
    ): Promise<DocumentUrlResponseDto> {
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
            'Upload a document file directly. The file will be uploaded to R2 and a document record created. Document type must match the requirements for your business type.',
    })
    @ApiBody({
        description: 'Document file upload with type specification',
        schema: {
            type: 'object',
            required: ['file', 'documentType'],
            properties: {
                file: {
                    type: 'string',
                    format: 'binary',
                    description: 'Document file (JPEG, PNG, or PDF)',
                },
                documentType: {
                    type: 'string',
                    description: 'Type of document being uploaded. Must match one of the required document types for your business.',
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
        description: 'Invalid file, file type, or document type',
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

        // Validate document type against enum
        if (!Object.values(DocumentType).includes(documentType as DocumentType)) {
            throw new BadRequestException(
                `Invalid document type. Must be one of: ${Object.values(DocumentType).join(', ')}`,
            );
        }

        // Validate file type
        const allowedMimeTypes = ['image/jpeg', 'image/png', 'image/jpg', 'application/pdf'];
        if (!allowedMimeTypes.includes(file.mimetype)) {
            throw new BadRequestException(
                'Invalid file type. Only JPEG, PNG, and PDF files are allowed.',
            );
        }

        // Validate file size (5MB limit)
        const maxSize = 5 * 1024 * 1024;
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
        const fileExtension = file.originalname.split('.').pop();
        const fileKey = `documents/${partner.id}/${documentType}/${Date.now()}.${fileExtension}`;

        // Upload file to R2/S3
        await this.documentsService['s3Service'].uploadFile(
            fileKey,
            file.buffer,
            file.mimetype,
        );

        // Submit document record with the uploaded file
        const document = await this.documentsService.submitDocument(req.user.id, {
            documentType: documentType as DocumentType,
            documentUrl: fileKey, // Store the key as URL initially
        });

        // Update the document to set the documentKey (since it's an uploaded file)
        document.documentKey = fileKey;
        await this.documentsService['documentRepo'].save(document);

        return document;
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
        type: DocumentStatusResponseDto,
    })
    async getPartnerDocumentStatusAdmin(
        @Param('accountId') accountId: string,
    ): Promise<DocumentStatusResponseDto> {
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
        type: PartnerDocumentsResponseDto,
    })
    async getPartnerDocuments(
        @Param('accountId') accountId: string,
    ): Promise<PartnerDocumentsResponseDto> {
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
        type: DocumentUrlResponseDto,
    })
    @ApiResponse({
        status: 404,
        description: 'Document not found',
    })
    async getDocumentUrlAdmin(@Param('id') id: string): Promise<DocumentUrlResponseDto> {
        return this.documentsService.getDocumentUrl(id);
    }
}
