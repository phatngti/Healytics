export const BOOKING_STATUS_REDIS_CHANNEL = 'booking.status.changed';
export const BOOKING_STATUS_SOCKET_EVENT = 'booking.status.changed';

export const bookingUserRoom = (userId: string) => `user:${userId}`;
export const bookingPartnerRoom = (partnerId: string) => `partner:${partnerId}`;
export const bookingEmployeeRoom = (employeeId: string) =>
  `employee:${employeeId}`;
