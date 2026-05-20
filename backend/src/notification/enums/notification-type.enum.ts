import { registerWsEnum } from '@/common/decorators/ws';

/**
 * Supported notification types for the Healytics platform.
 * Each type maps to a specific domain event or admin action.
 */
export enum NotificationType {
  // ── Booking lifecycle ───────────────────────────────────────
  BOOKING_CONFIRMED = 'booking_confirmed',
  BOOKING_CANCELLED = 'booking_cancelled',
  BOOKING_COMPLETED = 'booking_completed',

  // ── Appointment ─────────────────────────────────────────────
  APPOINTMENT_REMINDER = 'appointment_reminder',
  APPOINTMENT_UPDATED = 'appointment_updated',

  // ── Chat ────────────────────────────────────────────────────
  NEW_CHAT_MESSAGE = 'new_chat_message',

  // ── Payment ─────────────────────────────────────────────────
  PAYMENT_SUCCESS = 'payment_success',
  PAYMENT_FAILED = 'payment_failed',

  // ── System ──────────────────────────────────────────────────
  SYSTEM_BROADCAST = 'system_broadcast',
  SYSTEM_MAINTENANCE = 'system_maintenance',

  // ── Partner ─────────────────────────────────────────────────
  PARTNER_VERIFIED = 'partner_verified',
  PARTNER_REJECTED = 'partner_rejected',
}

// Register for WS contract generation
registerWsEnum('NotificationType', {
  contractName: 'WsNotificationType',
  description: 'Type of notification in the Healytics platform',
  values: Object.values(NotificationType),
});
