import {
  MigrationInterface,
  QueryRunner,
  Table,
  TableForeignKey,
  TableIndex,
  TableUnique,
} from 'typeorm';

export class CreatePartnerChatTables1775200000000 implements MigrationInterface {
  name = 'CreatePartnerChatTables1775200000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // ────────────────────────────────────────────────────────────
    // 1. CREATE ENUM: partner_conversations_status_enum
    // ────────────────────────────────────────────────────────────
    await queryRunner.query(
      `CREATE TYPE "partner_conversations_status_enum" AS ENUM ('active', 'archived', 'closed')`,
    );

    // ────────────────────────────────────────────────────────────
    // 2. CREATE ENUM: partner_chat_messages_message_type_enum
    // ────────────────────────────────────────────────────────────
    await queryRunner.query(
      `CREATE TYPE "partner_chat_messages_message_type_enum" AS ENUM ('text', 'image', 'file', 'system')`,
    );

    // ────────────────────────────────────────────────────────────
    // 3. CREATE TABLE: partner_conversations
    // ────────────────────────────────────────────────────────────
    await queryRunner.createTable(
      new Table({
        name: 'partner_conversations',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'user_id',
            type: 'uuid',
          },
          {
            name: 'partner_account_id',
            type: 'uuid',
          },
          {
            name: 'booking_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'status',
            type: 'partner_conversations_status_enum',
            default: `'active'`,
          },
          {
            name: 'last_message_text',
            type: 'text',
            isNullable: true,
          },
          {
            name: 'last_message_at',
            type: 'timestamptz',
            isNullable: true,
          },
          {
            name: 'last_message_sender_id',
            type: 'uuid',
            isNullable: true,
          },
          {
            name: 'user_unread_count',
            type: 'int',
            default: 0,
          },
          {
            name: 'partner_unread_count',
            type: 'int',
            default: 0,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'updated_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'deleted_at',
            type: 'timestamptz',
            isNullable: true,
          },
        ],
      }),
      true,
    );

    // Indexes
    await queryRunner.createIndex(
      'partner_conversations',
      new TableIndex({
        name: 'IDX_PARTNER_CONV_USER_ID',
        columnNames: ['user_id'],
      }),
    );
    await queryRunner.createIndex(
      'partner_conversations',
      new TableIndex({
        name: 'IDX_PARTNER_CONV_PARTNER_ACCOUNT_ID',
        columnNames: ['partner_account_id'],
      }),
    );
    await queryRunner.createIndex(
      'partner_conversations',
      new TableIndex({
        name: 'IDX_PARTNER_CONV_BOOKING_ID',
        columnNames: ['booking_id'],
      }),
    );

    // Unique constraint
    await queryRunner.createUniqueConstraint(
      'partner_conversations',
      new TableUnique({
        name: 'UQ_PARTNER_CONV_USER_PARTNER',
        columnNames: ['user_id', 'partner_account_id'],
      }),
    );

    // Foreign keys
    await queryRunner.createForeignKey(
      'partner_conversations',
      new TableForeignKey({
        name: 'FK_PARTNER_CONV_USER_ID',
        columnNames: ['user_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'partner_conversations',
      new TableForeignKey({
        name: 'FK_PARTNER_CONV_PARTNER_ACCOUNT_ID',
        columnNames: ['partner_account_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'partner_conversations',
      new TableForeignKey({
        name: 'FK_PARTNER_CONV_BOOKING_ID',
        columnNames: ['booking_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'bookings',
        onDelete: 'SET NULL',
      }),
    );

    // ────────────────────────────────────────────────────────────
    // 4. CREATE TABLE: partner_chat_messages
    // ────────────────────────────────────────────────────────────
    await queryRunner.createTable(
      new Table({
        name: 'partner_chat_messages',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'conversation_id',
            type: 'uuid',
          },
          {
            name: 'sender_id',
            type: 'uuid',
          },
          {
            name: 'content',
            type: 'text',
          },
          {
            name: 'message_type',
            type: 'partner_chat_messages_message_type_enum',
            default: `'text'`,
          },
          {
            name: 'client_message_id',
            type: 'varchar',
            length: '100',
            isNullable: true,
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
          {
            name: 'deleted_at',
            type: 'timestamptz',
            isNullable: true,
          },
        ],
      }),
      true,
    );

    // Composite index for efficient message listing
    await queryRunner.createIndex(
      'partner_chat_messages',
      new TableIndex({
        name: 'IDX_PARTNER_MSG_CONV_CREATED',
        columnNames: ['conversation_id', 'created_at'],
      }),
    );
    await queryRunner.createIndex(
      'partner_chat_messages',
      new TableIndex({
        name: 'IDX_PARTNER_MSG_CONVERSATION_ID',
        columnNames: ['conversation_id'],
      }),
    );
    await queryRunner.createIndex(
      'partner_chat_messages',
      new TableIndex({
        name: 'IDX_PARTNER_MSG_SENDER_ID',
        columnNames: ['sender_id'],
      }),
    );
    await queryRunner.createIndex(
      'partner_chat_messages',
      new TableIndex({
        name: 'IDX_PARTNER_MSG_CLIENT_MESSAGE_ID',
        columnNames: ['client_message_id'],
      }),
    );

    // Foreign keys
    await queryRunner.createForeignKey(
      'partner_chat_messages',
      new TableForeignKey({
        name: 'FK_PARTNER_MSG_CONVERSATION_ID',
        columnNames: ['conversation_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'partner_conversations',
        onDelete: 'CASCADE',
      }),
    );
    await queryRunner.createForeignKey(
      'partner_chat_messages',
      new TableForeignKey({
        name: 'FK_PARTNER_MSG_SENDER_ID',
        columnNames: ['sender_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'account',
        onDelete: 'CASCADE',
      }),
    );

    // ────────────────────────────────────────────────────────────
    // 5. CREATE TABLE: partner_chat_attachments
    // ────────────────────────────────────────────────────────────
    await queryRunner.createTable(
      new Table({
        name: 'partner_chat_attachments',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'message_id',
            type: 'uuid',
          },
          {
            name: 'file_url',
            type: 'text',
          },
          {
            name: 'file_name',
            type: 'varchar',
            length: '255',
          },
          {
            name: 'file_type',
            type: 'varchar',
            length: '100',
          },
          {
            name: 'file_size',
            type: 'int',
          },
          {
            name: 'created_at',
            type: 'timestamptz',
            default: 'now()',
          },
        ],
      }),
      true,
    );

    // Index
    await queryRunner.createIndex(
      'partner_chat_attachments',
      new TableIndex({
        name: 'IDX_PARTNER_ATT_MESSAGE_ID',
        columnNames: ['message_id'],
      }),
    );

    // Foreign key
    await queryRunner.createForeignKey(
      'partner_chat_attachments',
      new TableForeignKey({
        name: 'FK_PARTNER_ATT_MESSAGE_ID',
        columnNames: ['message_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'partner_chat_messages',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // 5. partner_chat_attachments
    await queryRunner.dropForeignKey('partner_chat_attachments', 'FK_PARTNER_ATT_MESSAGE_ID');
    await queryRunner.dropIndex('partner_chat_attachments', 'IDX_PARTNER_ATT_MESSAGE_ID');
    await queryRunner.dropTable('partner_chat_attachments', true);

    // 4. partner_chat_messages
    await queryRunner.dropForeignKey('partner_chat_messages', 'FK_PARTNER_MSG_SENDER_ID');
    await queryRunner.dropForeignKey('partner_chat_messages', 'FK_PARTNER_MSG_CONVERSATION_ID');
    await queryRunner.dropIndex('partner_chat_messages', 'IDX_PARTNER_MSG_CLIENT_MESSAGE_ID');
    await queryRunner.dropIndex('partner_chat_messages', 'IDX_PARTNER_MSG_SENDER_ID');
    await queryRunner.dropIndex('partner_chat_messages', 'IDX_PARTNER_MSG_CONVERSATION_ID');
    await queryRunner.dropIndex('partner_chat_messages', 'IDX_PARTNER_MSG_CONV_CREATED');
    await queryRunner.dropTable('partner_chat_messages', true);

    // 3. partner_conversations
    await queryRunner.dropForeignKey('partner_conversations', 'FK_PARTNER_CONV_BOOKING_ID');
    await queryRunner.dropForeignKey('partner_conversations', 'FK_PARTNER_CONV_PARTNER_ACCOUNT_ID');
    await queryRunner.dropForeignKey('partner_conversations', 'FK_PARTNER_CONV_USER_ID');
    await queryRunner.dropUniqueConstraint('partner_conversations', 'UQ_PARTNER_CONV_USER_PARTNER');
    await queryRunner.dropIndex('partner_conversations', 'IDX_PARTNER_CONV_BOOKING_ID');
    await queryRunner.dropIndex('partner_conversations', 'IDX_PARTNER_CONV_PARTNER_ACCOUNT_ID');
    await queryRunner.dropIndex('partner_conversations', 'IDX_PARTNER_CONV_USER_ID');
    await queryRunner.dropTable('partner_conversations', true);

    // Enums
    await queryRunner.query(`DROP TYPE IF EXISTS "partner_chat_messages_message_type_enum"`);
    await queryRunner.query(`DROP TYPE IF EXISTS "partner_conversations_status_enum"`);
  }
}
