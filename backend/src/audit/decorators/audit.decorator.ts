import { SetMetadata, applyDecorators } from '@nestjs/common';

export const AUDIT_ACTION_KEY = 'audit_action';
export const AUDIT_TARGET_ENTITY_KEY = 'audit_target_entity';

export const Audit = (action: string, targetEntity: string) =>
  applyDecorators(
    SetMetadata(AUDIT_ACTION_KEY, action),
    SetMetadata(AUDIT_TARGET_ENTITY_KEY, targetEntity),
  );
