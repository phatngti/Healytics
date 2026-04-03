import { WsEnumRegistration } from './types';

/**
 * Global registry for enums used in WS contracts.
 *
 * TypeScript enums cannot have decorators, so we use a registration
 * function instead. The generator reads this registry to produce
 * the `enums` section of the contract.
 *
 * Key = `enumName` string used in `@ApiProperty({ enumName })`.
 */
const wsEnumRegistry = new Map<string, WsEnumRegistration>();

/**
 * Register a backend enum for inclusion in the WS contract.
 *
 * @param enumName — the string used in `@ApiProperty({ enumName })` on DTO properties
 * @param registration — contract name, description, and values
 *
 * @example
 * ```ts
 * export enum MessageType { TEXT = 'text', IMAGE = 'image', FILE = 'file', SYSTEM = 'system' }
 *
 * registerWsEnum('MessageType', {
 *   contractName: 'WsMessageType',
 *   description: 'Type of chat message content',
 *   values: Object.values(MessageType),
 * });
 * ```
 */
export function registerWsEnum(
  enumName: string,
  registration: WsEnumRegistration,
): void {
  wsEnumRegistry.set(enumName, registration);
}

/** Look up a registered WS enum by its `enumName`. */
export function getWsEnum(enumName: string): WsEnumRegistration | undefined {
  return wsEnumRegistry.get(enumName);
}

/** Get all registered WS enums. */
export function getAllWsEnums(): Map<string, WsEnumRegistration> {
  return wsEnumRegistry;
}
