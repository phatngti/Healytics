import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { DashboardNotificationDto } from '../dto/response/dashboard-notification.dto';

/**
 * Maps NotificationType enum values to dashboard-friendly type categories.
 * See Guide §4.8 for the full mapping table.
 */
const TYPE_MAPPING: Record<string, string> = {
  booking_confirmed: 'appointment',
  booking_cancelled: 'appointment',
  booking_completed: 'appointment',
  appointment_reminder: 'appointment',
  appointment_updated: 'appointment',
  payment_success: 'system',
  payment_failed: 'system',
  new_chat_message: 'system',
  partner_verified: 'alert',
  partner_rejected: 'alert',
  system_broadcast: 'system',
  system_maintenance: 'system',
};

@Injectable()
export class ListDashboardNotificationsHandler {
  private readonly logger = new Logger(ListDashboardNotificationsHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  async execute(
    accountId: string,
    limit: number,
  ): Promise<DashboardNotificationDto[]> {
    this.logger.log(
      `Listing notifications for account: ${accountId}, limit: ${limit}`,
    );

    const rows = await this.dataSource.query(
      `SELECT
        n.id,
        n.title,
        n.body,
        n.type,
        n.created_at,
        n.is_read,
        n.is_broadcast,
        nr.id AS read_record_id
      FROM notifications n
      LEFT JOIN notification_reads nr
        ON nr.notification_id = n.id AND nr.user_id = $1
      WHERE (
             n.recipient_id = $1
          OR n.is_broadcast = true
           )
        AND n.deleted_at IS NULL
      ORDER BY n.created_at DESC
      LIMIT $2`,
      [accountId, limit],
    );

    return rows.map((row: any) => {
      const dto = new DashboardNotificationDto();
      dto.id = row.id;
      dto.title = row.title;
      dto.message = row.body;
      dto.type = TYPE_MAPPING[row.type] ?? 'system';
      dto.createdAt = new Date(row.created_at).toISOString();
      // For broadcasts, check the reads table; for targeted, use is_read directly
      dto.isRead = row.is_broadcast ? !!row.read_record_id : !!row.is_read;
      return dto;
    });
  }
}
