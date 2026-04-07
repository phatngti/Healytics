export const SEED_MARKERS = {
  address: 'SEED_ADDR_',
  auditAction: 'SEED_AUDIT_',
  checkoutKey: 'SEED_CHK_',
  couponCode: 'SEED_COUPON_',
  partnerReviewComment: 'SEED_REVIEW_LOG_',
  clinicCertificationTitle: 'SEED_CERT_',
  clinicResponseText: 'SEED_CLINIC_RESP_',
  chatClientMessageId: 'SEED_CHAT_MSG_',
  notificationTitle: 'SEED_NOTIF_',
  notificationToken: 'SEED_DEVICE_TOKEN_',
  paymentLogActor: 'seed:ptl:',
  aiConversationTitle: 'SEED_AI_CONV_',
} as const;

export function seedKey(prefix: string, code: string): string {
  return `${prefix}${code}`;
}

export function likePrefix(prefix: string): string {
  return `${prefix}%`;
}

export function buildMapBy<T, K>(items: T[], keySelector: (item: T) => K): Map<K, T> {
  return new Map(items.map((item) => [keySelector(item), item]));
}
