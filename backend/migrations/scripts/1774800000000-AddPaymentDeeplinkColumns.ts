import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

/**
 * Adds `payment_deeplink` column to both `payments` and `bookings` tables.
 *
 * On mobile browsers, redirecting to MoMo's `payUrl` shows a QR code page
 * which is useless — the user can't scan their own screen. The `deeplink`
 * field from MoMo's response opens the MoMo app directly, providing much
 * better mobile UX.
 */
export class AddPaymentDeeplinkColumns1774800000000
  implements MigrationInterface
{
  name = 'AddPaymentDeeplinkColumns1774800000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // 1. Add to payments table (idempotent: skip if already exists from synchronize)
    const hasPaymentCol = await queryRunner.query(
      `SELECT 1 FROM information_schema.columns WHERE table_name = 'payments' AND column_name = 'payment_deeplink'`,
    );
    if (hasPaymentCol.length === 0) {
      await queryRunner.addColumn(
        'payments',
        new TableColumn({
          name: 'payment_deeplink',
          type: 'text',
          isNullable: true,
        }),
      );
    }

    // 2. Add to bookings table (idempotent)
    const hasBookingCol = await queryRunner.query(
      `SELECT 1 FROM information_schema.columns WHERE table_name = 'bookings' AND column_name = 'payment_deeplink'`,
    );
    if (hasBookingCol.length === 0) {
      await queryRunner.addColumn(
        'bookings',
        new TableColumn({
          name: 'payment_deeplink',
          type: 'text',
          isNullable: true,
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn('bookings', 'payment_deeplink');
    await queryRunner.dropColumn('payments', 'payment_deeplink');
  }
}
