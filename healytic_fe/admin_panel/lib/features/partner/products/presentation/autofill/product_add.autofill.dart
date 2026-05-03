import 'package:admin_panel/features/partner/products/domain/facility_image_key.dart';

/// Dev-only autofill defaults for the Product Add form.
///
/// Used when navigating to the Add Product screen with
/// `?autofill=true`
/// (e.g. `/provider/products/add?autofill=true`).
///
/// Only active when [kDebugMode] is `true` — the
/// guard lives in [ProductAddScreen], not here,
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
  static const leadTime = '2';

  /// Product image URLs for autofill.
  static const productImages = <String>[
    'https://pub-58a545087a6b4221b1b0dab10d8d3517'
        '.r2.dev/1770314548932-'
        'Gemini_Generated_Image_86fd6v86fd6v86fd.png',
    'https://pub-58a545087a6b4221b1b0dab10d8d3517'
        '.r2.dev/1770314552105-'
        'Gemini_Generated_Image_eq0jpneq0jpneq0j.png',
    'https://pub-58a545087a6b4221b1b0dab10d8d3517'
        '.r2.dev/1770314560561-Gemini_Generated_Image'
        '_86fd6v86fd6v86fd-Photoroom.png',
    'https://pub-58a545087a6b4221b1b0dab10d8d3517'
        '.r2.dev/1770314567024-'
        'istockphoto-1460619599-1024x1024.jpg',
  ];

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
}
