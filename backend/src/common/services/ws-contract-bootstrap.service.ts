import { Injectable, Logger, OnApplicationBootstrap } from '@nestjs/common';
import { DiscoveryService } from '@nestjs/core';
import * as fs from 'fs';
import * as path from 'path';
import { WS_NAMESPACE_METADATA } from '@/common/decorators/ws/constants';
import { generateWsContract } from '@/common/decorators/ws';

/**
 * Automatically generates `ws-contract.json` on application bootstrap
 * by discovering all gateways decorated with `@WsNamespace`.
 *
 * Only runs when `NODE_ENV === 'development'`.
 */
@Injectable()
export class WsContractBootstrapService implements OnApplicationBootstrap {
  private readonly logger = new Logger(WsContractBootstrapService.name);

  constructor(private readonly discoveryService: DiscoveryService) {}

  onApplicationBootstrap() {
    if (process.env.NODE_ENV !== 'development') return;

    try {
      this.generateContract();
    } catch (error) {
      this.logger.error(
        `Failed to generate WS contract: ${(error as Error).message}`,
        (error as Error).stack,
      );
    }
  }

  private generateContract() {
    // ── Discover all providers with @WsNamespace metadata ──
    const providers = this.discoveryService.getProviders();
    const gatewayCtrList: any[] = [];

    for (const wrapper of providers) {
      const { metatype } = wrapper;
      if (!metatype) continue;

      const nsMeta = Reflect.getMetadata(WS_NAMESPACE_METADATA, metatype);
      if (nsMeta) {
        gatewayCtrList.push(metatype);
      }
    }

    if (gatewayCtrList.length === 0) {
      this.logger.warn(
        'No @WsNamespace gateways found — skipping contract generation',
      );
      return;
    }

    // ── Generate & write the contract ──
    const outputPath = path.resolve(process.cwd(), 'openapi/ws-contract.json');
    const contract = generateWsContract(gatewayCtrList);

    const outputDir = path.dirname(outputPath);
    if (!fs.existsSync(outputDir)) {
      fs.mkdirSync(outputDir, { recursive: true });
    }

    // ── Skip write if contract hasn't changed ──
    const newContent = JSON.stringify(contract, null, 2) + '\n';
    if (fs.existsSync(outputPath)) {
      const existing = fs.readFileSync(outputPath, 'utf-8');
      if (existing === newContent) {
        this.logger.log('WS contract is up-to-date — no changes');
        return;
      }
    }

    fs.writeFileSync(outputPath, newContent);

    // ── Summary ──
    const nsCount = Object.keys(contract.namespaces).length;
    const modelCount = Object.keys(contract.models).length;
    const enumCount = Object.keys(contract.enums).length;

    let eventCount = 0;
    for (const ns of Object.values(contract.namespaces)) {
      eventCount += Object.keys((ns as any).clientToServer || {}).length;
      eventCount += Object.keys((ns as any).serverToClient || {}).length;
    }

    this.logger.log(
      `🔌 WS contract generated: ${nsCount} namespaces, ${eventCount} events, ${modelCount} models, ${enumCount} enums → ${outputPath}`,
    );
  }
}
