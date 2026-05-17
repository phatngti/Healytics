import { Injectable, Logger, OnModuleDestroy } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { DataSource } from 'typeorm';

/**
 * Keeps employees.rating and employees.review_count as a denormalized cache.
 * specialist_reviews remains the source of truth; every refresh recomputes
 * from that table so duplicate queue entries cannot double count.
 */
@Injectable()
export class SpecialistReviewAggregateService implements OnModuleDestroy {
  private static readonly RECONCILE_LOCK_NAMESPACE = 1779000000;
  private static readonly RECONCILE_LOCK_ID = 1;

  private readonly logger = new Logger(SpecialistReviewAggregateService.name);
  private readonly pendingSpecialistIds = new Set<string>();
  private flushTimer: ReturnType<typeof setTimeout> | null = null;
  private isFlushing = false;

  constructor(private readonly dataSource: DataSource) {}

  onModuleDestroy(): void {
    if (this.flushTimer) {
      clearTimeout(this.flushTimer);
      this.flushTimer = null;
    }
  }

  enqueueSpecialistRefresh(specialistId: string): void {
    if (!specialistId) return;

    this.pendingSpecialistIds.add(specialistId);
    if (this.flushTimer) return;

    this.flushTimer = setTimeout(() => {
      this.flushTimer = null;
      void this.flushPendingSpecialists();
    }, 0);
  }

  async flushPendingSpecialists(): Promise<void> {
    if (this.isFlushing) return;

    this.isFlushing = true;
    try {
      while (this.pendingSpecialistIds.size > 0) {
        const specialistIds = [...this.pendingSpecialistIds];
        this.pendingSpecialistIds.clear();
        await this.refreshSpecialists(specialistIds);
      }
    } catch (error) {
      this.logger.error(
        `Failed to flush specialist review aggregates: ${(error as Error).message}`,
        (error as Error).stack,
      );
    } finally {
      this.isFlushing = false;
    }
  }

  async refreshSpecialist(specialistId: string): Promise<void> {
    await this.refreshSpecialists([specialistId]);
  }

  async refreshSpecialists(specialistIds: string[]): Promise<void> {
    const uniqueIds = [...new Set(specialistIds.filter(Boolean))];
    if (uniqueIds.length === 0) return;

    await this.dataSource.query(
      `
      WITH requested_specialists AS (
        SELECT unnest($1::uuid[]) AS specialist_id
      ),
      review_aggregates AS (
        SELECT
          sr.specialist_id,
          ROUND(AVG(sr.rating)::numeric, 2) AS rating,
          COUNT(sr.id)::int AS review_count
        FROM specialist_reviews sr
        INNER JOIN requested_specialists rs
          ON rs.specialist_id = sr.specialist_id
        GROUP BY sr.specialist_id
      )
      UPDATE employees e
      SET
        rating = COALESCE(ra.rating, 0),
        review_count = COALESCE(ra.review_count, 0),
        updated_at = NOW()
      FROM requested_specialists rs
      LEFT JOIN review_aggregates ra
        ON ra.specialist_id = rs.specialist_id
      WHERE e.id = rs.specialist_id
        AND (
          e.rating IS DISTINCT FROM COALESCE(ra.rating, 0)
          OR e.review_count IS DISTINCT FROM COALESCE(ra.review_count, 0)
        )
      `,
      [uniqueIds],
    );
  }

  @Cron(CronExpression.EVERY_5_MINUTES)
  async reconcileAllSpecialistAggregates(): Promise<void> {
    await this.flushPendingSpecialists();

    const hasLock = await this.tryAcquireReconcileLock();
    if (!hasLock) {
      this.logger.debug(
        'Skipping specialist review aggregate reconciliation; another worker holds the lock',
      );
      return;
    }

    try {
      await this.refreshAllEmployeeAggregates();
    } finally {
      await this.releaseReconcileLock();
    }
  }

  async refreshAllEmployeeAggregates(): Promise<void> {
    await this.dataSource.query(`
      WITH review_aggregates AS (
        SELECT
          sr.specialist_id,
          ROUND(AVG(sr.rating)::numeric, 2) AS rating,
          COUNT(sr.id)::int AS review_count
        FROM specialist_reviews sr
        GROUP BY sr.specialist_id
      ),
      updated_reviewed_employees AS (
        UPDATE employees e
        SET
          rating = ra.rating,
          review_count = ra.review_count,
          updated_at = NOW()
        FROM review_aggregates ra
        WHERE e.id = ra.specialist_id
          AND (
            e.rating IS DISTINCT FROM ra.rating
            OR e.review_count IS DISTINCT FROM ra.review_count
          )
        RETURNING e.id
      )
      UPDATE employees e
      SET
        rating = 0,
        review_count = 0,
        updated_at = NOW()
      WHERE NOT EXISTS (
          SELECT 1
          FROM specialist_reviews sr
          WHERE sr.specialist_id = e.id
        )
        AND (
          e.rating IS DISTINCT FROM 0
          OR e.review_count IS DISTINCT FROM 0
        )
    `);
  }

  private async tryAcquireReconcileLock(): Promise<boolean> {
    const rows = await this.dataSource.query(
      `
      SELECT pg_try_advisory_lock($1, $2) AS locked
      `,
      [
        SpecialistReviewAggregateService.RECONCILE_LOCK_NAMESPACE,
        SpecialistReviewAggregateService.RECONCILE_LOCK_ID,
      ],
    );
    return rows[0]?.locked === true;
  }

  private async releaseReconcileLock(): Promise<void> {
    await this.dataSource.query(
      `
      SELECT pg_advisory_unlock($1, $2)
      `,
      [
        SpecialistReviewAggregateService.RECONCILE_LOCK_NAMESPACE,
        SpecialistReviewAggregateService.RECONCILE_LOCK_ID,
      ],
    );
  }
}
