import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AddUsernameAccountTable1769929436336 implements MigrationInterface {

    public async up(queryRunner: QueryRunner): Promise<void> {
        const tableAccount = await queryRunner.getTable('account');
        if(!tableAccount){
            return;
        }
        if (tableAccount.columns.some(column => column.name === 'username')) {
            return;
        }
        await queryRunner.addColumn(tableAccount,
            new TableColumn({
            name: 'username',
            type: 'varchar',
            isNullable: true,
        }));
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        const tableAccount = await queryRunner.getTable('account');
        if(!tableAccount){
            return;
        }
        if (tableAccount.columns.some(column => column.name === 'username')) {
            await queryRunner.dropColumn(tableAccount, 'username');
        }
    }

}
