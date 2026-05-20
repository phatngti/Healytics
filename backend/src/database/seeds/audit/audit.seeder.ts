import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Like, Repository } from 'typeorm';
import { Account } from '@/common/entities/account.entity';
import { AuditLog } from '@/common/entities/audit-log.entity';
import { Partner } from '@/common/entities/partner.entity';
import { Booking } from '@/common/entities/booking.entity';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, likePrefix, seedKey } from '../utils/seed.utils';

interface SeedAuditLog {
  code: string;
  actorEmail: string;
  action: string;
  targetEntity: string;
  target: {
    type: 'partner_tax_code' | 'booking_notes';
    value: string;
  };
  ipAddress: string | null;
  userAgent: string | null;
  metadata: Record<string, unknown> | null;
}

const SEED_AUDIT_LOGS: SeedAuditLog[] = [
  {
    code: '001',
    actorEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'PARTNER_APPROVED'),
    targetEntity: 'health_partner_profile',
    target: { type: 'partner_tax_code', value: '0123456789' },
    ipAddress: '10.10.10.1',
    userAgent: 'seed-script/admin-review',
    metadata: { seedKey: 'AUDIT_001', reason: 'verification approved' },
  },
  {
    code: '002',
    actorEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'PARTNER_RESUBMIT'),
    targetEntity: 'health_partner_profile',
    target: { type: 'partner_tax_code', value: '5566778899' },
    ipAddress: '10.10.10.2',
    userAgent: 'seed-script/admin-review',
    metadata: { seedKey: 'AUDIT_002', reason: 'required resubmission' },
  },
  {
    code: '003',
    actorEmail: 'user@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'BOOKING_CHECKED'),
    targetEntity: 'bookings',
    target: { type: 'booking_notes', value: 'Please use lavender oil' },
    ipAddress: '10.10.10.3',
    userAgent: 'seed-script/user-action',
    metadata: { seedKey: 'AUDIT_003', scope: 'booking-tracking' },
  },
  {
    code: '004',
    actorEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'PARTNER_PENDING_REVIEW'),
    targetEntity: 'health_partner_profile',
    target: { type: 'partner_tax_code', value: '0987654321' },
    ipAddress: '10.10.10.4',
    userAgent: 'seed-script/admin-review',
    metadata: { seedKey: 'AUDIT_004', reason: 'documents queued for review' },
  },
  {
    code: '005',
    actorEmail: process.env.DEFAULT_ADMIN_EMAIL || 'admin@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'PARTNER_APPROVED_MINDSKIN'),
    targetEntity: 'health_partner_profile',
    target: { type: 'partner_tax_code', value: '7788990011' },
    ipAddress: '10.10.10.5',
    userAgent: 'seed-script/admin-review',
    metadata: {
      seedKey: 'AUDIT_005',
      reason: 'multi-specialty verification approved',
    },
  },
  {
    code: '006',
    actorEmail: 'nguyenvana@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'DENTAL_BOOKING_VIEWED'),
    targetEntity: 'bookings',
    target: {
      type: 'booking_notes',
      value: 'Routine dental cleaning before travel',
    },
    ipAddress: '10.10.10.6',
    userAgent: 'seed-script/user-action',
    metadata: { seedKey: 'AUDIT_006', scope: 'dental-booking' },
  },
  {
    code: '007',
    actorEmail: 'vuthif@healytics.vn',
    action: seedKey(SEED_MARKERS.auditAction, 'COUNSELING_NOTE_UPDATED'),
    targetEntity: 'bookings',
    target: {
      type: 'booking_notes',
      value: 'Requests quiet room for first counseling session',
    },
    ipAddress: '10.10.10.7',
    userAgent: 'seed-script/user-action',
    metadata: { seedKey: 'AUDIT_007', scope: 'mental-wellness-booking' },
  },
];

@Injectable()
export class AuditSeeder implements ISeeder {
  private readonly logger = new Logger(AuditSeeder.name);

  constructor(
    @InjectRepository(AuditLog)
    private readonly auditRepo: Repository<AuditLog>,
    @InjectRepository(Account)
    private readonly accountRepo: Repository<Account>,
    @InjectRepository(Partner)
    private readonly partnerRepo: Repository<Partner>,
    @InjectRepository(Booking)
    private readonly bookingRepo: Repository<Booking>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding audit logs...');

    const actorEmails = [
      ...new Set(SEED_AUDIT_LOGS.map((item) => item.actorEmail)),
    ];
    const actors = await this.accountRepo.find({
      where: { email: In(actorEmails) },
      select: ['id', 'email'],
      loadEagerRelations: false,
    });
    const actorMap = new Map(
      actors.map((account) => [account.email, account.id]),
    );

    for (const entry of SEED_AUDIT_LOGS) {
      const existing = await this.auditRepo.findOne({
        where: { action: entry.action },
      });
      if (existing) {
        this.logger.log(
          `  ⏭ Audit action "${entry.action}" already exists, skipping`,
        );
        continue;
      }

      const actorId = actorMap.get(entry.actorEmail);
      if (!actorId) {
        this.logger.warn(
          `  ⚠ Actor "${entry.actorEmail}" not found — skipping`,
        );
        continue;
      }

      let targetId: string | null = null;
      if (entry.target.type === 'partner_tax_code') {
        const partner = await this.partnerRepo.findOne({
          where: { taxCode: entry.target.value },
          select: ['id'],
        });
        targetId = partner?.id ?? null;
      } else {
        const booking = await this.bookingRepo.findOne({
          where: { notes: entry.target.value },
          select: ['id'],
        });
        targetId = booking?.id ?? null;
      }

      if (!targetId) {
        this.logger.warn(
          `  ⚠ Target "${entry.target.value}" not found for "${entry.action}" — skipping`,
        );
        continue;
      }

      const auditLog = new AuditLog();
      auditLog.actorId = actorId;
      auditLog.action = entry.action;
      auditLog.targetEntity = entry.targetEntity;
      auditLog.targetId = targetId;
      if (entry.ipAddress) {
        auditLog.ipAddress = entry.ipAddress;
      }
      if (entry.userAgent) {
        auditLog.userAgent = entry.userAgent;
      }
      auditLog.metadata = entry.metadata;

      await this.auditRepo.save(auditLog);
      this.logger.log(`  ✅ Created audit log "${entry.action}"`);
    }

    this.logger.log('Audit log seeding completed');
  }

  async clear(): Promise<void> {
    const { affected } = await this.auditRepo.delete({
      action: Like(likePrefix(SEED_MARKERS.auditAction)),
    });

    if (!affected) {
      this.logger.warn('⚠ No seed audit logs found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${affected} seed audit log(s)`);
  }
}
