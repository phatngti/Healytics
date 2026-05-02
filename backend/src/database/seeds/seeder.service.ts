import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UserSeeder } from './users/user.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { AppointmentSeeder } from './appointments/appointment.seeder';
import { AccountProfileSeeder } from './account-profiles/account-profile.seeder';
import { CheckoutTicketSeeder } from './checkout-tickets/checkout-ticket.seeder';
import { CartSeeder } from './cart/cart.seeder';
import { PartnerReviewLogSeeder } from './partner-review-logs/partner-review-log.seeder';
import { ClinicSeeder } from './clinic/clinic.seeder';
import { PartnerChatSeeder } from './partner-chat/partner-chat.seeder';
import { NotificationSeeder } from './notifications/notification.seeder';
import { PaymentTransactionLogSeeder } from './payment-transaction-logs/payment-transaction-log.seeder';
import { AiConversationSeeder } from './ai-conversations/ai-conversation.seeder';
import { PartnerFinanceSeeder } from './partner-finance/partner-finance.seeder';
import { AuditSeeder } from './audit/audit.seeder';
import { ISeeder } from './seeder.interface';

/**
 * Tables populated by migrations/master-data/ — never truncated by clearAll().
 * Also preserves the TypeORM `migrations` table so migration history stays intact.
 */
const PRESERVED_TABLES = [
  'migrations',
  'location',
  'health_partner_document_requirement',
];

const REQUIRED_SEED_TABLES = [
  'account',
  'user_profile',
  'address',
  'location',
  'health_partner_document_requirement',
  'categories',
  'product_feature_tags',
  'product_tags',
  'employees',
  'doctor_profiles',
  'therapist_profiles',
  'products',
  'product_definitions',
  'product_resource_requirements',
  'resource_types',
  'product_employee_eligibility',
  'health_partner_profile',
  'health_partner_legal_representative',
  'health_partner_document',
  'health_partner_review_log',
  'bookings',
  'booking_status_logs',
  'payments',
  'payment_transaction_logs',
  'partner_payouts',
  'partner_ledger_transactions',
  'partner_payout_transactions',
  'partner_refund_cases',
  'partner_transaction_timeline_events',
  'product_facility_images',
  'product_media',
  'product_treatment_reviews',
  'specialist_reviews',
  'checkout_tickets',
  'coupons',
  'cart_items',
  'partner_certifications',
  'clinic_review_responses',
  'partner_conversations',
  'partner_chat_messages',
  'partner_chat_attachments',
  'notifications',
  'notification_reads',
  'device_tokens',
  'audit_log',
  'conversations',
  'messages',
] as const;

/**
 * Orchestrates seed execution order.
 * Seeders are run sequentially to respect cross-module dependencies.
 *
 * Dependency graph:
 *   UserSeeder                  ← no deps
 *   AccountProfileSeeder        ← depends on UserSeeder (user_profile)
 *   PartnerSeeder               ← depends on UserSeeder + location
 *   EmployeeSeeder              ← depends on PartnerSeeder
 *   ServiceTagSeeder            ← depends on UserSeeder
 *   CategorySeeder              ← no deps
 *   ProductSeeder               ← depends on Category + ServiceTag + Employee
 *   AppointmentSeeder           ← depends on User + Employee + Product
 *   CheckoutTicketSeeder        ← depends on Booking + User + Employee + Product
 *   CartSeeder                  ← depends on User + Product + Category
 *   PartnerReviewLogSeeder      ← depends on Partner + Account
 *   ClinicSeeder                ← depends on TreatmentReview + Product + Partner
 *   PartnerChatSeeder           ← depends on Account + Booking
 *   NotificationSeeder          ← depends on Account
 *   PaymentTransactionLogSeeder ← depends on Payment
 *   PartnerFinanceSeeder        ← depends on Partner + Booking + Payment
 *   AiConversationSeeder        ← depends on Account
 *   AuditSeeder                 ← depends on Account + Booking + Partner
 */
@Injectable()
export class SeederService {
  private readonly logger = new Logger(SeederService.name);
  private readonly seeders: ISeeder[];

  constructor(
    private readonly dataSource: DataSource,
    private readonly userSeeder: UserSeeder,
    private readonly accountProfileSeeder: AccountProfileSeeder,
    private readonly employeeSeeder: EmployeeSeeder,
    private readonly serviceTagSeeder: ServiceTagSeeder,
    private readonly productSeeder: ProductSeeder,
    private readonly partnerSeeder: PartnerSeeder,
    private readonly categorySeeder: CategorySeeder,
    private readonly appointmentSeeder: AppointmentSeeder,
    private readonly checkoutTicketSeeder: CheckoutTicketSeeder,
    private readonly cartSeeder: CartSeeder,
    private readonly partnerReviewLogSeeder: PartnerReviewLogSeeder,
    private readonly clinicSeeder: ClinicSeeder,
    private readonly partnerChatSeeder: PartnerChatSeeder,
    private readonly notificationSeeder: NotificationSeeder,
    private readonly paymentTransactionLogSeeder: PaymentTransactionLogSeeder,
    private readonly partnerFinanceSeeder: PartnerFinanceSeeder,
    private readonly aiConversationSeeder: AiConversationSeeder,
    private readonly auditSeeder: AuditSeeder,
  ) {
    // ⚠️ ORDER MATTERS — seeders with dependencies come AFTER their dependencies
    this.seeders = [
      this.userSeeder, // 1. no deps
      this.accountProfileSeeder, // 2. depends on users
      this.partnerSeeder, // 3. depends on users + location
      this.employeeSeeder, // 4. depends on partners
      this.serviceTagSeeder, // 5. depends on users
      this.categorySeeder, // 6. no deps
      this.productSeeder, // 7. depends on categories, tags, employees
      this.appointmentSeeder, // 8. depends on users, employees, products
      this.checkoutTicketSeeder, // 9. depends on bookings + users + employees + products
      this.cartSeeder, // 10. depends on users + categories + products
      this.partnerReviewLogSeeder, // 11. depends on partners + account
      this.clinicSeeder, // 12. depends on treatment reviews + partners + products
      this.partnerChatSeeder, // 13. depends on accounts + bookings
      this.notificationSeeder, // 14. depends on accounts
      this.paymentTransactionLogSeeder, // 15. depends on payments
      this.partnerFinanceSeeder, // 16. depends on partners + bookings + payments
      this.aiConversationSeeder, // 17. depends on accounts
      this.auditSeeder, // 18. depends on accounts + bookings + partners
    ];
  }

  async seed(): Promise<void> {
    this.logger.log('🌱 Starting database seeding...');
    const startTime = Date.now();

    await this.assertRequiredTablesExist();

    for (const seeder of this.seeders) {
      await seeder.seed();
    }

    await this.verifyRelationalIntegrity();

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    this.logger.log(`🎉 Database seeding completed in ${duration}s`);
  }

  async clear(): Promise<void> {
    this.logger.log('🗑️ Clearing seed data...');

    // Clear in reverse order to respect foreign key constraints
    for (const seeder of [...this.seeders].reverse()) {
      await seeder.clear();
    }

    this.logger.log('🗑️ Seed data cleared');
  }

  /**
   * Truncates ALL application tables except master-data tables
   * (location, health_partner_document_requirement) and the migrations table.
   * Uses TRUNCATE ... CASCADE to handle foreign key dependencies automatically.
   */
  async clearAll(): Promise<void> {
    this.logger.log('🗑️ Clearing ALL data (preserving master-data)...');
    const startTime = Date.now();

    // Query all user-created table names from the public schema
    const tables: { table_name: string }[] = await this.dataSource.query(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
      ORDER BY table_name
    `);

    const tablesToTruncate = tables
      .map((t) => t.table_name)
      .filter((name) => !PRESERVED_TABLES.includes(name));

    if (tablesToTruncate.length === 0) {
      this.logger.warn('No tables to truncate');
      return;
    }

    this.logger.log(`Preserving: ${PRESERVED_TABLES.join(', ')}`);
    this.logger.log(`Truncating ${tablesToTruncate.length} table(s)...`);

    // Truncate all tables in a single statement with CASCADE
    const quoted = tablesToTruncate.map((t) => `"${t}"`).join(', ');
    await this.dataSource.query(
      `TRUNCATE TABLE ${quoted} RESTART IDENTITY CASCADE`,
    );

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    this.logger.log(
      `🎉 Cleared all data in ${duration}s (${tablesToTruncate.length} tables truncated)`,
    );
  }

  private async assertRequiredTablesExist(): Promise<void> {
    const rows: { table_name: string }[] = await this.dataSource.query(`
      SELECT table_name
      FROM information_schema.tables
      WHERE table_schema = 'public'
        AND table_type = 'BASE TABLE'
    `);
    const existing = new Set(rows.map((row) => row.table_name));
    const missing = REQUIRED_SEED_TABLES.filter((name) => !existing.has(name));

    if (!missing.length) {
      return;
    }

    const requiresNotificationMigration = [
      'notifications',
      'notification_reads',
      'device_tokens',
    ].some((name) => missing.includes(name as any));
    const requiresPartnerFinanceMigration = [
      'partner_payouts',
      'partner_ledger_transactions',
      'partner_payout_transactions',
      'partner_refund_cases',
      'partner_transaction_timeline_events',
    ].some((name) => missing.includes(name as any));

    const hints = [
      requiresNotificationMigration
        ? 'Missing notification tables detected; run migrations including 1776100000000-CreateNotificationTables.'
        : null,
      requiresPartnerFinanceMigration
        ? 'Missing partner finance tables detected; run migrations including 1776600000000-CreatePartnerFinanceTables.'
        : null,
    ].filter((hint): hint is string => Boolean(hint));

    throw new Error(
      `Schema preflight failed. Missing table(s): ${missing.join(', ')}.${hints.length ? ` ${hints.join(' ')}` : ''}`,
    );
  }

  private async verifyRelationalIntegrity(): Promise<void> {
    this.logger.log('🔍 Verifying relational integrity...');

    const checks: Array<{ name: string; sql: string }> = [
      {
        name: 'cart_items.user_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM cart_items ci
          LEFT JOIN account a ON a.id = ci.user_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'cart_items.service_id -> products.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM cart_items ci
          LEFT JOIN products p ON p.id = ci.service_id
          WHERE p.id IS NULL
        `,
      },
      {
        name: 'coupons.service_id -> products.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM coupons c
          LEFT JOIN products p ON p.id = c.service_id
          WHERE c.service_id IS NOT NULL
            AND p.id IS NULL
        `,
      },
      {
        name: 'coupons.category_id -> categories.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM coupons c
          LEFT JOIN categories cat ON cat.id = c.category_id
          WHERE c.category_id IS NOT NULL
            AND cat.id IS NULL
        `,
      },
      {
        name: 'checkout_tickets.user_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM checkout_tickets ct
          LEFT JOIN account a ON a.id = ct.user_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'checkout_tickets.staff_id -> employees.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM checkout_tickets ct
          LEFT JOIN employees e ON e.id = ct.staff_id
          WHERE ct.staff_id IS NOT NULL
            AND e.id IS NULL
        `,
      },
      {
        name: 'checkout_tickets.product_id -> products.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM checkout_tickets ct
          LEFT JOIN products p ON p.id = ct.product_id
          WHERE ct.product_id IS NOT NULL
            AND p.id IS NULL
        `,
      },
      {
        name: 'checkout_tickets.booking_id -> bookings.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM checkout_tickets ct
          LEFT JOIN bookings b ON b.id = ct.booking_id
          WHERE ct.booking_id IS NOT NULL
            AND b.id IS NULL
        `,
      },
      {
        name: 'payment_transaction_logs.payment_id -> payments.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM payment_transaction_logs ptl
          LEFT JOIN payments p ON p.id = ptl.payment_id
          WHERE p.id IS NULL
        `,
      },
      {
        name: 'partner_payouts.partner_id -> health_partner_profile.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_payouts pp
          LEFT JOIN health_partner_profile hp ON hp.id = pp.partner_id
          WHERE hp.id IS NULL
        `,
      },
      {
        name: 'partner_ledger_transactions.partner_id -> health_partner_profile.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_ledger_transactions plt
          LEFT JOIN health_partner_profile hp ON hp.id = plt.partner_id
          WHERE hp.id IS NULL
        `,
      },
      {
        name: 'partner_ledger_transactions.payout_id -> partner_payouts.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_ledger_transactions plt
          LEFT JOIN partner_payouts pp ON pp.id = plt.payout_id
          WHERE plt.payout_id IS NOT NULL
            AND pp.id IS NULL
        `,
      },
      {
        name: 'partner_payout_transactions.payout_id -> partner_payouts.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_payout_transactions ppt
          LEFT JOIN partner_payouts pp ON pp.id = ppt.payout_id
          WHERE pp.id IS NULL
        `,
      },
      {
        name: 'partner_payout_transactions.transaction_id -> partner_ledger_transactions.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_payout_transactions ppt
          LEFT JOIN partner_ledger_transactions plt ON plt.id = ppt.transaction_id
          WHERE plt.id IS NULL
        `,
      },
      {
        name: 'partner_refund_cases.transaction_id -> partner_ledger_transactions.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_refund_cases prc
          LEFT JOIN partner_ledger_transactions plt ON plt.id = prc.transaction_id
          WHERE plt.id IS NULL
        `,
      },
      {
        name: 'partner_transaction_timeline_events.transaction_id -> partner_ledger_transactions.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_transaction_timeline_events ptte
          LEFT JOIN partner_ledger_transactions plt ON plt.id = ptte.transaction_id
          WHERE plt.id IS NULL
        `,
      },
      {
        name: 'partner finance payout ownership consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_payout_transactions ppt
          INNER JOIN partner_payouts pp ON pp.id = ppt.payout_id
          INNER JOIN partner_ledger_transactions plt ON plt.id = ppt.transaction_id
          WHERE ppt.partner_id IS DISTINCT FROM pp.partner_id
            OR ppt.partner_id IS DISTINCT FROM plt.partner_id
            OR plt.payout_id IS DISTINCT FROM pp.id
        `,
      },
      {
        name: 'partner finance refund ownership consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_refund_cases prc
          INNER JOIN partner_ledger_transactions plt ON plt.id = prc.transaction_id
          WHERE prc.partner_id IS DISTINCT FROM plt.partner_id
        `,
      },
      {
        name: 'partner finance timeline ownership consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_transaction_timeline_events ptte
          INNER JOIN partner_ledger_transactions plt ON plt.id = ptte.transaction_id
          WHERE ptte.partner_id IS DISTINCT FROM plt.partner_id
        `,
      },
      {
        name: 'partner finance service booking source ownership consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_ledger_transactions plt
          LEFT JOIN bookings b ON b.id = plt.source_id
          LEFT JOIN products p ON p.id = b.product_id
          WHERE plt.source_type = 'serviceBooking'
            AND plt.source_id IS NOT NULL
            AND (
              b.id IS NULL
              OR p.id IS NULL
              OR p.partner_id IS DISTINCT FROM plt.partner_id
            )
        `,
      },
      {
        name: 'health_partner_review_log.partner_id -> health_partner_profile.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM health_partner_review_log prl
          LEFT JOIN health_partner_profile hp ON hp.id = prl.partner_id
          WHERE hp.id IS NULL
        `,
      },
      {
        name: 'health_partner_review_log.reviewer_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM health_partner_review_log prl
          LEFT JOIN account a ON a.id = prl.reviewer_id
          WHERE prl.reviewer_id IS NOT NULL
            AND a.id IS NULL
        `,
      },
      {
        name: 'partner_certifications.partner_id -> health_partner_profile.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_certifications pc
          LEFT JOIN health_partner_profile hp ON hp.id = pc.partner_id
          WHERE hp.id IS NULL
        `,
      },
      {
        name: 'clinic_review_responses.review_id -> product_treatment_reviews.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM clinic_review_responses crr
          LEFT JOIN product_treatment_reviews ptr ON ptr.id = crr.review_id
          WHERE ptr.id IS NULL
        `,
      },
      {
        name: 'clinic_review_responses.partner_id -> health_partner_profile.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM clinic_review_responses crr
          LEFT JOIN health_partner_profile hp ON hp.id = crr.partner_id
          WHERE hp.id IS NULL
        `,
      },
      {
        name: 'partner_conversations.user_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_conversations pc
          LEFT JOIN account a ON a.id = pc.user_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'partner_conversations.partner_account_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_conversations pc
          LEFT JOIN account a ON a.id = pc.partner_account_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'partner_conversations.booking_id -> bookings.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_conversations pc
          LEFT JOIN bookings b ON b.id = pc.booking_id
          WHERE pc.booking_id IS NOT NULL
            AND b.id IS NULL
        `,
      },
      {
        name: 'partner_chat_messages.conversation_id -> partner_conversations.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_chat_messages pcm
          LEFT JOIN partner_conversations pc ON pc.id = pcm.conversation_id
          WHERE pc.id IS NULL
        `,
      },
      {
        name: 'partner_chat_messages.sender_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_chat_messages pcm
          LEFT JOIN account a ON a.id = pcm.sender_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'partner_chat_attachments.message_id -> partner_chat_messages.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_chat_attachments pca
          LEFT JOIN partner_chat_messages pcm ON pcm.id = pca.message_id
          WHERE pcm.id IS NULL
        `,
      },
      {
        name: 'notifications.recipient_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM notifications n
          LEFT JOIN account a ON a.id = n.recipient_id
          WHERE n.recipient_id IS NOT NULL
            AND a.id IS NULL
        `,
      },
      {
        name: 'notifications.sender_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM notifications n
          LEFT JOIN account a ON a.id = n.sender_id
          WHERE n.sender_id IS NOT NULL
            AND a.id IS NULL
        `,
      },
      {
        name: 'notification_reads.notification_id -> notifications.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM notification_reads nr
          LEFT JOIN notifications n ON n.id = nr.notification_id
          WHERE n.id IS NULL
        `,
      },
      {
        name: 'notification_reads.user_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM notification_reads nr
          LEFT JOIN account a ON a.id = nr.user_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'device_tokens.user_id -> account.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM device_tokens dt
          LEFT JOIN account a ON a.id = dt.user_id
          WHERE a.id IS NULL
        `,
      },
      {
        name: 'messages.conversation_id -> conversations.id',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM messages m
          LEFT JOIN conversations c ON c.id = m.conversation_id
          WHERE c.id IS NULL
        `,
      },
      {
        name: 'checkout SUCCESS ticket consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM checkout_tickets ct
          LEFT JOIN bookings b ON b.id = ct.booking_id
          WHERE ct.status = 'SUCCESS'
            AND (
              ct.booking_id IS NULL
              OR b.id IS NULL
              OR ct.user_id IS DISTINCT FROM b.user_id
              OR ct.staff_id IS DISTINCT FROM b.staff_id
              OR ct.product_id IS DISTINCT FROM b.product_id
              OR ct.start_time IS DISTINCT FROM b.start_time
            )
        `,
      },
      {
        name: 'clinic response partner ownership consistency',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM clinic_review_responses crr
          LEFT JOIN product_treatment_reviews tr ON tr.id = crr.review_id
          LEFT JOIN bookings b ON b.id = tr.appointment_id
          LEFT JOIN products p ON p.id = b.product_id
          WHERE tr.id IS NULL
            OR b.id IS NULL
            OR p.id IS NULL
            OR crr.partner_id IS DISTINCT FROM p.partner_id
        `,
      },
      {
        name: 'partner chat sender belongs to conversation participants',
        sql: `
          SELECT COUNT(*)::int AS count
          FROM partner_chat_messages pcm
          INNER JOIN partner_conversations pc ON pc.id = pcm.conversation_id
          WHERE pcm.sender_id <> pc.user_id
            AND pcm.sender_id <> pc.partner_account_id
        `,
      },
    ];

    let hasViolation = false;
    for (const check of checks) {
      const [{ count }] = (await this.dataSource.query(check.sql)) as Array<{
        count: number;
      }>;
      const violationCount = Number(count);
      if (violationCount > 0) {
        hasViolation = true;
        this.logger.error(`❌ ${check.name}: ${violationCount} violation(s)`);
      }
    }

    if (hasViolation) {
      throw new Error(
        'Relational verification failed. See logs for violated constraints.',
      );
    }

    this.logger.log('✅ Relational verification passed');
  }
}
