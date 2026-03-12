// Domain entities for the service manual feature.
//
// Pure Dart — no Flutter or framework imports.

/// Top-level container for a service's manual.
class ServiceManualEntity {
  final String serviceName;
  final String vendorName;
  final String imageUrl;
  final List<String> preServiceGuidelines;
  final List<ServiceRuleEntity> serviceRules;
  final List<ProcedureStepEntity> procedureSteps;
  final List<FacilityEntity> facilities;
  final ManualReviewEntity review;

  const ServiceManualEntity({
    required this.serviceName,
    required this.vendorName,
    required this.imageUrl,
    required this.preServiceGuidelines,
    required this.serviceRules,
    required this.procedureSteps,
    required this.facilities,
    required this.review,
  });
}

/// A single rule displayed with an icon.
class ServiceRuleEntity {
  final String iconSlug;
  final String title;
  final String description;

  const ServiceRuleEntity({
    required this.iconSlug,
    required this.title,
    required this.description,
  });
}

/// One step in the service procedure timeline.
class ProcedureStepEntity {
  final int stepNumber;
  final String title;
  final String description;
  final bool isActive;

  const ProcedureStepEntity({
    required this.stepNumber,
    required this.title,
    required this.description,
    this.isActive = false,
  });
}

/// A facility image & name shown in the carousel.
class FacilityEntity {
  final String imageUrl;
  final String name;

  const FacilityEntity({required this.imageUrl, required this.name});
}

/// A single user review with star rating.
class ManualReviewEntity {
  final double averageRating;
  final String reviewerName;
  final String reviewText;
  final int starCount;

  const ManualReviewEntity({
    required this.averageRating,
    required this.reviewerName,
    required this.reviewText,
    this.starCount = 5,
  });
}
