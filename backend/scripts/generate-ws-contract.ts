#!/usr/bin/env ts-node
/**
 * CLI script to generate ws-contract.json from gateway decorator metadata.
 *
 * NOTE: The contract is also auto-generated on application startup in
 * development mode via WsContractBootstrapService. This script is kept
 * for CI pipelines or manual one-off generation.
 *
 * Usage:
 *   yarn generate:ws-contract
 *   yarn generate:ws-contract --output ./custom/path/ws-contract.json
 */
import 'reflect-metadata';
import * as fs from 'fs';
import * as path from 'path';

// ── Import enum registrations (side-effect: registers enums) ──
import '@/chat/enums/message-type.enum';

// ── Import gateway classes (side-effect: registers decorators) ──
import { UserChatGateway } from '@/chat/ws/user-chat.gateway';
import { PartnerChatGateway } from '@/chat/ws/partner-chat.gateway';

import { generateWsContract } from '@/common/decorators/ws';

// ── CLI args ──────────────────────────────────────────────────

const args = process.argv.slice(2);
const outputIdx = args.indexOf('--output');
const defaultOutput = path.resolve(__dirname, '../openapi/ws-contract.json');
const outputPath = outputIdx !== -1 && args[outputIdx + 1]
  ? path.resolve(args[outputIdx + 1])
  : defaultOutput;

// ── Generate ──────────────────────────────────────────────────

console.log('\n🔌  WS Contract Generator (CLI)');
console.log(`   Output: ${outputPath}\n`);

const contract = generateWsContract([UserChatGateway, PartnerChatGateway]);

// Ensure output directory exists
const outputDir = path.dirname(outputPath);
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

fs.writeFileSync(outputPath, JSON.stringify(contract, null, 2) + '\n');

// ── Summary ───────────────────────────────────────────────────

const nsCount = Object.keys(contract.namespaces).length;
const modelCount = Object.keys(contract.models).length;
const enumCount = Object.keys(contract.enums).length;

let eventCount = 0;
for (const ns of Object.values(contract.namespaces)) {
  eventCount += Object.keys((ns as any).clientToServer || {}).length;
  eventCount += Object.keys((ns as any).serverToClient || {}).length;
}

console.log('📦  Generation complete!');
console.log(`   ${nsCount} namespaces, ${eventCount} events, ${modelCount} models, ${enumCount} enums`);
console.log(`   Written to: ${outputPath}\n`);
