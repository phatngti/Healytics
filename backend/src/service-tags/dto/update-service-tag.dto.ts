import { PartialType } from '@nestjs/swagger';
import { CreateServiceTagDto } from './create-service-tag.dto';

/**
 * DTO for updating an existing service tag.
 * All fields are optional.
 */
export class UpdateServiceTagDto extends PartialType(CreateServiceTagDto) {}
