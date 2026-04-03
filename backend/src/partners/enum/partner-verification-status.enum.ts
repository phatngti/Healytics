/**
 * Partner verification status enum.
 * Represents the overall approval decision by admin.
 */
export enum PartnerVerificationStatus {
  ONBOARDING = 'ONBOARDING', // Partner created, uploading documents
  PENDING = 'PENDING', // Awaiting admin decision
  APPROVED = 'APPROVED', // Partner approved to operate
  REJECTED = 'REJECTED', // Partner rejected (Terminal)
  REQUIRED_RESUBMIT = 'REQUIRED_RESUBMIT', // Admin requested changes (Soft Reject)
}
