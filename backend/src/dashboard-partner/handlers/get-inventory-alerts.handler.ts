import { Injectable, Logger } from '@nestjs/common';
import { InventoryAlertDto } from '../dto/response/inventory-alert.dto';

@Injectable()
export class GetInventoryAlertsHandler {
  private readonly logger = new Logger(GetInventoryAlertsHandler.name);

  async execute(partnerId: string): Promise<InventoryAlertDto[]> {
    this.logger.log(`Getting inventory alerts for partner: ${partnerId}`);

    // TODO: Replace with real inventory table query when inventory feature is implemented
    return [];
  }
}
