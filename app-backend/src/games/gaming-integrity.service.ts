import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { SubmitMatchResultDto } from './dto/submit-result.dto';
import { RaiseDisputeDto } from './dto/raise-dispute.dto';

@Injectable()
export class GamingIntegrityService {
  constructor(private prisma: PrismaService) {}

  async submitResult(userId: string, dto: SubmitMatchResultDto) {
    const db: any = this.prisma;
    const challenge = await db.challenge.findUnique({ where: { id: dto.challengeId } });

    if (!challenge) throw new NotFoundException('Match challenge not found.');
    if (challenge.status !== 'ACTIVE') throw new BadRequestException('Match is not currently active.');

    const isCreator = challenge.creatorId === userId;
    const isOpponent = challenge.opponentId === userId;

    if (!isCreator && !isOpponent) {
      throw new BadRequestException('You are not a participant in this match.');
    }

    // Record player result and proof
    const updateField = isCreator ? { creatorScore: dto.reportedScore, creatorProof: dto.proofUrl } : { opponentScore: dto.reportedScore, opponentProof: dto.proofUrl };

    return db.challenge.update({
      where: { id: dto.challengeId },
      data: { ...updateField, status: 'PENDING_VERIFICATION' },
    });
  }

  async raiseDispute(userId: string, dto: RaiseDisputeDto) {
    const db: any = this.prisma;
    const challenge = await db.challenge.findUnique({ where: { id: dto.challengeId } });

    if (!challenge) throw new NotFoundException('Challenge not found.');

    // Lock match status into Dispute
    await db.challenge.update({
      where: { id: dto.challengeId },
      data: { status: 'DISPUTED' },
    });

    // Create formal moderation dispute ticket
    return db.dispute.create({
      data: {
        challengeId: dto.challengeId,
        raisedById: userId,
        reason: dto.reason,
        description: dto.description,
        evidenceUrl: dto.evidenceUrl,
        status: 'OPEN',
      },
    });
  }

  async checkMatchTimeouts() {
    const db: any = this.prisma;
    const thresholdTime = new Date(Date.now() - 15 * 60 * 1000); // 15 minutes inactivity limit

    // Auto-cancel matches where opponent didn't join in time
    const expiredChallenges = await db.challenge.findMany({
      where: {
        status: 'PENDING_ACCEPTANCE',
        createdAt: { lt: thresholdTime },
      },
    });

    for (const challenge of expiredChallenges) {
      await db.challenge.update({
        where: { id: challenge.id },
        data: { status: 'CANCELLED_TIMEOUT' },
      });
      // Refund creator stake back to wallet ledger automatically
    }
  }
}