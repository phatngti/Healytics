import {
  Body,
  ClassSerializerInterceptor,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { CartService } from '@/cart/cart.service';
import { CurrentUser } from '@/common/decorators/auth/current-user.decorator';
import { AddToCartDto } from '@/cart/dto/add-to-cart.dto';
import { CartItemResponseDto } from '@/cart/dto/cart-item-response.dto';
import { ApplyCouponDto } from '@/cart/dto/apply-coupon.dto';
import { JwtAuthGuard } from '@/auth/guards/jwt-auth.guard';
import { RolesGuard } from '@/auth/guards/roles.guard';
import { Roles } from '@/common/decorators/auth/roles.decorator';
import { Role } from '@/account/enum/role.enum';

@ApiTags('Cart')
@ApiBearerAuth()
@Controller({ path: 'cart', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(Role.USER)
@UseInterceptors(ClassSerializerInterceptor)
export class CartController {
  constructor(private readonly cartService: CartService) {}

  @Get()
  @ApiOperation({ summary: 'Get all cart items for current user' })
  @ApiOkResponse({ type: [CartItemResponseDto] })
  async getItems(@CurrentUser('id') userId: string): Promise<CartItemResponseDto[]> {
    return this.cartService.getCartItems(userId);
  }

  @Post()
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Add service to cart' })
  @ApiCreatedResponse({ type: CartItemResponseDto })
  @ApiBadRequestResponse({ description: 'Invalid service or inactive service.' })
  @ApiConflictResponse({ description: 'Service already exists in cart.' })
  async addItem(
    @CurrentUser('id') userId: string,
    @Body() dto: AddToCartDto,
  ): Promise<CartItemResponseDto> {
    return this.cartService.addItem(userId, dto);
  }

  @Delete(':cartItemId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Remove an item from cart' })
  @ApiNoContentResponse({ description: 'Item removed from cart.' })
  @ApiNotFoundResponse({ description: 'Cart item not found.' })
  async removeItem(
    @CurrentUser('id') userId: string,
    @Param('cartItemId', ParseUUIDPipe) cartItemId: string,
  ): Promise<void> {
    return this.cartService.removeItem(userId, cartItemId);
  }

  @Post(':cartItemId/coupon')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Apply coupon to cart item' })
  @ApiOkResponse({ type: CartItemResponseDto })
  @ApiBadRequestResponse({ description: 'Invalid or expired coupon.' })
  @ApiNotFoundResponse({ description: 'Cart item not found.' })
  async applyCoupon(
    @CurrentUser('id') userId: string,
    @Param('cartItemId', ParseUUIDPipe) cartItemId: string,
    @Body() dto: ApplyCouponDto,
  ): Promise<CartItemResponseDto> {
    return this.cartService.applyCoupon(userId, cartItemId, dto);
  }

  @Delete(':cartItemId/coupon')
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Remove coupon from cart item' })
  @ApiOkResponse({ type: CartItemResponseDto })
  @ApiNotFoundResponse({ description: 'Cart item not found.' })
  async removeCoupon(
    @CurrentUser('id') userId: string,
    @Param('cartItemId', ParseUUIDPipe) cartItemId: string,
  ): Promise<CartItemResponseDto> {
    return this.cartService.removeCoupon(userId, cartItemId);
  }

  @Delete()
  @HttpCode(HttpStatus.NO_CONTENT)
  @Throttle({ default: { limit: 30, ttl: 60000 } })
  @ApiOperation({ summary: 'Clear all cart items' })
  @ApiNoContentResponse({ description: 'Cart cleared successfully.' })
  async clearCart(@CurrentUser('id') userId: string): Promise<void> {
    return this.cartService.clearCart(userId);
  }
}
