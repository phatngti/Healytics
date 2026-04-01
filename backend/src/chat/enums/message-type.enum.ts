import { registerWsEnum } from '@/common/decorators/ws';

export enum MessageType {
  TEXT = 'text',
  IMAGE = 'image',
  FILE = 'file',
  SYSTEM = 'system',
}

// Register for WS contract generation
registerWsEnum('MessageType', {
  contractName: 'WsMessageType',
  description: 'Type of chat message content',
  values: Object.values(MessageType),
});
