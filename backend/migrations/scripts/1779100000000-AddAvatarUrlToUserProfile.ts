import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddAvatarUrlToUserProfile1779100000000
  implements MigrationInterface
{
  name = 'AddAvatarUrlToUserProfile1779100000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "user_profile" ADD "avatar_url" text`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "user_profile" DROP COLUMN "avatar_url"`,
    );
  }
}
