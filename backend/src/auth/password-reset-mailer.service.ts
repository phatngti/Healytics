import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class PasswordResetMailerService {
  private readonly logger = new Logger(PasswordResetMailerService.name);

  async sendPasswordResetEmail(email: string, token: string): Promise<void> {
    const resetUrl = this.buildResetUrl(token);
    const apiKey = process.env.RESEND_API_KEY;

    if (!apiKey) {
      this.logger.warn(
        `RESEND_API_KEY is not configured. Password reset link for ${email}: ${resetUrl}`,
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
        subject: 'Reset your Healytics password',
        text: [
          'We received a request to reset your Healytics password.',
          '',
          `Open this link to reset your password: ${resetUrl}`,
          '',
          'If you did not request this, you can ignore this email.',
        ].join('\n'),
        html: [
          '<p>We received a request to reset your Healytics password.</p>',
          `<p><a href="${this.escapeHtml(resetUrl)}">Reset your password</a></p>`,
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

  private buildResetUrl(token: string): string {
    const configured =
      process.env.PASSWORD_RESET_URL ||
      process.env.APP_PASSWORD_RESET_URL ||
      process.env.FRONTEND_RESET_PASSWORD_URL ||
      'https://dev.healytics.me/reset-password';

    if (configured.includes('{token}')) {
      return configured.replace('{token}', encodeURIComponent(token));
    }

    const separator = configured.includes('?') ? '&' : '?';
    return `${configured}${separator}token=${encodeURIComponent(token)}`;
  }

  private escapeHtml(value: string): string {
    return value
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }
}
