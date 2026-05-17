import { MigrationInterface, QueryRunner } from 'typeorm';

export class OptimizeSpecialistReviewAggregates1779000000000
  implements MigrationInterface
{
  name = 'OptimizeSpecialistReviewAggregates1779000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SPECIALIST_REVIEWS_SPECIALIST_RATING"
      ON "specialist_reviews" ("specialist_id", "rating")
    `);

    await queryRunner.query(`
      CREATE INDEX IF NOT EXISTS "IDX_SPECIALIST_REVIEWS_SPECIALIST_CREATED_AT"
      ON "specialist_reviews" ("specialist_id", "created_at")
    `);

    await queryRunner.query(`
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

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_SPECIALIST_REVIEWS_SPECIALIST_CREATED_AT"`,
    );
    await queryRunner.query(
      `DROP INDEX IF EXISTS "IDX_SPECIALIST_REVIEWS_SPECIALIST_RATING"`,
    );
  }
}
