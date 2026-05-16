import {
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
} from '@nestjs/common';
import {
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
} from '@nestjs/swagger';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { UserApi } from '@/common/decorators/api/user-api.decorator';
import { WishlistItemResponseDto } from './dto/wishlist-item-response.dto';
import { WishlistService } from './wishlist.service';

@UserApi('wishlist')
export class UserWishlistController {
  constructor(private readonly wishlistService: WishlistService) {}

  @Get()
  @ApiOperation({ summary: 'List current user wishlist items' })
  @ApiOkResponse({ type: [WishlistItemResponseDto] })
  listWishlist(
    @CurrentUser('id') userId: string,
  ): Promise<WishlistItemResponseDto[]> {
    return this.wishlistService.list(userId);
  }

  @Post(':productId')
  @ApiOperation({
    operationId: 'userWishlistControllerAddItem',
    summary: 'Add a product to the current user wishlist',
  })
  @ApiCreatedResponse({ type: WishlistItemResponseDto })
  addWishlistItem(
    @CurrentUser('id') userId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
  ): Promise<WishlistItemResponseDto> {
    return this.wishlistService.add(userId, productId);
  }

  @Delete(':productId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    operationId: 'userWishlistControllerRemoveItem',
    summary: 'Remove a product from the current user wishlist',
  })
  @ApiNoContentResponse()
  removeWishlistItem(
    @CurrentUser('id') userId: string,
    @Param('productId', ParseUUIDPipe) productId: string,
  ): Promise<void> {
    return this.wishlistService.remove(userId, productId);
  }
}
