import 'package:admin_panel/features/partner/products/domain/facility_image_key.dart';
import 'package:admin_panel/features/partner/products/domain/service_manual_key.dart';

/// UAT-only autofill defaults for the Product Add form.
///
/// Used when navigating to the Add Product screen with
/// `?autofill=true`
/// (e.g. `/provider/products/add?autofill=true`).
///
/// The UAT guard lives in [ProductAddScreen],
/// so this class stays pure.
abstract final class ProductAddAutofill {
  static const name = 'Signature Rejuvenating Facial';

  /// Quill Delta JSON for the Description rich-text field.
  static const description =
      '[{"insert":"Signature Rejuvenating Facial"}'
      ',{"insert":"\\n","attributes":{"header":2}}'
      ',{"insert":"A luxurious 90-minute facial treatment '
      'using premium botanical extracts. Deeply hydrates, '
      'brightens, and restores skin vitality.\\n\\n"}'
      ',{"insert":"Key Benefits"}'
      ',{"insert":"\\n","attributes":{"header":3}}'
      ',{"insert":"Deep hydration and nourishment"}'
      ',{"insert":"\\n","attributes":{"list":"bullet"}}'
      ',{"insert":"Brightens and evens skin tone"}'
      ',{"insert":"\\n","attributes":{"list":"bullet"}}'
      ',{"insert":"Reduces fine lines and wrinkles"}'
      ',{"insert":"\\n","attributes":{"list":"bullet"}}'
      ',{"insert":"Anti-aging botanical extracts"}'
      ',{"insert":"\\n","attributes":{"list":"bullet"}}'
      ',{"insert":"\\nIdeal for all skin types. '
      'Results visible after first session.\\n"}]';
  static const productType = 'service';
  static const basePrice = '950000';
  static const salePrice = '799000';
  static const status = 'active';
  static const onlineStore = true;
  static const duration = '90';
  static const buffer = '15';
  static const capacity = '1';


  /// Facility image entries (URL + label)
  /// for autofill.
  static const facilityImages = <Map<String, String>>[
    {
      FacilityImageKey.imageUrl:
          'https://pub-58a545087a6b4221b1b0dab10d8d3517'
          '.r2.dev/1770315713692-Gemini_Generated_Image'
          '_86fd6v86fd6v86fd-Photoroom.png',
      FacilityImageKey.label: 'Reception Area',
    },
    {
      FacilityImageKey.imageUrl:
          'https://pub-58a545087a6b4221b1b0dab10d8d3517'
          '.r2.dev/1770315725051-Gemini_Generated_Image'
          '_eq0jpneq0jpneq0j-Photoroom.png',
      FacilityImageKey.label: 'Treatment Room',
    },
    {
      FacilityImageKey.imageUrl:
          'https://pub-58a545087a6b4221b1b0dab10d8d3517'
          '.r2.dev/1770316458784-Gemini_Generated_Image'
          '_86fd6v86fd6v86fd-Photoroom.png',
      FacilityImageKey.label: 'Relaxation Lounge',
    },
  ];

  // ── Service Manual ──────────────────────────────

  /// Pre-service guidelines for autofill.
  static const guidelines = <String>[
    'Arrive at least 15 minutes before'
        ' your appointment',
    'Remove all makeup and jewelry'
        ' before the session',
    'Inform your therapist of any'
        ' skin allergies or sensitivities',
    'Avoid direct sun exposure for'
        ' 24 hours prior to treatment',
  ];

  /// Service rules for autofill.
  /// Each map: {iconSlug, title, description}.
  static const rules = <Map<String, String>>[
    {
      ServiceManualKey.iconSlug: 'schedule',
      ServiceManualKey.title: 'Punctuality',
      ServiceManualKey.description:
          'Clients arriving more than 15 minutes '
          'late may have their session shortened.',
    },
    {
      ServiceManualKey.iconSlug: 'shield',
      ServiceManualKey.title: 'Hygiene Standards',
      ServiceManualKey.description:
          'All tools are sterilized between '
          'sessions. Fresh linens are provided '
          'for every client.',
    },
    {
      ServiceManualKey.iconSlug: 'warning',
      ServiceManualKey.title: 'Contraindications',
      ServiceManualKey.description:
          'Not recommended for clients with '
          'active skin infections, open wounds, '
          'or severe sunburn.',
    },
  ];

  /// Procedure steps for autofill.
  /// Each map: {title, description}.
  static const steps = <Map<String, String>>[
    {
      ServiceManualKey.title: 'Consultation',
      ServiceManualKey.description:
          'Assess skin type and discuss '
          'client concerns and goals.',
    },
    {
      ServiceManualKey.title: 'Deep Cleansing',
      ServiceManualKey.description:
          'Double-cleanse to remove impurities '
          'and prepare the skin.',
    },
    {
      ServiceManualKey.title: 'Exfoliation',
      ServiceManualKey.description:
          'Gentle enzyme exfoliation to promote '
          'cell turnover.',
    },
    {
      ServiceManualKey.title: 'Serum Application',
      ServiceManualKey.description:
          'Apply botanical extract serums '
          'targeting hydration and brightening.',
    },
    {
      ServiceManualKey.title: 'Massage & Mask',
      ServiceManualKey.description:
          'Relaxing facial massage followed by '
          'a nourishing collagen mask.',
    },
  ];
}
