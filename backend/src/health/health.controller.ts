import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiTags } from '@nestjs/swagger';
import { Public } from '@/common/decorators/auth/public.decorator';

@ApiTags('Health')
@Controller('health')
@Public()
export class HealthController {
  @Get()
  @ApiOkResponse({ description: 'Backend liveness check.' })
  check() {
    return {
      status: 'ok',
      service: 'healytics-backend',
      timestamp: new Date().toISOString(),
    };
  }
}
