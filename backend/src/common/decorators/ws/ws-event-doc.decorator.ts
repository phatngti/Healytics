import { WS_EVENT_DOC_METADATA } from './constants';
import { WsEventDocOptions } from './types';

/**
 * Method decorator for `@SubscribeMessage` handlers.
 *
 * Documents the event's payload DTO and optional ACK response
 * for the WS contract generator. The event name and direction
 * (client→server) are inferred from `@SubscribeMessage`.
 *
 * @example
 * ```ts
 * @WsEventDoc({
 *   description: 'Send a chat message',
 *   payload: WsSendMessagePayloadDto,
 *   ack: WsMessageSentAckDto,
 * })
 * @SubscribeMessage(ChatEvent.SEND_MESSAGE)
 * async handleSendMessage(...) { ... }
 * ```
 */
export function WsEventDoc(options: WsEventDocOptions): MethodDecorator {
  return (_target, _propertyKey, descriptor: PropertyDescriptor) => {
    Reflect.defineMetadata(WS_EVENT_DOC_METADATA, options, descriptor.value);
    return descriptor;
  };
}
