import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class RenameIdCardUrlToVerificationDocuments1774400000000 implements MigrationInterface {
    name = 'RenameIdCardUrlToVerificationDocuments1774400000000';

    public async up(queryRunner: QueryRunner): Promise<void> {
        // 1. Add new JSONB column
        await queryRunner.addColumn("employees", new TableColumn({
            name: "verification_documents",
            type: "jsonb",
            isNullable: true,
        }));

        // 2. Migrate existing data: convert non-null id_card_url to JSONB array
        await queryRunner.query(`
            UPDATE employees
            SET verification_documents = jsonb_build_array(
                jsonb_build_object(
                    'field_key', 'id_card',
                    'name', 'ID Card',
                    'url', id_card_url,
                    'updated_time', to_char(now() AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')
                )
            )
            WHERE id_card_url IS NOT NULL
        `);

        // 3. Drop old column
        await queryRunner.dropColumn("employees", "id_card_url");
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        // 1. Re-add old column
        await queryRunner.addColumn("employees", new TableColumn({
            name: "id_card_url",
            type: "text",
            isNullable: true,
        }));

        // 2. Extract first document URL back into id_card_url
        await queryRunner.query(`
            UPDATE employees
            SET id_card_url = verification_documents->0->>'url'
            WHERE verification_documents IS NOT NULL
              AND jsonb_array_length(verification_documents) > 0
        `);

        // 3. Drop JSONB column
        await queryRunner.dropColumn("employees", "verification_documents");
    }
}
