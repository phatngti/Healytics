import 'package:user_app/features/booking/domain/entities/booking.entity.dart';
import 'package:user_app/features/booking/domain/entities/eligibility_detail.entity.dart';
import 'package:user_app/features/booking/domain/entities/time_slot.entity.dart';

// ─── Category → Specialist mappings ───────────────

/// Mock specialists grouped by category ID.
///
/// Keys correspond to [kMockCategories] IDs from
/// `home_mock_data.dart`.
final Map<String, List<BookingSpecialist>> kMockSpecialistsByCategory = {
  // ── Spa ────────────────────────────────────────
  'cat-1': const [
    BookingSpecialist(
      id: 'spec-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Spa Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Anna',
    ),
    BookingSpecialist(
      id: 'spec-2',
      name: 'Dr. Minh Tran',
      specialty: 'Massage Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Minh',
    ),
    BookingSpecialist(
      id: 'spec-3',
      name: 'Linh Pham',
      specialty: 'Aromatherapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Linh',
    ),
    BookingSpecialist(
      id: 'spec-12',
      name: 'Ngoc Anh',
      specialty: 'Skincare Expert',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=NgocAnh',
    ),
    BookingSpecialist(
      id: 'spec-13',
      name: 'Thanh Ha',
      specialty: 'Body Scrub Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThanhHa',
    ),
  ],

  // ── Wellness ───────────────────────────────────
  'cat-2': const [
    BookingSpecialist(
      id: 'spec-4',
      name: 'Dr. Hoa Le',
      specialty: 'Wellness Coach',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Hoa',
    ),
    BookingSpecialist(
      id: 'spec-5',
      name: 'Thu Dao',
      specialty: 'Yoga Instructor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Thu',
    ),
    BookingSpecialist(
      id: 'spec-14',
      name: 'Kim Chi Vu',
      specialty: 'Nutritionist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=KimChi',
    ),
    BookingSpecialist(
      id: 'spec-15',
      name: 'Quang Huy',
      specialty: 'Mindfulness Coach',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=QuangHuy',
    ),
  ],

  // ── Fitness ────────────────────────────────────
  'cat-3': const [
    BookingSpecialist(
      id: 'spec-6',
      name: 'Coach Duc Vo',
      specialty: 'Personal Trainer',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Duc',
    ),
    BookingSpecialist(
      id: 'spec-7',
      name: 'Coach Mai Ly',
      specialty: 'Fitness Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=MaiLy',
    ),
    BookingSpecialist(
      id: 'spec-16',
      name: 'Trung Kien',
      specialty: 'Strength Coach',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=TrungKien',
    ),
    BookingSpecialist(
      id: 'spec-17',
      name: 'Bich Ngoc',
      specialty: 'Pilates Instructor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=BichNgoc',
    ),
  ],

  // ── Mental Health ──────────────────────────────
  'cat-4': const [
    BookingSpecialist(
      id: 'spec-8',
      name: 'Dr. Tuan Phan',
      specialty: 'Psychologist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Tuan',
    ),
    BookingSpecialist(
      id: 'spec-18',
      name: 'Dr. Phuong Nhi',
      specialty: 'Clinical Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=PhuongNhi',
    ),
    BookingSpecialist(
      id: 'spec-19',
      name: 'Thanh Son',
      specialty: 'Life Coach',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThanhSon',
    ),
  ],

  // ── Therapy ────────────────────────────────────
  'cat-5': const [
    BookingSpecialist(
      id: 'spec-9',
      name: 'Dr. Lan Bui',
      specialty: 'Physical Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Lan',
    ),
    BookingSpecialist(
      id: 'spec-10',
      name: 'Khoa Vu',
      specialty: 'Rehab Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Khoa',
    ),
    BookingSpecialist(
      id: 'spec-20',
      name: 'Dr. My Hanh',
      specialty: 'Acupuncturist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=MyHanh',
    ),
  ],

  // ── Medical ────────────────────────────────────
  'cat-6': const [
    BookingSpecialist(
      id: 'spec-11',
      name: 'Dr. Bao Hoang',
      specialty: 'General Physician',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Bao',
    ),
    BookingSpecialist(
      id: 'spec-21',
      name: 'Dr. Van Khanh',
      specialty: 'Family Doctor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=VanKhanh',
    ),
    BookingSpecialist(
      id: 'spec-22',
      name: 'Dr. Quoc Dat',
      specialty: 'Internist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=QuocDat',
    ),
  ],
};

// ─── Service → Specialist mappings ────────────────

/// Mock specialists grouped by service ID.
///
/// Used when navigating from Service Details
/// to Select Specialist.
final Map<String, List<BookingSpecialist>> kMockSpecialistsByService = {
  // ── Employee-detail: Dermatology services ─────
  'svc-derm-1': const [
    BookingSpecialist(
      id: 'emp-doctor-1',
      name: 'Dr. Nguyen Van A',
      specialty: 'Senior Doctor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=VanA',
    ),
    BookingSpecialist(
      id: 'spec-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Spa Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Anna',
    ),
  ],
  'svc-derm-2': const [
    BookingSpecialist(
      id: 'emp-doctor-1',
      name: 'Dr. Nguyen Van A',
      specialty: 'Senior Doctor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=VanA',
    ),
  ],
  'svc-derm-3': const [
    BookingSpecialist(
      id: 'emp-doctor-1',
      name: 'Dr. Nguyen Van A',
      specialty: 'Senior Doctor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=VanA',
    ),
  ],
  'svc-derm-4': const [
    BookingSpecialist(
      id: 'emp-doctor-1',
      name: 'Dr. Nguyen Van A',
      specialty: 'Senior Doctor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=VanA',
    ),
  ],

  // ── Employee-detail: Therapy services ─────────
  'svc-ther-1': const [
    BookingSpecialist(
      id: 'emp-therapist-1',
      name: 'Tran Thi B',
      specialty: 'Senior Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThiB',
    ),
    BookingSpecialist(
      id: 'spec-9',
      name: 'Dr. Lan Bui',
      specialty: 'Physical Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Lan',
    ),
  ],
  'svc-ther-2': const [
    BookingSpecialist(
      id: 'emp-therapist-1',
      name: 'Tran Thi B',
      specialty: 'Senior Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThiB',
    ),
  ],
  'svc-ther-3': const [
    BookingSpecialist(
      id: 'emp-therapist-1',
      name: 'Tran Thi B',
      specialty: 'Senior Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThiB',
    ),
  ],
  'svc-ther-4': const [
    BookingSpecialist(
      id: 'emp-therapist-1',
      name: 'Tran Thi B',
      specialty: 'Senior Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=ThiB',
    ),
  ],

  // ── Spa services ──────────────────────────────
  'service-laser-co2': const [
    BookingSpecialist(
      id: 'spec-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Spa Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Anna',
    ),
    BookingSpecialist(
      id: 'spec-2',
      name: 'Dr. Minh Tran',
      specialty: 'Massage Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Minh',
    ),
  ],
  'prod-1': const [
    BookingSpecialist(
      id: 'spec-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Spa Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Anna',
    ),
    BookingSpecialist(
      id: 'spec-2',
      name: 'Dr. Minh Tran',
      specialty: 'Massage Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Minh',
    ),
  ],
  'prod-5': const [
    BookingSpecialist(
      id: 'spec-3',
      name: 'Linh Pham',
      specialty: 'Aromatherapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Linh',
    ),
    BookingSpecialist(
      id: 'spec-1',
      name: 'Dr. Anna Nguyen',
      specialty: 'Spa Therapist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Anna',
    ),
  ],

  // ── Wellness services ─────────────────────────
  'prod-2': const [
    BookingSpecialist(
      id: 'spec-4',
      name: 'Dr. Hoa Le',
      specialty: 'Wellness Coach',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Hoa',
    ),
    BookingSpecialist(
      id: 'spec-5',
      name: 'Thu Dao',
      specialty: 'Yoga Instructor',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Thu',
    ),
  ],

  // ── Fitness services ──────────────────────────
  'prod-3': const [
    BookingSpecialist(
      id: 'spec-6',
      name: 'Coach Duc Vo',
      specialty: 'Personal Trainer',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=Duc',
    ),
    BookingSpecialist(
      id: 'spec-7',
      name: 'Coach Mai Ly',
      specialty: 'Fitness Specialist',
      avatarUrl:
          'https://api.dicebear.com/9.x/'
          'avataaars/svg?seed=MaiLy',
    ),
  ],
};

// ─── Specialist → Service mappings ────────────────

/// Mock services grouped by specialist ID.
final Map<String, List<BookingService>> kMockServicesBySpecialist = {
  // ── Employee-detail specialists ─────────────────
  'emp-doctor-1': const [
    BookingService(
      id: 'svc-derm-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1612349317150-e413f6a5b16d'
          '?w=400&h=250&fit=crop',
      title: 'Skin Consultation',
      duration: '30 min',
      price: '500,000 VND',
      clinicName: 'Glow Saigon Spa Retreat',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'svc-derm-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1570172619644-dfd03ed5d881'
          '?w=400&h=250&fit=crop',
      title: 'Laser CO2 Treatment',
      duration: '45 min',
      price: '1,800,000 VND',
      clinicName: 'Glow Saigon Spa Retreat',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'svc-derm-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1629909613654-28e377c37b09'
          '?w=400&h=250&fit=crop',
      title: 'Acne Scar Removal',
      duration: '60 min',
      price: '2,200,000 VND',
      clinicName: 'Glow Saigon Spa Retreat',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'svc-derm-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Mole & Skin Tag Removal',
      duration: '20 min',
      price: '600,000 VND',
      clinicName: 'Glow Saigon Spa Retreat',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
  ],
  'emp-therapist-1': const [
    BookingService(
      id: 'svc-ther-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=400&h=250&fit=crop',
      title: 'Deep Tissue Massage',
      duration: '60 min',
      price: '850,000 VND',
      clinicName: 'Zen Wellness Center',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
    BookingService(
      id: 'svc-ther-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1519823551278-64ac92734fb1'
          '?w=400&h=250&fit=crop',
      title: 'Sports Recovery Therapy',
      duration: '75 min',
      price: '1,100,000 VND',
      clinicName: 'Zen Wellness Center',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
    BookingService(
      id: 'svc-ther-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1600334089648-b0d9d3028eb2'
          '?w=400&h=250&fit=crop',
      title: 'Aromatherapy Session',
      duration: '60 min',
      price: '900,000 VND',
      clinicName: 'Zen Wellness Center',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
    BookingService(
      id: 'svc-ther-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1591343395082-e120087004b4'
          '?w=400&h=250&fit=crop',
      title: 'Rehabilitation Massage',
      duration: '50 min',
      price: '750,000 VND',
      clinicName: 'Zen Wellness Center',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
  ],

  // ── Spa specialists ────────────────────────────
  'spec-1': const [
    BookingService(
      id: 'prod-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=400&h=250&fit=crop',
      title: 'Deep Tissue Massage',
      duration: '60 min',
      price: '850,000 VND',
      clinicName: 'Healytics Spa & Wellness',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'prod-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1600334089648-b0d9d3028eb2'
          '?w=400&h=250&fit=crop',
      title: 'Hot Stone Therapy',
      duration: '90 min',
      price: '1,200,000 VND',
      clinicName: 'Healytics Spa & Wellness',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'svc-spa-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1519823551278-64ac92734fb1'
          '?w=400&h=250&fit=crop',
      title: 'Swedish Massage',
      duration: '60 min',
      price: '750,000 VND',
      clinicName: 'Healytics Spa & Wellness',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
  ],
  'spec-2': const [
    BookingService(
      id: 'prod-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1544161515-4ab6ce6db874'
          '?w=400&h=250&fit=crop',
      title: 'Deep Tissue Massage',
      duration: '60 min',
      price: '850,000 VND',
      clinicName: 'Zen Body Studio',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
    BookingService(
      id: 'svc-spa-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1591343395082-e120087004b4'
          '?w=400&h=250&fit=crop',
      title: 'Sports Recovery Massage',
      duration: '75 min',
      price: '950,000 VND',
      clinicName: 'Zen Body Studio',
      clinicAddress: '45 Le Loi, D1',
      distance: '2.5 km',
    ),
  ],
  'spec-3': const [
    BookingService(
      id: 'prod-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1600334089648-b0d9d3028eb2'
          '?w=400&h=250&fit=crop',
      title: 'Hot Stone Therapy',
      duration: '90 min',
      price: '1,200,000 VND',
      clinicName: 'Aroma Bliss Center',
      clinicAddress: '78 Hai Ba Trung, D3',
      distance: '3.1 km',
    ),
    BookingService(
      id: 'svc-spa-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1515377905703-c4788e51af15'
          '?w=400&h=250&fit=crop',
      title: 'Aromatherapy Massage',
      duration: '60 min',
      price: '800,000 VND',
      clinicName: 'Aroma Bliss Center',
      clinicAddress: '78 Hai Ba Trung, D3',
      distance: '3.1 km',
    ),
    BookingService(
      id: 'svc-spa-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1540555700478-4be289fbec6d'
          '?w=400&h=250&fit=crop',
      title: 'Essential Oil Wrap',
      duration: '45 min',
      price: '650,000 VND',
      clinicName: 'Aroma Bliss Center',
      clinicAddress: '78 Hai Ba Trung, D3',
      distance: '3.1 km',
    ),
  ],
  'spec-12': const [
    BookingService(
      id: 'svc-spa-7',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1570172619644-dfd03ed5d881'
          '?w=400&h=250&fit=crop',
      title: 'Hydrating Facial',
      duration: '50 min',
      price: '700,000 VND',
      clinicName: 'Glow Skin Lab',
      clinicAddress: '12 Pasteur, D1',
      distance: '0.8 km',
    ),
    BookingService(
      id: 'svc-spa-8',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1612349317150-e413f6a5b16d'
          '?w=400&h=250&fit=crop',
      title: 'Anti-Aging Treatment',
      duration: '60 min',
      price: '1,100,000 VND',
      clinicName: 'Glow Skin Lab',
      clinicAddress: '12 Pasteur, D1',
      distance: '0.8 km',
    ),
  ],
  'spec-13': const [
    BookingService(
      id: 'svc-spa-9',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1540555700478-4be289fbec6d'
          '?w=400&h=250&fit=crop',
      title: 'Full Body Scrub',
      duration: '45 min',
      price: '600,000 VND',
      clinicName: 'Pure Radiance Spa',
      clinicAddress: '99 Dong Khoi, D1',
      distance: '1.5 km',
    ),
    BookingService(
      id: 'svc-spa-10',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1515377905703-c4788e51af15'
          '?w=400&h=250&fit=crop',
      title: 'Detox Body Wrap',
      duration: '60 min',
      price: '900,000 VND',
      clinicName: 'Pure Radiance Spa',
      clinicAddress: '99 Dong Khoi, D1',
      distance: '1.5 km',
    ),
  ],

  // ── Wellness specialists ───────────────────────
  'spec-4': const [
    BookingService(
      id: 'prod-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=400&h=250&fit=crop',
      title: 'Yoga & Meditation',
      duration: '45 min',
      price: '450,000 VND',
      clinicName: 'Harmony Wellness Hub',
      clinicAddress: '200 Vo Van Tan, D3',
      distance: '2.0 km',
    ),
    BookingService(
      id: 'svc-well-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1545205597-3d9d02c29597'
          '?w=400&h=250&fit=crop',
      title: 'Stress Management',
      duration: '60 min',
      price: '500,000 VND',
      clinicName: 'Harmony Wellness Hub',
      clinicAddress: '200 Vo Van Tan, D3',
      distance: '2.0 km',
    ),
    BookingService(
      id: 'svc-well-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1571019613454-1cb2f99b2d8b'
          '?w=400&h=250&fit=crop',
      title: 'Wellness Assessment',
      duration: '30 min',
      price: '350,000 VND',
      clinicName: 'Harmony Wellness Hub',
      clinicAddress: '200 Vo Van Tan, D3',
      distance: '2.0 km',
    ),
  ],
  'spec-5': const [
    BookingService(
      id: 'prod-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=400&h=250&fit=crop',
      title: 'Yoga & Meditation',
      duration: '45 min',
      price: '450,000 VND',
      clinicName: 'Lotus Yoga Studio',
      clinicAddress: '88 Tran Hung Dao, D5',
      distance: '4.2 km',
    ),
    BookingService(
      id: 'svc-well-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1518611012118-696072aa579a'
          '?w=400&h=250&fit=crop',
      title: 'Power Yoga',
      duration: '60 min',
      price: '500,000 VND',
      clinicName: 'Lotus Yoga Studio',
      clinicAddress: '88 Tran Hung Dao, D5',
      distance: '4.2 km',
    ),
  ],
  'spec-14': const [
    BookingService(
      id: 'svc-well-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1490645935967-10de6ba17061'
          '?w=400&h=250&fit=crop',
      title: 'Nutrition Consultation',
      duration: '45 min',
      price: '400,000 VND',
      clinicName: 'NutriLife Center',
      clinicAddress: '55 Nguyen Thi Minh Khai, D1',
      distance: '1.8 km',
    ),
    BookingService(
      id: 'svc-well-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1512621776951-a57141f2eefd'
          '?w=400&h=250&fit=crop',
      title: 'Meal Plan Design',
      duration: '30 min',
      price: '300,000 VND',
      clinicName: 'NutriLife Center',
      clinicAddress: '55 Nguyen Thi Minh Khai, D1',
      distance: '1.8 km',
    ),
  ],
  'spec-15': const [
    BookingService(
      id: 'svc-well-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1545205597-3d9d02c29597'
          '?w=400&h=250&fit=crop',
      title: 'Guided Meditation',
      duration: '30 min',
      price: '250,000 VND',
      clinicName: 'ZenMind Space',
      clinicAddress: '33 Le Thanh Ton, D1',
      distance: '0.9 km',
    ),
    BookingService(
      id: 'svc-well-7',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1506126613408-eca07ce68773'
          '?w=400&h=250&fit=crop',
      title: 'Breathwork Session',
      duration: '40 min',
      price: '350,000 VND',
      clinicName: 'ZenMind Space',
      clinicAddress: '33 Le Thanh Ton, D1',
      distance: '0.9 km',
    ),
  ],

  // ── Fitness specialists ────────────────────────
  'spec-6': const [
    BookingService(
      id: 'prod-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1534438327276-14e5300c3a48'
          '?w=400&h=250&fit=crop',
      title: 'Personal Training',
      duration: '50 min',
      price: '600,000 VND',
      clinicName: 'FitZone Gym',
      clinicAddress: '77 Ly Tu Trong, D1',
      distance: '1.0 km',
    ),
    BookingService(
      id: 'svc-fit-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1517836357463-d25dfeac3438'
          '?w=400&h=250&fit=crop',
      title: 'HIIT Session',
      duration: '45 min',
      price: '550,000 VND',
      clinicName: 'FitZone Gym',
      clinicAddress: '77 Ly Tu Trong, D1',
      distance: '1.0 km',
    ),
    BookingService(
      id: 'svc-fit-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1571019613454-1cb2f99b2d8b'
          '?w=400&h=250&fit=crop',
      title: 'Body Composition',
      duration: '20 min',
      price: '200,000 VND',
      clinicName: 'FitZone Gym',
      clinicAddress: '77 Ly Tu Trong, D1',
      distance: '1.0 km',
    ),
  ],
  'spec-7': const [
    BookingService(
      id: 'prod-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1534438327276-14e5300c3a48'
          '?w=400&h=250&fit=crop',
      title: 'Personal Training',
      duration: '50 min',
      price: '600,000 VND',
      clinicName: 'CrossFit HCMC',
      clinicAddress: '150 Cach Mang Thang 8, D3',
      distance: '3.5 km',
    ),
    BookingService(
      id: 'svc-fit-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1526506118085-60ce8714f8c5'
          '?w=400&h=250&fit=crop',
      title: 'CrossFit Coaching',
      duration: '60 min',
      price: '650,000 VND',
      clinicName: 'CrossFit HCMC',
      clinicAddress: '150 Cach Mang Thang 8, D3',
      distance: '3.5 km',
    ),
  ],
  'spec-16': const [
    BookingService(
      id: 'svc-fit-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1517836357463-d25dfeac3438'
          '?w=400&h=250&fit=crop',
      title: 'Strength Training',
      duration: '60 min',
      price: '600,000 VND',
      clinicName: 'Iron Temple',
      clinicAddress: '22 Nguyen Dinh Chieu, D3',
      distance: '2.8 km',
    ),
    BookingService(
      id: 'svc-fit-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1526506118085-60ce8714f8c5'
          '?w=400&h=250&fit=crop',
      title: 'Olympic Lifting',
      duration: '60 min',
      price: '700,000 VND',
      clinicName: 'Iron Temple',
      clinicAddress: '22 Nguyen Dinh Chieu, D3',
      distance: '2.8 km',
    ),
  ],
  'spec-17': const [
    BookingService(
      id: 'svc-fit-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1518611012118-696072aa579a'
          '?w=400&h=250&fit=crop',
      title: 'Pilates Mat Class',
      duration: '50 min',
      price: '400,000 VND',
      clinicName: 'BodyFlow Pilates',
      clinicAddress: '66 Nam Ky Khoi Nghia, D1',
      distance: '1.3 km',
    ),
    BookingService(
      id: 'svc-fit-7',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1571019613454-1cb2f99b2d8b'
          '?w=400&h=250&fit=crop',
      title: 'Reformer Pilates',
      duration: '50 min',
      price: '550,000 VND',
      clinicName: 'BodyFlow Pilates',
      clinicAddress: '66 Nam Ky Khoi Nghia, D1',
      distance: '1.3 km',
    ),
  ],

  // ── Mental Health specialists ──────────────────
  'spec-8': const [
    BookingService(
      id: 'svc-mental-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1573497019940-1c28c88b4f3e'
          '?w=400&h=250&fit=crop',
      title: 'Counseling Session',
      duration: '60 min',
      price: '700,000 VND',
      clinicName: 'MindCare Clinic',
      clinicAddress: '10 Pham Ngoc Thach, D3',
      distance: '2.2 km',
    ),
    BookingService(
      id: 'svc-mental-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1527137342181-19aab11a8ee8'
          '?w=400&h=250&fit=crop',
      title: 'CBT Therapy',
      duration: '50 min',
      price: '800,000 VND',
      clinicName: 'MindCare Clinic',
      clinicAddress: '10 Pham Ngoc Thach, D3',
      distance: '2.2 km',
    ),
  ],
  'spec-18': const [
    BookingService(
      id: 'svc-mental-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1573497019940-1c28c88b4f3e'
          '?w=400&h=250&fit=crop',
      title: 'Anxiety Management',
      duration: '60 min',
      price: '750,000 VND',
      clinicName: 'ClearMind Therapy',
      clinicAddress: '40 Dien Bien Phu, Binh Thanh',
      distance: '5.0 km',
    ),
    BookingService(
      id: 'svc-mental-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1527137342181-19aab11a8ee8'
          '?w=400&h=250&fit=crop',
      title: 'Trauma-Focused Therapy',
      duration: '60 min',
      price: '900,000 VND',
      clinicName: 'ClearMind Therapy',
      clinicAddress: '40 Dien Bien Phu, Binh Thanh',
      distance: '5.0 km',
    ),
    BookingService(
      id: 'svc-mental-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1545205597-3d9d02c29597'
          '?w=400&h=250&fit=crop',
      title: 'EMDR Session',
      duration: '50 min',
      price: '850,000 VND',
      clinicName: 'ClearMind Therapy',
      clinicAddress: '40 Dien Bien Phu, Binh Thanh',
      distance: '5.0 km',
    ),
  ],
  'spec-19': const [
    BookingService(
      id: 'svc-mental-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1571019613454-1cb2f99b2d8b'
          '?w=400&h=250&fit=crop',
      title: 'Life Coaching',
      duration: '45 min',
      price: '500,000 VND',
      clinicName: 'Thrive Coaching Lab',
      clinicAddress: '18 Mac Dinh Chi, D1',
      distance: '1.6 km',
    ),
    BookingService(
      id: 'svc-mental-7',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1573497019940-1c28c88b4f3e'
          '?w=400&h=250&fit=crop',
      title: 'Career Counseling',
      duration: '45 min',
      price: '450,000 VND',
      clinicName: 'Thrive Coaching Lab',
      clinicAddress: '18 Mac Dinh Chi, D1',
      distance: '1.6 km',
    ),
  ],

  // ── Therapy specialists ────────────────────────
  'spec-9': const [
    BookingService(
      id: 'svc-therapy-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Rehabilitation Session',
      duration: '45 min',
      price: '550,000 VND',
      clinicName: 'PhysioPlus Rehab',
      clinicAddress: '25 Tran Quoc Toan, D3',
      distance: '2.7 km',
    ),
    BookingService(
      id: 'svc-therapy-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1629909613654-28e377c37b09'
          '?w=400&h=250&fit=crop',
      title: 'Post-Surgery Rehab',
      duration: '60 min',
      price: '700,000 VND',
      clinicName: 'PhysioPlus Rehab',
      clinicAddress: '25 Tran Quoc Toan, D3',
      distance: '2.7 km',
    ),
  ],
  'spec-10': const [
    BookingService(
      id: 'svc-therapy-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Rehabilitation Session',
      duration: '45 min',
      price: '550,000 VND',
      clinicName: 'ActiveLife Sports Med',
      clinicAddress: '60 Hoang Sa, D1',
      distance: '1.9 km',
    ),
    BookingService(
      id: 'svc-therapy-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1591343395082-e120087004b4'
          '?w=400&h=250&fit=crop',
      title: 'Sports Injury Recovery',
      duration: '50 min',
      price: '650,000 VND',
      clinicName: 'ActiveLife Sports Med',
      clinicAddress: '60 Hoang Sa, D1',
      distance: '1.9 km',
    ),
  ],
  'spec-20': const [
    BookingService(
      id: 'svc-therapy-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1512290923902-8a9f81dc236c'
          '?w=400&h=250&fit=crop',
      title: 'Acupuncture Session',
      duration: '40 min',
      price: '500,000 VND',
      clinicName: 'Golden Needle TCM',
      clinicAddress: '15 Nguyen Van Troi, PN',
      distance: '4.0 km',
    ),
    BookingService(
      id: 'svc-therapy-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1519823551278-64ac92734fb1'
          '?w=400&h=250&fit=crop',
      title: 'Cupping Therapy',
      duration: '30 min',
      price: '350,000 VND',
      clinicName: 'Golden Needle TCM',
      clinicAddress: '15 Nguyen Van Troi, PN',
      distance: '4.0 km',
    ),
    BookingService(
      id: 'svc-therapy-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1515377905703-c4788e51af15'
          '?w=400&h=250&fit=crop',
      title: 'Moxibustion Treatment',
      duration: '35 min',
      price: '400,000 VND',
      clinicName: 'Golden Needle TCM',
      clinicAddress: '15 Nguyen Van Troi, PN',
      distance: '4.0 km',
    ),
  ],

  // ── Medical specialists ────────────────────────
  'spec-11': const [
    BookingService(
      id: 'svc-medical-1',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1631217868264-e5b90bb7e133'
          '?w=400&h=250&fit=crop',
      title: 'General Checkup',
      duration: '30 min',
      price: '400,000 VND',
      clinicName: 'Healytics Medical',
      clinicAddress: '100 Le Lai, D1',
      distance: '0.5 km',
    ),
    BookingService(
      id: 'svc-medical-2',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Blood Pressure Check',
      duration: '15 min',
      price: '200,000 VND',
      clinicName: 'Healytics Medical',
      clinicAddress: '100 Le Lai, D1',
      distance: '0.5 km',
    ),
    BookingService(
      id: 'svc-medical-3',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1629909613654-28e377c37b09'
          '?w=400&h=250&fit=crop',
      title: 'Full Health Screening',
      duration: '120 min',
      price: '2,500,000 VND',
      clinicName: 'Healytics Medical',
      clinicAddress: '100 Le Lai, D1',
      distance: '0.5 km',
    ),
  ],
  'spec-21': const [
    BookingService(
      id: 'svc-medical-4',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1631217868264-e5b90bb7e133'
          '?w=400&h=250&fit=crop',
      title: 'Family Consultation',
      duration: '30 min',
      price: '350,000 VND',
      clinicName: 'FamilyCare Clinic',
      clinicAddress: '8 Truong Dinh, D3',
      distance: '3.0 km',
    ),
    BookingService(
      id: 'svc-medical-5',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Vaccination',
      duration: '15 min',
      price: '250,000 VND',
      clinicName: 'FamilyCare Clinic',
      clinicAddress: '8 Truong Dinh, D3',
      distance: '3.0 km',
    ),
  ],
  'spec-22': const [
    BookingService(
      id: 'svc-medical-6',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1631217868264-e5b90bb7e133'
          '?w=400&h=250&fit=crop',
      title: 'ECG / EKG Test',
      duration: '30 min',
      price: '500,000 VND',
      clinicName: 'HeartBeat Diagnostics',
      clinicAddress: '70 Nguyen Trai, D5',
      distance: '4.5 km',
    ),
    BookingService(
      id: 'svc-medical-7',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1576091160550-2173dba999ef'
          '?w=400&h=250&fit=crop',
      title: 'Lab Work & Blood Test',
      duration: '20 min',
      price: '600,000 VND',
      clinicName: 'HeartBeat Diagnostics',
      clinicAddress: '70 Nguyen Trai, D5',
      distance: '4.5 km',
    ),
    BookingService(
      id: 'svc-medical-8',
      imageUrl:
          'https://images.unsplash.com/'
          'photo-1612349317150-e413f6a5b16d'
          '?w=400&h=250&fit=crop',
      title: 'Internal Medicine Consult',
      duration: '45 min',
      price: '500,000 VND',
      clinicName: 'HeartBeat Diagnostics',
      clinicAddress: '70 Nguyen Trai, D5',
      distance: '4.5 km',
    ),
  ],
};

// ─── Category → Service mappings ──────────────────

/// Mock services grouped by category ID.
///
/// Aggregated from specialist→service data above,
/// deduplicated by service ID.
final Map<String, List<BookingService>> kMockServicesByCategory = {
  // ── Spa ────────────────────────────────────────
  'cat-1': const [
    BookingService(
      id: 'prod-1',
      title: 'Deep Tissue Massage',
      duration: '60 min',
      price: '850,000 VND',
      clinicName: 'Healytics Spa & Wellness',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'prod-5',
      title: 'Hot Stone Therapy',
      duration: '90 min',
      price: '1,200,000 VND',
      clinicName: 'Aroma Bliss Center',
      clinicAddress: '78 Hai Ba Trung, D3',
      distance: '3.1 km',
    ),
    BookingService(
      id: 'svc-spa-3',
      title: 'Swedish Massage',
      duration: '60 min',
      price: '750,000 VND',
      clinicName: 'Healytics Spa & Wellness',
      clinicAddress: '123 Nguyen Hue, D1',
      distance: '1.2 km',
    ),
    BookingService(
      id: 'svc-spa-5',
      title: 'Aromatherapy Massage',
      duration: '60 min',
      price: '800,000 VND',
      clinicName: 'Aroma Bliss Center',
      clinicAddress: '78 Hai Ba Trung, D3',
      distance: '3.1 km',
    ),
    BookingService(
      id: 'svc-spa-7',
      title: 'Hydrating Facial',
      duration: '50 min',
      price: '700,000 VND',
      clinicName: 'Glow Skin Lab',
      clinicAddress: '12 Pasteur, D1',
      distance: '0.8 km',
    ),
    BookingService(
      id: 'svc-spa-9',
      title: 'Full Body Scrub',
      duration: '45 min',
      price: '600,000 VND',
      clinicName: 'Pure Radiance Spa',
      clinicAddress: '99 Dong Khoi, D1',
      distance: '1.5 km',
    ),
  ],

  // ── Wellness ───────────────────────────────────
  'cat-2': const [
    BookingService(
      id: 'prod-2',
      title: 'Yoga & Meditation',
      duration: '45 min',
      price: '450,000 VND',
      clinicName: 'Harmony Wellness Hub',
      clinicAddress: '200 Vo Van Tan, D3',
      distance: '2.0 km',
    ),
    BookingService(
      id: 'svc-well-1',
      title: 'Stress Management',
      duration: '60 min',
      price: '500,000 VND',
      clinicName: 'Harmony Wellness Hub',
      clinicAddress: '200 Vo Van Tan, D3',
      distance: '2.0 km',
    ),
    BookingService(
      id: 'svc-well-4',
      title: 'Nutrition Consultation',
      duration: '45 min',
      price: '400,000 VND',
      clinicName: 'NutriLife Center',
      clinicAddress: '55 Nguyen Thi Minh Khai, D1',
      distance: '1.8 km',
    ),
    BookingService(
      id: 'svc-well-6',
      title: 'Guided Meditation',
      duration: '30 min',
      price: '250,000 VND',
      clinicName: 'ZenMind Space',
      clinicAddress: '33 Le Thanh Ton, D1',
      distance: '0.9 km',
    ),
  ],

  // ── Fitness ────────────────────────────────────
  'cat-3': const [
    BookingService(
      id: 'prod-3',
      title: 'Personal Training',
      duration: '50 min',
      price: '600,000 VND',
      clinicName: 'FitZone Gym',
      clinicAddress: '77 Ly Tu Trong, D1',
      distance: '1.0 km',
    ),
    BookingService(
      id: 'svc-fit-1',
      title: 'HIIT Session',
      duration: '45 min',
      price: '550,000 VND',
      clinicName: 'FitZone Gym',
      clinicAddress: '77 Ly Tu Trong, D1',
      distance: '1.0 km',
    ),
    BookingService(
      id: 'svc-fit-4',
      title: 'Strength Training',
      duration: '60 min',
      price: '600,000 VND',
      clinicName: 'Iron Temple',
      clinicAddress: '22 Nguyen Dinh Chieu, D3',
      distance: '2.8 km',
    ),
    BookingService(
      id: 'svc-fit-6',
      title: 'Pilates Mat Class',
      duration: '50 min',
      price: '400,000 VND',
      clinicName: 'BodyFlow Pilates',
      clinicAddress: '66 Nam Ky Khoi Nghia, D1',
      distance: '1.3 km',
    ),
  ],

  // ── Mental Health ──────────────────────────────
  'cat-4': const [
    BookingService(
      id: 'svc-mental-1',
      title: 'Counseling Session',
      duration: '60 min',
      price: '700,000 VND',
      clinicName: 'MindCare Clinic',
      clinicAddress: '10 Pham Ngoc Thach, D3',
      distance: '2.2 km',
    ),
    BookingService(
      id: 'svc-mental-3',
      title: 'Anxiety Management',
      duration: '60 min',
      price: '750,000 VND',
      clinicName: 'ClearMind Therapy',
      clinicAddress: '40 Dien Bien Phu, Binh Thanh',
      distance: '5.0 km',
    ),
    BookingService(
      id: 'svc-mental-6',
      title: 'Life Coaching',
      duration: '45 min',
      price: '500,000 VND',
      clinicName: 'Thrive Coaching Lab',
      clinicAddress: '18 Mac Dinh Chi, D1',
      distance: '1.6 km',
    ),
  ],

  // ── Therapy ────────────────────────────────────
  'cat-5': const [
    BookingService(
      id: 'svc-therapy-1',
      title: 'Rehabilitation Session',
      duration: '45 min',
      price: '550,000 VND',
      clinicName: 'PhysioPlus Rehab',
      clinicAddress: '25 Tran Quoc Toan, D3',
      distance: '2.7 km',
    ),
    BookingService(
      id: 'svc-therapy-4',
      title: 'Acupuncture Session',
      duration: '40 min',
      price: '500,000 VND',
      clinicName: 'Golden Needle TCM',
      clinicAddress: '15 Nguyen Van Troi, PN',
      distance: '4.0 km',
    ),
    BookingService(
      id: 'svc-therapy-5',
      title: 'Cupping Therapy',
      duration: '30 min',
      price: '350,000 VND',
      clinicName: 'Golden Needle TCM',
      clinicAddress: '15 Nguyen Van Troi, PN',
      distance: '4.0 km',
    ),
  ],

  // ── Medical ────────────────────────────────────
  'cat-6': const [
    BookingService(
      id: 'svc-medical-1',
      title: 'General Checkup',
      duration: '30 min',
      price: '400,000 VND',
      clinicName: 'Healytics Medical',
      clinicAddress: '100 Le Lai, D1',
      distance: '0.5 km',
    ),
    BookingService(
      id: 'svc-medical-4',
      title: 'Family Consultation',
      duration: '30 min',
      price: '350,000 VND',
      clinicName: 'FamilyCare Clinic',
      clinicAddress: '8 Truong Dinh, D3',
      distance: '3.0 km',
    ),
    BookingService(
      id: 'svc-medical-6',
      title: 'ECG / EKG Test',
      duration: '30 min',
      price: '500,000 VND',
      clinicName: 'HeartBeat Diagnostics',
      clinicAddress: '70 Nguyen Trai, D5',
      distance: '4.5 km',
    ),
  ],
};

// ─── Employee time-slot mock data ─────────────────

/// Default mock time-slot response used across
/// all specialists. In production the API returns
/// schedule specific to employee + date range.
<<<<<<< HEAD
final kMockEmployeeTimeSlots = EmployeeTimeSlotsEntity(
=======
final kMockEmployeeTimeSlots =
    EmployeeTimeSlotsEntity(
>>>>>>> origin/develop
  employeeId: 'mock-employee',
  employeeName: 'Mock Employee',
  slotDurationMinutes: 30,
  rangeStart: _mockDate(0),
  rangeEnd: _mockDate(6),
  schedule: List.generate(
    7,
    (i) => DayScheduleEntity(
      date: _mockDate(i),
      dayOfWeek: _mockDayOfWeek(i),
      isWorkingDay: i != 6, // Sunday off
      slots: i == 6
          ? const []
          : [
              TimeSlotEntity(
                label: '09:00 AM',
                time: '09:00',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '09:30 AM',
                time: '09:30',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '10:00 AM',
                time: '10:00',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '10:30 AM',
                time: '10:30',
                isAvailable: i != 1,
              ),
              TimeSlotEntity(
                label: '11:00 AM',
                time: '11:00',
                isAvailable: false,
              ),
              TimeSlotEntity(
                label: '11:30 AM',
                time: '11:30',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '02:00 PM',
                time: '14:00',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '02:30 PM',
                time: '14:30',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '03:00 PM',
                time: '15:00',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '03:30 PM',
                time: '15:30',
                isAvailable: i != 2,
              ),
              TimeSlotEntity(
                label: '04:00 PM',
                time: '16:00',
                isAvailable: true,
              ),
              TimeSlotEntity(
                label: '04:30 PM',
                time: '16:30',
                isAvailable: true,
              ),
            ],
    ),
  ),
);

/// Generates a YYYY-MM-DD date string [daysFromNow]
/// days from today.
String _mockDate(int daysFromNow) {
<<<<<<< HEAD
  final date = DateTime.now().add(Duration(days: daysFromNow));
=======
  final date =
      DateTime.now().add(Duration(days: daysFromNow));
>>>>>>> origin/develop
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Returns day-of-week name for [daysFromNow].
String _mockDayOfWeek(int daysFromNow) {
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
<<<<<<< HEAD
  final date = DateTime.now().add(Duration(days: daysFromNow));
=======
  final date =
      DateTime.now().add(Duration(days: daysFromNow));
>>>>>>> origin/develop
  // DateTime.weekday: 1 = Monday ... 7 = Sunday
  return days[date.weekday - 1];
}

// ─── Eligibility detail mock ──────────────────────

/// Mock eligibility detail returned by the mock
/// data source for any eligibility ID.
<<<<<<< HEAD
const kMockEligibilityDetail = EligibilityDetailEntity(
=======
const kMockEligibilityDetail =
    EligibilityDetailEntity(
>>>>>>> origin/develop
  isCompletedStep: true,
  specialist: EligibilitySpecialist(
    id: 'spec-1',
    name: 'Dr. Anna Nguyen',
    specialty: 'Spa Therapist',
    avatarUrl:
        'https://api.dicebear.com/9.x/'
        'avataaars/svg?seed=Anna',
  ),
  service: EligibilityService(
    id: 'prod-1',
    title: 'Deep Tissue Massage',
    subtitle: 'Full body relaxation therapy',
    duration: '60 min',
    imageUrl:
        'https://images.unsplash.com/'
        'photo-1544161515-4ab6ce6db874'
        '?w=400&h=250&fit=crop',
  ),
<<<<<<< HEAD
  category: EligibilityCategory(id: 'cat-1', name: 'Spa'),
  location: EligibilityLocation(
    name: 'Healytics Spa & Wellness',
    address:
        '123 Nguyen Hue, District 1, '
        'Ho Chi Minh City',
    latitude: 10.7758,
    longitude: 106.7009,
=======
  category: EligibilityCategory(
    id: 'cat-1',
    name: 'Spa',
  ),
  location: EligibilityLocation(
    name: 'Healytics Spa & Wellness',
    address: '123 Nguyen Hue, District 1, '
        'Ho Chi Minh City',
>>>>>>> origin/develop
  ),
  priceBreakdown: EligibilityPriceBreakdown(
    subTotal: 850000,
    discount: 50000,
    totalAmount: 800000,
    currency: 'VND',
  ),
);
