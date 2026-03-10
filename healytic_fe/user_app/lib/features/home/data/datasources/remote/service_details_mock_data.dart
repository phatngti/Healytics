import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

// ─────────────────────────────────────────────────────
// Scheduling helpers
// ─────────────────────────────────────────────────────

/// Today at midnight — base date for mock schedules.
final DateTime _today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

/// Builds a 30-day schedule with varied availability.
List<DayScheduleEntity> _buildMonthSchedule({
  required List<String> baseSlots,
  Set<int> closedWeekdays = const {6, 7},
}) {
  return List.generate(30, (i) {
    final date = _today.add(Duration(days: i));
    final isClosed = closedWeekdays.contains(date.weekday);

    if (isClosed) {
      return DayScheduleEntity(
        date: date,
        timeSlots: const [],
        isAvailable: false,
      );
    }

    final slots = <TimeSlotEntity>[];
    for (int j = 0; j < baseSlots.length; j++) {
      final skipSlot = (i + j) % 5 == 0;
      if (skipSlot) continue;
      final booked = (i * 3 + j) % 4 == 0;
      slots.add(TimeSlotEntity(label: baseSlots[j], isAvailable: !booked));
    }

    return DayScheduleEntity(date: date, timeSlots: slots, isAvailable: true);
  });
}

// ─────────────────────────────────────────────────────
// 1. SERVICE INFO — keyed by service ID
// ─────────────────────────────────────────────────────

/// Default service info used as fallback.
final kMockServiceInfo = ServiceDetailsEntity(
  id: 'service-laser-co2',
  title: 'Laser CO2 Skin\nTherapy',
  categoryLabel: 'Clinical Dermatology',
  images: const [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAWK5FyO-mTU6MTCyXD3ltC8CbqBqSmBUxjXMTidRKJwW6ECbzeR2-7D6s0NAUjTTysGCqoX_MePcTv0K_X3QIIVdiJ4KpgwJ8wOW0L65fQjM7kK8HND5qfYd5OsPHco99npiBVsrOX-iOnWn1wHjiSRpWdyJSZjwxanKpFvYXwkLHD9aS-3D-XtilUmdILsYVPg9qmAV_xCShqCs-iDYiFtEi4R_Dyhdm236EEG6yEfxHFRFotrFm9V2TNcU2kzrouGZI_APyC4IPt',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC9Ww8TM-sbzwF10paTNSMARMIe24-2PSwX-mT1GmFKSXMsdbYSb7fxztigcqlKFAGzzA-n3mEF7RO7ep1kAFYEMwi3VGLuEPHJYDP66AH5eYqUkf0xOW4ECQ1d25k3Yk4cIVBg-iYJqBuPhJ4E2hv90NuYBcUpZaAUuHFQUah-FHL_A2TK6JNVBAL6DiJxKksW-ngR4UtaZwPa1We7IrkScL91dkMoJdspv-q2kXTPc_bo2pZ_El_GsniCr5LfulO36unQK7U1zYj5',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuDmeQ0aMYVXwMkKC_VIrTM7bN-6tKEWAX3o1rsRnfNHiGtmeRBPF6Z1UD9mbgRpw699WPx8oX1Dn6EPuFBiL9LGh0waLmV1Gj6Te7QWZDHdQpvoKKWX1b3EqdQWHOHufgVx4zAXZxBKUTczIXWH5IMeX5l59xNQopwpJGUckijkKiMGkNkJdYlRbVrzs2EYSp9CY8uVfXq3n5NaQ-Pzp5Ptb3r4Ghg-7QhSiq8Fep5L1Gl5WL7ZpgNg84bhVAROAZzP6xgV-evw3YhS',
  ],
  rating: 4.9,
  reviewCount: 124,
  price: r'$350.00',
  isVerified: true,
  description:
      'Experience state-of-the-art '
      'skin resurfacing designed to '
      'reduce fine lines, scars, '
      'and pigmentation. Our '
      'advanced CO2 fractional '
      'laser stimulates collagen '
      'production for lasting '
      'rejuvenation with minimal '
      'downtime.\n\n'
      'The procedure begins with a '
      'thorough skin analysis using '
      'our AI-powered diagnostic '
      'tools, followed by a '
      'customized treatment plan '
      'tailored to your unique skin '
      'profile.',
  featureTags: const [
    FeatureTagEntity(iconName: 'schedule', label: '60 min'),
    FeatureTagEntity(iconName: 'spa', label: 'Single Session'),
    FeatureTagEntity(iconName: 'biotech', label: 'Advanced Tech'),
  ],
  clinic: const ClinicEntity(
    name: 'Elite Dermatology',
    address: '42 West St, NY',
  ),
  facilityImages: const [
    FacilityImageEntity(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDmeQ0aMYVXwMkKC_VIrTM7bN-6tKEWAX3o1rsRnfNHiGtmeRBPF6Z1UD9mbgRpw699WPx8oX1Dn6EPuFBiL9LGh0waLmV1Gj6Te7QWZDHdQpvoKKWX1b3EqdQWHOHufgVx4zAXZxBKUTczIXWH5IMeX5l59xNQopwpJGUckijkKiMGkNkJdYlRbVrzs2EYSp9CY8uVfXq3n5NaQ-Pzp5Ptb3r4Ghg-7QhSiq8Fep5L1Gl5WL7ZpgNg84bhVAROAZzP6xgV-evw3YhS',
      label: 'Main Hall',
    ),
    FacilityImageEntity(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9Ww8TM-sbzwF10paTNSMARMIe24-2PSwX-mT1GmFKSXMsdbYSb7fxztigcqlKFAGzzA-n3mEF7RO7ep1kAFYEMwi3VGLuEPHJYDP66AH5eYqUkf0xOW4ECQ1d25k3Yk4cIVBg-iYJqBuPhJ4E2hv90NuYBcUpZaAUuHFQUah-FHL_A2TK6JNVBAL6DiJxKksW-ngR4UtaZwPa1We7IrkScL91dkMoJdspv-q2kXTPc_bo2pZ_El_GsniCr5LfulO36unQK7U1zYj5',
      label: 'Treatment Suite A',
    ),
    FacilityImageEntity(
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAEplDyrl0hlNhqQ-w7ybufYAvaTYoQdJlQVjSpvjxVt6vYB6bZdEplJckrk6MbbDmKTXQgMXA66pChZrDWc5UygpDu8WvZBrvxswFJyFbdKLki0wwCDOmbiKC7tK3c9Xlc3GCd-2aa-2i-LSLksZQ-rwI9zKX-pIHLB03E8loO7jf6bshgApH201cCLWtL-B5nyj7AukyeeUtRxVnzoluYuxCCISs1mN62LulDcZl_X4JJTN6ip4dHh1mA5LCyC1Rmf4V4B5HPkvfV',
      label: 'Recovery Lounge',
    ),
    FacilityImageEntity(
      imageUrl:
          'https://images.unsplash.com/photo-1629909613654-28e377c37b09'
          '?w=600&h=400&fit=crop',
      label: 'Laser Lab',
    ),
  ],
);

/// Product-specific service info keyed by ID.
final Map<String, ServiceDetailsEntity> kMockServiceInfoMap = {
  'service-laser-co2': kMockServiceInfo,
  'prod-1': ServiceDetailsEntity(
    id: 'prod-1',
    title: 'Deep Tissue\nMassage',
    categoryLabel: 'Spa',
    images: const [
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
          '?w=800&h=600&fit=crop',
      'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
          '?w=800&h=600&fit=crop',
    ],
    rating: 4.9,
    reviewCount: 87,
    price: '850,000 VND',
    isVerified: true,
    description:
        'Our Deep Tissue Massage targets chronic '
        'muscle tension using slow, firm strokes '
        'and deep pressure. Ideal for athletes '
        'and those with persistent back or neck '
        'pain.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '60 min'),
      FeatureTagEntity(iconName: 'spa', label: 'Therapeutic'),
      FeatureTagEntity(iconName: 'self_improvement', label: 'Pain Relief'),
    ],
    clinic: const ClinicEntity(
      name: 'Spa Harmony',
      address: 'District 1, Ho Chi Minh City',
    ),
    facilityImages: const [
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
            '?w=600&h=400&fit=crop',
        label: 'Massage Room',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1540555700478-4be289fbec6d'
            '?w=600&h=400&fit=crop',
        label: 'Aromatherapy Suite',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1596178065887-1198b6148b2b'
            '?w=600&h=400&fit=crop',
        label: 'Relaxation Lounge',
      ),
    ],
  ),
  'prod-2': ServiceDetailsEntity(
    id: 'prod-2',
    title: 'Yoga &\nMeditation',
    categoryLabel: 'Wellness',
    images: const [
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773'
          '?w=800&h=600&fit=crop',
    ],
    rating: 4.8,
    reviewCount: 62,
    price: '450,000 VND',
    isVerified: true,
    description:
        'Combine gentle yoga postures with guided '
        'meditation for total mind-body balance. '
        'Suitable for all levels.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '45 min'),
      FeatureTagEntity(iconName: 'self_improvement', label: 'Mindfulness'),
      FeatureTagEntity(iconName: 'spa', label: 'All Levels'),
    ],
    clinic: const ClinicEntity(
      name: 'Zen Studio',
      address: 'Thao Dien, Thu Duc City',
    ),
    facilityImages: const [
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1506126613408-eca07ce68773'
            '?w=600&h=400&fit=crop',
        label: 'Yoga Studio',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1545389336-cf090694435e'
            '?w=600&h=400&fit=crop',
        label: 'Meditation Garden',
      ),
    ],
  ),
  'prod-3': ServiceDetailsEntity(
    id: 'prod-3',
    title: 'Personal\nTraining',
    categoryLabel: 'Fitness',
    images: const [
      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b'
          '?w=800&h=600&fit=crop',
    ],
    rating: 4.7,
    reviewCount: 45,
    price: '600,000 VND',
    isVerified: true,
    description:
        'Get a customized workout plan designed '
        'by certified trainers. Build strength, '
        'lose weight, or train for competition.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '50 min'),
      FeatureTagEntity(iconName: 'fitness_center', label: '1-on-1'),
      FeatureTagEntity(iconName: 'biotech', label: 'Custom Plan'),
    ],
    clinic: const ClinicEntity(
      name: 'FitLife Center',
      address: 'District 7, Ho Chi Minh City',
    ),
    facilityImages: const [
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b'
            '?w=600&h=400&fit=crop',
        label: 'Training Floor',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48'
            '?w=600&h=400&fit=crop',
        label: 'Free Weights Zone',
      ),
    ],
  ),
  'prod-5': ServiceDetailsEntity(
    id: 'prod-5',
    title: 'Hot Stone\nTherapy',
    categoryLabel: 'Spa',
    images: const [
      'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
          '?w=800&h=600&fit=crop',
    ],
    rating: 5.0,
    reviewCount: 31,
    price: '1,200,000 VND',
    isVerified: true,
    description:
        'Smooth, heated basalt stones are placed '
        'on key energy points to melt away '
        'tension and promote deep relaxation.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '90 min'),
      FeatureTagEntity(iconName: 'spa', label: 'Premium'),
      FeatureTagEntity(
        iconName: 'local_fire_department',
        label: 'Heat Therapy',
      ),
    ],
    clinic: const ClinicEntity(
      name: 'Royal Spa',
      address: 'District 3, Ho Chi Minh City',
    ),
    facilityImages: const [
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
            '?w=600&h=400&fit=crop',
        label: 'Stone Therapy Suite',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1540555700478-4be289fbec6d'
            '?w=600&h=400&fit=crop',
        label: 'Herbal Bath Room',
      ),
    ],
  ),
};

// ─────────────────────────────────────────────────────
// 2. EMPLOYEES — keyed by service ID
// ─────────────────────────────────────────────────────

/// Shared base slots for clinic-style schedules.
final _clinicSlots = [
  '7:00 AM',
  '7:30 AM',
  '8:00 AM',
  '9:00 AM',
  '9:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '12:30 PM',
  '1:00 PM',
  '2:00 PM',
  '3:00 PM',
  '3:30 PM',
  '4:00 PM',
];

/// Employee lists keyed by service ID.
final Map<String, List<SpecialistEntity>> kMockEmployeesMap = {
  'service-laser-co2': [
    SpecialistEntity(
      id: 'emp-sarah-lin',
      name: 'Dr. Sarah Lin',
      role: 'Dermatologist',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHthfJMRsQoaGQ-Gx-AQKuG3pqy78O1HkokgX72RKZbDP-80hfNVsu9PA4vau_VjSUNv-TquBHvFuN3jQ01dY_aKxbjOX0wiYqBSDTnMZVPvF6Szzg52jMo7QE4GxCbwAPie1UdgRcWbOm_OPwKXxVenTwPQiheu34BTHu8-u2xMWWIffLZBJO_gfdqstxSeazc3iRAztQ0dg7N6KLlC0Z6KEs8UmkBD3d56dj16WSfA6YY69-PIRZMaz1CssJ3wbAH-W5R8J3TJal',
      isSelected: true,
      quote:
          'Specializing in cosmetic laser procedures '
          'with over 10 years of experience.',
      degrees: 'MD, PhD',
      languages: 'EN, ES',
      experience: '12 years',
      specializations: const [
        'Laser Therapy',
        'Acne Treatment',
        'Skin Rejuvenation',
        'Scar Removal',
      ],
      bio:
          'Dr. Sarah Lin graduated top of her class '
          'from Harvard Medical School.',
      daySchedules: _buildMonthSchedule(
        baseSlots: _clinicSlots,
        closedWeekdays: {6, 7},
      ),
    ),
    SpecialistEntity(
      id: 'emp-jessica-m',
      name: 'Jessica M.',
      role: 'Aesthetician',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCS2-Xy4vXjbVEOeewuuJBFwnU85bii7U6sAbIZyiL5e_NMo2jBQVTWLCzsKWt8-svm5ff_qil_Xulo6g1B0E7ymbNu9KMjfpIH_atcTw9nbxTtHfIdE85g1Sa4izHS4d4f33gkwRRa478uiLdIAW9p-OddRYC5C9O__3tErH2s5_HuIVFlIiLuRHEIQ6rxWHTI22Ipjsql3U5uc6rQ94LEnxVNiesi8rTcI6DsxW5fCMIoqSaL-ROBEibmMuHaiamJmOqLgIkXLALq',
      quote:
          'I focus on creating personalized '
          'skincare routines.',
      degrees: 'Licensed Aesthetician',
      languages: 'EN, FR',
      experience: '8 years',
      specializations: const [
        'Post-Laser Care',
        'Chemical Peels',
        'Microdermabrasion',
      ],
      daySchedules: _buildMonthSchedule(
        baseSlots: _clinicSlots,
        closedWeekdays: {6, 7},
      ),
    ),
    SpecialistEntity(
      id: 'emp-michael-c',
      name: 'Dr. Michael C.',
      role: 'Surgeon',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCWBxuMs7eA4Uro_8BitSt_iHtzVCTiGydckROlbFnFaUZ5Ij3vgXN7YOBUAct2SLpppfPvJ3OKTm8oKLf-YJh32E-4AQSU_fTzrsNw8fodFplfpzJ9gKgDmfZtPhSBKhFvJB0wVtfWGPXqXryigjB0RKARjJla8oeipbBYWlpBd3FIi6kQvGVtwCdRGvO5gc8LMpSbrDyPgU9yFlWJeA0HzbUdy6CSDE7AEJ4b8qtQimtL_6v_nSkwfiHygzIjanwAzJRWfd9vj6KA',
      quote:
          'Precision and patient safety are at '
          'the core of every procedure.',
      degrees: 'MD, FACS',
      languages: 'EN, KO',
      experience: '15 years',
      specializations: const [
        'Reconstructive Surgery',
        'Cosmetic Procedures',
        'Laser Surgery',
      ],
      daySchedules: _buildMonthSchedule(
        baseSlots: _clinicSlots,
        closedWeekdays: {6, 7},
      ),
    ),
  ],
  'prod-1': [
    SpecialistEntity(
      id: 'emp-thu-ha',
      name: 'Nguyen Thu Ha',
      role: 'Senior Therapist',
      imageUrl:
          'https://images.unsplash.com/photo-1594824476967-48c8b964f137'
          '?w=200&h=200&fit=crop',
      isSelected: true,
      quote: '10 years experience in therapeutic massage.',
      degrees: 'Certified MT',
      languages: 'VI, EN',
      experience: '10 years',
      specializations: const [
        'Deep Tissue',
        'Sports Recovery',
        'Trigger Point',
      ],
      daySchedules: _buildMonthSchedule(
        baseSlots: _clinicSlots,
        closedWeekdays: {7},
      ),
    ),
  ],
  'prod-2': [
    SpecialistEntity(
      id: 'emp-minh-anh',
      name: 'Tran Minh Anh',
      role: 'Yoga Instructor',
      imageUrl:
          'https://images.unsplash.com/photo-1506126613408-eca07ce68773'
          '?w=200&h=200&fit=crop',
      isSelected: true,
      quote: 'Certified RYT-500 teacher.',
      degrees: 'RYT-500',
      languages: 'VI, EN',
      experience: '7 years',
      specializations: const ['Vinyasa Flow', 'Yin Yoga', 'Meditation'],
      daySchedules: _buildMonthSchedule(
        baseSlots: ['7:00 AM', '9:00 AM', '5:00 PM'],
        closedWeekdays: {4, 7},
      ),
    ),
  ],
  'prod-3': [
    SpecialistEntity(
      id: 'emp-quang-huy',
      name: 'Le Quang Huy',
      role: 'Head Trainer',
      imageUrl:
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b'
          '?w=200&h=200&fit=crop',
      isSelected: true,
      quote: 'NSCA-certified personal trainer.',
      degrees: 'BSc Sports Science',
      languages: 'VI, EN',
      experience: '9 years',
      specializations: const [
        'Strength Training',
        'HIIT',
        'Functional Fitness',
      ],
      daySchedules: _buildMonthSchedule(
        baseSlots: ['6:00 AM', '8:00 AM', '4:00 PM', '6:00 PM'],
        closedWeekdays: {6, 7},
      ),
    ),
  ],
  'prod-5': [
    SpecialistEntity(
      id: 'emp-thuy-linh',
      name: 'Pham Thuy Linh',
      role: 'Spa Therapist',
      imageUrl:
          'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
          '?w=200&h=200&fit=crop',
      isSelected: true,
      quote: 'Expert in Eastern stone therapy.',
      degrees: 'Dip. Spa Therapy',
      languages: 'VI, EN, ZH',
      experience: '8 years',
      specializations: const [
        'Hot Stone Therapy',
        'Aromatherapy',
        'Traditional Vietnamese Massage',
      ],
      daySchedules: _buildMonthSchedule(
        baseSlots: ['10:00 AM', '1:00 PM', '3:00 PM'],
        closedWeekdays: {5, 7},
      ),
    ),
  ],
};

// ─────────────────────────────────────────────────────
// 3. REVIEWS — keyed by service ID
// ─────────────────────────────────────────────────────

/// Reviews keyed by service ID.
final Map<String, List<ReviewEntity>> kMockReviewsMap = {
  'service-laser-co2': [
    ReviewEntity(
      reviewerName: 'John Wick',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuA7F6xHpVITBbG3FG1Yi-U2-Olw3bWWGygQcCpD1'
          'zCM-5K0UOIxbXbz-kLH5FBmaodmXwKnGmAg7qlxwejRQH5'
          'ijqWh85KmnM9kJRlLZXiOKPeJcEvq285itZ1I8yZG6Htez'
          'bhQb_ixhI4VqzktAPD2V6N_AziieUSOfA72VRwR17lh2NB'
          'SBbHyvlIufHDAnRiUkaQEckbuZjIRHGRli4UAJc7h7anMA'
          'aN2dBW_fnd9lKlB6MYwJCv1guzLLQvmjdLJVcOtG3OAET6J',
      rating: 5,
      date: DateTime(2025, 5, 11),
      location: 'District 1, HCM',
      serviceName: 'Laser CO2',
      text:
          'Excellent service and amazing results! '
          'I would definitely book again.',
    ),
    ReviewEntity(
      reviewerName: 'Ethan Hunt',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuAhG2PskZIr1Qt1Ya5JXU5Sqc-smGhjjKcb1BwNH'
          '_u7zej3ps4mVm1SIERRuGP4SiSsV1gVMFxbSQ9oem8FgHU'
          'cL1ItJ7UyAIvKSenGqnPKQO-tibqxJhk5MS38Qbw1Dx-Y'
          '77ilh5fsXeLy9Fj3aWBXsqx4CR_4FM9G5psnFMqx3T7p8'
          'ztqwZbYWh-AxStDe1enXG77ZKh-gLMxtBj8P_M-j4SIPz'
          'lIn0E2-FPBbb3gE3AW3Wyuc_5FRWpG9c7j1Q4U8L5ugQi'
          'EfRYi',
      rating: 5,
      date: DateTime(2025, 5, 11),
      location: 'District 3, HCM',
      serviceName: 'Laser CO2',
      text:
          'Excellent experience from start to '
          'finish. Highly recommend.',
    ),
  ],
  'prod-1': [
    ReviewEntity(
      reviewerName: 'Tran Van Nam',
      avatarUrl:
          'https://images.unsplash.com/'
          'photo-1507003211169-0a1dd7228f2d'
          '?w=100&h=100&fit=crop',
      rating: 5,
      date: DateTime(2025, 4, 20),
      location: 'District 1, HCM',
      serviceName: 'Deep Tissue Massage',
      text:
          'Best deep tissue massage I have ever '
          'had. Highly recommend.',
    ),
    ReviewEntity(
      reviewerName: 'Le Thi Mai',
      avatarUrl:
          'https://images.unsplash.com/'
          'photo-1494790108377-be9c29b29330'
          '?w=100&h=100&fit=crop',
      rating: 4,
      date: DateTime(2025, 3, 15),
      location: 'Thu Duc City',
      serviceName: 'Deep Tissue Massage',
      text:
          'Great experience overall. The pressure '
          'was perfect. Will come back.',
    ),
  ],
  'prod-2': [
    ReviewEntity(
      reviewerName: 'Nguyen Hoang Anh',
      avatarUrl:
          'https://images.unsplash.com/'
          'photo-1438761681033-6461ffad8d80'
          '?w=100&h=100&fit=crop',
      rating: 5,
      date: DateTime(2025, 5, 2),
      location: 'Thao Dien, Thu Duc',
      serviceName: 'Yoga & Meditation',
      text: 'The guided meditation was amazing.',
    ),
  ],
  'prod-3': [
    ReviewEntity(
      reviewerName: 'Vo Thanh Dat',
      avatarUrl:
          'https://images.unsplash.com/'
          'photo-1472099645785-5658abf4ff4e'
          '?w=100&h=100&fit=crop',
      rating: 5,
      date: DateTime(2025, 5, 8),
      location: 'District 7, HCM',
      serviceName: 'Personal Training',
      text: 'Lost 5 kg in the first month!',
    ),
  ],
  'prod-5': [
    ReviewEntity(
      reviewerName: 'Dang Thuy Trang',
      avatarUrl:
          'https://images.unsplash.com/'
          'photo-1534528741775-53994a69daeb'
          '?w=100&h=100&fit=crop',
      rating: 5,
      date: DateTime(2025, 5, 10),
      location: 'District 3, HCM',
      serviceName: 'Hot Stone Therapy',
      text:
          'Absolute luxury. Best spa experience '
          'in Saigon.',
    ),
  ],
};

// ─────────────────────────────────────────────────────
// 4. RECOMMENDED SERVICES — keyed by service ID
// ─────────────────────────────────────────────────────

/// Recommended services keyed by service ID.
const Map<String, List<RecommendedServiceEntity>> kMockRecommendedMap = {
  'service-laser-co2': [
    RecommendedServiceEntity(
      id: 'rec-hydrafacial',
      title: 'HydraFacial Deep Clean',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuC_dUeufK5FnBK9RXpjmc7PoCc1QRfXDLyeRwpG8C'
          'vijwkpc_hp5JIjiP_B1QaydPVYpCaiR0KPPSWE49d7A3qo'
          'rR6fx1Ox-OyAesTL68uVtwuVB8aE_9VYHrjTZfKia3MDH'
          'NY7l9IDQLgT7lIiBhmmGOJj7JIRZQ52VUF0SVzlWLLd7ev'
          'YPt6-7kacsw9ybFCQnXvk9IIEMNQ66qNF8SK7DkG41r8rQ'
          '7DMq5V7xDAEroZXFkecNgFODW0x6rAPkDDp0500bHNcCCb8',
      rating: 4.9,
      reviewLabel: '(500+ Reviews)',
      bookedLabel: '1.2k+ Booked',
      price: r'$120.00',
    ),
    RecommendedServiceEntity(
      id: 'rec-microdermabrasion',
      title: 'Microdermabrasion Pro',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuAPV9sWjeFLDtv_tvZJjfB6yhTnCd_IYSWuwVYG_a'
          'H4G5R9wjizsh3nXkTLORNpNZt__fYmgT5AfwIYWIPiEHyA'
          'pDH8zmlJfEdbJK_rcdPmGC09_pWLroPKpst2IBJqIrp0AJ'
          '-P1KoSoIpveqzGSEZkm0766WuM1nNXH9uUyj4olocJgm9w'
          'Mhl4AKubEk9Gu6ijKTqrptE8ZVLNVp28s5VHP-jyAT2-hf'
          'GwlTXC0S85LBg-eC_O2mnxKc3uNVCPKkwC0LwkLLCWkw0v',
      rating: 4.8,
      reviewLabel: '(320+ Reviews)',
      bookedLabel: '850+ Booked',
      price: r'$95.00',
    ),
  ],
  'prod-1': [
    RecommendedServiceEntity(
      id: 'rec-yoga',
      title: 'Yoga & Meditation',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=600&h=400&fit=crop',
      rating: 4.8,
      reviewLabel: '(62 Reviews)',
      bookedLabel: '300+ Booked',
      price: '450,000 VND',
    ),
    RecommendedServiceEntity(
      id: 'rec-hot-stone',
      title: 'Hot Stone Therapy',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1600334089648-b0d9d3028eb2'
          '?w=600&h=400&fit=crop',
      rating: 5.0,
      reviewLabel: '(31 Reviews)',
      bookedLabel: '200+ Booked',
      price: '1,200,000 VND',
    ),
  ],
  'prod-2': [
    RecommendedServiceEntity(
      id: 'rec-deep-tissue',
      title: 'Deep Tissue Massage',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=600&h=400&fit=crop',
      rating: 4.9,
      reviewLabel: '(87 Reviews)',
      bookedLabel: '700+ Booked',
      price: '850,000 VND',
    ),
  ],
  'prod-3': [
    RecommendedServiceEntity(
      id: 'rec-deep-tissue',
      title: 'Deep Tissue Massage',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=600&h=400&fit=crop',
      rating: 4.9,
      reviewLabel: '(87 Reviews)',
      bookedLabel: '700+ Booked',
      price: '850,000 VND',
    ),
    RecommendedServiceEntity(
      id: 'rec-yoga',
      title: 'Yoga & Meditation',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=600&h=400&fit=crop',
      rating: 4.8,
      reviewLabel: '(62 Reviews)',
      bookedLabel: '300+ Booked',
      price: '450,000 VND',
    ),
  ],
  'prod-5': [
    RecommendedServiceEntity(
      id: 'rec-deep-tissue',
      title: 'Deep Tissue Massage',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=600&h=400&fit=crop',
      rating: 4.9,
      reviewLabel: '(87 Reviews)',
      bookedLabel: '700+ Booked',
      price: '850,000 VND',
    ),
    RecommendedServiceEntity(
      id: 'rec-yoga',
      title: 'Yoga & Meditation',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=600&h=400&fit=crop',
      rating: 4.8,
      reviewLabel: '(62 Reviews)',
      bookedLabel: '300+ Booked',
      price: '450,000 VND',
    ),
  ],
};
