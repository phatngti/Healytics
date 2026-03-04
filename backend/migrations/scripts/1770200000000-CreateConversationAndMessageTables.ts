import {
    MigrationInterface,
    QueryRunner,
    Table,
    TableForeignKey,
    TableIndex,
} from "typeorm";

export class CreateConversationAndMessageTables1770200000000
    implements MigrationInterface {
    name = "CreateConversationAndMessageTables1770200000000";

    public async up(queryRunner: QueryRunner): Promise<void> {
        // ----------------------------------------------------------------
        // 1. CREATE TABLE: conversations
        // ----------------------------------------------------------------
        await queryRunner.createTable(
            new Table({
                name: "conversations",
                columns: [
                    {
                        name: "id",
                        type: "uuid",
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: "uuid",
                        default: "uuid_generate_v4()",
                    },
                    {
                        name: "user_id",
                        type: "varchar",
                        isNullable: true,
                    },
                    {
                        name: "title",
                        type: "varchar",
                        length: "255",
                    },
                    {
                        name: "created_at",
                        type: "timestamptz",
                        default: "now()",
                    },
                    {
                        name: "updated_at",
                        type: "timestamptz",
                        default: "now()",
                    },
                ],
            }),
            true,
        );

        // Index on user_id for faster lookups
        await queryRunner.createIndex(
            "conversations",
            new TableIndex({
                name: "IDX_CONVERSATIONS_USER_ID",
                columnNames: ["user_id"],
            }),
        );

        // ----------------------------------------------------------------
        // 2. CREATE TABLE: messages
        // ----------------------------------------------------------------
        await queryRunner.createTable(
            new Table({
                name: "messages",
                columns: [
                    {
                        name: "id",
                        type: "uuid",
                        isPrimary: true,
                        isGenerated: true,
                        generationStrategy: "uuid",
                        default: "uuid_generate_v4()",
                    },
                    {
                        name: "conversation_id",
                        type: "uuid",
                    },
                    {
                        name: "role",
                        type: "varchar",
                        length: "20",
                    },
                    {
                        name: "content",
                        type: "text",
                    },
                    {
                        name: "created_at",
                        type: "timestamptz",
                        default: "now()",
                    },
                ],
            }),
            true,
        );

        // Index on conversation_id FK
        await queryRunner.createIndex(
            "messages",
            new TableIndex({
                name: "IDX_MESSAGES_CONVERSATION_ID",
                columnNames: ["conversation_id"],
            }),
        );

        // FK: messages -> conversations
        await queryRunner.createForeignKey(
            "messages",
            new TableForeignKey({
                name: "FK_MESSAGES_CONVERSATION_ID",
                columnNames: ["conversation_id"],
                referencedColumnNames: ["id"],
                referencedTableName: "conversations",
                onDelete: "CASCADE",
            }),
        );
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // Drop in reverse order

        // 2. messages
        await queryRunner.dropForeignKey(
            "messages",
            "FK_MESSAGES_CONVERSATION_ID",
        );
        await queryRunner.dropIndex(
            "messages",
            "IDX_MESSAGES_CONVERSATION_ID",
        );
        await queryRunner.dropTable("messages", true);

        // 1. conversations
        await queryRunner.dropIndex(
            "conversations",
            "IDX_CONVERSATIONS_USER_ID",
        );
        await queryRunner.dropTable("conversations", true);
    }
}
