import { PasswordResetMailerService } from './password-reset-mailer.service';

describe('PasswordResetMailerService', () => {
  const originalNodeEnv = process.env.NODE_ENV;
  const originalFixedResetCode = process.env.TEST_PASSWORD_RESET_CODE;
  const originalResendApiKey = process.env.RESEND_API_KEY;
  const originalFetch = global.fetch;

  const restoreEnv = (key: string, value: string | undefined) => {
    if (value === undefined) {
      delete process.env[key];
    } else {
      process.env[key] = value;
    }
  };

  afterEach(() => {
    restoreEnv('NODE_ENV', originalNodeEnv);
    restoreEnv('TEST_PASSWORD_RESET_CODE', originalFixedResetCode);
    restoreEnv('RESEND_API_KEY', originalResendApiKey);
    global.fetch = originalFetch;
    jest.restoreAllMocks();
  });

  it('skips external email delivery when fixed test reset code is configured', async () => {
    process.env.NODE_ENV = 'test';
    process.env.TEST_PASSWORD_RESET_CODE = '123456';
    process.env.RESEND_API_KEY = 'resend-key';
    global.fetch = jest.fn();

    const service = new PasswordResetMailerService();

    await service.sendPasswordResetCode('user@test.healytics.vn', '123456');

    expect(global.fetch).not.toHaveBeenCalled();
  });
});
