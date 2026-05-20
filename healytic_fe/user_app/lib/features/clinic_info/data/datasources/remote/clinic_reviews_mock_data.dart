import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';

/// Mock review summary data matching the HTML design.
const kMockClinicReviewSummary = ClinicReviewSummary(
  averageRating: 4.9,
  totalReviewCount: 2500,
  ratingLabel: 'Excellent',
  starDistribution: {
    5: 0.92,
    4: 0.06,
    3: 0.01,
    2: 0.005,
    1: 0.005,
  },
);

/// Mock filter pills matching the HTML design.
const kMockClinicReviewFilters = <ClinicReviewFilter>[
  ClinicReviewFilter(
    id: 'all',
    label: 'All (2.5k)',
  ),
  ClinicReviewFilter(
    id: 'with-media',
    label: 'With Media (840)',
    requiresMedia: true,
  ),
  ClinicReviewFilter(
    id: '5-star',
    label: '5 Stars (2.1k)',
    starCount: 5,
  ),
  ClinicReviewFilter(
    id: 'good-service',
    label: 'Good service',
  ),
  ClinicReviewFilter(
    id: '4-star',
    label: '4 Stars (240)',
    starCount: 4,
  ),
];

/// Mock reviews matching the HTML design.
const kMockClinicReviews = <ClinicReviewEntity>[
  ClinicReviewEntity(
    id: 'review-1',
    reviewerName: 'n***a',
    reviewerInitial: 'N',
    starCount: 5,
    memberBadge: 'GOLD MEMBER',
    dateLabel: '04-04-2026',
    serviceName: 'Himalayan Salt Stone Massage (90 min)',
    serviceIcon: 'spa',
    reviewText:
        'The atmosphere at An Mien is incredibly serene. '
        'The stones were at the perfect temperature and '
        'my therapist was very attentive to my tension '
        'points. Highly recommend for anyone looking for '
        'a premium detox experience.',
    mediaUrls: [
      'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuDPfQU0HOjkOF4t9CPIq7bRCiVN0B2oNTpDXzgR'
          'wJDFIx-csJTGeeG98QvcwjmZI5D3jEKywbZO5pAvzqBx'
          '_3ANaGhMlxVSGX3wGI1bD6k0riSP-CFxhUB6Xmjr9be-'
          'RKyQuHWWe5jR8Fs95K2U5EsN3w85pVg2FlqbPlR5YwWjw'
          'DUlzlH_aRqDDMUhygvCfwBw6W6LNaErMN6WILb1rcCIJy'
          'XIYQHM3F-4kapGLNBAJrwVFa7t5V2Xv3C0cdSQx6y4zh6'
          'tejoFo034',
      'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuCHx9pCFeWNfFsu1zy0drimJzVfoBO_bwk-UijbktdA'
          'fEuH5w0vDeeTxTxRsl6mtUVbsHejKGUTym1Uqg57s8u1g9E'
          'r11P-Gxr9cineJfF6m-fzoI89wq_klzr6c5AE9a5nqgcTaK'
          '6I63TJY0FX3ozjtNKHxVeNyayJneXyvjBEWOUvWvAByc0PL'
          't52vRGdMabHGQX-lSdPmAKFLY6NDz-udPRF4Y6LhUfwKwvj'
          'CWw9xLoyaCTc_SmnfrfXuZOFnZ-dEcE3ZbuyJfJN',
      'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuAsQPUVDXdGLC7hGU_29pHQPeKWqsSSrQw-JYsOec'
          'V99FYx6rCpi6x3d1YHqb_K3Mu0rxsKvnQu_ZzWNCPUrIYV'
          'KQgkR92pQ8ZuM5qD8EO90HTgkO5GaQZy-4UcsJn90ZeonRr'
          'ceXyLHk5iNZT8FN684iiT8uvaqAkrIbKoeU9vC1LQzpIzQN'
          'AHasaENk-phdRlj9fn6E4yg96HO-FrIbVi7ktYJlxGx9kF8'
          'uzQZsuTPoMIanKrf9fKU896E9UJ66tNZyB3UWFHm807',
    ],
    clinicResponse: ClinicReviewResponse(
      responseText:
          'Dear n***a, thank you for your kind words! '
          'We are delighted you enjoyed the Himalayan '
          'Salt Stone session. We look forward to seeing '
          'you again soon.',
    ),
  ),
  ClinicReviewEntity(
    id: 'review-2',
    reviewerName: 'm***v',
    reviewerInitial: 'M',
    starCount: 4,
    dateLabel: '02-04-2026',
    serviceName: 'Deep Tissue Facial',
    serviceIcon: 'face',
    reviewText:
        'Overall a very good experience. The staff was '
        'polite and professional. I docked one star '
        'because the lobby was a bit crowded while '
        'waiting for my turn. The treatment itself was '
        'excellent.',
  ),
  ClinicReviewEntity(
    id: 'review-3',
    reviewerName: 'k***t',
    reviewerInitial: 'K',
    starCount: 5,
    memberBadge: 'MEMBER',
    dateLabel: '28-03-2026',
    serviceName: 'Deep Tissue Full Body',
    serviceIcon: 'spa',
    reviewText:
        'Magical hands! I\'ve been to many spas in the '
        'city but An Mien is on another level. The '
        'skill level of the therapists is very '
        'consistent.',
    mediaUrls: [
      'https://lh3.googleusercontent.com/aida-public/'
          'AB6AXuA075E_1xiEuPryiQSg5rBf67xl-eWJgVH2ldGNB6'
          'D2mU1v0BVgRuCm1a4kMuH7G5Xwh-Nry5y5p0Ej1HiVzQl'
          'QcVPpWMJ-Hn4EZXCdH6oAFgOO2EUDr629W43MX3z92AmTv'
          'DeX23pbnjQMgHjFg2iEbJ8fVEay6rxFXoGKlY0kds0fL-sD'
          'GKXiiHsWc2bIDGc715SdmG_EvjmtjZWozcWE49F9OcIiso0'
          'GhcRRViF5cmSO945P3fBHjaQ37B_VuMyNoX2ctlHZgUwl',
    ],
    clinicResponse: ClinicReviewResponse(
      responseText:
          'We are so happy to hear this, k***t! '
          'Consistency is what we strive for. See you '
          'at your next monthly session.',
    ),
  ),
];

/// Default mock reviews data bundle.
const kMockClinicReviewsData = ClinicReviewsData(
  summary: kMockClinicReviewSummary,
  filters: kMockClinicReviewFilters,
  reviews: kMockClinicReviews,
  totalCount: 3,
  hasMore: false,
);
