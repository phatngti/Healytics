import { Type } from '@nestjs/common';

// ─── @WsNamespace (class decorator on gateways) ────────────────

export interface WsServerEventDef {
  /** Event name (use ChatEvent enum value) */
  event: string;
  /** Human-readable description */
  description: string;
  /** DTO class for the event payload */
  payload: Type;
}

export interface WsNamespaceOptions {
  /** Namespace path, e.g. 'user-chat' */
  name: string;
  /** Human-readable description */
  description: string;
  /** Auth requirements */
  auth: { type: string; roles: string[] };
  /** Name of another namespace whose events this one inherits */
  extends?: string;
  /** Server → Client events (emitted, no handler method) */
  serverEvents?: WsServerEventDef[];
}

// ─── @WsEventDoc (method decorator on @SubscribeMessage handlers) ──

export interface WsEventDocOptions {
  /** Human-readable description */
  description: string;
  /** DTO class for the event payload */
  payload: Type;
  /** DTO class for the ACK response (optional) */
  ack?: Type;
}

// ─── @WsModel (class decorator on WS DTOs) ────────────────────

export interface WsModelOptions {
  /** Human-readable description for the contract */
  description: string;
}

// ─── Enum registration ─────────────────────────────────────────

export interface WsEnumRegistration {
  /** Name in the generated contract (e.g. 'WsMessageType') */
  contractName: string;
  /** Human-readable description */
  description: string;
  /** Enum string values */
  values: string[];
}
