import { WS_MODEL_METADATA } from './constants';
import { WsModelOptions } from './types';

/**
 * Class decorator for WebSocket payload / event DTOs.
 *
 * Provides the description used in the generated WS contract.
 * Property schemas are read from existing `@ApiProperty` decorators.
 *
 * @example
 * ```ts
 * @WsModel({ description: 'Payload for sending a message via WebSocket' })
 * export class WsSendMessagePayloadDto { ... }
 * ```
 */
export function WsModel(options: WsModelOptions): ClassDecorator {
  return (target) => {
    Reflect.defineMetadata(WS_MODEL_METADATA, options, target);
  };
}
