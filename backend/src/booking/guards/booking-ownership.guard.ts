import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Role } from '@/account/enum/role.enum';
import { BookingAccessService } from '../services/booking-access.service';

interface CurrentJwtUser {
  id: string;
  role: Role;
}

@Injectable()
export class BookingOwnershipGuard implements CanActivate {
  constructor(private readonly bookingAccessService: BookingAccessService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<{
      params: { id?: string };
      user?: CurrentJwtUser;
    }>();
    const bookingId = request.params.id;
    const user = request.user;

    if (!bookingId || !user) return false;

    // Deep ABAC validation reads ownership from the database. It never trusts
    // route/body IDs for user, employee, or partner ownership.
    await this.bookingAccessService.assertCanAccessBooking(user, bookingId);
    return true;
  }
}
