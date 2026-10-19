import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import * as crypto from 'crypto';

@Injectable()
export class WebhookSignatureGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const signature = request.headers['x-paystack-signature'] || request.headers['verif-hash'];

    if (!signature) {
      throw new ForbiddenException('Missing webhook signature.');
    }

    const secret = process.env.PAYSTACK_WEBHOOK_SECRET || 'secret';
    const hash = crypto
      .createHmac('sha512', secret)
      .update(JSON.stringify(request.body))
      .digest('hex');

    if (hash !== signature) {
      throw new ForbiddenException('Invalid webhook cryptographic signature.');
    }

    return true;
  }
}