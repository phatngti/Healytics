import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class PasswordResetMailerService {
  private readonly logger = new Logger(PasswordResetMailerService.name);

  async sendPasswordResetCode(email: string, code: string): Promise<void> {
    if (
      process.env.NODE_ENV === 'test' &&
      process.env.TEST_PASSWORD_RESET_CODE
    ) {
      this.logger.log(
        `Skipping password reset email in test mode for ${email}: ${code}`,
      );
      return;
    }

    const apiKey = process.env.RESEND_API_KEY;

    if (!apiKey) {
      this.logger.warn(
        `RESEND_API_KEY is not configured. Password reset code for ${email}: ${code}`,
      );
      return;
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from:
          process.env.RESEND_FROM_EMAIL ||
          process.env.MAIL_FROM ||
          'Healytics <no-reply@healytics.vn>',
        to: [email],
        subject: 'Your Healytics password reset code',
        text: [
          'We received a request to reset your Healytics password.',
          '',
          `Your password reset code is: ${code}`,
          '',
          'This code expires shortly.',
          'If you did not request this, you can ignore this email.',
        ].join('\n'),
        html: [
          '<p>We received a request to reset your Healytics password.</p>',
          `<p>Your password reset code is:</p><p><strong style="font-size: 24px; letter-spacing: 4px;">${this.escapeHtml(code)}</strong></p>`,
          '<p>This code expires shortly.</p>',
          '<p>If you did not request this, you can ignore this email.</p>',
        ].join(''),
      }),
    });

    if (!response.ok) {
      const body = await response.text().catch(() => '');
      throw new Error(
        `Resend password reset email failed (${response.status}): ${body}`,
      );
    }
  }

  private escapeHtml(value: string): string {
    return value
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }
}
