import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Default mock clinic used as fallback for any
/// unknown clinic ID.
const kMockClinicInfo = ClinicInfoEntity(
  id: 'clinic-elite-dermatology',
  name: 'An Mien Spa & Clinic',
  address: '42 West St., District 1, HCM',
  coverImageUrl:
      'https://lh3.googleusercontent.com/aida-public/'
      'AB6AXuCEVF8gVYMud0aSZMOFJdwnVTPvmmtOq86O6fAghUnFKzSvG2i'
      'GgEr25EdKuPNmAonkFhPgvW6KNMsy61qoNVDuEwDpt2PPI4xJQV1qZ0N'
      'oYQvu_1ROeGptLsERDrmDAd-wO_iuUlDgnHXE64ngnQ4KPHWisYSWYHki'
      'v_huCQcJW7H1soRGJ-8uIfu7dUZsly-arXknf1NTr5wlhZexPxysFTPFu'
      'CBEaX-I5LSkjuJf7YvAj3yUf5nDpsqGQLPp9HSYnglSqd6cs4II',
  logoImageUrl:
      'https://lh3.googleusercontent.com/aida-public/'
      'AB6AXuC0XMbjgaEyxbg2gUlYQ2Nh9b-RBfPC8-EWl4z4gWbnN0CbOsjF'
      '7Vv8-78aY-yzApAXNGTgna6A6A4SEyeXZ11l8XjkVrNhCXISaO3rL9dsw'
      'wiEO2mNPSqYWSekZp41dqE-a3YIwcUlLRqX--D3FqcBTDu3mEz3MuFOGn'
      'aXSr5JvBzE0BDD-ZBIzOPK0CM2OQkjuxKd-1b9q6D7c677pNvJxvnMN6G'
      'UXLWzNFcqKNuUuk6rwCfl05W9B7d4oXgC4d8smBqODB7n29HR',
  gallery: [
    'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuD3Zn8zSQuudv0UU4v3iI8UNInx5WYmAeilp6OWhD_hpdyQXOJF'
        't_FMYjR2bWCL5clwKIPH4_KhHv6mldc9SYbjfcdNjezPDW7hLzXsOHgz'
        'BA5JtPw8jKuFjpEJ-orZbHPYqPpLg6hZjDYPMM7-pN3oOpjtnql6xf-d'
        '2AS__2TGRfJ_q3BwgW159fhxYKaCmmige5qp_rIQsf2y2P17JV0jrEHO'
        'zHj33HC9_I9WSbBImrLezcmVIb3nBaV0wFH7m6x5Ke94SrzITCg8',
  ],
  followersLabel: '15k',
  reviewsLabel: '2.5k',
  phoneNumber: '+84 28 1234 5678',
  description:
      'Experience world-class skin treatments with our '
      'advanced CO2 laser resurfacing technology. We '
      'specialize in non-invasive aesthetic procedures, '
      'clinical facials, and medical-grade skincare '
      'tailored for Asian skin types. Our facility '
      'combines medical expertise with a tranquil spa '
      'environment.',
  trustMetrics: ClinicTrustMetrics(
    rating: 4.9,
    reviewCount: 2500,
    experienceLabel: '10+ Yrs',
    clientsLabel: '30k+',
  ),
  certifications: [
    ClinicCertification(
      title: 'Medical License #124',
      subtitle: 'Ministry of Health',
      iconName: 'workspace_premium',
    ),
    ClinicCertification(
      title: 'Top 10 Spa 2025',
      subtitle: 'Beauty Insider Asia',
      iconName: 'rewarded_ads',
    ),
    ClinicCertification(
      title: 'ISO 9001:2015',
      subtitle: 'Quality Management',
      iconName: 'verified_user',
    ),
  ],
  specialists: [
    ClinicSpecialistPreview(
      id: 'emp-sarah-lin',
      name: 'Dr. Sarah Lin',
      role: 'Dermatologist',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuDPMlwqUr8pfzmjwgygmZhHg7Tx6xGc6Jm6CeWxFxfmFwjp'
          'zZbGxxRQT3iTsD_bFkRIG3cly82USe-GmVPVgInDbjcwrXtnulHQKP'
          '2k8M108XNLqMD0MvH8OpjBnoKfllXdK-i8YPOIIJ2dN1XCHbwe8G8y'
          'oXSiyCA5ZEeWbCq60tsYqbsILgvVw3XWoYe7dSmIDM6axlz9yZSvz7'
          'q17D89_T9fkJnxCv7JbqrmkQTFjW-BWE5NdWEcSX-4ANRryNcMDPPM'
          '5oGz0iro',
      experienceLabel: '10 Yrs Exp',
    ),
    ClinicSpecialistPreview(
      id: 'emp-james-chen',
      name: 'Dr. James Chen',
      role: 'Aesthetician',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuDSfL8c94-r9L1NnDnjzhn1xh6cG2zh1UOeVXkNhNx5Jf2mw'
          'Qse8yCcBricwWIWcP4FFx3wbwMiK66tuhIdKpfIieJ0NGuYmDVA_0Rr'
          'QUy3RsPUQ_mlRu0lVanHfBQlruXCPNk65SnMQG4moF5Z8Ee0-ZXsxtT'
          'ARkdQwPQ1LN8kXn9Vole2B58EC3cEokMmUWlwTzZQvDU2lARZdBR3kl'
          'DdRf_LoB-fFCdjpNjJy93H-Kb-ReExU5CcwhZrxUgPVvIVEjH93lz5P'
          'jAA',
      experienceLabel: '8 Yrs Exp',
    ),
    ClinicSpecialistPreview(
      id: 'emp-elena-rose',
      name: 'Dr. Elena Rose',
      role: 'Laser Expert',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuCOi9MNoMf1PGW5irE8VCpfafrRNaywRJ5zlkWktAuY0y7yBU'
          'SBDrX6vETLqDQML6XTTSvFF66Ugq7UDEUPY2dEbz8ZCmpZ99s-RH3BA'
          '102Ei3IuAYreZ8RUKFNP3U5hlHqI_IZPhQnryJHKFgxRFE1JjJEffwj'
          'ccOTCQcvuPGGQ4NpX7K9CaoiBnfxV0Ow1B18CVdolNKMFuQ01Kq1FGU'
          'MCY_ydveVTbJG4SplP0fi-F2S0VOW17txReiJ-4SkM_SQEE1huNVo85H'
          '_',
      experienceLabel: '12 Yrs Exp',
    ),
  ],
  businessTypes: [
    'Spa',
    'Dermatology',
    'Aesthetic Clinic',
  ],
  facilityImages: [
    ClinicFacilityImage(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuD3Zn8zSQuudv0UU4v3iI8UNInx5WYmAeilp6OWhD_hpdyQXO'
          'JFt_FMYjR2bWCL5clwKIPH4_KhHv6mldc9SYbjfcdNjezPDW7hLzXs'
          'OHgzBA5JtPw8jKuFjpEJ-orZbHPYqPpLg6hZjDYPMM7-pN3oOpjtnq'
          'l6xf-d2AS__2TGRfJ_q3BwgW159fhxYKaCmmige5qp_rIQsf2y2P17'
          'JV0jrEHOzHj33HC9_I9WSbBImrLezcmVIb3nBaV0wFH7m6x5Ke94Sr'
          'zITCg8',
      label: 'Main Hall',
    ),
    ClinicFacilityImage(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuDUaMWXMiOlu9Ud3v3O0NyMiYryQEKwk88dsIicriQmA02gPjV'
          'ExHN8IJ0fjXmMHnHZDNHkEX7Ujg6WWy_7QuEShzk5Sv7THP-Yu8DDMw'
          'wLzrUEK7njTc1Jqe50Lp_KN8WtjIywo2OntLRkBGx-Y0K4JOHRea7TG'
          '7auuGyFY6PCoLGSyV5IEvHhoHjeSdZ-2HJlpSN5rPLW6htbi_jS-sRl'
          'ykKxC3VBItiua4XKI8mLfzmOiv9QzwfYUXujTCo-cX_Bmw7asIl3YTmy',
      label: 'VIP Suite A',
    ),
    ClinicFacilityImage(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuDgkD90aAc68oZIvnhJtmVE0UMzTIH1E2fvhRFffYow2R5Fg_t'
          'OApdQkg8Wax-kdjKJJHOb1KwuB3ywZXj8tbiUYR7dkBAM7p1dR4OtKA'
          'VZ269jAfseWLMFYQBx5J02ZBDFllzVnOiN6f-gxz73v7dvAOitfbO-1b'
          '0BOgSy26ao6L8exL_6pmgCyMhfEJxq53BzFsq43hSBK-jn9-B9Axo1z'
          'm87ORMJLStUq9DXmP9wFYpieLuO6aQ2FNCnMYZkVpoQdmzaD150j4OD',
      label: 'Laser Room',
    ),
  ],
);

/// Clinic info keyed by clinic ID for mock lookups.
final Map<String, ClinicInfoEntity> kMockClinicInfoMap = {
  kMockClinicInfo.id: kMockClinicInfo,
  'clinic-spa-harmony': ClinicInfoEntity(
    id: 'clinic-spa-harmony',
    name: 'Spa Harmony',
    address: 'District 1, Ho Chi Minh City',
    followersLabel: '5k',
    reviewsLabel: '800',
    trustMetrics: const ClinicTrustMetrics(
      rating: 4.5,
      reviewCount: 800,
      experienceLabel: '5+ Yrs',
      clientsLabel: '10k+',
    ),
  ),
};
