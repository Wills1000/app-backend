import {
  BadRequestException,
  HttpException,
  HttpStatus,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { createHash, randomInt, timingSafeEqual } from 'crypto';
import { PrismaService } from '../prisma/prisma.service';
 
const CODE_TTL_MINUTES = 10; // how long a code stays valid
const RESEND_WAIT_SECONDS = 60; // wait before another code can be sent
const MAX_ATTEMPTS = 5; // wrong guesses allowed per code
 
type VerifiableUser = { id: string; email: string; isVerified: boolean };
 
@Injectable()
export class VerificationService {
  private readonly logger = new Logger(VerificationService.name);
 
  constructor(private prisma: PrismaService) {}
 
  // Codes are stored hashed, never as plain text
  private hashCode(userId: string, code: string): string {
    return createHash('sha256').update(`${userId}:${code}`).digest('hex');
  }
 
  // Sends the email through Brevo's web API (Render's free plan blocks normal SMTP)
  private async sendEmail(to: string, code: string): Promise<void> {
    const apiKey = process.env.BREVO_API_KEY;
    const fromEmail = process.env.MAIL_FROM;
 
    if (!apiKey || !fromEmail) {
      this.logger.error('BREVO_API_KEY or MAIL_FROM is not set');
      throw new InternalServerErrorException('Email service is not configured');
    }
 
    const res = await fetch('https://api.brevo.com/v3/smtp/email', {
      method: 'POST',
      headers: {
        'api-key': apiKey,
        'content-type': 'application/json',
        accept: 'application/json',
      },
      body: JSON.stringify({
        sender: {
          email: fromEmail,
          name: process.env.MAIL_FROM_NAME || 'Gamer App',
        },
        to: [{ email: to }],
        subject: 'Your verification code',
        htmlContent:
          `<p>Your verification code is:</p>` +
          `<h2 style="letter-spacing:4px">${code}</h2>` +
          `<p>It expires in ${CODE_TTL_MINUTES} minutes. ` +
          `If you didn't request this, you can ignore this email.</p>`,
      }),
    });
 
    if (!res.ok) {
      const text = await res.text();
      this.logger.error(`Brevo error ${res.status}: ${text}`);
      throw new InternalServerErrorException('Could not send verification email');
    }
  }
 
  async sendCode(user: VerifiableUser) {
    if (user.isVerified) {
      return { message: 'Email already verified', verified: true };
    }
 
    // Enforce the resend wait (matches the timer on the app screen)
    const existing = await this.prisma.emailVerification.findUnique({
      where: { userId: user.id },
    });
    if (existing) {
      const secondsSince = (Date.now() - existing.lastSentAt.getTime()) / 1000;
      if (secondsSince < RESEND_WAIT_SECONDS) {
        const wait = Math.ceil(RESEND_WAIT_SECONDS - secondsSince);
        throw new HttpException(
          {
            message: `Please wait ${wait}s before requesting another code`,
            resendInSeconds: wait,
          },
          HttpStatus.TOO_MANY_REQUESTS,
        );
      }
    }
 
    const code = randomInt(100000, 1000000).toString();
 
    // Send first, save after: if the email fails, nothing is saved or locked
    await this.sendEmail(user.email, code);
 
    const now = new Date();
    const data = {
      codeHash: this.hashCode(user.id, code),
      expiresAt: new Date(now.getTime() + CODE_TTL_MINUTES * 60 * 1000),
      attempts: 0,
      lastSentAt: now,
    };
 
    await this.prisma.emailVerification.upsert({
      where: { userId: user.id },
      create: { userId: user.id, ...data },
      update: data,
    });
 
    return {
      message: 'Verification code sent',
      resendInSeconds: RESEND_WAIT_SECONDS,
    };
  }
 
  async verifyCode(user: VerifiableUser, code: string) {
    if (user.isVerified) {
      return { verified: true };
    }
 
    const record = await this.prisma.emailVerification.findUnique({
      where: { userId: user.id },
    });
 
    if (!record) {
      throw new BadRequestException('No code requested. Please request a new code.');
    }
    if (record.expiresAt.getTime() < Date.now()) {
      throw new BadRequestException('Code expired. Please request a new code.');
    }
    if (record.attempts >= MAX_ATTEMPTS) {
      throw new BadRequestException('Too many wrong attempts. Please request a new code.');
    }
 
    const given = Buffer.from(this.hashCode(user.id, code));
    const expected = Buffer.from(record.codeHash);
    const matches = given.length === expected.length && timingSafeEqual(given, expected);
 
    if (!matches) {
      await this.prisma.emailVerification.update({
        where: { id: record.id },
        data: { attempts: { increment: 1 } },
      });
      throw new BadRequestException('Incorrect code');
    }
 
    await this.prisma.$transaction([
      this.prisma.user.update({
        where: { id: user.id },
        data: { isVerified: true },
      }),
      this.prisma.emailVerification.delete({ where: { id: record.id } }),
    ]);
 
    return { verified: true };
  }
}
 