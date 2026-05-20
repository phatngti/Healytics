import { Role } from '@/account/enum/role.enum';
import { BookingStatus } from '@/booking/enums/booking-status.enum';
import {
  DocumentFileTypes,
  DocumentTypes,
  PartnerDocumentStatuses,
} from '@/common/entities/partner-document.entity';
import { EmployeeRole } from '@/employees/enum/employee-role.enum';
import { Gender } from '@/employees/enum/gender.enum';
import { HealthServiceStatus } from '@/health-service/enums/health-service-status.enum';
import { HealthServiceType } from '@/health-service/enums/health-service-type.enum';
import { StaffAssignmentType } from '@/health-service/enums/staff-assignment-type.enum';
import { BusinessType } from '@/partners/enum/business-type.enum';
import { IdType } from '@/partners/enum/id-type.enum';
import { PartnerVerificationStatus } from '@/partners/enum/partner-verification-status.enum';
import { PaymentMethod } from '@/payment-gateway/enums/payment-method.enum';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';

export const BULK_WELLNESS_PRODUCT_PREFIX = 'bulk-wellness';
export const BULK_WELLNESS_PARTNER_PREFIX = 'bulk.partner';
export const BULK_WELLNESS_EMPLOYEE_PREFIX = 'BULK-EMP';
export const BULK_WELLNESS_PRODUCT_COUNT = 1000;

const VN_PARTNER_PASSWORD = 'partner@123';
const USER_REVIEW_EMAILS = [
  'user@healytics.vn',
  'nguyenvana@healytics.vn',
  'tranthib@healytics.vn',
  'levanc@healytics.vn',
  'phamthid@healytics.vn',
  'hoangvane@healytics.vn',
  'vuthif@healytics.vn',
  'dangvang@healytics.vn',
  'buithih@healytics.vn',
  'ngothii@healytics.vn',
  'dovank@healytics.vn',
  'nguyenminh@healytics.vn',
  'lehoanglinh@healytics.vn',
  'phamquang@healytics.vn',
  'trandangthao@healytics.vn',
  'maianh@healytics.vn',
  'votuankiet@healytics.vn',
];

const hcmcWards = [
  { districtCode: '760', wardCode: '26740', district: 'Quận 1' },
  { districtCode: '770', wardCode: '27139', district: 'Quận 3' },
  { districtCode: '764', wardCode: '26911', district: 'Quận 5' },
  { districtCode: '765', wardCode: '26938', district: 'Quận 6' },
  { districtCode: '766', wardCode: '26965', district: 'Quận 8' },
  { districtCode: '767', wardCode: '27001', district: 'Quận 10' },
  { districtCode: '768', wardCode: '27043', district: 'Quận 11' },
  { districtCode: '769', wardCode: '27073', district: 'Quận 12' },
  { districtCode: '771', wardCode: '27181', district: 'Quận Bình Thạnh' },
  { districtCode: '772', wardCode: '27259', district: 'Quận Gò Vấp' },
  { districtCode: '773', wardCode: '27301', district: 'Quận Phú Nhuận' },
  { districtCode: '774', wardCode: '27337', district: 'Quận Tân Bình' },
];

const hanoiWards = [
  { districtCode: '001', wardCode: '00001', district: 'Quận Ba Đình' },
  { districtCode: '002', wardCode: '00037', district: 'Quận Hoàn Kiếm' },
  { districtCode: '003', wardCode: '00070', district: 'Quận Tây Hồ' },
  { districtCode: '004', wardCode: '00097', district: 'Quận Long Biên' },
  { districtCode: '005', wardCode: '00133', district: 'Quận Cầu Giấy' },
  { districtCode: '006', wardCode: '00160', district: 'Quận Đống Đa' },
  { districtCode: '007', wardCode: '00190', district: 'Quận Hai Bà Trưng' },
  { districtCode: '008', wardCode: '00220', district: 'Quận Hoàng Mai' },
  { districtCode: '009', wardCode: '00256', district: 'Quận Thanh Xuân' },
  { districtCode: '016', wardCode: '00478', district: 'Huyện Sóc Sơn' },
  { districtCode: '017', wardCode: '00493', district: 'Huyện Đông Anh' },
  { districtCode: '018', wardCode: '00526', district: 'Huyện Gia Lâm' },
];

const citySeeds = [
  ...Array.from({ length: 24 }, (_, index) => {
    const ward = hcmcWards[index % hcmcWards.length];
    return {
      cityKey: 'tphcm',
      cityName: 'TPHCM',
      provinceCode: '79',
      districtCode: ward.districtCode,
      wardCode: ward.wardCode,
      districtName: ward.district,
      lat: 10.76 + (index % 8) * 0.012,
      lng: 106.66 + Math.floor(index / 8) * 0.018,
    };
  }),
  ...Array.from({ length: 24 }, (_, index) => {
    const ward = hanoiWards[index % hanoiWards.length];
    return {
      cityKey: 'ha-noi',
      cityName: 'Hà Nội',
      provinceCode: '01',
      districtCode: ward.districtCode,
      wardCode: ward.wardCode,
      districtName: ward.district,
      lat: 21.0 + (index % 8) * 0.012,
      lng: 105.78 + Math.floor(index / 8) * 0.018,
    };
  }),
  ...[
    ['da-nang', 'Đà Nẵng', '48', '490', '20194', 'Quận Hải Châu', 16.0678, 108.2208],
    ['hai-phong', 'Hải Phòng', '31', '303', '11311', 'Quận Hồng Bàng', 20.8449, 106.6881],
    ['can-tho', 'Cần Thơ', '92', '916', '31117', 'Quận Ninh Kiều', 10.0452, 105.7469],
    ['hue', 'Huế', '46', '474', '19804', 'Thành phố Huế', 16.4637, 107.5909],
    ['khanh-hoa', 'Khánh Hòa', '56', '568', '22363', 'Thành phố Nha Trang', 12.2388, 109.1967],
    ['lam-dong', 'Lâm Đồng', '68', '672', '24778', 'Thành phố Đà Lạt', 11.9404, 108.4583],
    ['vung-tau', 'Bà Rịa - Vũng Tàu', '77', '747', '26506', 'Thành phố Vũng Tàu', 10.4114, 107.1362],
    ['binh-duong', 'Bình Dương', '74', '718', '25741', 'Thành phố Thủ Dầu Một', 10.9804, 106.6519],
    ['dong-nai', 'Đồng Nai', '75', '731', '25942', 'Thành phố Biên Hòa', 10.9574, 106.8426],
    ['quang-ninh', 'Quảng Ninh', '22', '193', '06637', 'Thành phố Hạ Long', 20.9712, 107.0448],
    ['nghe-an', 'Nghệ An', '40', '412', '16663', 'Thành phố Vinh', 18.6796, 105.6813],
    ['dak-lak', 'Đắk Lắk', '66', '643', '24121', 'Thành phố Buôn Ma Thuột', 12.6662, 108.0378],
    ['binh-dinh', 'Bình Định', '52', '540', '21595', 'Thành phố Quy Nhơn', 13.782, 109.219],
    ['quang-nam', 'Quảng Nam', '49', '502', '20335', 'Thành phố Hội An', 15.8801, 108.338],
    ['thanh-hoa', 'Thanh Hóa', '38', '380', '14725', 'Thành phố Thanh Hóa', 19.8067, 105.7852],
    ['thai-nguyen', 'Thái Nguyên', '19', '164', '05830', 'Thành phố Thái Nguyên', 21.5942, 105.8482],
  ].map(
    ([
      cityKey,
      cityName,
      provinceCode,
      districtCode,
      wardCode,
      districtName,
      lat,
      lng,
    ]) => ({
      cityKey: cityKey as string,
      cityName: cityName as string,
      provinceCode: provinceCode as string,
      districtCode: districtCode as string,
      wardCode: wardCode as string,
      districtName: districtName as string,
      lat: lat as number,
      lng: lng as number,
    }),
  ),
];

type WellnessDomain = {
  key: string;
  label: string;
  categorySlug: string;
  tags: string[];
  businessTypes: BusinessType[];
  nameRoots: string[];
  descriptions: string[];
  resources: string[];
  image: string;
  priceMin: number;
  priceMax: number;
  durations: number[];
  capacity: number;
  staffAssignmentType: StaffAssignmentType;
  employeeTitles: [string, string];
};

const wellnessDomains: WellnessDomain[] = [
  {
    key: 'massage-thu-gian',
    label: 'Massage thư giãn',
    categorySlug: 'relaxation-massage',
    tags: ['Thư giãn', 'Massage trị liệu'],
    businessTypes: [BusinessType.MASSAGE_THERAPY, BusinessType.SPA_BEAUTY],
    nameRoots: ['Aroma Relax', 'Deep Calm', 'Body Balance', 'Herbal Warm Oil'],
    descriptions: [
      'Liệu trình massage thư giãn giúp giảm căng cơ nhẹ, hỗ trợ tuần hoàn và tạo cảm giác phục hồi sau ngày dài.',
      'Không gian spa yên tĩnh với tinh dầu dịu nhẹ, phù hợp cho khách cần nghỉ ngơi và giải tỏa stress.',
    ],
    resources: ['Massage Room', 'Massage Oil Set'],
    image: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800',
    priceMin: 180000,
    priceMax: 1200000,
    durations: [45, 60, 75, 90],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.ANY,
    employeeTitles: ['Chuyên viên massage thư giãn', 'Kỹ thuật viên spa'],
  },
  {
    key: 'spa-cham-soc-da',
    label: 'Spa chăm sóc da',
    categorySlug: 'spa-beauty',
    tags: ['Chăm sóc da', 'Thư giãn'],
    businessTypes: [BusinessType.SPA_BEAUTY],
    nameRoots: ['Hydra Glow', 'Calm Skin', 'Bright Facial', 'Botanical Care'],
    descriptions: [
      'Chăm sóc da không xâm lấn gồm làm sạch, massage mặt, cấp ẩm và hướng dẫn chăm sóc tại nhà.',
      'Liệu trình spa nhẹ nhàng tập trung vào thư giãn, cấp ẩm và cải thiện cảm giác tươi mới cho làn da.',
    ],
    resources: ['Facial Treatment Room', 'Skincare Product Kit'],
    image: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800',
    priceMin: 220000,
    priceMax: 1500000,
    durations: [45, 60, 75, 90],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.ANY,
    employeeTitles: ['Chuyên viên chăm sóc da', 'Kỹ thuật viên spa'],
  },
  {
    key: 'vat-ly-tri-lieu',
    label: 'Vật lý trị liệu',
    categorySlug: 'rehabilitation-massage',
    tags: ['Vật lý trị liệu', 'Giảm đau', 'Phục hồi chức năng'],
    businessTypes: [BusinessType.MASSAGE_REHABILITATION],
    nameRoots: ['Mobility Restore', 'Neck Shoulder Care', 'Joint Ease', 'Posture Reset'],
    descriptions: [
      'Buổi trị liệu vận động nhẹ, kéo giãn và thư giãn cơ dành cho đau mỏi cơ xương khớp mức độ thông thường.',
      'Chuyên viên hướng dẫn bài tập phục hồi chức năng cơ bản, không thay thế chẩn đoán hay điều trị chuyên khoa.',
    ],
    resources: ['Therapy Room', 'Exercise Band Set'],
    image: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
    priceMin: 300000,
    priceMax: 1800000,
    durations: [45, 60, 75],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Kỹ thuật viên vật lý trị liệu', 'Chuyên viên phục hồi chức năng'],
  },
  {
    key: 'phuc-hoi-chuc-nang',
    label: 'Phục hồi chức năng',
    categorySlug: 'rehabilitation-massage',
    tags: ['Phục hồi chức năng', 'Vật lý trị liệu', 'Giảm đau'],
    businessTypes: [BusinessType.MASSAGE_REHABILITATION, BusinessType.FITNESS],
    nameRoots: ['Functional Recovery', 'Movement Reset', 'Balance Rehab', 'Active Recovery'],
    descriptions: [
      'Chương trình phục hồi vận động nhẹ cho khách cần cải thiện linh hoạt, thăng bằng và sức bền cơ bản.',
      'Buổi tập có giám sát với bài tập cá nhân hóa ở mức wellness, phù hợp sau mệt mỏi hoặc ít vận động.',
    ],
    resources: ['Recovery Studio', 'Mobility Equipment Set'],
    image: 'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=800',
    priceMin: 350000,
    priceMax: 2200000,
    durations: [60, 75, 90],
    capacity: 2,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Chuyên viên phục hồi chức năng', 'Huấn luyện viên phục hồi'],
  },
  {
    key: 'y-hoc-co-truyen',
    label: 'Y học cổ truyền',
    categorySlug: 'traditional-medicine',
    tags: ['Y học cổ truyền', 'Giảm đau', 'Thư giãn'],
    businessTypes: [BusinessType.TRADITIONAL_MEDICINE],
    nameRoots: ['Herbal Balance', 'Cupping Relax', 'Meridian Care', 'Warm Herbal Compress'],
    descriptions: [
      'Liệu trình chăm sóc theo y học cổ truyền ở mức hỗ trợ wellness như xoa bóp bấm huyệt, chườm thảo dược và thư giãn.',
      'Dịch vụ tập trung vào cân bằng cơ thể và giảm căng mỏi thông thường, không bao gồm kê đơn hay điều trị chuyên sâu.',
    ],
    resources: ['Traditional Therapy Room', 'Herbal Compress Kit'],
    image: 'https://images.unsplash.com/photo-1603398938378-e54eab446dde?w=800',
    priceMin: 250000,
    priceMax: 1600000,
    durations: [45, 60, 75],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Chuyên viên y học cổ truyền', 'Kỹ thuật viên bấm huyệt'],
  },
  {
    key: 'cham-soc-kinh-lac',
    label: 'Chăm sóc kinh lạc',
    categorySlug: 'acupuncture',
    tags: ['Y học cổ truyền', 'Giảm đau'],
    businessTypes: [BusinessType.TRADITIONAL_MEDICINE],
    nameRoots: ['Meridian Relax', 'Acupressure Balance', 'Energy Flow', 'Point Release'],
    descriptions: [
      'Chăm sóc huyệt đạo bằng bấm huyệt và thư giãn kinh lạc, không dùng thủ thuật xâm lấn hoặc kê đơn.',
      'Liệu trình wellness giúp giảm căng mỏi thường gặp và hỗ trợ cảm giác thư giãn toàn thân.',
    ],
    resources: ['Acupressure Room', 'Warm Towel Set'],
    image: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc236c?w=800',
    priceMin: 260000,
    priceMax: 1500000,
    durations: [45, 60, 75],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Chuyên viên bấm huyệt', 'Kỹ thuật viên chăm sóc kinh lạc'],
  },
  {
    key: 'tam-ly-tri-lieu',
    label: 'Tâm lý trị liệu',
    categorySlug: 'psychology-therapy',
    tags: ['Sức khỏe tinh thần', 'Thư giãn'],
    businessTypes: [BusinessType.PSYCHOLOGY],
    nameRoots: ['Stress Reset', 'Mindful Balance', 'Sleep Calm', 'Emotional Wellness'],
    descriptions: [
      'Buổi tham vấn tâm lý định hướng wellness, tập trung vào quản lý căng thẳng, giấc ngủ và kỹ năng tự chăm sóc.',
      'Không gian riêng tư cho khách trao đổi mục tiêu cảm xúc và xây dựng kế hoạch coping ngắn hạn.',
    ],
    resources: ['Private Counseling Room', 'Wellness Journal Set'],
    image: 'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=800',
    priceMin: 450000,
    priceMax: 2500000,
    durations: [50, 60, 75],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Chuyên viên tham vấn tâm lý', 'Chuyên viên sức khỏe tinh thần'],
  },
  {
    key: 'yoga-phuc-hoi',
    label: 'Yoga phục hồi',
    categorySlug: 'yoga-recovery',
    tags: ['Yoga phục hồi', 'Phục hồi chức năng', 'Thư giãn'],
    businessTypes: [BusinessType.FITNESS, BusinessType.MASSAGE_REHABILITATION],
    nameRoots: ['Restorative Yoga', 'Mobility Yoga', 'Breath Flow', 'Gentle Stretch'],
    descriptions: [
      'Lớp yoga phục hồi nhịp chậm, kết hợp thở, kéo giãn và thư giãn sâu cho dân văn phòng hoặc người vận động nhiều.',
      'Buổi tập nhóm nhỏ giúp cải thiện linh hoạt, thả lỏng cơ và phục hồi năng lượng.',
    ],
    resources: ['Yoga Mat', 'Stretch Strap'],
    image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
    priceMin: 120000,
    priceMax: 900000,
    durations: [45, 60, 75, 90],
    capacity: 8,
    staffAssignmentType: StaffAssignmentType.ANY,
    employeeTitles: ['Huấn luyện viên yoga phục hồi', 'Chuyên viên vận động trị liệu'],
  },
  {
    key: 'dinh-duong-wellness',
    label: 'Dinh dưỡng wellness',
    categorySlug: 'nutrition-counseling',
    tags: ['Dinh dưỡng', 'Sức khỏe tinh thần'],
    businessTypes: [BusinessType.NUTRITION],
    nameRoots: ['Balanced Meal Plan', 'Energy Nutrition', 'Lifestyle Nutrition', 'Healthy Habit'],
    descriptions: [
      'Tư vấn dinh dưỡng wellness dựa trên thói quen ăn uống, mục tiêu năng lượng và lối sống hằng ngày.',
      'Chuyên viên xây dựng gợi ý thực đơn cân bằng, không kê đơn thuốc hoặc điều trị bệnh lý chuyên khoa.',
    ],
    resources: ['Consultation Room', 'Nutrition Planning Kit'],
    image: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
    priceMin: 250000,
    priceMax: 1600000,
    durations: [45, 60, 75],
    capacity: 1,
    staffAssignmentType: StaffAssignmentType.SPECIFIC,
    employeeTitles: ['Chuyên viên dinh dưỡng wellness', 'Tư vấn viên lối sống lành mạnh'],
  },
];

export const BULK_WELLNESS_TAGS = [
  { name: 'Thư giãn', description: 'Dịch vụ thư giãn và phục hồi năng lượng', colorValue: '#FF2E7D32' },
  { name: 'Giảm đau', description: 'Hỗ trợ giảm đau mỏi thông thường', colorValue: '#FFEF6C00' },
  { name: 'Phục hồi chức năng', description: 'Hỗ trợ phục hồi vận động và chức năng cơ bản', colorValue: '#FF00838F' },
  { name: 'Massage trị liệu', description: 'Massage trị liệu và chăm sóc cơ', colorValue: '#FF6D4C41' },
  { name: 'Chăm sóc da', description: 'Chăm sóc da spa không xâm lấn', colorValue: '#FFC2185B' },
  { name: 'Y học cổ truyền', description: 'Chăm sóc wellness theo y học cổ truyền', colorValue: '#FF795548' },
  { name: 'Vật lý trị liệu', description: 'Vật lý trị liệu và vận động trị liệu cơ bản', colorValue: '#FF1565C0' },
  { name: 'Sức khỏe tinh thần', description: 'Tham vấn và chăm sóc sức khỏe tinh thần', colorValue: '#FF546E7A' },
  { name: 'Dinh dưỡng', description: 'Tư vấn dinh dưỡng và lối sống lành mạnh', colorValue: '#FF7CB342' },
  { name: 'Yoga phục hồi', description: 'Yoga phục hồi, thở và kéo giãn', colorValue: '#FF00695C' },
];

const slugify = (input: string): string =>
  input
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[đĐ]/g, 'd')
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');

const roundTo = (value: number, unit: number): number =>
  Math.round(value / unit) * unit;

const daysAgo = (n: number, hour = 10, minute = 0): Date => {
  const d = new Date();
  d.setDate(d.getDate() - n);
  d.setHours(hour, minute, 0, 0);
  return d;
};

const domainForIndex = (index: number): WellnessDomain =>
  wellnessDomains[index % wellnessDomains.length];

export const BULK_WELLNESS_PARTNERS = citySeeds.map((city, index) => {
  const domain = domainForIndex(index);
  const ordinal = String(index + 1).padStart(2, '0');
  const taxCode = `8800${String(index + 1).padStart(6, '0')}`;
  const brandName = `${domain.label} ${city.cityName} ${ordinal}`;

  return {
    accountEmail: `${BULK_WELLNESS_PARTNER_PREFIX}.${ordinal}@healytics.vn`,
    taxCode,
    legalName: `Công ty TNHH ${brandName}`,
    brandName,
    businessType: domain.businessTypes,
    streetAddress: `${24 + index} ${index % 2 === 0 ? 'Nguyễn Trãi' : 'Lê Lợi'}, ${city.districtName}`,
    phoneNumber: `09${String(70000000 + index).padStart(8, '0')}`,
    verificationStatus: PartnerVerificationStatus.APPROVED,
    coordinates: `${(city.lat + (index % 3) * 0.002).toFixed(6)},${(city.lng + (index % 4) * 0.002).toFixed(6)}`,
    coverImageUrl: domain.image.replace('w=800', 'w=1200'),
    logoImageUrl: `https://api.dicebear.com/9.x/initials/svg?seed=${encodeURIComponent(brandName)}`,
    gallery: [
      domain.image.replace('w=800', 'w=900'),
      'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=900',
      'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=900',
    ],
    description: `${brandName} cung cấp các dịch vụ ${domain.label.toLowerCase()} theo hướng wellness, không bao gồm thủ thuật chuyên sâu, phẫu thuật hoặc kê đơn chuyên khoa.`,
    followerCount: 80 + ((index * 37) % 900),
    address: {
      provinceCode: city.provinceCode,
      districtCode: city.districtCode,
      wardCode: city.wardCode,
    },
    legalRepresentative: {
      fullName: `Nguyễn Đại Diện ${ordinal}`,
      position: 'Giám đốc',
      idType: IdType.CITIZEN_ID,
      idNumber: `0${String(79000000000 + index)}`,
      idIssueDate: '2022-01-15',
      phoneNumber: `09${String(80000000 + index).padStart(8, '0')}`,
    },
    documents: [
      {
        documentKey: `partners/${taxCode}/business-license.pdf`,
        fileUrl: `https://storage.healytics.vn/partners/${taxCode}/business-license.pdf`,
        type: DocumentTypes.BUSINESS_LICENSE,
        fileType: DocumentFileTypes.PDF,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: `partners/${taxCode}/id-front.jpg`,
        fileUrl: `https://storage.healytics.vn/partners/${taxCode}/id-front.jpg`,
        type: DocumentTypes.IDENTITY_FRONT,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
      {
        documentKey: `partners/${taxCode}/id-back.jpg`,
        fileUrl: `https://storage.healytics.vn/partners/${taxCode}/id-back.jpg`,
        type: DocumentTypes.IDENTITY_BACK,
        fileType: DocumentFileTypes.IMAGE,
        status: PartnerDocumentStatuses.ACCEPTED,
      },
    ],
  };
});

export const BULK_WELLNESS_PARTNER_ACCOUNTS = BULK_WELLNESS_PARTNERS.map(
  (partner) => ({
    email: partner.accountEmail,
    password: VN_PARTNER_PASSWORD,
    role: Role.HEALTH_PARTNER,
  }),
);

export const BULK_WELLNESS_EMPLOYEES = BULK_WELLNESS_PARTNERS.flatMap(
  (partner, partnerIndex) => {
    const domain = domainForIndex(partnerIndex);
    return [0, 1].map((employeeIndex) => {
      const sequence = partnerIndex * 2 + employeeIndex + 1;
      const code = `${BULK_WELLNESS_EMPLOYEE_PREFIX}-${String(sequence).padStart(3, '0')}`;
      const isLead = employeeIndex === 0;
      const title = domain.employeeTitles[employeeIndex];
      return {
        employeeCode: code,
        partnerTaxCode: partner.taxCode,
        firstName: isLead ? 'Minh' : 'Lan',
        lastName: `Wellness ${String(sequence).padStart(3, '0')}`,
        email: `${code.toLowerCase()}@healytics.vn`,
        phone: `09${String(60000000 + sequence).padStart(8, '0')}`,
        avatarUrl: `https://api.dicebear.com/9.x/avataaars/svg?seed=${code}`,
        jobTitle: title,
        role: EmployeeRole.THERAPIST,
        gender: isLead ? Gender.MALE : Gender.FEMALE,
        dob: new Date(isLead ? '1988-04-12' : '1992-09-20'),
        startDate: new Date('2023-02-01'),
        employmentType: 'Full-time',
        description: `${title} tại ${partner.brandName}, phụ trách các dịch vụ wellness không xâm lấn và chăm sóc phục hồi cơ bản.`,
        schedule: [
          { day: 'Monday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Tuesday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Wednesday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Thursday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Friday', start: '08:00', end: '17:00', isWorking: true },
          { day: 'Saturday', start: '09:00', end: '13:00', isWorking: true },
          { day: 'Sunday', start: '00:00', end: '00:00', isWorking: false },
        ],
        workHistory: [
          {
            facility: partner.brandName,
            position: title,
            period: '2023-Present',
            isCurrent: true,
          },
        ],
      };
    });
  },
);

const productForIndex = (index: number) => {
  const domain = domainForIndex(index);
  const partner = BULK_WELLNESS_PARTNERS[index % BULK_WELLNESS_PARTNERS.length];
  const city = citySeeds[index % citySeeds.length];
  const ordinal = String(index + 1).padStart(4, '0');
  const nameRoot = domain.nameRoots[index % domain.nameRoots.length];
  const duration =
    domain.durations[(index + Math.floor(index / 7)) % domain.durations.length];
  const priceRange = domain.priceMax - domain.priceMin;
  const basePrice = roundTo(
    domain.priceMin + ((index * 7919) % priceRange),
    10000,
  );
  const salePrice =
    index % 4 === 0 ? roundTo(basePrice * (0.82 + (index % 3) * 0.03), 10000) : undefined;
  const slug = `${BULK_WELLNESS_PRODUCT_PREFIX}-${domain.key}-${city.cityKey}-${ordinal}`;
  const employeeOffset = (index % BULK_WELLNESS_PARTNERS.length) * 2;
  const primaryEmployee = BULK_WELLNESS_EMPLOYEES[employeeOffset];
  const secondaryEmployee = BULK_WELLNESS_EMPLOYEES[employeeOffset + 1];

  return {
    name: `${nameRoot} ${city.cityName} ${ordinal}`,
    slug,
    description: `${domain.descriptions[index % domain.descriptions.length]} Dịch vụ thuộc nhóm ${domain.label.toLowerCase()} tại ${partner.brandName}, phù hợp đặt lịch wellness hằng ngày.`,
    type: HealthServiceType.SERVICE,
    basePrice,
    salePrice,
    categorySlug: domain.categorySlug,
    partnerTaxCode: partner.taxCode,
    media: [
      { url: domain.image, isThumbnail: true, sortOrder: 0 },
      {
        url: 'https://images.unsplash.com/photo-1540555700478-4be289fbec6e?w=800',
        isThumbnail: false,
        sortOrder: 1,
      },
    ],
    serviceDefinition: {
      durationMinutes: duration,
      bufferMinutes: index % 3 === 0 ? 15 : 10,
      maxCapacity: domain.capacity,
      minLeadTimeHours: 2 + (index % 6),
      staffAssignmentType: domain.staffAssignmentType,
    },
    resourceRequirements: domain.resources.map((resourceTypeName, resourceIndex) => ({
      resourceTypeName,
      quantityRequired: resourceIndex === 0 ? 1 : domain.capacity > 1 ? 2 : 1,
    })),
    serviceManual: {
      preServiceGuidelines: [
        'Đến sớm 10 phút để hoàn tất tiếp nhận.',
        'Thông báo cho chuyên viên nếu có vùng đau mỏi hoặc tình trạng cần lưu ý.',
        'Dịch vụ không thay thế chẩn đoán hoặc điều trị chuyên khoa.',
      ],
      serviceRules: [
        {
          iconSlug: 'arrive-early',
          title: 'Đến sớm',
          description: 'Vui lòng đến sớm để chuẩn bị và trao đổi nhu cầu chăm sóc.',
        },
        {
          iconSlug: 'communicate',
          title: 'Trao đổi rõ nhu cầu',
          description: 'Chia sẻ mức độ thoải mái để chuyên viên điều chỉnh phù hợp.',
        },
      ],
      procedureSteps: [
        {
          stepNumber: 1,
          title: 'Tiếp nhận nhu cầu',
          description: 'Chuyên viên ghi nhận mục tiêu wellness và tình trạng cơ bản.',
        },
        {
          stepNumber: 2,
          title: 'Thực hiện liệu trình',
          description: `Thực hiện ${domain.label.toLowerCase()} trong ${duration} phút.`,
        },
        {
          stepNumber: 3,
          title: 'Hướng dẫn sau buổi',
          description: 'Nhận gợi ý tự chăm sóc, nghỉ ngơi và lịch hẹn tiếp theo nếu cần.',
        },
      ],
    },
    tagNames: domain.tags,
    eligibleEmployees: [
      { code: primaryEmployee.employeeCode, isPrimary: true },
      { code: secondaryEmployee.employeeCode, isPrimary: false },
    ],
    facilityImages: [
      {
        imageUrl: domain.image.replace('w=800', 'w=600'),
        label: `${domain.label} Room`,
        sortOrder: 0,
      },
    ],
    reviewProfile: {
      userEmails: USER_REVIEW_EMAILS,
      primaryStaffCode: primaryEmployee.employeeCode,
      secondaryStaffCode: secondaryEmployee.employeeCode,
      reviewCount:
        index % 20 === 0
          ? 30
          : index % 10 === 0
            ? 15
            : 1 + (index % 5),
      baseRatingPattern: [5, 5, 4, 5, 4, 3, 5, 4, 5, 4],
      paymentAmount: salePrice ?? basePrice,
    },
  };
};

export const BULK_WELLNESS_PRODUCTS = Array.from(
  { length: BULK_WELLNESS_PRODUCT_COUNT },
  (_, index) => productForIndex(index),
);

export const BULK_WELLNESS_APPOINTMENTS = BULK_WELLNESS_PRODUCTS.flatMap(
  (product, productIndex) =>
    Array.from({ length: product.reviewProfile.reviewCount }, (_, reviewIndex) => {
      const pattern = product.reviewProfile.baseRatingPattern;
      const rating = pattern[(productIndex + reviewIndex) % pattern.length];
      const staffCode =
        reviewIndex % 3 === 0
          ? product.reviewProfile.secondaryStaffCode
          : product.reviewProfile.primaryStaffCode;
      const startTime = daysAgo(
        35 + ((productIndex * 11 + reviewIndex) % 330),
        8 + (reviewIndex % 8),
        (productIndex * 7 + reviewIndex * 11) % 50,
      );
      const endTime = new Date(
        startTime.getTime() +
          (product.serviceDefinition.durationMinutes + 10) * 60 * 1000,
      );
      const idempotencyKey = `BULK-SVC-${String(productIndex + 1).padStart(4, '0')}-${String(reviewIndex + 1).padStart(2, '0')}`;

      return {
        idempotencyKey,
        userEmail:
          product.reviewProfile.userEmails[
            (productIndex + reviewIndex) % product.reviewProfile.userEmails.length
          ],
        staffCode,
        productSlug: product.slug,
        startTime,
        endTime,
        status: BookingStatus.COMPLETED,
        isReviewed: true,
        notes: `Bulk wellness completed booking ${idempotencyKey}`,
        payment: {
          method:
            reviewIndex % 3 === 0
              ? PaymentMethod.CASH
              : reviewIndex % 3 === 1
                ? PaymentMethod.MOMO
                : PaymentMethod.VNPAY,
          status: PaymentStatus.PAID,
          amount: product.reviewProfile.paymentAmount,
          paidAt: endTime,
        },
        statusLogs: [
          {
            fromStatus: null,
            toStatus: BookingStatus.PENDING_PAYMENT,
            changedBy: 'system',
          },
          {
            fromStatus: BookingStatus.PENDING_PAYMENT,
            toStatus: BookingStatus.CONFIRMED,
            changedBy: 'system',
          },
          {
            fromStatus: BookingStatus.CONFIRMED,
            toStatus: BookingStatus.COMPLETED,
            changedBy: `staff:${staffCode}`,
          },
        ],
        treatmentReview: {
          rating,
          comment:
            rating >= 5
              ? 'Dịch vụ rất tốt, chuyên viên chu đáo và không gian sạch sẽ.'
              : rating === 4
                ? 'Trải nghiệm tốt, liệu trình rõ ràng và đúng thời lượng.'
                : 'Dịch vụ ổn, phù hợp nhu cầu thư giãn cơ bản.',
          tags:
            rating >= 5
              ? ['Chuyên nghiệp', 'Sạch sẽ', 'Thư giãn']
              : rating === 4
                ? ['Đúng giờ', 'Thân thiện']
                : ['Ổn định'],
          photoUrls: [],
        },
        specialistReview: {
          rating,
          comment:
            rating >= 4
              ? 'Chuyên viên tư vấn rõ ràng, thao tác cẩn thận và theo sát cảm nhận của khách.'
              : 'Chuyên viên hỗ trợ đầy đủ, cần cải thiện thêm phần hướng dẫn sau buổi.',
          tags:
            rating >= 4
              ? ['Tận tâm', 'Kỹ năng tốt']
              : ['Thân thiện'],
          wouldRecommend: rating >= 4,
        },
      };
    }),
);

if (BULK_WELLNESS_PRODUCTS.length !== BULK_WELLNESS_PRODUCT_COUNT) {
  throw new Error(
    `Expected ${BULK_WELLNESS_PRODUCT_COUNT} bulk wellness products, got ${BULK_WELLNESS_PRODUCTS.length}`,
  );
}
