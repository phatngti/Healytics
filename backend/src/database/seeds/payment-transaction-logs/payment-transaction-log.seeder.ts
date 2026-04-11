import { Injectable, Logger } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Like, Repository } from 'typeorm';
import { Payment } from '@/common/entities/payment.entity';
import { PaymentTransactionLog } from '@/common/entities/payment-transaction-log.entity';
import { PaymentStatus } from '@/payment-gateway/enums/payment-status.enum';
import { TransactionAction } from '@/payment-gateway/enums/transaction-action.enum';
import { ISeeder } from '../seeder.interface';
import { SEED_MARKERS, seedKey } from '../utils/seed.utils';

@Injectable()
export class PaymentTransactionLogSeeder implements ISeeder {
  private readonly logger = new Logger(PaymentTransactionLogSeeder.name);

  constructor(
    @InjectRepository(PaymentTransactionLog)
    private readonly transactionLogRepo: Repository<PaymentTransactionLog>,
    @InjectRepository(Payment)
    private readonly paymentRepo: Repository<Payment>,
  ) {}

  async seed(): Promise<void> {
    this.logger.log('Seeding payment transaction logs...');

    const [paidPayment, unpaidPayment, refundPayment] = await Promise.all([
      this.paymentRepo.findOne({
        where: { paymentStatus: PaymentStatus.PAID },
        order: { createdAt: 'ASC' },
      }),
      this.paymentRepo.findOne({
        where: { paymentStatus: PaymentStatus.UNPAID },
        order: { createdAt: 'ASC' },
      }),
      this.paymentRepo.findOne({
        where: { paymentStatus: PaymentStatus.REFUND },
        order: { createdAt: 'ASC' },
      }),
    ]);

    if (unpaidPayment) {
      await this.createLogIfMissing({
        paymentId: unpaidPayment.id,
        action: TransactionAction.CREATE_PAYMENT,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'UNPAID_CREATE'),
        message: 'Seeded unpaid payment creation event',
      });
    }

    if (paidPayment) {
      await this.createLogIfMissing({
        paymentId: paidPayment.id,
        action: TransactionAction.CREATE_PAYMENT,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'PAID_CREATE'),
        message: 'Seeded paid payment creation event',
      });
      await this.createLogIfMissing({
        paymentId: paidPayment.id,
        action: TransactionAction.IPN_RECEIVED,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'PAID_IPN_RECEIVED'),
        message: 'Seeded IPN callback received',
      });
      await this.createLogIfMissing({
        paymentId: paidPayment.id,
        action: TransactionAction.IPN_VERIFIED,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'PAID_IPN_VERIFIED'),
        message: 'Seeded IPN signature verified',
      });
    }

    if (refundPayment) {
      await this.createLogIfMissing({
        paymentId: refundPayment.id,
        action: TransactionAction.REFUND_REQUESTED,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'REFUND_REQUESTED'),
        message: 'Seeded refund request',
      });
      await this.createLogIfMissing({
        paymentId: refundPayment.id,
        action: TransactionAction.REFUND_CONFIRMED,
        actor: seedKey(SEED_MARKERS.paymentLogActor, 'REFUND_CONFIRMED'),
        message: 'Seeded refund confirmation',
      });
    }

    this.logger.log('Payment transaction log seeding completed');
  }

  private async createLogIfMissing(params: {
    paymentId: string;
    action: TransactionAction;
    actor: string;
    message: string;
  }): Promise<void> {
    const payment = await this.paymentRepo.findOne({
      where: { id: params.paymentId },
      select: ['id', 'paymentMethod', 'gatewayResultCode'],
    });
    if (!payment) return;

    const existing = await this.transactionLogRepo.findOne({
      where: {
        paymentId: params.paymentId,
        action: params.action,
        actor: params.actor,
      },
    });
    if (existing) return;

    await this.transactionLogRepo.save(
      this.transactionLogRepo.create({
        paymentId: params.paymentId,
        action: params.action,
        gateway: payment.paymentMethod,
        resultCode: payment.gatewayResultCode,
        message: params.message,
        requestPayload: { seed: true, action: params.action },
        responsePayload: { seed: true, status: 'ok' },
        ipAddress: '10.10.11.11',
        actor: params.actor,
      }),
    );

    this.logger.log(`  ✅ Created payment transaction log "${params.actor}"`);
  }

  async clear(): Promise<void> {
    const { affected } = await this.transactionLogRepo.delete({
      actor: Like(`${SEED_MARKERS.paymentLogActor}%`),
    });

    if (!affected) {
      this.logger.warn('⚠ No seed payment transaction logs found to delete');
      return;
    }

    this.logger.log(`🗑️ Hard-deleted ${affected} seed payment transaction log(s)`);
  }
}
