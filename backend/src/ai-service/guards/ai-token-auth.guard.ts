import {
  CanActivate,
  ExecutionContext,
  Injectable,
  Logger,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';

/**
 * Guard that validates the `X-AI-API-Key` header against a static
 * API token stored in the `AI_API_TOKEN` environment variable.
 *
 * This provides machine-to-machine (M2M) authentication for the
 * external AI service, separate from user JWT authentication.
 */
@Injectable()
export class AiTokenAuthGuard implements CanActivate {
  private readonly logger = new Logger(AiTokenAuthGuard.name);

  constructor(private readonly configService: ConfigService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    const apiKey = request.headers['x-ai-api-key'] as string | undefined;

    if (!apiKey) {
      this.logger.warn('Missing X-AI-API-Key header');
      throw new UnauthorizedException('Missing API key');
    }

    const expectedToken = this.configService.get<string>('AI_API_TOKEN');
    if (!expectedToken) {
      this.logger.error('AI_API_TOKEN environment variable is not configured');
      throw new UnauthorizedException('AI service is not configured');
    }

    console.log('API Key:', apiKey);
    console.log('Expected Token:', expectedToken);

    if (apiKey.trim() !== expectedToken.trim()) {
      this.logger.warn('Invalid AI API key provided');
      throw new UnauthorizedException('Invalid API key');
    }

    return true;
  }
}
