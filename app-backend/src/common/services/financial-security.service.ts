import { Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class FinancialSecurityService {
  private readonly PLATFORM_FEE_PERCENTAGE = 5; // 5% platform cut

  calculateWagerPayout(stakeAmount: number) {
    if (stakeAmount <= 0) {
      throw new BadRequestException('Stake amount must be positive.');
    }

    const platformFee = (stakeAmount * 2 * this.PLATFORM_FEE_PERCENTAGE) / 100;
    const totalPrizePool = (stakeAmount * 2) - platformFee;

    return {
      stakeAmount,
      platformFee,
      totalPrizePool,
    };
  }
}