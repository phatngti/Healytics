// Mock data for the service manual feature.
//
// Mirrors the HTML reference content (Vietnamese text).

import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';

/// Returns mock [ServiceManualEntity] keyed by
/// appointment ID. All IDs share the same manual
/// for demo purposes.
ServiceManualEntity getMockServiceManual(String appointmentId) {
  return const ServiceManualEntity(
    serviceName: 'Swedish Relax',
    vendorName: 'Glow Saigon',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuDAV7ffDZ8xgx6Yc7OlQbOpkt91mpf5NlR_-UCY'
        '-7YrCtg8J6tWRPGhQL6qxlC8zPYcKCehGr6WpzgCb1NN'
        'J5vegIyMLocAW0lyMSHgu_JHSbamiiFJ7sUT3n4ZylYrl'
        'aqb27JGV_Ij1yWHGC_j7UOsi4LYgRG7VoA6Qmb9evt5'
        'PCeFpI2DBPZ67EtYid1bn-NW6tnmEpKMc4KwBXEHyP6-'
        'H__fQAQwqIFD5bXtI6qVlJCFGtPh9Q4_1C8CkYUaUT8T'
        'bixCOiMQMYqF',
    preServiceGuidelines: [
      'Vui lòng đến trước 15 phút để hoàn tất '
          'thủ tục check-in và thay trang phục.',
      'Uống đủ nước trước khi bắt đầu liệu trình '
          'để hỗ trợ quá trình thải độc.',
      'Thông báo tình trạng sức khỏe đặc biệt '
          'cho trị liệu viên.',
    ],
    serviceRules: [
      ServiceRuleEntity(
        iconSlug: 'volume_off',
        title: 'Yên lặng',
        description:
            'Vui lòng tắt chuông điện thoại để '
            'duy trì không gian thư giãn.',
      ),
      ServiceRuleEntity(
        iconSlug: 'event_busy',
        title: 'Hủy lịch',
        description:
            'Hủy trước 4 giờ để không '
            'mất phí đặt cọc.',
      ),
    ],
    procedureSteps: [
      ProcedureStepEntity(
        stepNumber: 1,
        title: 'Consultation',
        description: 'Tư vấn chọn tinh dầu và kiểm tra da.',
      ),
      ProcedureStepEntity(
        stepNumber: 2,
        title: 'Preparation',
        description: 'Thay trang phục, ngâm chân thảo dược.',
      ),
      ProcedureStepEntity(
        stepNumber: 3,
        title: 'Massage',
        description: '60 phút trị liệu Thụy Điển chuyên sâu.',
        isActive: true,
      ),
      ProcedureStepEntity(
        stepNumber: 4,
        title: 'Relaxation',
        description: 'Thư giãn với khăn nóng và đắp mắt.',
      ),
      ProcedureStepEntity(
        stepNumber: 5,
        title: 'Aftercare',
        description: 'Thưởng thức trà thảo mộc và bánh ngọt.',
      ),
    ],
    facilities: [
      FacilityEntity(
        imageUrl:
            'https://lh3.googleusercontent.com/'
            'aida-public/AB6AXuDXr91M9zc7hOZCEcbw5ZMR'
            'hXzvFphdmfjLGt6GHCwIuLtL5nZKa5RTsD4zPAe03'
            'uaUDOzA_tdbRJz5EDC3--3rXQ4GhefBU_7CAzGlnB'
            '_GLcSbuDnQKM_yzcTjjzadwb3i-DHZ04k9bEIQAPT-'
            'iOolk15oOORBPUdD_RW2zg75Xc6KlHCFvRVtQmeQ7y'
            'P1tYXToSKHd5bSUeyZ-PstfJ3a2f-p-Ukw7HkW_Me'
            'Umq_TjDwOZDndANGVJmkrw4mnFY_5KfRnbUoirY0y',
        name: 'Private Suite',
      ),
      FacilityEntity(
        imageUrl:
            'https://lh3.googleusercontent.com/'
            'aida-public/AB6AXuDk4uaCsGINbgrArAKGDI-O'
            'yNsL5RnjKwAwmZ5AxMSgptnDtCq31nRqh-f8E5fRz'
            'zZ5ovpRgaYIxVricS7icKX5V0KWwF18QKe4n0QyaJX'
            'gp2JiIBSVXHra0DBnGhRVIBSPSavWHP63UPskvuRB-'
            'We6dsMgYeb5aS0-EaaXJoMuVBvUmJn9GhT9AMiwm1q'
            'KANXdwRwVmOmIY2M0eHq8mCY3tRyd2x9laYlqxnMY'
            'vatkopwrz0P7cuXODnw73bvtJbhJ9WQYaa5GhF1x',
        name: 'Herbal Sauna',
      ),
      FacilityEntity(
        imageUrl:
            'https://lh3.googleusercontent.com/'
            'aida-public/AB6AXuCsb4vHt9ffFIigsf85Ub5Z'
            'xZpOtYAfI9PPvbtCP116lkvY4SNGqSWgNwI6aPaSw'
            'LlXhsOkEOpdePea4RW_5f1qv5cw6ZDp_waHW5ncFm'
            'q6YPUwuYXFB3_Tz3GD1bJkw2R4rtVvG2YQp-MDL7lL'
            '8-xKvv01wNEmrG0dqXqk699GaoaNfGZaM4QwwhIeVR'
            'UrTLHnnasqFWYrCmo1unQ_50BS0Whsgq2gLMxI_zA4'
            'hVgfATkF2qr02YWo3W0BGkEae2ENhNb9yfhfcPFL',
        name: 'Relaxation Lounge',
      ),
    ],
    review: ManualReviewEntity(
      averageRating: 4.9,
      reviewerName: 'Sarah M.',
      reviewText:
          'The Swedish Relax treatment was absolutely '
          'divine. The therapists are world-class.',
    ),
  );
}
