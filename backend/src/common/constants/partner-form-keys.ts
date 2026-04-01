// ============================================================================
// Field Keys for Review (centralized for admin and partner general use)
// ============================================================================
export const PartnerFieldKeys = {
  // Business Info Fields
  brandName: 'brandName',
  taxCode: 'taxCode',
  legalName: 'legalName',
  businessType: 'businessType',
  serviceTags: 'serviceTags',
  phoneNumber: 'phoneNumber',
  email: 'email',
  username: 'username',

  // Address Fields (matching /partners/me API keys)
  streetAddress: 'streetAddress',
  // Legacy keys for backward compatibility
  ward: 'ward',
  district: 'district',
  city: 'city',

  // Legal Representative Fields (prefixed with 'legalRep.')
  fullName: 'fullName',
  position: 'position',
  idType: 'idType',
  idNumber: 'idNumber',
  idIssueDate: 'idIssueDate',
} as const;

export type PartnerFieldKey =
  (typeof PartnerFieldKeys)[keyof typeof PartnerFieldKeys];
