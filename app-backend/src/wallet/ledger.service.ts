// src/wallet/ledger.service.ts
import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LedgerService {
  constructor(private prisma: PrismaService) {}

  /**
   * Core Immutable Ledger Recording Helper
   */
  async recordLedgerEntry(
    tx: any,
    walletId: string,
    type: any,
    amount: number,
    reference: string,
    status: any = 'SUCCESS',
    metadata?: Record<string, any>,
  ) {
    const wallet = await tx.wallet.findUnique({ where: { id: walletId } });
    if (!wallet) throw new NotFoundException('Wallet not found');

    const balanceBefore = wallet.balance;
    const balanceAfter = balanceBefore + amount;

    if (balanceAfter < 0 && amount < 0) {
      throw new BadRequestException('Insufficient wallet balance for this operation.');
    }

    const updatedWallet = await tx.wallet.update({
      where: { id: walletId },
      data: { balance: balanceAfter },
    });

    const transaction = await tx.transaction.create({
      data: {
        walletId,
        type,
        amount,
        balanceBefore,
        balanceAfter,
        reference,
        status,
        metadata: metadata || {},
      },
    });

    return { updatedWallet, transaction };
  }

  async holdFunds(tx: any, userId: string, amount: number, reference: string, metadata?: Record<string, any>) {
    const wallet = await tx.wallet.findUnique({ where: { userId } });
    if (!wallet) throw new NotFoundException('Wallet not found');

    const availableBalance = wallet.balance - wallet.lockedBalance;
    if (availableBalance < amount) {
      throw new BadRequestException('Insufficient available balance to hold');
    }

    const updatedWallet = await tx.wallet.update({
      where: { id: wallet.id },
      data: { lockedBalance: { increment: amount } },
    });

    const balanceBefore = wallet.balance;
    const transaction = await tx.transaction.create({
      data: {
        walletId: wallet.id,
        type: 'HOLD' as any,
        amount: -amount,
        balanceBefore,
        balanceAfter: balanceBefore,
        reference,
        status: 'SUCCESS' as any,
        metadata: metadata || { action: 'funds_held' },
      },
    });

    return { updatedWallet, transaction };
  }

  async releaseFunds(tx: any, userId: string, amount: number, reference: string, deductTotal: boolean = false, metadata?: Record<string, any>) {
    const wallet = await tx.wallet.findUnique({ where: { userId } });
    if (!wallet) throw new NotFoundException('Wallet not found');

    if (wallet.lockedBalance < amount) {
      throw new BadRequestException('Locked balance is less than the release amount');
    }

    const newBalance = deductTotal ? wallet.balance - amount : wallet.balance;
    const balanceBefore = wallet.balance;

    const updatedWallet = await tx.wallet.update({
      where: { id: wallet.id },
      data: {
        balance: newBalance,
        lockedBalance: { decrement: amount },
      },
    });

    const transaction = await tx.transaction.create({
      data: {
        walletId: wallet.id,
        type: 'RELEASE' as any,
        amount: deductTotal ? -amount : 0,
        balanceBefore,
        balanceAfter: newBalance,
        reference,
        status: 'SUCCESS' as any,
        metadata: metadata || { action: 'funds_released' },
      },
    });

    return { updatedWallet, transaction };
  }

  async processRefund(tx: any, walletId: string, amount: number, reference: string, metadata?: Record<string, any>) {
    return this.recordLedgerEntry(tx, walletId, 'REFUND' as any, amount, reference, 'SUCCESS' as any, metadata || { action: 'refund_issued' });
  }

  async deductPlatformFee(tx: any, walletId: string, amount: number, reference: string, metadata?: Record<string, any>) {
    return this.recordLedgerEntry(tx, walletId, 'PLATFORM_FEE' as any, -amount, reference, 'SUCCESS' as any, metadata || { action: 'platform_fee_deducted' });
  }

  async grantBonus(tx: any, walletId: string, amount: number, reference: string, metadata?: Record<string, any>) {
    return this.recordLedgerEntry(tx, walletId, 'BONUS' as any, amount, reference, 'SUCCESS' as any, metadata || { action: 'bonus_granted' });
  }

  async adjustBalance(tx: any, walletId: string, amount: number, reference: string, metadata?: Record<string, any>) {
    return this.recordLedgerEntry(tx, walletId, 'ADJUSTMENT' as any, amount, reference, 'SUCCESS' as any, metadata || { action: 'balance_adjusted' });
  }
}