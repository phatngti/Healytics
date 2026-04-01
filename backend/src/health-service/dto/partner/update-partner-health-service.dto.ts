import { PartialType } from '@nestjs/swagger';
import { CreatePartnerHealthServiceDto } from './create-partner-health-service.dto';

export class UpdatePartnerHealthServiceDto extends PartialType(
  CreatePartnerHealthServiceDto,
) {}
