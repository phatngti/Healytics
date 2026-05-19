import 'reflect-metadata';
import { Type } from '@nestjs/common';
import { DECORATORS } from '@nestjs/swagger/dist/constants';
import {
  WS_NAMESPACE_METADATA,
  WS_EVENT_DOC_METADATA,
  WS_MODEL_METADATA,
} from './constants';
import { WsNamespaceOptions, WsEventDocOptions, WsModelOptions } from './types';
import { getWsEnum, getAllWsEnums } from './ws-enum.registry';

// ─── Internal Types ────────────────────────────────────────────

interface ContractNamespace {
  description: string;
  auth: { type: string; roles: string[] };
  extends?: string;
  clientToServer?: Record<string, ContractEventDef>;
  serverToClient?: Record<string, ContractEventDef>;
}

interface ContractEventDef {
  description: string;
  payload: string;
  ack?: string;
}

interface ContractProperty {
  type: string;
  required: boolean;
  description: string;
  isEnum?: boolean;
  default?: string;
}

interface ContractModel {
  description: string;
  direction: 'clientToServer' | 'serverToClient';
  properties: Record<string, ContractProperty>;
}

interface ContractEnum {
  description: string;
  values: string[];
}

interface WsContract {
  $schema: string;
  $comment: string;
  namespaces: Record<string, ContractNamespace>;
  models: Record<string, ContractModel>;
  enums: Record<string, ContractEnum>;
}

// ─── Helpers ───────────────────────────────────────────────────

/** Strip 'Dto' suffix: WsSendMessagePayloadDto → WsSendMessagePayload */
function toContractModelName(dtoClass: Type): string {
  return dtoClass.name.replace(/Dto$/, '');
}

function isDtoConstructor(value: unknown): value is Type {
  return (
    typeof value === 'function' &&
    ![String, Number, Boolean, Date, Object, Array].includes(value as any)
  );
}

/** Map JS constructor / swagger type to contract type string */
function resolveType(meta: any): { type: string; isEnum?: boolean } {
  // Enum property — use enumName to look up the registry
  if (meta.enumName) {
    const reg = getWsEnum(meta.enumName);
    if (reg) return { type: reg.contractName, isEnum: true };
    // Fallback: use enumName directly
    return { type: meta.enumName, isEnum: true };
  }
  if (meta.enum) {
    // enum passed without enumName — try to detect
    return { type: 'String', isEnum: true };
  }

  const t = meta.type;
  if (!t) return { type: 'String' };
  if (
    t === Date ||
    t === 'Date' ||
    (typeof t === 'function' && t.name === 'Date')
  ) {
    return { type: 'DateTime' };
  }
  if (t === Number || t === 'Number' || t === 'number') return { type: 'num' };
  if (t === Boolean || t === 'Boolean' || t === 'boolean')
    return { type: 'bool' };
  if (
    t === 'object' ||
    t === Object ||
    (typeof t === 'function' && t.name === 'Object')
  )
    return { type: 'object' };
  if (isDtoConstructor(t)) return { type: toContractModelName(t) };
  return { type: 'String' };
}

function readDtoPropertyTypes(dtoClass: Type): Type[] {
  const nested: Type[] = [];
  const propArray: string[] =
    Reflect.getMetadata(
      DECORATORS.API_MODEL_PROPERTIES_ARRAY,
      dtoClass.prototype,
    ) || [];

  for (const prefixed of propArray) {
    const name = prefixed.startsWith(':') ? prefixed.slice(1) : prefixed;
    const meta =
      Reflect.getMetadata(
        DECORATORS.API_MODEL_PROPERTIES,
        dtoClass.prototype,
        name,
      ) || {};

    if (isDtoConstructor(meta.type)) {
      nested.push(meta.type);
    }
  }

  return nested;
}

/** Read @ApiProperty metadata from a DTO class */
function readDtoProperties(dtoClass: Type): Record<string, ContractProperty> {
  const props: Record<string, ContractProperty> = {};

  const propArray: string[] =
    Reflect.getMetadata(
      DECORATORS.API_MODEL_PROPERTIES_ARRAY,
      dtoClass.prototype,
    ) || [];

  for (const prefixed of propArray) {
    const name = prefixed.startsWith(':') ? prefixed.slice(1) : prefixed;
    const meta =
      Reflect.getMetadata(
        DECORATORS.API_MODEL_PROPERTIES,
        dtoClass.prototype,
        name,
      ) || {};

    const { type, isEnum } = resolveType(meta);

    const prop: ContractProperty = {
      type,
      required: meta.required !== false,
      description: meta.description || '',
    };

    if (isEnum) prop.isEnum = true;
    if (meta.default !== undefined) {
      prop.default =
        typeof meta.default === 'string' ? meta.default : String(meta.default);
    }

    props[name] = prop;
  }

  return props;
}

// ─── Main Generator ──────────────────────────────────────────

/**
 * Generate a WS contract JSON object by reading decorator metadata
 * from the provided gateway classes.
 *
 * @param gateways — Array of gateway class constructors decorated with @WsNamespace
 */
export function generateWsContract(gateways: Type[]): WsContract {
  const contract: WsContract = {
    $schema: 'https://json-schema.org/draft/2020-12/schema',
    $comment:
      'Auto-generated from backend WS decorators — DO NOT EDIT BY HAND. Run: yarn generate:ws-contract',
    namespaces: {},
    models: {},
    enums: {},
  };

  // Track which DTOs are used in which direction
  const clientToServerDtos = new Set<Type>();
  const serverToClientDtos = new Set<Type>();

  for (const gateway of gateways) {
    const nsMeta: WsNamespaceOptions | undefined = Reflect.getMetadata(
      WS_NAMESPACE_METADATA,
      gateway,
    );
    if (!nsMeta) {
      console.warn(
        `⚠️  ${gateway.name} has no @WsNamespace decorator — skipping`,
      );
      continue;
    }

    const nsEntry: ContractNamespace = {
      description: nsMeta.description,
      auth: nsMeta.auth,
    };

    if (nsMeta.extends) {
      nsEntry.extends = nsMeta.extends;
    } else {
      // ── Client → Server events (from @SubscribeMessage + @WsEventDoc) ──
      const clientEvents: Record<string, ContractEventDef> = {};

      for (const methodName of Object.getOwnPropertyNames(gateway.prototype)) {
        if (methodName === 'constructor') continue;

        const method = gateway.prototype[methodName];
        if (typeof method !== 'function') continue;

        // @SubscribeMessage stores metadata on the function itself (descriptor.value)
        const eventName: string | undefined = Reflect.getMetadata(
          'message',
          method,
        );
        if (!eventName) continue;

        const wsDoc: WsEventDocOptions | undefined = Reflect.getMetadata(
          WS_EVENT_DOC_METADATA,
          method,
        );
        if (!wsDoc) {
          console.warn(
            `⚠️  ${gateway.name}.${methodName} has @SubscribeMessage('${eventName}') but no @WsEventDoc — skipping`,
          );
          continue;
        }

        const eventDef: ContractEventDef = {
          description: wsDoc.description,
          payload: toContractModelName(wsDoc.payload),
        };
        if (wsDoc.ack) {
          eventDef.ack = toContractModelName(wsDoc.ack);
          serverToClientDtos.add(wsDoc.ack);
        }

        clientEvents[eventName] = eventDef;
        clientToServerDtos.add(wsDoc.payload);
      }

      nsEntry.clientToServer = clientEvents;

      // ── Server → Client events (from @WsNamespace serverEvents) ────
      const serverEvents: Record<string, ContractEventDef> = {};

      for (const se of nsMeta.serverEvents || []) {
        serverEvents[se.event] = {
          description: se.description,
          payload: toContractModelName(se.payload),
        };
        serverToClientDtos.add(se.payload);
      }

      nsEntry.serverToClient = serverEvents;
    }

    contract.namespaces[nsMeta.name] = nsEntry;
  }

  // ── Build models ─────────────────────────────────────────────
  const allDtos = new Map<Type, 'clientToServer' | 'serverToClient'>();
  for (const dto of clientToServerDtos) allDtos.set(dto, 'clientToServer');
  for (const dto of serverToClientDtos) allDtos.set(dto, 'serverToClient');

  for (const [dtoClass, direction] of Array.from(allDtos)) {
    for (const nestedDto of readDtoPropertyTypes(dtoClass)) {
      if (!allDtos.has(nestedDto)) {
        allDtos.set(nestedDto, direction);
      }
    }
  }

  for (const [dtoClass, direction] of allDtos) {
    const contractName = toContractModelName(dtoClass);
    const modelMeta: WsModelOptions | undefined = Reflect.getMetadata(
      WS_MODEL_METADATA,
      dtoClass,
    );

    contract.models[contractName] = {
      description: modelMeta?.description || contractName,
      direction,
      properties: readDtoProperties(dtoClass),
    };
  }

  // ── Build enums ──────────────────────────────────────────────
  for (const [, reg] of getAllWsEnums()) {
    contract.enums[reg.contractName] = {
      description: reg.description,
      values: reg.values,
    };
  }

  return contract;
}
