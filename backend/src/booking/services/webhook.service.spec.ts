import { Test, TestingModule } from '@nestjs/testing';
import { HttpService } from '@nestjs/axios';
import { of, throwError } from 'rxjs';
import { WebhookService, WebhookPayload } from './webhook.service';

describe('WebhookService', () => {
  let service: WebhookService;
  let httpService: { post: jest.Mock };

  beforeEach(async () => {
    httpService = {
      post: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WebhookService,
        { provide: HttpService, useValue: httpService },
      ],
    }).compile();

    service = module.get<WebhookService>(WebhookService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  const samplePayload: WebhookPayload = {
    ticket_id: 'ticket-1',
    status: 'SUCCESS',
    data: {
      booking_id: 'booking-1',
      payment_url: 'https://pay.example.com',
      expires_at: '2025-10-25T14:10:00Z',
    },
    error: null,
  };

  it('should skip notification when URL is null', async () => {
    // Act
    await service.notify(null, samplePayload);

    // Assert
    expect(httpService.post).not.toHaveBeenCalled();
  });

  it('should deliver webhook successfully on first attempt', async () => {
    // Arrange
    httpService.post.mockReturnValue(of({ status: 200 }));

    // Act
    await service.notify('https://hook.example.com', samplePayload);

    // Assert
    expect(httpService.post).toHaveBeenCalledTimes(1);
    expect(httpService.post).toHaveBeenCalledWith(
      'https://hook.example.com',
      samplePayload,
      { timeout: 5000 },
    );
  });

  it('should retry up to 3 times on failure then succeed', async () => {
    // Arrange — fail twice, succeed on third
    httpService.post
      .mockReturnValueOnce(throwError(() => new Error('Network error')))
      .mockReturnValueOnce(throwError(() => new Error('Timeout')))
      .mockReturnValueOnce(of({ status: 200 }));

    // Act
    await service.notify('https://hook.example.com', samplePayload);

    // Assert
    expect(httpService.post).toHaveBeenCalledTimes(3);
  });

  it('should exhaust all 3 retries and never throw', async () => {
    // Arrange — fail all 3 times
    httpService.post.mockReturnValue(
      throwError(() => new Error('Persistent error')),
    );

    // Act — should not throw
    await expect(
      service.notify('https://hook.example.com', samplePayload),
    ).resolves.toBeUndefined();

    // Assert
    expect(httpService.post).toHaveBeenCalledTimes(3);
  });
});
