import { BookingStatus } from '@/booking/enums/booking-status.enum';
import { Booking } from '@/common/entities/booking.entity';
import { AppointmentResponseDto } from './appointment-response.dto';

describe('AppointmentResponseDto', () => {
  it('formats check-in and check-out times in Vietnam timezone', () => {
    const booking = {
      id: 'booking-1',
      startTime: new Date('2026-05-20T03:00:00.000Z'),
      endTime: new Date('2026-05-20T04:00:00.000Z'),
      status: BookingStatus.PENDING_PAYMENT,
      productId: 'product-1',
      product: {
        name: 'Full Body Massage 60 Min',
        partner: {
          brandName: 'Healytics Spa & Wellness',
          accountId: 'partner-account-1',
        },
        category: { name: 'Relaxation Massage' },
        productDefinition: { durationMinutes: 60 },
        media: [],
      },
      staff: {
        id: 'staff-1',
        fullName: 'James Anderson',
      },
      isReviewed: false,
      paymentUrl: 'https://payment.example.test',
      paymentDeeplink: null,
      paymentExpiresAt: null,
    } as unknown as Booking;

    const dto = AppointmentResponseDto.fromEntity(booking);

    expect(dto.checkInTime).toBe('10:00 AM');
    expect(dto.checkOutTime).toBe('11:00 AM');
  });
});
