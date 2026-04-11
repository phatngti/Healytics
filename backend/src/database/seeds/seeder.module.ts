import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Account } from '@/common/entities/account.entity';
import { UserProfile } from '@/common/entities/user-profile.entity';
import { Address } from '@/common/entities/address.entity';
import { Category } from '@/common/entities/category.entity';
import { ProductFeatureTag } from '@/common/entities/product-feature-tag.entity';
import { ProductTag } from '@/common/entities/product-tag.entity';
import { Employee } from '@/common/entities/employee.entity';
import { DoctorProfile } from '@/common/entities/doctor-profile.entity';
import { TherapistProfile } from '@/common/entities/therapist-profile.entity';
import { Product } from '@/common/entities/product.entity';
import { ProductDefinition } from '@/common/entities/product-definition.entity';
import { ProductResourceRequirement } from '@/common/entities/product-resource-requirement.entity';
import { ResourceType } from '@/common/entities/resource-type.entity';
import { ProductEmployeeEligibility } from '@/common/entities/product-employee-eligibility.entity';
import { Partner } from '@/common/entities/partner.entity';
import { LegalRepresentative } from '@/common/entities/legal-representative.entity';
import { PartnerDocument } from '@/common/entities/partner-document.entity';
import { PartnerReviewLog } from '@/common/entities/partner-review-log.entity';
import { Location } from '@/common/entities/location.entity';
import { TreatmentReview } from '@/common/entities/treatment-review.entity';
import { SpecialistReview } from '@/common/entities/specialist-review.entity';
import { Booking } from '@/common/entities/booking.entity';
import { BookingStatusLog } from '@/common/entities/booking-status-log.entity';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { CheckoutTicket } from '@/common/entities/checkout-ticket.entity';
import { ProductFacilityImage } from '@/common/entities/product-facility-image.entity';
import { ProductMedia } from '@/common/entities/product-media.entity';
import { PartnerConversation } from '@/common/entities/partner-conversation.entity';
import { PartnerChatMessage } from '@/common/entities/partner-chat-message.entity';
import { PartnerChatAttachment } from '@/common/entities/partner-chat-attachment.entity';
import { Notification } from '@/common/entities/notification.entity';
import { NotificationRead } from '@/common/entities/notification-read.entity';
import { DeviceToken } from '@/common/entities/device-token.entity';
import { AuditLog } from '@/common/entities/audit-log.entity';
import { AiConversation } from '@/common/entities/conversation.entity';
import { AiChatMessage } from '@/common/entities/chat-message.entity';
import { CartItem } from '@/cart/entities/cart-item.entity';
import { Coupon } from '@/cart/entities/coupon.entity';
import { PartnerCertification } from '@/clinic/entities/partner-certification.entity';
import { ClinicReviewResponse } from '@/clinic/entities/clinic-review-response.entity';
import { UserSeeder } from './users/user.seeder';
import { ServiceTagSeeder } from './service-tags/service-tag.seeder';
import { EmployeeSeeder } from './employees/employee.seeder';
import { ProductSeeder } from './products/product.seeder';
import { PartnerSeeder } from './partners/partner.seeder';
import { CategorySeeder } from './categories/category.seeder';
import { AppointmentSeeder } from './appointments/appointment.seeder';
import { AccountProfileSeeder } from './account-profiles/account-profile.seeder';
import { AuditSeeder } from './audit/audit.seeder';
import { CheckoutTicketSeeder } from './checkout-tickets/checkout-ticket.seeder';
import { CartSeeder } from './cart/cart.seeder';
import { PartnerReviewLogSeeder } from './partner-review-logs/partner-review-log.seeder';
import { ClinicSeeder } from './clinic/clinic.seeder';
import { PartnerChatSeeder } from './partner-chat/partner-chat.seeder';
import { NotificationSeeder } from './notifications/notification.seeder';
import { PaymentTransactionLogSeeder } from './payment-transaction-logs/payment-transaction-log.seeder';
import { AiConversationSeeder } from './ai-conversations/ai-conversation.seeder';
import { SeederService } from './seeder.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Account,
      UserProfile,
      Address,
      Category,
      ProductFeatureTag,
      ProductTag,
      Employee,
      DoctorProfile,
      TherapistProfile,
      Product,
      ProductDefinition,
      ProductResourceRequirement,
      ResourceType,
      ProductEmployeeEligibility,
      Partner,
      LegalRepresentative,
      PartnerDocument,
      PartnerReviewLog,
      Location,
      TreatmentReview,
      SpecialistReview,
      Booking,
      BookingStatusLog,
      Payment,
      PaymentTransactionLog,
      CheckoutTicket,
      ProductFacilityImage,
      ProductMedia,
      PartnerConversation,
      PartnerChatMessage,
      PartnerChatAttachment,
      Notification,
      NotificationRead,
      DeviceToken,
      AuditLog,
      AiConversation,
      AiChatMessage,
      CartItem,
      Coupon,
      PartnerCertification,
      ClinicReviewResponse,
    ]),
  ],
  providers: [
    UserSeeder,
    AccountProfileSeeder,
    ServiceTagSeeder,
    EmployeeSeeder,
    ProductSeeder,
    PartnerSeeder,
    CategorySeeder,
    AppointmentSeeder,
    CheckoutTicketSeeder,
    CartSeeder,
    PartnerReviewLogSeeder,
    ClinicSeeder,
    PartnerChatSeeder,
    NotificationSeeder,
    PaymentTransactionLogSeeder,
    AiConversationSeeder,
    AuditSeeder,
    SeederService,
  ],
  exports: [SeederService],
})
export class SeederModule {}
