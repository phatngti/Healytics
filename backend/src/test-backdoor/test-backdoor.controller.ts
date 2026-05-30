import { Body, Controller, Get, Post } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Public } from '@/common/decorators/auth/public.decorator';
import { TestBackdoorService } from './test-backdoor.service';
import {
  BackdoorPrepareDto,
  BackdoorStatusResponseDto,
  CleanupSeedDataDto,
  CleanupSeedDataResponseDto,
  ResetDbResponseDto,
  SeedBookingDto,
  SeedCartItemDto,
  SeedCategoryDto,
  SeedCouponDto,
  SeedEmployeeDto,
  SeedPartnerDto,
  SeedPayloadDto,
  SeedResponseDto,
  SeedServiceDto,
  SeedUserDto,
} from './dto';

@Controller('test-backdoor')
@ApiTags('Test Backdoor')
@Public()
export class TestBackdoorController {
  constructor(private readonly service: TestBackdoorService) {}

  @Get('status')
  @ApiOperation({ summary: 'Check if backdoor is available' })
  @ApiOkResponse({ type: BackdoorStatusResponseDto })
  status() {
    return this.service.status();
  }

  @Post('reset-db')
  @ApiOperation({ summary: 'Truncate all non-master tables' })
  @ApiOkResponse({ type: ResetDbResponseDto })
  resetDb() {
    return this.service.resetDb();
  }

  @Post('prepare')
  @ApiOperation({ summary: 'Reset DB then seed a scenario' })
  @ApiOkResponse({ type: SeedResponseDto })
  prepare(@Body() body: BackdoorPrepareDto) {
    return this.service.prepare(body);
  }

  @Post('cleanup')
  @ApiOperation({ summary: 'Delete only rows returned by a seed response' })
  @ApiOkResponse({ type: CleanupSeedDataResponseDto })
  cleanup(@Body() body: CleanupSeedDataDto) {
    return this.service.cleanupSeedData(body.ids);
  }

  @Post('seed')
  @ApiOperation({ summary: 'Seed multiple entity types at once' })
  @ApiOkResponse({ type: SeedResponseDto })
  seed(@Body() body: SeedPayloadDto) {
    return this.service.seedPayload(body);
  }

  @Post('seed-user')
  @ApiOperation({ summary: 'Seed a single user' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedUser(@Body() body: SeedUserDto) {
    return this.service.seedUser(body);
  }

  @Post('seed-category')
  @ApiOperation({ summary: 'Seed a single category' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedCategory(@Body() body: SeedCategoryDto) {
    return this.service.seedCategory(body);
  }

  @Post('seed-partner')
  @ApiOperation({ summary: 'Seed a single partner' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedPartner(@Body() body: SeedPartnerDto) {
    return this.service.seedPartner(body);
  }

  @Post('seed-employee')
  @ApiOperation({ summary: 'Seed a single employee' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedEmployee(@Body() body: SeedEmployeeDto) {
    return this.service.seedEmployee(body);
  }

  @Post('seed-service')
  @ApiOperation({ summary: 'Seed a single health service' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedService(@Body() body: SeedServiceDto) {
    return this.service.seedService(body);
  }

  @Post('seed-cart')
  @ApiOperation({ summary: 'Seed a single cart item' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedCart(@Body() body: SeedCartItemDto) {
    return this.service.seedCartItem(body);
  }

  @Post('seed-coupon')
  @ApiOperation({ summary: 'Seed a single coupon' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedCoupon(@Body() body: SeedCouponDto) {
    return this.service.seedCoupon(body);
  }

  @Post('seed-booking')
  @ApiOperation({ summary: 'Seed a single booking' })
  @ApiOkResponse({ type: SeedResponseDto })
  seedBooking(@Body() body: SeedBookingDto) {
    return this.service.seedBooking(body);
  }
}
