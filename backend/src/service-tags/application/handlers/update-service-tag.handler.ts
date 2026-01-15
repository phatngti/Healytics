import {
  Injectable,
  Logger,
  NotFoundException,
  ForbiddenException,
  InternalServerErrorException,
} from '@nestjs/common';
import { DataSource } from 'typeorm';
import { UpdateServiceTagDto } from '../../dto/update-service-tag.dto';
import { ServiceTag } from '../../entities/service-tag.entity';

/**
 * Handler for updating an existing service tag.
 * Includes ownership validation - only the owner can update their tags.
 */
@Injectable()
export class UpdateServiceTagHandler {
  private readonly logger = new Logger(UpdateServiceTagHandler.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Executes the update service tag command.
   * @param id - The ID of the tag to update
   * @param command - The DTO containing update data
   * @param userId - The ID of the user requesting the update
   * @returns The updated ServiceTag entity
   */
  async execute(
    id: string,
    command: UpdateServiceTagDto,
    userId: string,
  ): Promise<ServiceTag> {
    this.logger.log(`Executing UpdateServiceTagHandler for tag: ${id}`);
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();

    try {
      // 1. Hydration (Load with pessimistic lock)
      const tag = await queryRunner.manager.findOne(ServiceTag, {
        where: { id },
        lock: { mode: 'pessimistic_write' },
      });

      // 2. Invariant Check (Validate)
      if (!tag) {
        throw new NotFoundException(`Service tag with ID ${id} not found`);
      }

      if (tag.userId !== userId) {
        throw new ForbiddenException('You do not have permission to update this tag');
      }

      // 3. Domain Action (Mutate)
      Object.assign(tag, command);

      // 4. Persistence
      const updatedTag = await queryRunner.manager.save(ServiceTag, tag);

      await queryRunner.commitTransaction();
      this.logger.log(`Service tag updated successfully: ${updatedTag.id}`);

      return updatedTag;
    } catch (error) {
      await queryRunner.rollbackTransaction();
      this.logger.error(
        `Failed to update service tag: ${error.message}`,
        error.stack,
      );

      if (error instanceof NotFoundException || error instanceof ForbiddenException) {
        throw error;
      }
      throw new InternalServerErrorException(
        'Transaction failed during service tag update',
      );
    } finally {
      await queryRunner.release();
    }
  }
}
