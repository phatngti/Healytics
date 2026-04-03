import { SetMetadata } from '@nestjs/common';
import { WS_NAMESPACE_METADATA } from './constants';
import { WsNamespaceOptions } from './types';

/**
 * Class decorator for WebSocket gateways.
 *
 * Defines namespace-level metadata used by the WS contract generator:
 * namespace name, description, auth, and server→client events.
 *
 * @example
 * ```ts
 * @WsNamespace({
 *   name: 'user-chat',
 *   description: 'User (patient) WebSocket gateway',
 *   auth: { type: 'jwt', roles: ['user'] },
 *   serverEvents: [
 *     { event: ChatEvent.NEW_MESSAGE, description: '...', payload: WsNewMessageEventDto },
 *   ],
 * })
 * @WebSocketGateway({ namespace: 'user-chat' })
 * export class UserChatGateway { ... }
 * ```
 */
export const WsNamespace = (options: WsNamespaceOptions) =>
  SetMetadata(WS_NAMESPACE_METADATA, options);
