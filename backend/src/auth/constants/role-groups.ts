import { Role } from '@/account/enum/role.enum';

// Admin/Partner roles - can access admin dashboard endpoints
export const ADMIN_ROLES: Role[] = [
  Role.ADMIN,
  Role.HEALTH_PARTNER,
  Role.EMPLOYEE,
];

// All authenticated roles - any logged-in user
export const ALL_ROLES: Role[] = [
  Role.ADMIN,
  Role.HEALTH_PARTNER,
  Role.EMPLOYEE,
  Role.USER,
];

// User-only roles - mobile app users
export const USER_ROLES: Role[] = [Role.USER];
