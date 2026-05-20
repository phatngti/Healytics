import { Body, Post } from '@nestjs/common';
import { ApiExcludeEndpoint } from '@nestjs/swagger';
import { AiApi } from '@/common/decorators/api/ai-api.decorator';
import { AiServiceService } from './ai-service.service';
import { AiRecommendationsRequestDto } from './dto/ai-recommendations-request.dto';
import { AiRecommendationsResponseDto } from './dto/ai-recommendation-response.dto';
import { LogResponse } from '@/common/interceptors/response.interceptor';

/**
 * Controller for AI service endpoints.
 * Authenticated via X-AI-API-Key header (M2M token).
 *
 * POST /v1/ai/recommendations — retrieve enriched service data by IDs.
 */
@AiApi('recommendations')
export class AiServiceController {
  constructor(private readonly aiServiceService: AiServiceService) {}

  @Post()
    @LogResponse()
  @ApiExcludeEndpoint()
  getRecommendations(
    @Body() dto: AiRecommendationsRequestDto,
  ): Promise<AiRecommendationsResponseDto> {
    return this.aiServiceService.getRecommendations(dto.serviceIds);
  }
}
