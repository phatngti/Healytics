import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ServiceTag } from '../../entities/service-tag.entity';

/**
 * Handler for removing (soft deleting) a service tag.
 * Includes ownership validation - only the owner can delete their tags.
 */
@Injectable()
export class RemoveServiceTagHandler {
  private readonly logger = new Logger(RemoveServiceTagHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the remove service tag command (soft delete).
   * @param id - The ID of the tag to remove
   * @param userId - The ID of the user requesting the deletion
   */
  async execute(id: string, userId: string): Promise<void> {
    this.logger.log(`Executing RemoveServiceTagHandler for tag: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration (Load)
      const tag = await queryRunner.manager.findOne(ServiceTag, {
        where: { id },
      });

      // 2. Invariant Check (Validate)
      if (!tag) {
        throw new NotFoundException(`Service tag with ID ${id} not found`);
      }

      if (tag.userId !== userId) {
        throw new ForbiddenException('You do not have permission to delete this tag');
      }

      // 3. Domain Action & Persistence (Soft Delete)
      await queryRunner.manager.softDelete(ServiceTag, id);

      await queryRunner.commitTransaction();
      this.logger.log(`Service tag soft deleted successfully: ${id}`);
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to remove service tag: ${error.message}`,
        error.stack,
      );

      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new InternalServerErrorException(
        'Transaction failed during service tag removal',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
