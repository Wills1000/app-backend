import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ChallengeStatus, TransactionType, TransactionStatus, InviteStatus } from '@prisma/client';
import { Prisma } from '@prisma/client';
 
@Injectable()
export class ChallengeService {
  constructor(private prisma: PrismaService) {}
 
  // 1. Create Challenge & Lock Host's Funds in Escrow
  async createChallenge(hostId: string, gameId: string, stakeAmount: number) {
    const stake = new Prisma.Decimal(stakeAmount);
 
    if (stake.lessThanOrEqualTo(0)) {
      throw new BadRequestException('Stake amount must be greater than zero');
    }
 
    return this.prisma.$transaction(async (tx) => {
      const wallet = await tx.wallet.findUnique({ where: { userId: hostId } });
      if (!wallet || wallet.availableBalance.lessThan(stake)) {
        throw new BadRequestException('Insufficient funds to create challenge');
      }
 
      await tx.wallet.update({
        where: { userId: hostId },
        data: {
          availableBalance: { decrement: stake },
          lockedBalance: { increment: stake },
        },
      });
 
      await tx.transaction.create({
        data: {
          walletId: wallet.id,
          userId: hostId,
          amount: stake,
          type: TransactionType.WAGER_ESCROW,
          status: TransactionStatus.COMPLETED,
          reference: `ESCROW-HOST-${Date.now()}-${hostId.slice(0, 5)}`,
          balanceBefore: wallet.availableBalance,
          balanceAfter: wallet.availableBalance.minus(stake),
        },
      });
 
      return tx.challenge.create({
        data: {
          hostId,
          gameId,
          stakeAmount: stake,
          status: ChallengeStatus.OPEN,
          participants: {
            create: [{ userId: hostId }],
          },
        },
      });
    });
  }
 
  // 2. View Single Challenge Details
  async viewChallenge(challengeId: string) {
    const challenge = await this.prisma.challenge.findUnique({
      where: { id: challengeId },
      include: {
        game: true,
        host: { select: { id: true, email: true } },
        opponent: { select: { id: true, email: true } },
        participants: true,
      },
    });
 
    if (!challenge) {
      throw new NotFoundException('Challenge not found');
    }
 
    return challenge;
  }
 
  // 3. Accept Challenge / Join with Full Eligibility & Security Guards (Task 20)
  async joinChallenge(opponentId: string, challengeId: string) {
    return this.prisma.$transaction(async (tx) => {
      const challenge = await tx.challenge.findUnique({
        where: { id: challengeId },
        include: { participants: true },
      });
 
      if (!challenge) throw new NotFoundException('Challenge not found');
 
      // Prevent accepting expired challenges
      if (challenge.status.toString() === 'EXPIRED') {
        throw new BadRequestException('Cannot accept an expired challenge');
      }
 
      // Ensure challenge is open
      if (challenge.status !== ChallengeStatus.OPEN) {
        throw new BadRequestException('Challenge is no longer open for acceptance');
      }
 
      // Prevent duplicate acceptance (if an opponent is already assigned)
      if (challenge.opponentId) {
        throw new BadRequestException('This challenge has already been accepted by another player');
      }
 
      // Prevent accepting your own challenge
      if (challenge.hostId === opponentId) {
        throw new BadRequestException('You cannot accept your own challenge');
      }
 
      // Verify eligibility & wallet balance against the stake amount
      const wallet = await tx.wallet.findUnique({ where: { userId: opponentId } });
      if (!wallet || wallet.availableBalance.lessThan(challenge.stakeAmount)) {
        throw new BadRequestException('Insufficient wallet balance to match this stake');
      }
 
      // Lock opponent's stake in Escrow
      await tx.wallet.update({
        where: { userId: opponentId },
        data: {
          availableBalance: { decrement: challenge.stakeAmount },
          lockedBalance: { increment: challenge.stakeAmount },
        },
      });
 
      // Create escrow transaction audit record
      await tx.transaction.create({
        data: {
          walletId: wallet.id,
          userId: opponentId,
          amount: challenge.stakeAmount,
          type: TransactionType.WAGER_ESCROW,
          status: TransactionStatus.COMPLETED,
          reference: `ESCROW-JOIN-${Date.now()}-${opponentId.slice(0, 5)}`,
          balanceBefore: wallet.availableBalance,
          balanceAfter: wallet.availableBalance.minus(challenge.stakeAmount),
        },
      });
 
      // Add opponent as participant
      await tx.challengeParticipant.create({
        data: {
          challengeId,
          userId: opponentId,
        },
      });
 
      // Update challenge status and assign opponent
      return tx.challenge.update({
        where: { id: challengeId },
        data: {
          opponentId,
          status: ChallengeStatus.ACCEPTED,
        },
      });
    });
  }
 
  // 4. Reject Challenge / Invitation
  async rejectChallenge(userId: string, challengeId: string) {
    const challenge = await this.prisma.challenge.findUnique({
      where: { id: challengeId },
    });
 
    if (!challenge) throw new NotFoundException('Challenge not found');
    if (challenge.status !== ChallengeStatus.OPEN) {
      throw new BadRequestException('Challenge cannot be rejected at this stage');
    }
 
    // Update invitation record if present
    await this.prisma.challengeInvite.updateMany({
      where: { challengeId, receiverId: userId },
      data: { status: InviteStatus.DECLINED },
    });
 
    return { success: true, message: 'Challenge successfully rejected' };
  }
 
  // 5. Cancel / Delete Challenge & Refund Host's Escrow
  async cancelChallenge(userId: string, challengeId: string) {
    return this.prisma.$transaction(async (tx) => {
      const challenge = await tx.challenge.findUnique({ where: { id: challengeId } });
      if (!challenge) throw new NotFoundException('Challenge not found');
      if (challenge.hostId !== userId) throw new ForbiddenException('Unauthorized');
      if (challenge.status !== ChallengeStatus.OPEN) {
        throw new BadRequestException('Can only cancel open challenges');
      }
 
      // Load the wallet (needed for walletId and the before/after balances)
      const wallet = await tx.wallet.findUnique({ where: { userId } });
      if (!wallet) throw new NotFoundException('Wallet not found');
 
      // Refund host locked balance back to available balance
      await tx.wallet.update({
        where: { userId },
        data: {
          availableBalance: { increment: challenge.stakeAmount },
          lockedBalance: { decrement: challenge.stakeAmount },
        },
      });
 
      await tx.transaction.create({
        data: {
          walletId: wallet.id,
          userId,
          amount: challenge.stakeAmount,
          type: TransactionType.REFUND,
          status: TransactionStatus.COMPLETED,
          reference: `REFUND-${Date.now()}-${userId.slice(0, 5)}`,
          balanceBefore: wallet.availableBalance,
          balanceAfter: wallet.availableBalance.plus(challenge.stakeAmount),
        },
      });
 
      return tx.challenge.update({
        where: { id: challengeId },
        data: { status: ChallengeStatus.CANCELLED },
      });
    });
  }
 
  // 6. Get & Filter Challenges (Public, Private, Status, Game filtering with pagination)
  async getChallenges(filters: {
    status?: ChallengeStatus;
    gameId?: string;
    isPublic?: boolean;
    page?: number;
    limit?: number;
  }) {
    const page = filters.page || 1;
    const limit = filters.limit || 10;
    const skip = (page - 1) * limit;
 
    const where: any = {};
    if (filters.status) where.status = filters.status;
    if (filters.gameId) where.gameId = filters.gameId;
    if (filters.isPublic !== undefined) {
      where.opponentId = filters.isPublic ? null : { not: null };
    }
 
    const [challenges, total] = await Promise.all([
      this.prisma.challenge.findMany({
        where,
        skip,
        take: limit,
        include: {
          game: true,
          host: { select: { id: true, email: true } },
          opponent: { select: { id: true, email: true } },
          participants: true,
        },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.challenge.count({ where }),
    ]);
 
    return {
      data: challenges,
      total,
      page,
      lastPage: Math.ceil(total / limit),
    };
  }
 
  // 7. Send Challenge Invitation
  async invitePlayer(userId: string, challengeId: string, receiverId: string) {
    const challenge = await this.prisma.challenge.findUnique({ where: { id: challengeId } });
    if (!challenge) throw new NotFoundException('Challenge not found');
    if (challenge.hostId !== userId) throw new ForbiddenException('Unauthorized');
 
    return this.prisma.challengeInvite.create({
      data: {
        challengeId,
        senderId: userId,
        receiverId,
        status: InviteStatus.PENDING,
      },
    });
  }
}
 