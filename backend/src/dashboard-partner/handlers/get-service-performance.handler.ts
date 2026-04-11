import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ServicePerformanceDto } from '../dto/response/service-performance.dto';

@Injectable()
export class GetServicePerformanceHandler {
  private readonly logger = new Logger(GetServicePerformanceHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(partnerId: string): Promise<ServicePerformanceDto[]> {
    this.logger.log(
      `Getting service performance for partner: ${partnerId}`,
    );

    const rows = await this.dataSource.query(
      `SELECT
        p.name                                  AS service_name,
        COUNT(b.id)                             AS booking_count,
        COALESCE(SUM(pay.amount), 0)            AS revenue,
        COALESCE(AVG(tr.rating), 0)             AS average_rating
      FROM products p
      LEFT JOIN bookings b ON b.product_id = p.id
          AND b.deleted_at IS NULL
      LEFT JOIN payments pay ON pay.booking_id = b.id
          AND pay.payment_status IN ('PAID', 'DEPOSITED')
      LEFT JOIN product_treatment_reviews tr
          ON tr.appointment_id = b.id
      WHERE p.partner_id = $1
        AND p.status = 'active'
        AND p.deleted_at IS NULL
      GROUP BY p.id, p.name
      ORDER BY booking_count DESC`,
      [partnerId],
    );

    return rows.map((row: any) => {
      const dto = new ServicePerformanceDto();
      dto.serviceName = row.service_name;
      dto.bookingCount = parseInt(row.booking_count) || 0;
      dto.revenue = parseFloat(row.revenue) || 0;
      dto.averageRating =
        Math.round((parseFloat(row.average_rating) || 0) * 10) / 10;
      return dto;
    });
  }
}
