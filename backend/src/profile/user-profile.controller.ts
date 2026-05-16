import { Get } from '@nestjs/common';
import { ApiOkResponse, ApiOperation } from '@nestjs/swagger';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { UserProfileSummaryResponseDto } from './dto/user-profile-summary-response.dto';
import { UserProfileSummaryService } from './user-profile-summary.service';

@UserApi('profile')
export class UserProfileController {
  constructor(
    private readonly profileSummaryService: UserProfileSummaryService,
  ) {}

  @Get('summary')
  @ApiOperation({
    operationId: 'userProfileControllerGetSummary',
    summary: 'Get current user profile summary counters',
  })
  @ApiOkResponse({ type: UserProfileSummaryResponseDto })
  getSummary(
    @CurrentUser('id') userId: string,
  ): Promise<UserProfileSummaryResponseDto> {
    return this.profileSummaryService.getSummary(userId);
  }
}
