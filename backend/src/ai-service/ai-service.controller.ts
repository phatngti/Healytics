import { Body, Post } from '@nestjs/common';
import { ApiOperation, ApiOkResponse } from '@nestjs/swagger';
import { AiApi } from '@/common/decorators/api/ai-api.decorator';
import { AiServiceService } from './ai-service.service';
import { AiRecommendationsRequestDto } from './dto/ai-recommendations-request.dto';
import { AiRecommendationsResponseDto } from './dto/ai-recommendation-response.dto';

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
  @ApiOperation({ summary: 'Get service recommendations by IDs' })
  @ApiOkResponse({
    description: 'Returns enriched recommendation data for the requested services.',
    type: AiRecommendationsResponseDto,
  })
  getRecommendations(
    @Body() dto: AiRecommendationsRequestDto,
  ): Promise<AiRecommendationsResponseDto> {
    return this.aiServiceService.getRecommendations(dto.serviceIds);
  }
}
