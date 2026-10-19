import { Injectable, BadRequestException, NotFoundException, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { LedgerService } from './ledger.service';
import { TransactionType, TransactionStatus } from '@prisma/client';
import axios from 'axios';
import * as crypto from 'crypto';
import { NotificationService } from '../notifications/notification.service';


@Injectable()
export class WalletService {
  private readonly logger = new Logger(WalletService.name);
  constructor(
    private prisma: PrismaService,
    private ledgerService: LedgerService, 
    private notificationService: NotificationService,
  ) {}  

  /**
   * Core Immutable Ledger Recording Helper
   * Automatically calculates balanceBefore and balanceAfter for full audit trails.
   */
  private async recordLedgerEntry(
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

    // Prevent negative balance for debits/withdrawals/stakes
    if (balanceAfter < 0 && amount < 0) {
      throw new BadRequestException('Insufficient wallet balance for this operation.');
    }

    // Update wallet balance
    const updatedWallet = await tx.wallet.update({
      where: { id: walletId },
      data: { balance: balanceAfter },
    });

    // Create immutable ledger record
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

  async getOrCreateWallet(userId: string) {
    const db: any = this.prisma;
    let wallet = await db.wallet.findUnique({
      where: { userId },
      include: { transactions: true },
    });

    if (!wallet) {
      wallet = await db.wallet.create({
        data: {
          userId,
          balance: 0.0,
          lockedBalance: 0.0,
          coinBalance: 0.0,
          coinRate: 1.0,
        },
        include: { transactions: true },
      });
    }

    if (wallet.transactions) {
      wallet.transactions.sort(
        (a: any, b: any) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
      );
      wallet.transactions = wallet.transactions.slice(0, 20);
    }

    return wallet;
  }

  async getWalletBalance(userId: string) {
    const wallet = await this.getOrCreateWallet(userId);
    return {
      balance: wallet.balance,
      lockedBalance: wallet.lockedBalance,
      availableBalance: wallet.balance - wallet.lockedBalance,
      coinBalance: wallet.coinBalance,
      coinRate: wallet.coinRate,
    };
  }

  async getWalletHistory(userId: string) {
    const wallet = await this.getOrCreateWallet(userId);
    return wallet.transactions;
  }

  async getWalletStatistics(userId: string) {
    const wallet = await this.getOrCreateWallet(userId);
    const totalDeposits = wallet.transactions
      .filter((t: any) => t.type === 'DEPOSIT' && t.status === 'SUCCESS' as any)
      .reduce((sum: number, t: any) => sum + t.amount, 0);

    const totalWithdrawals = wallet.transactions
      .filter((t: any) => t.type === 'WITHDRAWAL' && t.status === 'SUCCESS' as any)
      .reduce((sum: number, t: any) => sum + Math.abs(t.amount), 0);

    return {
      totalDeposits,
      totalWithdrawals,
      currentBalance: wallet.balance,
      lockedBalance: wallet.lockedBalance,
    };
  }

  async initializeDeposit(userId: string, amount: number, email: string) {
    if (amount < 100) throw new BadRequestException('Minimum deposit amount is 100 NGN');

    const reference = `DEP_${Date.now()}_${Math.floor(Math.random() * 1000000)}`;
    const wallet = await this.getOrCreateWallet(userId);
    const db: any = this.prisma;

    const balanceBefore = wallet.balance;
    await db.transaction.create({
      data: {
        walletId: wallet.id,
        type: 'DEPOSIT' as any,
        amount,
        balanceBefore,
        balanceAfter: balanceBefore,
        reference,
        status: 'PENDING' as any,
      },
    });

    try {
      const response = await axios.post(
        'https://api.paystack.co/transaction/initialize',
        {
          email,
          amount: Math.round(amount * 100),
          reference,
        },
        {
          headers: {
            Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
            'Content-Type': 'application/json',
          },
        },
      );
      return response.data.data;
    } catch (error) {
      throw new BadRequestException('Paystack initialization failed');
    }
  }

  /**
   * Verify Paystack Webhook Signature for secure communication
   */
  verifyWebhookSignature(signature: string, rawBody: string): boolean {
    const secret = process.env.PAYSTACK_SECRET_KEY || '';
    const hash = crypto
      .createHmac('sha512', secret)
      .update(rawBody)
      .digest('hex');
    return hash === signature;
  }

  /**
   * Explicitly verify transaction status directly from Paystack API
   */
  async verifyPayment(reference: string) {
    try {
      const response = await axios.get(
        `https://api.paystack.co/transaction/verify/${reference}`,
        {
          headers: {
            Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          },
        },
      );

      const paymentData = response.data.data;
      if (paymentData.status === 'success') {
        await this.handlePaystackWebhook({
          event: 'charge.success',
          data: paymentData,
        });
      }

      return paymentData;
    } catch (error) {
      throw new BadRequestException('Failed to verify payment with Paystack');
    }
  }

  async handlePaystackWebhook(event: any) {
    if (event.event === 'charge.success') {
      const { reference, amount } = event.data;
      const amountInNaira = amount / 100;
      const db: any = this.prisma;

      const transaction = await db.transaction.findUnique({
        where: { reference },
      });

      if (!transaction || transaction.status === ('SUCCESS' as any)) {
        return { status: 'already_processed_or_not_found' };
      }

      return db.$transaction(async (tx: any) => {
        const wallet = await tx.wallet.findUnique({ where: { id: transaction.walletId } });
        if (!wallet) throw new NotFoundException('Wallet not found');

        const balanceBefore = wallet.balance;
        const balanceAfter = balanceBefore + amountInNaira;

        await tx.wallet.update({
          where: { id: transaction.walletId },
          data: { balance: balanceAfter },
        });

        await tx.transaction.update({
          where: { reference },
          data: {
            status: 'SUCCESS' as any,
            balanceBefore,
            balanceAfter,
          },
        });

        return { status: 'success' };
      });
    }
    return { status: 'ignored' };
  }

  /**
   * Cancel a pending withdrawal and refund the user wallet
   */
  async cancelWithdrawal(userId: string, reference: string) {
    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet) throw new NotFoundException('Wallet not found');

      const transaction = await tx.transaction.findUnique({ where: { reference } });
      if (!transaction || transaction.walletId !== wallet.id) {
        throw new NotFoundException('Withdrawal transaction not found');
      }

      if (transaction.status !== ('PENDING' as any)) {
        throw new BadRequestException('Only pending withdrawals can be cancelled.');
      }

      // Refund funds back to the wallet
      const refundResult = await this.recordLedgerEntry(
        tx,
        wallet.id,
        'REFUND' as any,
        Math.abs(transaction.amount),
        `CAN-${reference}`,
        'SUCCESS' as any,
        { action: 'withdrawal_cancelled_by_user' },
      );

      // Mark original withdrawal as CANCELLED
      await tx.transaction.update({
        where: { id: transaction.id },
        data: { status: 'CANCELLED' as any },
      });

      return {
        message: 'Withdrawal request cancelled successfully and funds refunded.',
        wallet: refundResult.updatedWallet,
      };
    });
  }

  async transfer(senderId: string, recipientUserId: string, amount: number) {
    if (amount <= 0) throw new BadRequestException('Transfer amount must be greater than zero');

    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      const senderWallet = await tx.wallet.findUnique({ where: { userId: senderId } });
      if (!senderWallet) throw new NotFoundException('Sender wallet not found');

      const availableSenderBalance = senderWallet.balance - senderWallet.lockedBalance;
      if (availableSenderBalance < amount) {
        throw new BadRequestException('Insufficient balance for transfer');
      }

      const recipientWallet = await tx.wallet.upsert({
        where: { userId: recipientUserId },
        update: {},
        create: {
          userId: recipientUserId,
          balance: 0.0,
          lockedBalance: 0.0,
          coinBalance: 0.0,
          coinRate: 1.0,
        },
      });

      const transferRef = `TRF-${Date.now()}`;

      // 1. Record Debit for Sender
      await this.recordLedgerEntry(
        tx,
        senderWallet.id,
        'DEBIT' as any,
        -amount,
        transferRef,
        'SUCCESS' as any,
        { recipientUserId, action: 'transfer_sent' },
      );

      // 2. Record Credit for Recipient
      await this.recordLedgerEntry(
        tx,
        recipientWallet.id,
        'CREDIT' as any,
        amount,
        transferRef,
        'SUCCESS' as any,
        { senderId, action: 'transfer_received' },
      );

      return { message: 'Transfer successful', reference: transferRef };
    });
  }

  async stakeForChallenge(userId: string, amount: number, challengeId: string) {
    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet) throw new NotFoundException('Wallet not found');

      const availableBalance = wallet.balance - wallet.lockedBalance;
      if (availableBalance < amount) {
        throw new BadRequestException('Insufficient balance to stake for challenge');
      }

      const reference = `STK-${challengeId}-${Date.now()}`;
      return this.recordLedgerEntry(
        tx,
        wallet.id,
        'CHALLENGE_STAKE' as any,
        -amount,
        reference,
        'SUCCESS' as any,
        { challengeId, action: 'challenge_stake' },
      );
    });
  }

  async payoutWinnings(userId: string, amount: number, challengeId: string) {
    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet) throw new NotFoundException('Wallet not found');

      const reference = `WIN-${challengeId}-${Date.now()}`;
      return this.recordLedgerEntry(
        tx,
        wallet.id,
        'CHALLENGE_WINNINGS' as any,
        amount,
        reference,
        'SUCCESS' as any,
        { challengeId, action: 'challenge_winnings' },
      );
    });
  }

  /**
   * Get paginated transaction history for a user wallet
   */
  async getTransactionHistory(userId: string, page: number = 1, limit: number = 20) {
    const db: any = this.prisma;
    const wallet = await db.wallet.findUnique({ where: { userId } });
    if (!wallet) throw new NotFoundException('Wallet not found');

    const skip = (page - 1) * limit;

    const [transactions, total] = await Promise.all([
      db.transaction.findMany({
        where: { walletId: wallet.id },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      db.transaction.count({ where: { walletId: wallet.id } }),
    ]);

    return {
      data: transactions,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
        limit,
      },
    };
  }

  /**
   * Get single transaction details by reference or transaction ID
   */
  async getTransactionDetails(identifier: string) {
    const db: any = this.prisma;
    
    let transaction = await db.transaction.findUnique({
      where: { id: identifier },
      include: { wallet: { select: { userId: true } } },
    });

    if (!transaction) {
      transaction = await db.transaction.findUnique({
        where: { reference: identifier },
        include: { wallet: { select: { userId: true } } },
      });
    }

    if (!transaction) {
      throw new NotFoundException('Transaction not found');
    }

    return transaction;
  }

  /**
   * TASK 29: Verify Bank Account via Paystack NUBAN Resolution API
   */
  async verifyBankAccount(accountNumber: string, bankCode: string) {
    try {
      const response = await axios.get(
        `https://api.paystack.co/bank/resolve?account_number=${accountNumber}&bank_code=${bankCode}`,
        {
          headers: {
            Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          },
        },
      );
      return response.data.data; // Returns { account_number, account_name, bank_id }
    } catch (error: any) {
      this.logger.error('Bank account resolution failed:', error.response?.data || error.message);
      throw new BadRequestException('Could not verify bank account details. Please check the account number and bank.');
    }
  }

  /**
   * TASK 29: Comprehensive Withdrawal Request with Account Verification & Notifications
   */
  async requestWithdrawal(
    userId: string,
    dto: { amount: number; bankCode: string; accountNumber: string; accountName: string },
  ) {
    const { amount, bankCode, accountNumber, accountName } = dto;
    const MIN_WITHDRAWAL = 500;
    const MAX_WITHDRAWAL = 5000000;

    if (amount < MIN_WITHDRAWAL) {
      throw new BadRequestException(`Minimum withdrawal amount is ${MIN_WITHDRAWAL} NGN`);
    }
    if (amount > MAX_WITHDRAWAL) {
      throw new BadRequestException(`Maximum withdrawal amount is ${MAX_WITHDRAWAL} NGN`);
    }

    // 1. Verify Bank Account details via Paystack before proceeding
    const verifiedAccount = await this.verifyBankAccount(accountNumber, bankCode);
    
    // Optional: Cross-check name match for tight security (case-insensitive includes check)
    const resolvedName = verifiedAccount.account_name.toUpperCase();
    const providedName = accountName.toUpperCase();
    if (!resolvedName.includes(providedName.split(' ')[0])) {
      throw new BadRequestException(`Account name mismatch. Verified name on bank is: ${verifiedAccount.account_name}`);
    }

    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      // 2. Check KYC Requirement
      const user = await tx.user.findUnique({ where: { id: userId } });
      if (user && user.kycVerified === false) {
        throw new BadRequestException('KYC verification is required before initiating a withdrawal.');
      }

      // 3. Fetch wallet and check available balance
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet) throw new NotFoundException('Wallet not found');

      const availableBalance = wallet.balance - wallet.lockedBalance;
      if (availableBalance < amount) {
        throw new BadRequestException('Insufficient available balance for withdrawal.');
      }

      const reference = `WIT-${Date.now()}`;

      // 4. Record as PENDING withdrawal and deduct funds immediately
      const result = await this.recordLedgerEntry(
        tx,
        wallet.id,
        'WITHDRAWAL' as any,
        -amount,
        reference,
        'PENDING' as any,
        { 
          bankCode, 
          accountNumber, 
          accountName: verifiedAccount.account_name, 
          action: 'withdrawal_requested' 
        },
      );

      // 5. Notification payload trigger hook (ready for push notification / email dispatch)
      await this.notificationService.createNotification({
        userId,
        title: 'Withdrawal Request Submitted',
        message: `Your withdrawal request of ${amount} NGN has been logged.`,
        type: 'WITHDRAWAL_SUCCESS' as any, // Or 'WITHDRAWAL' if you added it to your enum
        metadata: { reference }
      });

      return {
      message: 'Withdrawal request submitted successfully and verified.',
      reference,
      verifiedAccountName: verifiedAccount.account_name,
      wallet: result.updatedWallet,
      transaction: result.transaction,
      // You can either remove line 542 completely, or pass a success flag like this:
      notificationStatus: 'sent',
    };
    });
  }

  async getCurrentRate() {
    const db: any = this.prisma;
    const activeRate = await db.coinRate.findFirst({
      where: { isActive: true },
      orderBy: { createdAt: 'desc' },
    });
    return { rate: activeRate ? activeRate.rate : 1.0 };
  }

  async getRateHistory() {
    const db: any = this.prisma;
    return db.coinRate.findMany({
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  async setCoinRate(adminUserId: string, newRate: number) {
    if (newRate <= 0) {
      throw new BadRequestException('Coin rate must be a positive value greater than zero.');
    }
    const db: any = this.prisma;
    return db.$transaction(async (tx: any) => {
      await tx.coinRate.updateMany({
        where: { isActive: true },
        data: { isActive: false },
      });
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
}