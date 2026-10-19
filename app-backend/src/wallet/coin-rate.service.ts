import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CoinRateService {
  constructor(private prisma: PrismaService) {}

  /**
   * Get Current Active Coin Rate
   */
  async getCurrentRate() {
    const db: any = this.prisma;
    const activeRate = await db.coinRate.findFirst({
      where: { isActive: true },
      orderBy: { createdAt: 'desc' },
    });

    // Default to 1.0 if no rate has been explicitly configured yet
    return { rate: activeRate ? activeRate.rate : 1.0 };
  }

  /**
   * Get Rate History
   */
  async getRateHistory() {
    const db: any = this.prisma;
    return db.coinRate.findMany({
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  /**
   * Admin-Controlled Rate: Set a new coin rate with validation
   */
  async setCoinRate(adminUserId: string, newRate: number) {
    if (newRate <= 0) {
      throw new BadRequestException('Coin rate must be a positive value greater than zero.');
    }

    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      // Deactivate previous active rates
      await tx.coinRate.updateMany({
        where: { isActive: true },
        data: { isActive: false },
      });

      // Create new active rate record
      const createdRate = await tx.coinRate.create({
        data: {
          rate: newRate,
          isActive: true,
          updatedBy: adminUserId,
        },
      });

      return {
        message: 'Coin rate updated successfully',
        coinRate: createdRate.rate,
      };
    });
  }

  /**
   * Server-Side Conversion: Convert Naira (Fiat) to Coins
   */
  async convertFiatToCoins(fiatAmount: number): Promise<number> {
    const { rate } = await this.getCurrentRate();
    if (rate <= 0) throw new BadRequestException('Invalid active coin conversion rate.');
    return Number((fiatAmount / rate).toFixed(4));
  }

  /**
   * Server-Side Conversion: Convert Coins to Naira (Fiat)
   */
  async convertCoinsToFiat(coinAmount: number): Promise<number> {
    const { rate } = await this.getCurrentRate();
    return Number((coinAmount * rate).toFixed(2));
  }

  /**
   * Deposit Conversion Integration: Add coins when depositing or funding
   */
  async processDepositConversion(userId: string, fiatAmount: number) {
    const coinsToAdd = await this.convertFiatToCoins(fiatAmount);
    const db: any = this.prisma;

    return db.wallet.update({
      where: { userId },
      data: {
        coinBalance: { increment: coinsToAdd },
      },
    });
  }

  /**
   * Winnings Conversion Integration: Convert game winnings to coin/fiat value
   */
  async processWinningsConversion(userId: string, baseWinnings: number) {
    const convertedWinnings = await this.convertFiatToCoins(baseWinnings);
    const db: any = this.prisma;

    return db.wallet.update({
      where: { userId },
      data: {
        coinBalance: { increment: convertedWinnings },
      },
    });
  }

  /**
   * Withdrawal Conversion Integration: Convert coin balance back to fiat for payout
   */
  async processWithdrawalConversion(userId: string, coinAmountToWithdraw: number) {
    const db: any = this.prisma;
    const wallet = await db.wallet.findUnique({ where: { userId } });
    if (!wallet || wallet.coinBalance < coinAmountToWithdraw) {
      throw new BadRequestException('Insufficient coin balance for withdrawal conversion.');
    }

    const fiatPayoutValue = await this.convertCoinsToFiat(coinAmountToWithdraw);

    return {
      coinDeducted: coinAmountToWithdraw,
      fiatPayoutValue,
    };
  }
}