export type BookingSearchDocumentType = 'service' | 'specialist';

export interface BookingSearchDocument {
  type: BookingSearchDocumentType;
  entityId: string;
  name: string;
  description?: string | null;
  specialty?: string | null;
  role?: string | null;
  serviceNames?: string[];
  serviceId?: string;
  imageUrl?: string | null;
  duration?: string;
  durationMinutes?: number | null;
  price?: string;
  priceVnd?: number | null;
  clinicName?: string | null;
  clinicAddress?: string | null;
  clinicNameSearch?: string | null;
  clinicAddressSearch?: string | null;
  provinceName?: string | null;
  districtName?: string | null;
  wardName?: string | null;
  locationText?: string | null;
  specialistId?: string;
  eligibilityId?: string | null;
  avatarUrl?: string | null;
  updatedAt: string;
}
