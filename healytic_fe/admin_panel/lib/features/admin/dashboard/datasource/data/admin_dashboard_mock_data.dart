import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';

class AdminDashboardMockData {
  static DateTime get anchorDate => DateTime(2026, 4, 11, 9, 30);

  static AdminDashboardOverview overview(AdminDashboardPeriod period) {
    return switch (period) {
      AdminDashboardPeriod.sevenDays => const AdminDashboardOverview(
        grossRevenue: 368000000,
        netRevenue: 339400000,
        refundAmount: 8200000,
        failedPaymentAmount: 4300000,
        averageBookingValue: 310000,
        successfulTransactions: 1218,
        pendingTransactions: 26,
        refundedTransactions: 19,
        failedTransactions: 12,
        canceledTransactions: 31,
        totalPartners: 428,
        pendingPartnerReviews: 19,
        bookingSuccessRate: 91.89,
        bookingFailedRate: 2.70,
        bookingCanceledRate: 5.41,
        notificationVolume: 7,
      ),
      AdminDashboardPeriod.thirtyDays => const AdminDashboardOverview(
        grossRevenue: 1642000000,
        netRevenue: 1514800000,
        refundAmount: 38400000,
        failedPaymentAmount: 19100000,
        averageBookingValue: 307400,
        successfulTransactions: 5541,
        pendingTransactions: 121,
        refundedTransactions: 132,
        failedTransactions: 74,
        canceledTransactions: 150,
        totalPartners: 428,
        pendingPartnerReviews: 24,
        bookingSuccessRate: 91.47,
        bookingFailedRate: 2.50,
        bookingCanceledRate: 6.03,
        notificationVolume: 18,
      ),
      AdminDashboardPeriod.ninetyDays => const AdminDashboardOverview(
        grossRevenue: 4718000000,
        netRevenue: 4379000000,
        refundAmount: 102600000,
        failedPaymentAmount: 51700000,
        averageBookingValue: 301200,
        successfulTransactions: 16290,
        pendingTransactions: 306,
        refundedTransactions: 372,
        failedTransactions: 188,
        canceledTransactions: 420,
        totalPartners: 428,
        pendingPartnerReviews: 27,
        bookingSuccessRate: 90.89,
        bookingFailedRate: 2.86,
        bookingCanceledRate: 6.25,
        notificationVolume: 43,
      ),
    };
  }

  static AdminDashboardBookingOutcomeSummary bookingOutcomes(
    AdminDashboardPeriod period,
  ) {
    return switch (period) {
      AdminDashboardPeriod.sevenDays =>
        const AdminDashboardBookingOutcomeSummary(
          totalBookings: 1294,
          success: AdminOutcomeMetric(count: 1189, rate: 91.89),
          failed: AdminOutcomeMetric(count: 35, rate: 2.70),
          canceled: AdminOutcomeMetric(count: 70, rate: 5.41),
        ),
      AdminDashboardPeriod.thirtyDays =>
        const AdminDashboardBookingOutcomeSummary(
          totalBookings: 5840,
          success: AdminOutcomeMetric(count: 5342, rate: 91.47),
          failed: AdminOutcomeMetric(count: 146, rate: 2.50),
          canceled: AdminOutcomeMetric(count: 352, rate: 6.03),
        ),
      AdminDashboardPeriod.ninetyDays =>
        const AdminDashboardBookingOutcomeSummary(
          totalBookings: 17580,
          success: AdminOutcomeMetric(count: 15980, rate: 90.89),
          failed: AdminOutcomeMetric(count: 503, rate: 2.86),
          canceled: AdminOutcomeMetric(count: 1097, rate: 6.25),
        ),
    };
  }

  static AdminDashboardTransactionHealth transactionHealth(
    AdminDashboardPeriod period,
  ) {
    return switch (period) {
      AdminDashboardPeriod.sevenDays => const AdminDashboardTransactionHealth(
        totalTransactions: 1306,
        paid: 1218,
        pending: 26,
        refunded: 19,
        failed: 12,
        canceled: 31,
        grossRevenue: 368000000,
        refundAmount: 8200000,
        failedAmount: 4300000,
      ),
      AdminDashboardPeriod.thirtyDays => const AdminDashboardTransactionHealth(
        totalTransactions: 6018,
        paid: 5541,
        pending: 121,
        refunded: 132,
        failed: 74,
        canceled: 150,
        grossRevenue: 1642000000,
        refundAmount: 38400000,
        failedAmount: 19100000,
      ),
      AdminDashboardPeriod.ninetyDays => const AdminDashboardTransactionHealth(
        totalTransactions: 17576,
        paid: 16290,
        pending: 306,
        refunded: 372,
        failed: 188,
        canceled: 420,
        grossRevenue: 4718000000,
        refundAmount: 102600000,
        failedAmount: 51700000,
      ),
    };
  }

  static List<AdminDashboardRevenueTrendPoint> revenueTrend(
    AdminDashboardPeriod period,
  ) {
    final days = switch (period) {
      AdminDashboardPeriod.sevenDays => 7,
      AdminDashboardPeriod.thirtyDays => 30,
      AdminDashboardPeriod.ninetyDays => 90,
    };
    final baseGross = switch (period) {
      AdminDashboardPeriod.sevenDays => 44000000.0,
      AdminDashboardPeriod.thirtyDays => 52000000.0,
      AdminDashboardPeriod.ninetyDays => 49500000.0,
    };
    final baseNet = switch (period) {
      AdminDashboardPeriod.sevenDays => 40500000.0,
      AdminDashboardPeriod.thirtyDays => 47800000.0,
      AdminDashboardPeriod.ninetyDays => 45900000.0,
    };

    return List.generate(days, (index) {
      final date = anchorDate.subtract(Duration(days: days - index - 1));
      final weekendDip =
          (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday)
          ? 0.82
          : 1.0;
      final campaignLift = period == AdminDashboardPeriod.sevenDays
          ? (index == 3 ? 1.24 : 1.0)
          : period == AdminDashboardPeriod.thirtyDays
          ? (index % 9 == 0 ? 1.14 : 1.0)
          : (index % 16 == 0 ? 1.18 : 1.0);
      final wave = 1 + ((index % 5) * 0.04);
      final gross = baseGross * weekendDip * campaignLift * wave;
      final refund = gross * (0.018 + (index % 3) * 0.004);
      final net = (baseNet * weekendDip * campaignLift * wave) - refund * 0.4;
      final transactions = ((gross / 320000) + (index % 4) * 6).round();
      final successfulBookings = ((transactions * 0.91) - (index % 3)).round();

      return AdminDashboardRevenueTrendPoint(
        date: DateTime(date.year, date.month, date.day),
        grossRevenue: gross,
        netRevenue: net,
        refundAmount: refund,
        transactionCount: transactions,
        successfulBookingCount: successfulBookings,
      );
    });
  }

  static List<AdminPartnerRankingItem> topPartners(
    AdminDashboardPeriod period,
  ) {
    return switch (period) {
      AdminDashboardPeriod.sevenDays => const [
        AdminPartnerRankingItem(
          partnerId: 'partner-vita-well',
          partnerName: 'VitaWell Rehab',
          rank: 1,
          grossRevenue: 61200000,
          bookingCount: 201,
          successfulBookingRate: 93.5,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-calm-lotus',
          partnerName: 'Calm Lotus Clinic',
          rank: 2,
          grossRevenue: 58800000,
          bookingCount: 192,
          successfulBookingRate: 94.1,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-mendcare',
          partnerName: 'MendCare Diagnostics',
          rank: 3,
          grossRevenue: 42700000,
          bookingCount: 136,
          successfulBookingRate: 92.8,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-sora',
          partnerName: 'Sora Aesthetic House',
          rank: 4,
          grossRevenue: 38400000,
          bookingCount: 120,
          successfulBookingRate: 90.7,
          verificationStatus: AdminPartnerVerificationStatus.changesRequired,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-an-nhi',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 31600000,
          bookingCount: 99,
          successfulBookingRate: 91.6,
          verificationStatus: AdminPartnerVerificationStatus.pending,
        ),
      ],
      AdminDashboardPeriod.thirtyDays => const [
        AdminPartnerRankingItem(
          partnerId: 'partner-calm-lotus',
          partnerName: 'Calm Lotus Clinic',
          rank: 1,
          grossRevenue: 248000000,
          bookingCount: 812,
          successfulBookingRate: 94.3,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-vita-well',
          partnerName: 'VitaWell Rehab',
          rank: 2,
          grossRevenue: 224000000,
          bookingCount: 731,
          successfulBookingRate: 92.6,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-sora',
          partnerName: 'Sora Aesthetic House',
          rank: 3,
          grossRevenue: 198000000,
          bookingCount: 640,
          successfulBookingRate: 90.8,
          verificationStatus: AdminPartnerVerificationStatus.changesRequired,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-mendcare',
          partnerName: 'MendCare Diagnostics',
          rank: 4,
          grossRevenue: 176000000,
          bookingCount: 522,
          successfulBookingRate: 93.2,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-an-nhi',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 154000000,
          bookingCount: 468,
          successfulBookingRate: 91.4,
          verificationStatus: AdminPartnerVerificationStatus.pending,
        ),
      ],
      AdminDashboardPeriod.ninetyDays => const [
        AdminPartnerRankingItem(
          partnerId: 'partner-calm-lotus',
          partnerName: 'Calm Lotus Clinic',
          rank: 1,
          grossRevenue: 708000000,
          bookingCount: 2336,
          successfulBookingRate: 94.0,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-vita-well',
          partnerName: 'VitaWell Rehab',
          rank: 2,
          grossRevenue: 684000000,
          bookingCount: 2214,
          successfulBookingRate: 92.8,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-sora',
          partnerName: 'Sora Aesthetic House',
          rank: 3,
          grossRevenue: 569000000,
          bookingCount: 1840,
          successfulBookingRate: 90.5,
          verificationStatus: AdminPartnerVerificationStatus.changesRequired,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-mendcare',
          partnerName: 'MendCare Diagnostics',
          rank: 4,
          grossRevenue: 512000000,
          bookingCount: 1567,
          successfulBookingRate: 93.1,
          verificationStatus: AdminPartnerVerificationStatus.approved,
        ),
        AdminPartnerRankingItem(
          partnerId: 'partner-an-nhi',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 438000000,
          bookingCount: 1385,
          successfulBookingRate: 91.0,
          verificationStatus: AdminPartnerVerificationStatus.pending,
        ),
      ],
    };
  }

  static List<AdminServiceRankingItem> topServices(
    AdminDashboardPeriod period,
  ) {
    return switch (period) {
      AdminDashboardPeriod.sevenDays => const [
        AdminServiceRankingItem(
          serviceId: 'service-rehab-plan',
          serviceName: 'Recovery Rehab Plan',
          categoryName: 'Physical Therapy',
          partnerName: 'VitaWell Rehab',
          rank: 1,
          grossRevenue: 28400000,
          bookingCount: 92,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-deep-relief',
          serviceName: 'Deep Relief Massage',
          categoryName: 'Massage Therapy',
          partnerName: 'Calm Lotus Clinic',
          rank: 2,
          grossRevenue: 26300000,
          bookingCount: 88,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-skin-reset',
          serviceName: 'Skin Reset Program',
          categoryName: 'Aesthetics',
          partnerName: 'Sora Aesthetic House',
          rank: 3,
          grossRevenue: 21900000,
          bookingCount: 61,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-lab-check',
          serviceName: 'Advanced Lab Check',
          categoryName: 'Diagnostics',
          partnerName: 'MendCare Diagnostics',
          rank: 4,
          grossRevenue: 19600000,
          bookingCount: 57,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-sleep-balance',
          serviceName: 'Sleep Balance Therapy',
          categoryName: 'Wellness',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 18200000,
          bookingCount: 54,
        ),
      ],
      AdminDashboardPeriod.thirtyDays => const [
        AdminServiceRankingItem(
          serviceId: 'service-deep-relief',
          serviceName: 'Deep Relief Massage',
          categoryName: 'Massage Therapy',
          partnerName: 'Calm Lotus Clinic',
          rank: 1,
          grossRevenue: 115000000,
          bookingCount: 372,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-rehab-plan',
          serviceName: 'Recovery Rehab Plan',
          categoryName: 'Physical Therapy',
          partnerName: 'VitaWell Rehab',
          rank: 2,
          grossRevenue: 107000000,
          bookingCount: 346,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-skin-reset',
          serviceName: 'Skin Reset Program',
          categoryName: 'Aesthetics',
          partnerName: 'Sora Aesthetic House',
          rank: 3,
          grossRevenue: 101000000,
          bookingCount: 286,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-lab-check',
          serviceName: 'Advanced Lab Check',
          categoryName: 'Diagnostics',
          partnerName: 'MendCare Diagnostics',
          rank: 4,
          grossRevenue: 94000000,
          bookingCount: 271,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-sleep-balance',
          serviceName: 'Sleep Balance Therapy',
          categoryName: 'Wellness',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 78000000,
          bookingCount: 238,
        ),
      ],
      AdminDashboardPeriod.ninetyDays => const [
        AdminServiceRankingItem(
          serviceId: 'service-rehab-plan',
          serviceName: 'Recovery Rehab Plan',
          categoryName: 'Physical Therapy',
          partnerName: 'VitaWell Rehab',
          rank: 1,
          grossRevenue: 331000000,
          bookingCount: 1096,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-deep-relief',
          serviceName: 'Deep Relief Massage',
          categoryName: 'Massage Therapy',
          partnerName: 'Calm Lotus Clinic',
          rank: 2,
          grossRevenue: 328000000,
          bookingCount: 1071,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-skin-reset',
          serviceName: 'Skin Reset Program',
          categoryName: 'Aesthetics',
          partnerName: 'Sora Aesthetic House',
          rank: 3,
          grossRevenue: 289000000,
          bookingCount: 812,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-lab-check',
          serviceName: 'Advanced Lab Check',
          categoryName: 'Diagnostics',
          partnerName: 'MendCare Diagnostics',
          rank: 4,
          grossRevenue: 266000000,
          bookingCount: 784,
        ),
        AdminServiceRankingItem(
          serviceId: 'service-sleep-balance',
          serviceName: 'Sleep Balance Therapy',
          categoryName: 'Wellness',
          partnerName: 'An Nhi Wellness',
          rank: 5,
          grossRevenue: 229000000,
          bookingCount: 705,
        ),
      ],
    };
  }

  static List<AdminDashboardNotificationItem> notifications() {
    return [
      AdminDashboardNotificationItem(
        id: 'notif-1',
        title: 'Payment failures trending above baseline',
        body: 'Card and bank transfer retries spiked 18% in the last 24 hours.',
        createdAt: anchorDate.subtract(const Duration(minutes: 18)),
        type: AdminDashboardNotificationType.payment,
        priority: AdminDashboardNotificationPriority.high,
      ),
      AdminDashboardNotificationItem(
        id: 'notif-2',
        title: '24 partner applications awaiting review',
        body: 'Review queue SLA is at risk for new partner onboarding.',
        createdAt: anchorDate.subtract(const Duration(hours: 2)),
        type: AdminDashboardNotificationType.review,
        priority: AdminDashboardNotificationPriority.critical,
        isRead: true,
      ),
      AdminDashboardNotificationItem(
        id: 'notif-3',
        title: 'April wellness campaign broadcast published',
        body:
            'A new cross-platform promotion was delivered to providers and customers.',
        createdAt: anchorDate.subtract(const Duration(hours: 4)),
        type: AdminDashboardNotificationType.broadcast,
        priority: AdminDashboardNotificationPriority.medium,
        isRead: true,
      ),
      AdminDashboardNotificationItem(
        id: 'notif-4',
        title: 'Diagnostics category has inactive mapped services',
        body: 'Three services remain attached to categories marked inactive.',
        createdAt: anchorDate.subtract(const Duration(hours: 9)),
        type: AdminDashboardNotificationType.category,
        priority: AdminDashboardNotificationPriority.medium,
      ),
      AdminDashboardNotificationItem(
        id: 'notif-5',
        title: 'Settlement lag normalized after payout batch',
        body: 'Pending payout queue dropped below the operational threshold.',
        createdAt: anchorDate.subtract(const Duration(days: 1)),
        type: AdminDashboardNotificationType.operations,
        priority: AdminDashboardNotificationPriority.low,
        isRead: true,
      ),
    ];
  }

  static AdminCategoryHealth categoryHealth() {
    return const AdminCategoryHealth(
      totalCategories: 32,
      activeCategories: 27,
      inactiveCategories: 5,
      rootCategories: 4,
      subCategories: 28,
      emptyCategories: 3,
      totalMappedServices: 186,
      topCategories: [
        AdminCategorySnapshot(
          id: 'cat-spa-beauty',
          name: 'Spa & Beauty',
          serviceCount: 72,
          subCategoryCount: 5,
          isActive: true,
        ),
        AdminCategorySnapshot(
          id: 'cat-exercise',
          name: 'Exercise',
          serviceCount: 48,
          subCategoryCount: 3,
          isActive: true,
        ),
        AdminCategorySnapshot(
          id: 'cat-nutrition',
          name: 'Nutrition',
          serviceCount: 36,
          subCategoryCount: 4,
          isActive: true,
        ),
        AdminCategorySnapshot(
          id: 'cat-mental-therapy',
          name: 'Mental Therapy',
          serviceCount: 30,
          subCategoryCount: 2,
          isActive: true,
        ),
      ],
    );
  }
}
