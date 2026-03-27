import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Mock data constants for the checkout feature,
/// matching the HTML design reference.

const kMockCustomerDetails = CustomerDetails(
  name: 'Nguyen Tien Phat',
  phone: '0912 345 678',
  address: '12 Street 12, Ward 2, District 3, HCMC',
);

const kMockCheckoutItems = <CheckoutItem>[
  CheckoutItem(
    id: '1',
    name: 'Elite Dermatology Laser CO2',
    imageUrl:
        'https://lh3.googleusercontent.com/'
        'aida-public/AB6AXuAWK5FyO-mTU6MTCyXD3ltC8CbqBq'
        'SmBUxjXMTidRKJwW6ECbzeR2-7D6s0NAUjTTysGCqoX_Me'
        'PcTv0K_X3QIIVdiJ4KpgwJ8wOW0L65fQjM7kK8HND5qfYd'
        '5OsPHco99npiBVsrOX-iOnWn1wHjiSRpWdyJSZjwxanKpF'
        'vYXwkLHD9aS-3D-XtilUmdILsYVPg9qmAV_xCShqCs-iDY'
        'iFtEi4R_Dyhdm236EEG6yEfxHFRFotrFm9V2TNcU2kzrou'
        'GZI_APyC4IPt',
    vendorName: 'Elite Dermatology Clinic',
    vendorIcon: 'local_hospital',
    duration: '60 min',
    specialistName: 'Dr. Sarah Lin',
    originalPrice: 5000000,
    discountedPrice: 3500000,
  ),
  CheckoutItem(
    id: '2',
    name: 'Swedish Relax Massage',
    imageUrl:
        'https://lh3.googleusercontent.com/'
        'aida-public/AB6AXuAEplDyrl0hlNhqQ-w7ybufYAvaTY'
        'oQdJlQVjSpvjxVt6vYB6bZdEplJckrk6MbbDmKTXQgMXA6'
        '6pChZrDWc5UygpDu8WvZBrvxswFJyFbdKLki0wwCDOmbiC'
        '7tK3c9Xlc3GCd-2aa-2i-LSLksZQ-rwI9zKX-pIHLB03E8'
        'loO7jf6bshgApH201cCLWtL-B5nyj7AukyeeUtRxVnzolu'
        'YuxCCISs1mN62LulDcZl_X4JJTN6ip4dHh1mA5LCyC1Rmf'
        '4V4B5HPkvfV',
    vendorName: 'Serenity Wellness Spa',
    vendorIcon: 'spa',
    duration: '90 min',
    specialistName: 'Therapist Anna',
    originalPrice: 1200000,
    discountedPrice: 850000,
  ),
];

const kMockShopVoucher = VoucherInfo(
  label: 'Shop Voucher',
  discountAmount: 0,
  isApplied: false,
);

const kMockPlatformVoucher = VoucherInfo(
  label: 'Platform Voucher',
  discountAmount: 150000,
  isApplied: true,
);

const kMockPaymentMethods = <PaymentMethodOption>[
  PaymentMethodOption(
    type: PaymentMethodType.card,
    label: 'Credit/Debit Card',
    subLabel: '*3434',
  ),
  PaymentMethodOption(
    type: PaymentMethodType.eWallet,
    label: 'E-Wallet (Momo/ZaloPay)',
  ),
  PaymentMethodOption(type: PaymentMethodType.payLater, label: 'Pay Later'),
];

const kMockCheckoutSummary = CheckoutSummary(
  subtotal: 10150000,
  shopDiscount: 1232000,
  platformVoucher: 150000,
  coinsUsed: 25000,
);

const kMockCheckoutData = CheckoutData(
  customer: kMockCustomerDetails,
  items: kMockCheckoutItems,
  shopVoucher: kMockShopVoucher,
  platformVoucher: kMockPlatformVoucher,
  coinBalance: 2500,
  coinValue: 25000,
  paymentMethods: kMockPaymentMethods,
  summary: kMockCheckoutSummary,
);
