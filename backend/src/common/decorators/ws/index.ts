// WS Contract Decorator System
// Custom decorators for documenting WebSocket gateways and generating ws-contract.json

export {
  WS_NAMESPACE_METADATA,
  WS_EVENT_DOC_METADATA,
  WS_MODEL_METADATA,
} from './constants';
export { WsNamespace } from './ws-namespace.decorator';
export { WsEventDoc } from './ws-event-doc.decorator';
export { WsModel } from './ws-model.decorator';
export { registerWsEnum, getWsEnum, getAllWsEnums } from './ws-enum.registry';
export { generateWsContract } from './ws-contract.generator';
export type {
  WsNamespaceOptions,
  WsEventDocOptions,
  WsModelOptions,
  WsServerEventDef,
  WsEnumRegistration,
} from './types';
