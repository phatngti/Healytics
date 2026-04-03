import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';

/// Mock categories for the clinic products tab.
const kMockClinicProductCategories = [
  ClinicProductCategory(id: 'all', label: 'All Services'),
  ClinicProductCategory(id: 'massage', label: 'Massage Therapy'),
  ClinicProductCategory(id: 'skincare', label: 'Skincare & Laser'),
  ClinicProductCategory(id: 'herbal', label: 'Herbal Hair Wash'),
];

/// Mock products matching the HTML design spec.
const kMockClinicProducts = [
  ClinicProductEntity(
    id: 'prod-co2-laser',
    title: 'Premium CO2 Laser Skin Resurfacing',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuBWQ2X3R2xxWf0audsJMtrykMm_nwBtAaxZ4WWOiv7'
        'XFB13fMADxsTmHhjj-R72ZFxAvsw5QdAOTVa0FdGOwPvydW'
        'h77xnFc68r6YcE-9e4wNKSaZ-f0HSlSVd2WOkewr5F7n9Jg'
        'E_TvzJsWukNQO9xDDyIeWuj57VE1rdJOtibwuQHy8eyp5G_'
        '5DqgeoCcY5BlLyGYSccFCXaNZWG8hGZsB72JPJmw2npxc9cH'
        'PjTlxBDjWY71y3JwnDSiWiSs4u9cUvztLfAap9Uc',
    price: '990.000đ',
    originalPrice: '1.250.000đ',
    discountLabel: '-20%',
    durationLabel: '60 min',
    specialistLabel: 'Specialist',
    categoryId: 'skincare',
    soldCount: 320,
    createdAtMs: 1743465600000, // 2025-04-01
  ),
  ClinicProductEntity(
    id: 'prod-deep-tissue',
    title: 'Deep Tissue Therapeutic Massage',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuB3HOIP0xJUgT9-wWPDAmA1gcgAJeThI0S0a6uqDx9'
        '93LdaSWrzfIq0A-DPfKjiZ3UyomHRAZV2KJBBD_wGPHNgBFo'
        'Cpz3jOIUXI2cK4kcTKZn8SC9t9Ppp1kVesjvX3nyUosAz9WI'
        'sCg1hrFAgpF0pIHQFCO6e4-gd0_gomwQrOtCNRi-nEAkqk_U'
        'SbszXwptaWSVnqsrFeZ0ECVMcxN5_Cbs_0IlC_sHM8Dzt-V7'
        'Y4IJ_HADMdeZ1Z3HaG9S5aXwQi1rmKVDvjRiE',
    price: '650.000đ',
    badgeLabel: 'HOT',
    durationLabel: '90 min',
    specialistLabel: 'Top Therapist',
    categoryId: 'massage',
    soldCount: 580,
    createdAtMs: 1743552000000, // 2025-04-02
  ),
  ClinicProductEntity(
    id: 'prod-herbal-hair',
    title: 'Traditional Herbal Hair Wash & Scalp Care',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuAtGZfTaiwH9f3JJZlBgKKi5P6vWiv1U8UjpKTzOXlc'
        '-QBTVsmzHNx_KHjiTBwKCkQh9iDdH6oL6V3DavsXIz6OQo_R'
        'utoNMgj0GcKE0kBcYRr2_O8LEKU5Ci0OFI3ZETFJX-0-LlaG'
        'YLjRVPcJL9k2BrM4l_S4d32JgpkdXcqy06OYt51qfGNT7uZt'
        'Ot9e6zwKU9WnWy6kQZcWoUBuJyglyFN8iHXd2soKznCbkdEj'
        'Ada3rv_wGO5703xVxCtsxOydat_SWveDy8QN',
    price: '280.000đ',
    durationLabel: '45 min',
    specialistLabel: 'Signature',
    categoryId: 'herbal',
    soldCount: 210,
    createdAtMs: 1743638400000, // 2025-04-03
  ),
  ClinicProductEntity(
    id: 'prod-acne-treatment',
    title: 'Acne Treatment & Extractions',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuA_mnbH4nsH-uV-VNwFoGprxggMOKigq0JrmMHcMp5u'
        'njLYRQ7-mxoeWwtwp1P7jSuqj6OYngk0gYnbUOc6VZ0HhElL'
        '5YuPC5mmGDnbYDfOrmuv8dpOuWWZu2sB_ifZY3fGQEsU4PXX'
        'RPxAw6jo3YCUM9pOg4eSdc-QZKgsOa7X4-_hnU90UIkKCxTR'
        'krZXJKfVspYHL2iNmPlVPDDfjpma9I3Yv0U5k3tLZGupr_Wqp'
        'W6erde09_SzUwW61BrF7HnPf3IRV89k1n02',
    price: '460.000đ',
    originalPrice: '550.000đ',
    discountLabel: '-15%',
    durationLabel: '75 min',
    specialistLabel: 'Specialist',
    categoryId: 'skincare',
    soldCount: 410,
    createdAtMs: 1743724800000, // 2025-04-04
  ),
  ClinicProductEntity(
    id: 'prod-hot-stone',
    title: 'Hot Stone Relaxation Massage',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuA49iO6cQxjEIK6MV_zJFF4RvVKf6tNXrJsHdaiTcaP'
        'TLp1XL8DqKb2G3QAWNBWOWP7_GiMBXmfQ5H5V1X2nFIPpfml'
        '29XgTTiXp16r-R12SYfhPMOS8NkFIlO26DE746wy2datP6i_P'
        'Zk9xnK4J8k6yxS0PbUx6IFQA2_OalMRtESyOQJcvTmgWTCO'
        'tdWxYRcjBsPaVAABvKxVIIuNg1UTsIsZcv6rZnllYM7BRZAOGq'
        'cLkfIM_c5Vlax2sWSvh0hrcL3fHynZzxJB',
    price: '520.000đ',
    durationLabel: '60 min',
    categoryId: 'massage',
    soldCount: 290,
    createdAtMs: 1743811200000, // 2025-04-05
  ),
  ClinicProductEntity(
    id: 'prod-vitamin-c',
    title: 'Vitamin C Brightening Facial',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/'
        'AB6AXuDE53UYbNKCTyNyZP6gvLqEIu-8aO-g7t6BiFQ1Ur-4'
        '4Wu_07H7xGpZPGjz1_WF8bAdFiaUJ8FTUcCrxXUjpIJWXgzb'
        'PAyprqtpLeLS8TfHkRYqQyFWAQfpC5S1rqIYRj5hNqihTmJG'
        'FAbo-2OiFy-RlSgG8GNLQ00sMVXKEVmAlQQmG6rYPwuIe1aZ'
        'RUEbex2f4XWNEbXrrjMtwYdpj4vM3reiR-O4awtST1MC_i2a_'
        '6kTt-C2t86XxDMctXISpVjOWqwGT3zGSZ7S',
    price: '750.000đ',
    durationLabel: '60 min',
    specialistLabel: 'Specialist',
    categoryId: 'skincare',
    soldCount: 350,
    createdAtMs: 1743897600000, // 2025-04-06
  ),
];
