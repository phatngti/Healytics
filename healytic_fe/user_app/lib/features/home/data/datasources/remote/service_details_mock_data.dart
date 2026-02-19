import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Today at midnight — used as the base date for
/// generating mock day schedules.
final DateTime _today = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

/// Helper that builds a 30-day schedule starting from
/// today.
///
/// Each day gets a **different subset** of [baseSlots]
/// with varied availability, so the UI shows meaningful
/// differences when changing dates.
///
/// [closedWeekdays] weekdays (1=Mon … 7=Sun) when the
/// clinic is closed (no slots at all).
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

    // Use day index to deterministically vary which
    // slots appear and which are unavailable.
    final slots = <TimeSlotEntity>[];
    for (int j = 0; j < baseSlots.length; j++) {
      // Skip some slots on certain days to vary count.
      final skipSlot = (i + j) % 5 == 0;
      if (skipSlot) continue;

      // Mark some slots as unavailable (booked).
      final booked = (i * 3 + j) % 4 == 0;
      slots.add(TimeSlotEntity(label: baseSlots[j], isAvailable: !booked));
    }

    return DayScheduleEntity(date: date, timeSlots: slots, isAvailable: true);
  });
}

/// Pre-built mock service details for development and testing.
final kMockServiceDetails = ServiceDetailsEntity(
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
      'profile. During the session, '
      'the fractional CO2 laser '
      'creates micro-channels in '
      'the skin, triggering the '
      'body\'s natural healing '
      'response and stimulating '
      'new collagen formation.\n\n'
      'Post-treatment care includes '
      'a complimentary soothing '
      'serum application and '
      'detailed aftercare '
      'instructions. Most patients '
      'notice visible improvement '
      'within two weeks, with '
      'optimal results appearing '
      'after three to six months.',
  featureTags: const [
    FeatureTagEntity(iconName: 'schedule', label: '60 min'),
    FeatureTagEntity(iconName: 'spa', label: 'Single Session'),
    FeatureTagEntity(iconName: 'biotech', label: 'Advanced Tech'),
  ],
  clinic: const ClinicEntity(
    name: 'Elite Dermatology',
    address: '42 West St, NY',
  ),
  specialists: const [
    SpecialistEntity(
      name: 'Dr. Sarah Lin',
      role: 'Dermatologist',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHthfJMRsQoaGQ-Gx-AQKuG3pqy78O1HkokgX72RKZbDP-80hfNVsu9PA4vau_VjSUNv-TquBHvFuN3jQ01dY_aKxbjOX0wiYqBSDTnMZVPvF6Szzg52jMo7QE4GxCbwAPie1UdgRcWbOm_OPwKXxVenTwPQiheu34BTHu8-u2xMWWIffLZBJO_gfdqstxSeazc3iRAztQ0dg7N6KLlC0Z6KEs8UmkBD3d56dj16WSfA6YY69-PIRZMaz1CssJ3wbAH-W5R8J3TJal',
      isSelected: true,
      quote:
          'Specializing in cosmetic laser procedures with '
          'over 10 years of experience. I believe in '
          'enhancing natural beauty through precise '
          'technological application.',
      degrees: 'MD, PhD',
      languages: 'EN, ES',
      experience: '12 years',
      specializations: [
        'Laser Therapy',
        'Acne Treatment',
        'Skin Rejuvenation',
        'Scar Removal',
      ],
      bio:
          'Dr. Sarah Lin graduated top of her class '
          'from Harvard Medical School and completed '
          'her residency at Johns Hopkins. She has '
          'published over 30 peer-reviewed articles '
          'on fractional CO2 laser technology and '
          'serves on the editorial board of the '
          'Journal of Cosmetic Dermatology.',
    ),
    SpecialistEntity(
      name: 'Jessica M.',
      role: 'Aesthetician',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCS2-Xy4vXjbVEOeewuuJBFwnU85bii7U6sAbIZyiL5e_NMo2jBQVTWLCzsKWt8-svm5ff_qil_Xulo6g1B0E7ymbNu9KMjfpIH_atcTw9nbxTtHfIdE85g1Sa4izHS4d4f33gkwRRa478uiLdIAW9p-OddRYC5C9O__3tErH2s5_HuIVFlIiLuRHEIQ6rxWHTI22Ipjsql3U5uc6rQ94LEnxVNiesi8rTcI6DsxW5fCMIoqSaL-ROBEibmMuHaiamJmOqLgIkXLALq',
      quote:
          'I focus on creating personalized skincare '
          'routines that complement laser treatments '
          'for optimal long-term results.',
      degrees: 'Licensed Aesthetician',
      languages: 'EN, FR',
      experience: '8 years',
      specializations: [
        'Post-Laser Care',
        'Chemical Peels',
        'Microdermabrasion',
      ],
      bio:
          'Jessica trained at the International '
          'Dermal Institute and has worked alongside '
          'board-certified dermatologists for nearly '
          'a decade. She specializes in designing '
          'aftercare protocols that accelerate '
          'recovery and maximize treatment outcomes.',
    ),
    SpecialistEntity(
      name: 'Dr. Michael C.',
      role: 'Surgeon',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCWBxuMs7eA4Uro_8BitSt_iHtzVCTiGydckROlbFnFaUZ5Ij3vgXN7YOBUAct2SLpppfPvJ3OKTm8oKLf-YJh32E-4AQSU_fTzrsNw8fodFplfpzJ9gKgDmfZtPhSBKhFvJB0wVtfWGPXqXryigjB0RKARjJla8oeipbBYWlpBd3FIi6kQvGVtwCdRGvO5gc8LMpSbrDyPgU9yFlWJeA0HzbUdy6CSDE7AEJ4b8qtQimtL_6v_nSkwfiHygzIjanwAzJRWfd9vj6KA',
      quote:
          'Precision and patient safety are at the '
          'core of every procedure I perform.',
      degrees: 'MD, FACS',
      languages: 'EN, KO',
      experience: '15 years',
      specializations: [
        'Reconstructive Surgery',
        'Cosmetic Procedures',
        'Laser Surgery',
      ],
      bio:
          'Dr. Michael Chen is a board-certified '
          'plastic surgeon with fellowship training '
          'in microsurgical reconstruction. He has '
          'performed over 5,000 procedures and '
          'regularly teaches advanced techniques at '
          'international conferences.',
    ),
    SpecialistEntity(
      name: 'Dr. Emily T.',
      role: 'Skin Specialist',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDmeQ0aMYVXwMkKC_VIrTM7bN-6tKEWAX3o1rsRnfNHiGtmeRBPF6Z1UD9mbgRpw699WPx8oX1Dn6EPuFBiL9LGh0waLmV1Gj6Te7QWZDHdQpvoKKWX1b3EqdQWHOHufgVx4zAXZxBKUTczIXWH5IMeX5l59xNQopwpJGUckijkKiMGkNkJdYlRbVrzs2EYSp9CY8uVfXq3n5NaQ-Pzp5Ptb3r4Ghg-7QhSiq8Fep5L1Gl5WL7ZpgNg84bhVAROAZzP6xgV-evw3YhS',
      quote:
          'Every skin tells a story — my job is to '
          'help write the next beautiful chapter.',
      degrees: 'MBBS, DDV',
      languages: 'EN, HI',
      experience: '9 years',
      specializations: ['Pigmentation', 'Anti-Aging', 'Laser Resurfacing'],
      bio:
          'Dr. Emily Tanaka holds a diploma in '
          'dermatology and venereology. She trained '
          'in Tokyo and New York and brings a '
          'holistic East-meets-West approach to '
          'skin health.',
    ),
    SpecialistEntity(
      name: 'Alex Rivera',
      role: 'Laser Tech',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAEplDyrl0hlNhqQ-w7ybufYAvaTYoQdJlQVjSpvjxVt6vYB6bZdEplJckrk6MbbDmKTXQgMXA66pChZrDWc5UygpDu8WvZBrvxswFJyFbdKLki0wwCDOmbiKC7tK3c9Xlc3GCd-2aa-2i-LSLksZQ-rwI9zKX-pIHLB03E8loO7jf6bshgApH201cCLWtL-B5nyj7AukyeeUtRxVnzoluYuxCCISs1mN62LulDcZl_X4JJTN6ip4dHh1mA5LCyC1Rmf4V4B5HPkvfV',
      quote:
          'I stay on the cutting edge of laser '
          'technology to deliver the safest, most '
          'effective treatments possible.',
      degrees: 'BSc Physics',
      languages: 'EN, PT',
      experience: '6 years',
      specializations: ['CO2 Laser', 'IPL Therapy', 'Device Calibration'],
    ),
    SpecialistEntity(
      name: 'Dr. Anh Pham',
      role: 'Dermatologist',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC9Ww8TM-sbzwF10paTNSMARMIe24-2PSwX-mT1GmFKSXMsdbYSb7fxztigcqlKFAGzzA-n3mEF7RO7ep1kAFYEMwi3VGLuEPHJYDP66AH5eYqUkf0xOW4ECQ1d25k3Yk4cIVBg-iYJqBuPhJ4E2hv90NuYBcUpZaAUuHFQUah-FHL_A2TK6JNVBAL6DiJxKksW-ngR4UtaZwPa1We7IrkScL91dkMoJdspv-q2kXTPc_bo2pZ_El_GsniCr5LfulO36unQK7U1zYj5',
      quote:
          'Combining traditional Vietnamese herbal '
          'wisdom with modern laser dermatology '
          'for truly personalized care.',
      degrees: 'MD, MSc Derm',
      languages: 'VI, EN, ZH',
      experience: '11 years',
      specializations: [
        'Herbal Dermatology',
        'Laser Therapy',
        'Eczema Management',
        'Sensitive Skin',
      ],
      bio:
          'Dr. Anh Pham studied at the University '
          'of Medicine and Pharmacy in Ho Chi Minh '
          'City and completed a master\'s programme '
          'in dermatology at Seoul National '
          'University. She bridges Eastern and '
          'Western approaches to skin care.',
    ),
  ],
  daySchedules: _buildMonthSchedule(
    baseSlots: [
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
    ],
    closedWeekdays: {6, 7}, // Sat & Sun closed
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
    FacilityImageEntity(
      imageUrl:
          'https://images.unsplash.com/photo-1631217868264-e5b90bb7e133'
          '?w=600&h=400&fit=crop',
      label: 'Consultation Room',
    ),
    FacilityImageEntity(
      imageUrl:
          'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d'
          '?w=600&h=400&fit=crop',
      label: 'Waiting Area',
    ),
  ],
  reviews: [
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
      text:
          'Excellent service and amazing results! '
          'I would definitely Book an appointment '
          'again. The staff was incredibly '
          'professional and the treatment '
          'was seamless.',
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/'
            'AB6AXuBdwlcNwX40eaOii-pyBW3M5Yl779r4JZmpkYWR'
            'JS0LbA-tBAOLrEquOcvuvXYgcS9kWOzXDBbHv5hNV6-C'
            '4UENPzAOMPPMpaAlYxoDffvfn8drjPgUqrXgyGn7WEQkc'
            'JrBs3bSrc75iaBbMq7JTEh2MoA-IaksUBMDBHltW7wC1Q'
            'S94yFzcte1tOcV7ZwKU-cFsQ3qhNFi4f6SrYE1gZoZTtT'
            'K_acWuKXjrmqTUE-KNWNE2AlFiT7r6Ulju-uixgUThN4'
            'WpGkVIIST',
      ],
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
      text:
          'Excellent experience from start to finish. '
          'Highly recommend if you want to Book an '
          'appointment for laser therapy. My skin '
          'feels rejuvenated.',
      imageUrls: [
        'https://lh3.googleusercontent.com/aida-public/'
            'AB6AXuDjNhv4t7a9tD8FkXCP-Rbk1QtUPWVpoH3I_jpI'
            'WxOdsza7xZpYPqgHOc_JcIVI2VERbOVSYPzUOGbW-aHd'
            'mwFBZPU_ZPLHNUp7BAftAy1qf6jBdqR9BGlDLSnQNwqP'
            '-ybn5maixKeVfZ7OjytF77yamxMb8ZQpWSYj0aCTWbFM7'
            'Uml_JXEU0eRfNMjNJNMTZn5EQ-6DnxuDw_FM2MaoMGI_'
            '-kBuge4qOalFao9nSQKoLXbPpOBr4ARqbiUO346M6ClHZ'
            'ibpDYpUcjg',
        'https://lh3.googleusercontent.com/aida-public/'
            'AB6AXuAJq_uoj_BIM1LCjvFl8CEPR_mklWXQs4YK3Jwc'
            'z_XfoMvz-lXRhRtfO_TaQo0hDzysooz7-YqPe-ZAZUe6'
            '0fPFJ28xr9RWUp9BiFG_fwnDkCRcD3uHCXgl-xwDtupt'
            'kCdlEuLRTX8nfIVS_omuFRZt04JREZ6yT_i9vR57Z2k5'
            'CLRJiT3Hfa7SDbGtxMHKcl0McRHpkptV5tQcpSMsKOdF'
            'nWedTWfuPc83C6rhzmmpvMNq1ye0bord9L15MZigq_pUM'
            'wDL13gbW9XT',
      ],
    ),
  ],
  recommendedServices: const [
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
    RecommendedServiceEntity(
      id: 'rec-led-therapy',
      title: 'LED Light Therapy',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuBVjcfweS_jHsnxqlP-9kDI5sWB-Pv2hTM2jTR8ry'
          'gia4joXWA_60FIyL3aOUUDwrM9s2gaWA4JK8Go_rOPPnfs'
          'IskDDy-Np668Qjj7-o54WFo3BQRabNfXa1mJlGmBpUk0Tu'
          'qV574BebDk37aCin8-lI48s7Un_psVtFQfONk_c_U-PWcyk'
          'rKiAH4W0B5Qm4iQ1Ux8ftQ-M6slr5NorAv2Pi8bREcM-HV'
          '14dIwsvLGvxCrPeMn4dF9jnjxxwiT8dOr_DupBaGl6VPL',
      rating: 4.7,
      reviewLabel: '(210+ Reviews)',
      bookedLabel: '400+ Booked',
      price: r'$60.00',
    ),
  ],
);

/// Product-specific mock details keyed by product ID.
///
/// When a product card is tapped, the datasource looks up
/// this map and falls back to [kMockServiceDetails] for
/// unknown IDs.
final Map<String, ServiceDetailsEntity> kMockServiceDetailsMap = {
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
        'pain. Each session is tailored to your '
        'body\'s specific needs.\n\n'
        'Your therapist will begin with a '
        'warm-up phase using lighter strokes '
        'before progressively working into '
        'deeper layers of muscle and fascia. '
        'Trigger-point therapy is applied to '
        'stubborn knots, releasing built-up '
        'tension and restoring range of motion.\n\n'
        'This treatment is recommended for '
        'those recovering from sports injuries, '
        'office-related postural strain, or '
        'chronic pain conditions. A post-session '
        'stretch routine is included to '
        'maximise the benefits.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '60 min'),
      FeatureTagEntity(iconName: 'spa', label: 'Therapeutic'),
      FeatureTagEntity(iconName: 'self_improvement', label: 'Pain Relief'),
    ],
    clinic: const ClinicEntity(
      name: 'Spa Harmony',
      address: 'District 1, Ho Chi Minh City',
    ),
    specialists: const [
      SpecialistEntity(
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
        specializations: [
          'Deep Tissue',
          'Sports Recovery',
          'Trigger Point',
          'Myofascial Release',
        ],
        bio:
            'Nguyen Thu Ha trained at the '
            'Thai Traditional Medicine Institute '
            'and holds advanced certifications '
            'in sports massage therapy. She has '
            'worked with professional athletes '
            'and chronic pain patients for over '
            'a decade, developing custom '
            'treatment protocols.',
      ),
    ],
    daySchedules: _buildMonthSchedule(
      baseSlots: [
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
      ],
      closedWeekdays: {7}, // Sun closed
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
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1600334089648-b0d9d3028eb2'
            '?w=600&h=400&fit=crop',
        label: 'Hot Stone Room',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1507652313519-d4e9174996dd'
            '?w=600&h=400&fit=crop',
        label: 'Reception',
      ),
    ],
    reviews: [
      ReviewEntity(
        reviewerName: 'Tran Van Nam',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1507003211169-0a1dd7228f2d'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 4, 20),
        text:
            'Best deep tissue massage I have ever '
            'had. The therapist found every knot '
            'and worked through them carefully. '
            'Highly recommend for anyone with '
            'chronic back pain.',
      ),
      ReviewEntity(
        reviewerName: 'Le Thi Mai',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1494790108377-be9c29b29330'
            '?w=100&h=100&fit=crop',
        rating: 4,
        date: DateTime(2025, 3, 15),
        text:
            'Great experience overall. The '
            'pressure was perfect and I felt '
            'so much better afterwards. Will '
            'definitely come back for another '
            'session soon.',
      ),
    ],
    recommendedServices: const [
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
      RecommendedServiceEntity(
        id: 'rec-personal-training',
        title: 'Personal Training',
        imageUrl:
            'https://images.unsplash.com/'
            'photo-1571019614242-c5c5dee9f50b'
            '?w=600&h=400&fit=crop',
        rating: 4.7,
        reviewLabel: '(45 Reviews)',
        bookedLabel: '500+ Booked',
        price: '600,000 VND',
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
      'https://images.unsplash.com/photo-1545389336-cf090694435e'
          '?w=800&h=600&fit=crop',
    ],
    rating: 4.8,
    reviewCount: 62,
    price: '450,000 VND',
    isVerified: true,
    description:
        'Combine gentle yoga postures with guided '
        'meditation for total mind-body balance. '
        'Suitable for all levels, our sessions '
        'help reduce stress, improve flexibility, '
        'and cultivate mindfulness.\n\n'
        'Each class follows a curated flow that '
        'begins with breathwork and gentle '
        'warm-ups, transitions into standing '
        'and seated postures, and concludes '
        'with a 10-minute guided Yoga Nidra '
        'relaxation. Our instructors adapt '
        'poses in real-time to suit each '
        'participant\'s flexibility and '
        'experience level.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '45 min'),
      FeatureTagEntity(iconName: 'self_improvement', label: 'Mindfulness'),
      FeatureTagEntity(iconName: 'spa', label: 'All Levels'),
    ],
    clinic: const ClinicEntity(
      name: 'Zen Studio',
      address: 'Thao Dien, Thu Duc City',
    ),
    specialists: const [
      SpecialistEntity(
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
        specializations: [
          'Vinyasa Flow',
          'Yin Yoga',
          'Meditation',
          'Breathwork',
        ],
        bio:
            'Tran Minh Anh completed her '
            'RYT-500 training in Rishikesh, '
            'India and has taught over 3,000 '
            'classes across Southeast Asia. '
            'She blends traditional Hatha '
            'techniques with modern movement '
            'science to create accessible, '
            'transformative yoga experiences.',
      ),
    ],
    daySchedules: _buildMonthSchedule(
      baseSlots: ['7:00 AM', '9:00 AM', '5:00 PM'],
      closedWeekdays: {4, 7}, // Thu & Sun off
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
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1588286840104-8957b019727f'
            '?w=600&h=400&fit=crop',
        label: 'Private Practice Room',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1600618528240-fb9fc964b853'
            '?w=600&h=400&fit=crop',
        label: 'Sound Healing Room',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1507652313519-d4e9174996dd'
            '?w=600&h=400&fit=crop',
        label: 'Tea Lounge',
      ),
    ],
    reviews: [
      ReviewEntity(
        reviewerName: 'Nguyen Hoang Anh',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1438761681033-6461ffad8d80'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 5, 2),
        text:
            'The guided meditation at the end '
            'was absolutely transformative. '
            'I left feeling completely '
            'refreshed and centred. The '
            'instructor was so attentive.',
      ),
      ReviewEntity(
        reviewerName: 'Pham Duc Minh',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1500648767791-00dcc994a43e'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 4, 28),
        text:
            'Perfect for beginners like me. '
            'The flow was gentle yet '
            'challenging enough to feel a '
            'real stretch. Loved the calming '
            'atmosphere of the studio.',
      ),
    ],
    recommendedServices: const [
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
      RecommendedServiceEntity(
        id: 'rec-personal-training',
        title: 'Personal Training',
        imageUrl:
            'https://images.unsplash.com/'
            'photo-1571019614242-c5c5dee9f50b'
            '?w=600&h=400&fit=crop',
        rating: 4.7,
        reviewLabel: '(45 Reviews)',
        bookedLabel: '500+ Booked',
        price: '600,000 VND',
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
        'by certified trainers. Whether you want '
        'to build strength, lose weight, or train '
        'for competition, we adapt every session '
        'to your fitness goals.\n\n'
        'Your first visit includes a '
        'comprehensive fitness assessment — '
        'body composition analysis, movement '
        'screening, and goal-setting '
        'consultation. From there, your trainer '
        'builds a progressive programme that '
        'evolves with you, incorporating '
        'strength, cardio, and mobility work '
        'in every block.',
    featureTags: const [
      FeatureTagEntity(iconName: 'schedule', label: '50 min'),
      FeatureTagEntity(iconName: 'fitness_center', label: '1-on-1'),
      FeatureTagEntity(iconName: 'biotech', label: 'Custom Plan'),
    ],
    clinic: const ClinicEntity(
      name: 'FitLife Center',
      address: 'District 7, Ho Chi Minh City',
    ),
    specialists: const [
      SpecialistEntity(
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
        specializations: [
          'Strength Training',
          'HIIT',
          'Functional Fitness',
          'Body Recomposition',
        ],
        bio:
            'Le Quang Huy earned his degree '
            'from the University of Sport in '
            'Ho Chi Minh City and is NSCA '
            'Certified Strength and Conditioning '
            'Specialist. He has coached over '
            '500 clients ranging from beginners '
            'to competitive bodybuilders and '
            'holds multiple national lifting '
            'records.',
      ),
    ],
    daySchedules: _buildMonthSchedule(
      baseSlots: ['6:00 AM', '8:00 AM', '4:00 PM', '6:00 PM'],
      closedWeekdays: {6, 7}, // Sat & Sun closed
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
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1540497077202-7c8a3999166f'
            '?w=600&h=400&fit=crop',
        label: 'Cardio Deck',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1576678927484-cc907957088c'
            '?w=600&h=400&fit=crop',
        label: 'Stretching Area',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1558618666-fcd25c85f82e'
            '?w=600&h=400&fit=crop',
        label: 'Locker Room',
      ),
    ],
    reviews: [
      ReviewEntity(
        reviewerName: 'Vo Thanh Dat',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1472099645785-5658abf4ff4e'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 5, 8),
        text:
            'Coach Huy designed a programme '
            'that pushed me just the right '
            'amount. Lost 5 kg in the first '
            'month! The fitness assessment '
            'was incredibly thorough.',
      ),
      ReviewEntity(
        reviewerName: 'Bui Ngoc Lan',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1544005313-94ddf0286df2'
            '?w=100&h=100&fit=crop',
        rating: 4,
        date: DateTime(2025, 4, 12),
        text:
            'Really solid personal training '
            'experience. The custom plan '
            'adapts every week which keeps '
            'things fresh. Great facility '
            'with modern equipment.',
      ),
    ],
    recommendedServices: const [
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
        'on key energy points to melt away tension '
        'and promote deep relaxation. The warmth '
        'improves circulation and eases muscle '
        'stiffness for a truly luxurious '
        'experience.\n\n'
        'Our therapists hand-select each stone '
        'and heat them to an optimal temperature '
        'before carefully positioning them along '
        'the spine, palms, and feet. Warm oil is '
        'applied between placements to enhance '
        'the soothing effect and allow for '
        'effortless gliding massage strokes.\n\n'
        'This treatment is especially beneficial '
        'during cooler months or for clients '
        'who experience cold extremities. '
        'A complimentary herbal tea service '
        'follows each session to extend the '
        'feeling of warmth and tranquility.',
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
    specialists: const [
      SpecialistEntity(
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
        specializations: [
          'Hot Stone Therapy',
          'Aromatherapy',
          'Traditional Vietnamese Massage',
          'Energy Healing',
        ],
        bio:
            'Pham Thuy Linh studied traditional '
            'healing arts in Hue and completed '
            'advanced spa therapy training at '
            'CIDESCO International. She combines '
            'Eastern energy-balancing techniques '
            'with Western relaxation methods to '
            'create deeply restorative sessions '
            'that address both body and spirit.',
      ),
    ],
    daySchedules: _buildMonthSchedule(
      baseSlots: ['10:00 AM', '1:00 PM', '3:00 PM'],
      closedWeekdays: {5, 7}, // Fri & Sun off
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
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1544161515-4ab6ce6db874'
            '?w=600&h=400&fit=crop',
        label: 'Couples Suite',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1596178065887-1198b6148b2b'
            '?w=600&h=400&fit=crop',
        label: 'VIP Relaxation Zone',
      ),
      FacilityImageEntity(
        imageUrl:
            'https://images.unsplash.com/photo-1507652313519-d4e9174996dd'
            '?w=600&h=400&fit=crop',
        label: 'Zen Garden',
      ),
    ],
    reviews: [
      ReviewEntity(
        reviewerName: 'Dang Thuy Trang',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1534528741775-53994a69daeb'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 5, 10),
        text:
            'Absolute luxury. The warm stones '
            'melted every bit of tension away. '
            'The herbal tea afterwards was a '
            'lovely touch. Best spa experience '
            'in Saigon.',
      ),
      ReviewEntity(
        reviewerName: 'Hoang Minh Tuan',
        avatarUrl:
            'https://images.unsplash.com/'
            'photo-1506794778202-cad84cf45f1d'
            '?w=100&h=100&fit=crop',
        rating: 5,
        date: DateTime(2025, 4, 25),
        text:
            'Incredible session — felt like '
            'floating on a cloud. The '
            'therapist was very skilled at '
            'placing stones on the right '
            'pressure points. Worth every '
            'dong.',
      ),
    ],
    recommendedServices: const [
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
      RecommendedServiceEntity(
        id: 'rec-personal-training',
        title: 'Personal Training',
        imageUrl:
            'https://images.unsplash.com/'
            'photo-1571019614242-c5c5dee9f50b'
            '?w=600&h=400&fit=crop',
        rating: 4.7,
        reviewLabel: '(45 Reviews)',
        bookedLabel: '500+ Booked',
        price: '600,000 VND',
      ),
    ],
  ),
};
