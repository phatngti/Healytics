export enum DocumentStatus {
    PENDING = 'PENDING',           // Submitted, awaiting review
    APPROVED = 'APPROVED',         // Verified and accepted
    REJECTED = 'REJECTED',         // Not acceptable, must re-upload
    CHANGES_REQUESTED = 'CHANGES_REQUESTED', // Admin requires updates/corrections
}
