import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardReviewDto } from '../dto/response/dashboard-review.dto';

@Injectable()
export class ListRecentReviewsHandler {
  private readonly logger = new Logger(ListRecentReviewsHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    partnerId: string,
    limit: number,
  ): Promise<DashboardReviewDto[]> {
    this.logger.log(
      `Listing recent reviews for partner: ${partnerId}, limit: ${limit}`,
    );

    // UNION ALL of treatment reviews + specialist reviews, sorted by date
    const rows = await this.dataSource.query(
      `(
        SELECT
          CONCAT(up.first_name, ' ', up.last_name) AS reviewer_name,
          NULL                                     AS avatar_url,
          tr.rating,
          tr.comment                               AS text,
          tr.photo_urls                            AS image_urls,
          tr.created_at,
          'published'                              AS status
        FROM product_treatment_reviews tr
        JOIN bookings b ON tr.appointment_id = b.id
        JOIN employees e ON b.staff_id = e.id
        JOIN user_profile up ON tr.user_id = up.account_id
        WHERE e.partner_id = $1
      )
      UNION ALL
      (
        SELECT
          CONCAT(up.first_name, ' ', up.last_name) AS reviewer_name,
          NULL                                     AS avatar_url,
          sr.rating,
          sr.comment                               AS text,
          '[]'::jsonb                              AS image_urls,
          sr.created_at,
          'published'                              AS status
        FROM specialist_reviews sr
        JOIN employees e ON sr.specialist_id = e.id
        JOIN user_profile up ON sr.user_id = up.account_id
        WHERE e.partner_id = $1
      )
      ORDER BY created_at DESC
      LIMIT $2`,
      [partnerId, limit],
    );

    return rows.map((row: any) => {
      const dto = new DashboardReviewDto();
      dto.reviewerName = (row.reviewer_name ?? '').trim() || 'Anonymous';
      dto.avatarUrl = row.avatar_url ?? undefined;
      dto.rating = parseInt(row.rating) || 0;
      dto.status = row.status;
      dto.date = new Date(row.created_at).toISOString();
      dto.text = row.text ?? '';
      dto.imageUrls = Array.isArray(row.image_urls) ? row.image_urls : [];
      return dto;
    });
  }
}
