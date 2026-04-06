import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/about_clinic_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/certifications_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/clinic_facility_grid.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/specialists_section.widget.dart';
import 'package:user_app/features/clinic_info/presentation/widgets/clinic_info/trust_metrics_bar.widget.dart';

/// Shop tab — existing clinic profile sections
/// including trust metrics, certifications,
/// specialists, facilities, and about.
class ShopTabContent extends StatelessWidget {
  const ShopTabContent({
    super.key,
    required this.clinic,
  });

  final ClinicInfoEntity clinic;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 120),
      children: [
        AppDimens.verticalLarge,

        // Trust metrics
        TrustMetricsBar(
          metrics: clinic.trustMetrics,
        ),
        AppDimens.verticalLarge,

        // Certifications
        if (clinic.certifications.isNotEmpty) ...[
          CertificationsSection(
            certifications:
                clinic.certifications,
          ),
          AppDimens.verticalLarge,
        ],

        // Specialists
        if (clinic.specialists.isNotEmpty) ...[
          SpecialistsSection(
            specialists: clinic.specialists,
          ),
          AppDimens.verticalLarge,
        ],

        // Facility tour
        if (clinic.facilityImages.isNotEmpty) ...[
          ClinicFacilityGrid(
            images: clinic.facilityImages,
          ),
          AppDimens.verticalLarge,
        ],

        // About
        if (clinic.description != null &&
            clinic.description!.isNotEmpty) ...[
          AboutClinicSection(
            description: clinic.description!,
          ),
          AppDimens.verticalLarge,
        ],
      ],
    );
  }
}
