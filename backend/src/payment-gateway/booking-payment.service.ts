import {
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Product } from '@/common/entities/product.entity';
import { BookingStatus } from '@/booking/enums/booking-status.enum';

/**
 * Booking-focused service for payment gateway.
 *
 * Luồng tạo booking đã nằm ở booking module,
 * service này chỉ làm truy vấn/cập nhật cho payment.
 */
@Injectable()
export class BookingPaymentService {
  private readonly logger = new Logger(BookingPaymentService.name);

  constructor(
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
    @InjectRepository(BookingStatusLog)
    private readonly bookingStatusLogRepo: Repository<BookingStatusLog>,
    @InjectRepository(Product)
    private readonly productRepo: Repository<Product>,
  ) {}

  /**
   * Lấy booking theo ID + userId.
   *
   * Đảm bảo user chỉ truy cập booking của mình.
   */
  async findByIdAndUser(
    bookingId: string,
    userId: string,
  ): Promise<Booking> {
    const booking = await this.bookingRepo.findOne({
      where: { id: bookingId, userId },
    });
    if (!booking) {
      throw new NotFoundException(
        `Booking ${bookingId} not found`,
      );
    }
    return booking;
  }

  /**
   * Lấy booking theo ID (không kiểm tra user).
   *
   * Dùng cho IPN callback (server-to-server).
   */
  async findById(bookingId: string): Promise<Booking> {
    const booking = await this.bookingRepo.findOne({
      where: { id: bookingId },
    });
    if (!booking) {
      throw new NotFoundException(
        `Booking ${bookingId} not found`,
      );
    }
    return booking;
  }

  /**
   * Resolve amount theo product của booking.
   * Ưu tiên salePrice, fallback basePrice.
   */
  async resolveBookingAmount(booking: Booking): Promise<number> {
    if (!booking.productId) {
      throw new NotFoundException(
        `Booking ${booking.id} does not have productId`,
      );
    }

    const product = await this.productRepo.findOne({
      where: { id: booking.productId },
    });
    if (!product) {
      throw new NotFoundException(
        `Product ${booking.productId} not found`,
      );
    }

    const rawAmount = product.salePrice ?? product.basePrice;
    return Math.round(Number(rawAmount));
  }

  /**
   * Cập nhật payment URL + deeplink sau khi tạo link MoMo.
   *
   * Mobile client dùng `deeplink` để mở app MoMo trực tiếp.
   * Desktop/WebView dùng `paymentUrl` (hiển thị QR code).
   */
  async updatePaymentLinks(
    bookingId: string,
    paymentUrl: string | null,
    deeplink: string | null = null,
  ): Promise<Booking> {
    const booking = await this.findById(bookingId);
    booking.paymentUrl = paymentUrl;
    booking.paymentDeeplink = deeplink;
    return this.bookingRepo.save(booking);
  }

  /**
   * Cập nhật trạng thái booking theo payment state.
   *
   * Gọi khi IPN xác nhận thanh toán thành công
   * hoặc khi cần cancel sau refund.
   *
   * @param bookingId - ID booking cần cập nhật.
   * @param status - Trạng thái booking mới.
   * @param changedBy - actor thay đổi trạng thái.
   * @param reason - lý do thay đổi trạng thái.
   */
  async updateBookingStatus(
    bookingId: string,
    status: BookingStatus,
    changedBy = 'system',
    reason?: string,
  ): Promise<Booking> {
    const booking = await this.findById(bookingId);

    if (booking.status === status) {
      return booking;
    }

    const fromStatus = booking.status;
    booking.status = status;

    const updated = await this.bookingRepo.save(booking);
    await this.bookingStatusLogRepo.save(
      this.bookingStatusLogRepo.create({
        bookingId: booking.id,
        fromStatus,
        toStatus: status,
        changedBy,
        reason: reason ?? `Payment status changed to ${status}`,
      }),
    );

    this.logger.log(
      `Booking ${booking.id}: status ${fromStatus} -> ${status}`,
    );
    return updated;
  }
}
