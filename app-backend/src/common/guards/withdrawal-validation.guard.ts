import { Injectable, CanActivate, ExecutionContext, BadRequestException } from '@nestjs/common';

@Injectable()
export class WithdrawalValidationGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const { amount, bankCode, accountNumber } = request.body;

    if (!amount || amount <= 0) {
      throw new BadRequestException('Invalid withdrawal amount.');
    }

    if (!bankCode || !accountNumber || accountNumber.length < 10) {
      throw new BadRequestException('Valid bank account details are required for withdrawal.');
    }

    return true;
  }
}