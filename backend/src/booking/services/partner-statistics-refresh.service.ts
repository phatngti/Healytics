import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { DataSource } from 'typeorm';

@Injectable()
export class PartnerStatisticsRefreshService {
  private static readonly LOCK_NAMESPACE = 1779100000;
  private static readonly LOCK_ID = 1;

  private readonly logger = new Logger(PartnerStatisticsRefreshService.name);

  constructor(private readonly dataSource: DataSource) {}

  @Cron(CronExpression.EVERY_MINUTE)
  async refreshAllPartnerStatistics(): Promise<void> {
    const locked = await this.tryAcquireLock();
    if (!locked) {
      this.logger.debug(
        'Skipping partner statistics refresh; another worker holds the lock',
      );
      return;
    }

    try {
      await this.upsertAllPartnerStatistics();
    } finally {
      await this.releaseLock();
    }
  }

  async upsertAllPartnerStatistics(): Promise<void> {
    await this.dataSource.query(`
      WITH partner_base AS (
        SELECT id AS partner_id
        FROM health_partner_profile
        WHERE deleted_at IS NULL
      ),
      booking_partner AS (
        SELECT
          b.id,
          b.status,
          COALESCE(e.partner_id, p.partner_id) AS partner_id
        FROM bookings b
        LEFT JOIN employees e ON e.id = b.staff_id
        LEFT JOIN products p ON p.id = b.product_id
        WHERE b.deleted_at IS NULL
      ),
      booking_stats AS (
        SELECT
          bp.partner_id,
          COUNT(*) FILTER (WHERE bp.status = 'COMPLETED')::int AS completed_bookings_count
        FROM booking_partner bp
        WHERE bp.partner_id IS NOT NULL
        GROUP BY bp.partner_id
      ),
      review_rows AS (
        SELECT
          bp.partner_id,
          tr.rating::numeric AS rating
        FROM product_treatment_reviews tr
        INNER JOIN booking_partner bp ON bp.id = tr.appointment_id
        WHERE bp.partner_id IS NOT NULL

        UNION ALL

        SELECT
          e.partner_id,
          sr.rating::numeric AS rating
        FROM specialist_reviews sr
        INNER JOIN employees e ON e.id = sr.specialist_id
        WHERE e.partner_id IS NOT NULL
          AND e.deleted_at IS NULL
      ),
      review_stats AS (
        SELECT
          rr.partner_id,
          COUNT(*)::int AS review_count,
          ROUND(AVG(rr.rating), 2) AS average_stars
        FROM review_rows rr
        GROUP BY rr.partner_id
      ),
      calculated AS (
        SELECT
          pb.partner_id,
          COALESCE(bs.completed_bookings_count, 0)::int AS completed_bookings_count,
          COALESCE(rs.review_count, 0)::int AS review_count,
          COALESCE(rs.average_stars, 0)::numeric(3, 2) AS average_stars,
          NOW() AS calculated_at
        FROM partner_base pb
        LEFT JOIN booking_stats bs ON bs.partner_id = pb.partner_id
        LEFT JOIN review_stats rs ON rs.partner_id = pb.partner_id
      )
      INSERT INTO partner_statistics (
        partner_id,
        completed_bookings_count,
        review_count,
        average_stars,
        last_calculated_at,
        created_at,
        updated_at
      )
      SELECT
        partner_id,
        completed_bookings_count,
        review_count,
        average_stars,
        calculated_at,
        calculated_at,
        calculated_at
      FROM calculated
      ON CONFLICT (partner_id) DO UPDATE
      SET
        completed_bookings_count = EXCLUDED.completed_bookings_count,
        review_count = EXCLUDED.review_count,
        average_stars = EXCLUDED.average_stars,
        last_calculated_at = EXCLUDED.last_calculated_at,
        updated_at = NOW()
      WHERE
        partner_statistics.completed_bookings_count IS DISTINCT FROM EXCLUDED.completed_bookings_count
        OR partner_statistics.review_count IS DISTINCT FROM EXCLUDED.review_count
        OR partner_statistics.average_stars IS DISTINCT FROM EXCLUDED.average_stars
        OR partner_statistics.last_calculated_at < NOW() - INTERVAL '55 seconds'
    `);
  }

  private async tryAcquireLock(): Promise<boolean> {
    const rows = await this.dataSource.query(
      'SELECT pg_try_advisory_lock($1, $2) AS locked',
      [
        PartnerStatisticsRefreshService.LOCK_NAMESPACE,
        PartnerStatisticsRefreshService.LOCK_ID,
      ],
    );
    return rows[0]?.locked === true;
  }

  private async releaseLock(): Promise<void> {
    await this.dataSource.query('SELECT pg_advisory_unlock($1, $2)', [
      PartnerStatisticsRefreshService.LOCK_NAMESPACE,
      PartnerStatisticsRefreshService.LOCK_ID,
    ]);
  }
}
