// Domain entity for the eligibility detail API.
//
// Pure Dart — no Flutter or framework imports.

/// Complete booking summary data returned by
/// the `/user/health-services/eligibilities/{id}`
/// endpoint.
///
/// Maps all nested DTOs into grouped sub-entities
/// for easy consumption by summary cards.
class EligibilityDetailEntity {
  /// Whether all booking steps are complete.
  final bool isCompletedStep;

  /// Booking schedule (date + time slot).
  final EligibilitySchedule? schedule;

  /// Specialist info.
  final EligibilitySpecialist specialist;

  /// Service info.
  final EligibilityService service;

  /// Category info.
  final EligibilityCategory category;

  /// Location / venue info.
  final EligibilityLocation location;

  /// Price breakdown.
  final EligibilityPriceBreakdown priceBreakdown;

  const EligibilityDetailEntity({
    required this.isCompletedStep,
    this.schedule,
    required this.specialist,
    required this.service,
    required this.category,
    required this.location,
    required this.priceBreakdown,
  });
}

/// Booking schedule with date and time slot.
class EligibilitySchedule {
  final String? date;
  final String? timeSlotLabel;

  const EligibilitySchedule({this.date, this.timeSlotLabel});
}

/// Specialist info for summary display.
class EligibilitySpecialist {
  final String id;
  final String name;
  final String? specialty;
  final String? avatarUrl;

  const EligibilitySpecialist({
    required this.id,
    required this.name,
    this.specialty,
    this.avatarUrl,
  });
}

/// Service info for summary display.
class EligibilityService {
  final String id;
  final String title;
  final String? subtitle;
  final String duration;
  final String? imageUrl;

  const EligibilityService({
    required this.id,
    required this.title,
    this.subtitle,
    required this.duration,
    this.imageUrl,
  });
}

/// Category info for summary display.
class EligibilityCategory {
  final String id;
  final String name;

  const EligibilityCategory({required this.id, required this.name});
}

/// Location / venue info for summary display.
class EligibilityLocation {
  final String name;
  final String address;
  final String? mapUrl;
  final double? latitude;
  final double? longitude;

  const EligibilityLocation({
    required this.name,
    required this.address,
    this.mapUrl,
    this.latitude,
    this.longitude,
  });
}

/// Price breakdown for summary display.
class EligibilityPriceBreakdown {
  final num subTotal;
  final num discount;
  final num totalAmount;
  final String currency;

  const EligibilityPriceBreakdown({
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.currency,
  });

  /// Formats a number as VND currency string.
  String _formatVnd(num value) {
    final intVal = value.toInt();
    final str = intVal.toString();
    final buf = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buf.write(',');
      }
      buf.write(str[i]);
    }
    return '${buf.toString()} $currency';
  }

  /// Formatted subtotal string.
  String get formattedSubTotal => _formatVnd(subTotal);

  /// Formatted discount string.
  String get formattedDiscount =>
      discount > 0 ? '-${_formatVnd(discount)}' : '—';

  /// Formatted total amount string.
  String get formattedTotal => _formatVnd(totalAmount);
}
