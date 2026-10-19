import { Injectable, BadRequestException, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { LedgerService } from '../wallet/ledger.service';

@Injectable()
export class EscrowService {
  constructor(
    private prisma: PrismaService,
    private ledgerService: LedgerService,
  ) {}

  /**
   * 1. Create Escrow & Lock Player Stake
   */
  async createAndLockEscrow(userId: string, challengeId: string, amount: number) {
    const db: any = this.prisma;

    return db.$transaction(async (tx: any) => {
      // Check if escrow already exists for this challenge and user
      const existingEscrow = await tx.escrow.findFirst({
        where: { challengeId, userId },
      });

      if (existingEscrow && existingEscrow.status === 'LOCKED') {
        throw new ConflictException('Stake already locked for this escrow.');
      }

      const reference = `ESC_LOCK_${challengeId}_${userId}_${Date.now()}`;

      // 1. Hold funds via Ledger Service
      const holdResult = await this.ledgerService.holdFunds(
        tx,
        userId,
        amount,
        reference,
        { challengeId, action: 'escrow_lock' }
      );

      // 2. Create or update Escrow record
      const escrow = await tx.escrow.upsert({
        where: { id: existingEscrow ? existingEscrow.id : 'non_existent_id' },
        update: { status: 'LOCKED', amount },
        create: {
          challengeId,
          userId,
          amount,
          status: 'LOCKED',
          reference,
        },
      });

      return { escrow, wallet: holdResult.updatedWallet };
    });
  }

  /**
   * 2. Verify Escrow Status for a Match
   */
  async verifyEscrow(challengeId: string) {
    const db: any = this.prisma;
    const escrows = await db.escrow.findMany({ where: { challengeId } });

    if (escrows.length < 2) {
      return { verified: false, message: 'Waiting for all participants to stake.' };
    }

    const allLocked = escrows.every((e: any) => e.status === 'LOCKED');
    return {
      verified: allLocked,
      participantsCount: escrows.length,
      totalStaked: escrows.reduce((sum: number, e: any) => sum + e.amount, 0),
    };
  }

  /**
   * 3. Dispute Hold (Freeze escrow state)
   */
  async disputeHold(challengeId: string, reason: string) {
    const db: any = this.prisma;
    return db.escrow.updateMany({
      where: { challengeId, status: 'LOCKED' },
      data: {
        status: 'DISPUTED',
        metadata: { disputeReason: reason, disputedAt: new Date().toISOString() },
      },
    });
  }

  /**
   * 4. Refund Funds (Cancel match & return stakes)
   */
  async refundEscrow(challengeId: string) {
    const db: any = this.prisma;

    return db.$transaction(async (tx: any) => {
      const escrows = await tx.escrow.findMany({ where: { challengeId } });
      const results = [];

      for (const escrow of escrows) {
        if (escrow.status === 'REFUNDED' || escrow.status === 'SETTLED') continue;

        const reference = `ESC_REF_${challengeId}_${escrow.userId}_${Date.now()}`;

        // Release locked funds and credit back balance
        await this.ledgerService.releaseFunds(
          tx,
          escrow.userId,
          escrow.amount,
          reference,
          true, // deductTotal = true (means return locked funds back to available balance)
          { challengeId, action: 'escrow_refund' }
        );

        await tx.escrow.update({
          where: { id: escrow.id },
          data: { status: 'REFUNDED' },
        });

        results.push({ userId: escrow.userId, refundedAmount: escrow.amount });
      }

      return { message: 'Escrow refunded successfully', results };
    });
  }

  /**
   * 5. Settle Match (Winner, Loser, Platform Fee & Prevent Double Settlement)
   */
  async settleMatch(challengeId: string, winnerId: string, loserId: string, platformFeePercentage: number = 5) {
    const db: any = this.prisma;

    return db.$transaction(async (tx: any) => {
      const escrows = await tx.escrow.findMany({ where: { challengeId } });

      // Prevent Double Settlement
      if (escrows.length === 0 || escrows.every((e: any) => e.status === 'SETTLED')) {
        throw new ConflictException('Escrow has already been settled or does not exist.');
      }

      const totalPool = escrows.reduce((sum: number, e: any) => sum + e.amount, 0);
      const platformFee = (totalPool * platformFeePercentage) / 100;
      const winnerPayout = totalPool - platformFee;

      const settlementRef = `SETTLE_${challengeId}_${Date.now()}`;

      for (const escrow of escrows) {
        // Release the initial hold without affecting main balance change yet
        await this.ledgerService.releaseFunds(
          tx,
          escrow.userId,
          escrow.amount,
          `${settlementRef}_rel_${escrow.userId}`,
          true, // Deduct from main balance since they lost or are being paid out via winnings
          { challengeId, action: 'escrow_settle_release' }
        );

        await tx.escrow.update({
          where: { id: escrow.id },
          data: { status: 'SETTLED' },
        });
      }

      // Pay out Winner
      const winnerWallet = await tx.wallet.findUnique({ where: { userId: winnerId } });
      await this.ledgerService.recordLedgerEntry(
        tx,
        winnerWallet.id,
        'CHALLENGE_WINNINGS' as any,
        winnerPayout,
        `${settlementRef}_winner`,
        'SUCCESS' as any,
        { challengeId, platformFee, action: 'winner_payout' }
      );

      return {
        success: true,
        totalPool,
        platformFee,
        winnerPayout,
        winnerId,
      };
    });
  }

  /**
   * 6. Escrow Expiration (Auto-refund stale/abandoned challenges after a time limit)
   */
  async expireStaleEscrows(maxAgeHours: number = 24) {
    const db: any = this.prisma;
    const thresholdDate = new Date(Date.now() - maxAgeHours * 60 * 60 * 1000);

    const staleEscrows = await db.escrow.findMany({
      where: {
        status: 'LOCKED',
        createdAt: { lt: thresholdDate },
      },
    });

   const expiredChallenges: string[] = [...new Set(staleEscrows.map((e: any) => e.challengeId))] as string[];
    const results: any[] = [];

    for (const challengeId of expiredChallenges) {
      try {
        const refundResult = await this.refundEscrow(challengeId);
        results.push({ challengeId, status: 'EXPIRED_AND_REFUNDED', details: refundResult });
      } catch (error: any) {
        results.push({ challengeId, status: 'FAILED_TO_EXPIRE', error: error.message });
      }
    }

    return { expiredCount: expiredChallenges.length, results };
  }

  /**
   * 7. Escrow Audit Trail (Retrieve full state history/timeline for an escrow)
   */
  async getEscrowAuditTrail(challengeId: string) {
    const db: any = this.prisma;
    const escrows = await db.escrow.findMany({
      where: { challengeId },
      include: {
        user: {
          select: { id: true, email: true },
        },
      },
    });

    if (!escrows || escrows.length === 0) {
      throw new NotFoundException('No escrow records found for this challenge');
    }

    return escrows.map((escrow: any) => ({
      escrowId: escrow.id,
      challengeId: escrow.challengeId,
      userId: escrow.userId,
      amount: escrow.amount,
      currentState: escrow.status,
      reference: escrow.reference,
      createdAt: escrow.createdAt,
      updatedAt: escrow.updatedAt,
      auditMetadata: escrow.metadata || {},
    }));
  }
}