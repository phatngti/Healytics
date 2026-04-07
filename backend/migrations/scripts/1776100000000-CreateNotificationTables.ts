import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreateNotificationTables1776100000000 implements MigrationInterface {
  name = 'CreateNotificationTables1776100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_type WHERE typname = 'notifications_type_enum'
        ) THEN
          CREATE TYPE "notifications_type_enum" AS ENUM (
            'booking_confirmed',
            'booking_cancelled',
            'booking_completed',
            'appointment_reminder',
            'appointment_updated',
            'new_chat_message',
            'payment_success',
            'payment_failed',
            'system_broadcast',
            'system_maintenance',
            'partner_verified',
            'partner_rejected'
          );
        END IF;
      END
      $$;
    `);

    await queryRunner.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (
          SELECT 1 FROM pg_type WHERE typname = 'device_tokens_platform_enum'
        ) THEN
          CREATE TYPE "device_tokens_platform_enum" AS ENUM (
            'ios',
            'android'
          );
        END IF;
      END
      $$;
    `);

    const hasNotifications = await queryRunner.hasTable('notifications');
    if (!hasNotifications) {
      await queryRunner.createTable(
        new Table({
          name: 'notifications',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              isGenerated: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'recipient_id', type: 'uuid', isNullable: true },
            { name: 'type', type: 'notifications_type_enum' },
            { name: 'title', type: 'varchar', length: '255' },
            { name: 'body', type: 'text' },
            { name: 'data', type: 'jsonb', isNullable: true },
            { name: 'is_read', type: 'boolean', default: false },
            { name: 'read_at', type: 'timestamptz', isNullable: true },
            { name: 'is_broadcast', type: 'boolean', default: false },
            { name: 'sender_id', type: 'uuid', isNullable: true },
            { name: 'created_at', type: 'timestamptz', default: 'now()' },
            { name: 'deleted_at', type: 'timestamptz', isNullable: true },
          ],
        }),
        true,
      );

      await queryRunner.createIndex(
        'notifications',
        new TableIndex({
          name: 'IDX_NOTIFICATIONS_RECIPIENT_ID',
          columnNames: ['recipient_id'],
        }),
      );
      await queryRunner.createIndex(
        'notifications',
        new TableIndex({
          name: 'IDX_NOTIF_RECIPIENT_READ_CREATED',
          columnNames: ['recipient_id', 'is_read', 'created_at'],
        }),
      );
      await queryRunner.createIndex(
        'notifications',
        new TableIndex({
          name: 'IDX_NOTIF_TYPE_CREATED',
          columnNames: ['type', 'created_at'],
        }),
      );
      await queryRunner.createIndex(
        'notifications',
        new TableIndex({
          name: 'IDX_NOTIF_BROADCAST_CREATED',
          columnNames: ['is_broadcast', 'created_at'],
        }),
      );

      await queryRunner.createForeignKey(
        'notifications',
        new TableForeignKey({
          name: 'FK_NOTIFICATIONS_RECIPIENT_ID',
          columnNames: ['recipient_id'],
          referencedTableName: 'account',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'notifications',
        new TableForeignKey({
          name: 'FK_NOTIFICATIONS_SENDER_ID',
          columnNames: ['sender_id'],
          referencedTableName: 'account',
          referencedColumnNames: ['id'],
          onDelete: 'SET NULL',
        }),
      );
    }

    const hasNotificationReads = await queryRunner.hasTable('notification_reads');
    if (!hasNotificationReads) {
      await queryRunner.createTable(
        new Table({
          name: 'notification_reads',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              isGenerated: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'notification_id', type: 'uuid' },
            { name: 'user_id', type: 'uuid' },
            { name: 'read_at', type: 'timestamptz', default: 'now()' },
          ],
        }),
        true,
      );

      await queryRunner.createUniqueConstraint(
        'notification_reads',
        new TableUnique({
          name: 'UQ_NOTIF_READ',
          columnNames: ['notification_id', 'user_id'],
        }),
      );
      await queryRunner.createIndex(
        'notification_reads',
        new TableIndex({
          name: 'IDX_NOTIFICATION_READS_NOTIFICATION_ID',
          columnNames: ['notification_id'],
        }),
      );
      await queryRunner.createIndex(
        'notification_reads',
        new TableIndex({
          name: 'IDX_NOTIFICATION_READS_USER_ID',
          columnNames: ['user_id'],
        }),
      );

      await queryRunner.createForeignKey(
        'notification_reads',
        new TableForeignKey({
          name: 'FK_NOTIFICATION_READS_NOTIFICATION_ID',
          columnNames: ['notification_id'],
          referencedTableName: 'notifications',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
      await queryRunner.createForeignKey(
        'notification_reads',
        new TableForeignKey({
          name: 'FK_NOTIFICATION_READS_USER_ID',
          columnNames: ['user_id'],
          referencedTableName: 'account',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
    }

    const hasDeviceTokens = await queryRunner.hasTable('device_tokens');
    if (!hasDeviceTokens) {
      await queryRunner.createTable(
        new Table({
          name: 'device_tokens',
          columns: [
            {
              name: 'id',
              type: 'uuid',
              isPrimary: true,
              isGenerated: true,
              generationStrategy: 'uuid',
              default: 'uuid_generate_v4()',
            },
            { name: 'user_id', type: 'uuid' },
            { name: 'token', type: 'text' },
            { name: 'platform', type: 'device_tokens_platform_enum' },
            { name: 'is_active', type: 'boolean', default: true },
            { name: 'created_at', type: 'timestamptz', default: 'now()' },
            { name: 'updated_at', type: 'timestamptz', default: 'now()' },
          ],
        }),
        true,
      );

      await queryRunner.createUniqueConstraint(
        'device_tokens',
        new TableUnique({
          name: 'UQ_DEVICE_TOKEN',
          columnNames: ['token'],
        }),
      );
      await queryRunner.createIndex(
        'device_tokens',
        new TableIndex({
          name: 'IDX_DEVICE_TOKENS_USER_ID',
          columnNames: ['user_id'],
        }),
      );

      await queryRunner.createForeignKey(
        'device_tokens',
        new TableForeignKey({
          name: 'FK_DEVICE_TOKENS_USER_ID',
          columnNames: ['user_id'],
          referencedTableName: 'account',
          referencedColumnNames: ['id'],
          onDelete: 'CASCADE',
        }),
      );
    }
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    if (await queryRunner.hasTable('device_tokens')) {
      await queryRunner.query(
        `ALTER TABLE "device_tokens" DROP CONSTRAINT IF EXISTS "FK_DEVICE_TOKENS_USER_ID"`,
      );
      await queryRunner.dropTable('device_tokens', true);
    }

    if (await queryRunner.hasTable('notification_reads')) {
      await queryRunner.query(
        `ALTER TABLE "notification_reads" DROP CONSTRAINT IF EXISTS "FK_NOTIFICATION_READS_USER_ID"`,
      );
      await queryRunner.query(
        `ALTER TABLE "notification_reads" DROP CONSTRAINT IF EXISTS "FK_NOTIFICATION_READS_NOTIFICATION_ID"`,
      );
      await queryRunner.dropTable('notification_reads', true);
    }

    if (await queryRunner.hasTable('notifications')) {
      await queryRunner.query(
        `ALTER TABLE "notifications" DROP CONSTRAINT IF EXISTS "FK_NOTIFICATIONS_SENDER_ID"`,
      );
      await queryRunner.query(
        `ALTER TABLE "notifications" DROP CONSTRAINT IF EXISTS "FK_NOTIFICATIONS_RECIPIENT_ID"`,
      );
      await queryRunner.dropTable('notifications', true);
    }

    await queryRunner.query(`DROP TYPE IF EXISTS "device_tokens_platform_enum"`);
    await queryRunner.query(`DROP TYPE IF EXISTS "notifications_type_enum"`);
  }
}
