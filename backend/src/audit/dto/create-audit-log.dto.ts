import { IsString, IsUUID, IsOptional, IsNotEmpty, IsObject } from 'class-validator';

export class CreateAuditLogDto {
    @IsUUID()
    @IsNotEmpty()
    actorId: string;

    @IsString()
    @IsNotEmpty()
    action: string;

    @IsString()
    @IsNotEmpty()
    targetEntity: string;

    @IsUUID()
    @IsNotEmpty()
    targetId: string;

    @IsObject()
    @IsOptional()
    metadata?: any;

    @IsString()
    @IsOptional()
    ipAddress?: string;

    @IsString()
    @IsOptional()
    userAgent?: string;
}
