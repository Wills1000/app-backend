import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ChallengeStatus, DisputeStatus } from '@prisma/client';
import { ResolveDisputeDto, DisputeResolutionAction } from './dto/resolve-dispute.dto';

@Injectable()
export class DisputesService {
  constructor(private prisma: PrismaService) {}

  async createDispute(userId: string, challengeId: string, dto: {
    reason: string;
    proofUrls?: string[];
  }) {
    return this.prisma.$transaction(async (tx) => {
      const challenge = await tx.challenge.findUnique({
        where: { id: challengeId },
      });

      if (!challenge) {
        throw new NotFoundException('Challenge not found');
      }

      const isParticipant = challenge.hostId === userId || challenge.opponentId === userId;
      if (!isParticipant) {
        throw new ForbiddenException('Only match participants can raise a dispute');
      }

      const existingDispute = await tx.dispute.findFirst({
        where: { challengeId, status: DisputeStatus.OPEN },
      });

      if (existingDispute) {
        throw new BadRequestException('An open dispute already exists for this challenge');
      }

      const dispute = await tx.dispute.create({
        data: {
          challengeId,
          raisedById: userId,
          reason: dto.reason,
          status: DisputeStatus.OPEN,
          proofs: dto.proofUrls && dto.proofUrls.length > 0 ? {
            create: dto.proofUrls.map((url) => ({ mediaUrl: url }))
          } : undefined,
        },
        include: { proofs: true },
      });

      await tx.challenge.update({
        where: { id: challengeId },
        data: { status: ChallengeStatus.DISPUTED },
      });

      return dispute;
    });
  }

  async getDisputeByChallenge(challengeId: string) {
    const dispute = await this.prisma.dispute.findFirst({
      where: { challengeId },
      include: { 
        proofs: true, 
        raisedBy: { 
          include: { profile: true } 
        } 
      },
    });

    if (!dispute) {
      throw new NotFoundException('No dispute found for this challenge');
    }

    return dispute;
  }

  async resolveDispute(adminId: string, disputeId: string, dto: ResolveDisputeDto) {
    return this.prisma.$transaction(async (tx) => {
      const dispute = await tx.dispute.findUnique({
        where: { id: disputeId },
        include: { challenge: true },
      });

      if (!dispute) {
        throw new NotFoundException('Dispute not found');
      }

      if (dispute.status === DisputeStatus.RESOLVED || dispute.status === DisputeStatus.REJECTED) {
        throw new BadRequestException('This dispute has already been resolved');
      }

      const challenge = dispute.challenge;

      if (dto.action === DisputeResolutionAction.DECLARE_WINNER) {
        if (!dto.winnerId) {
          throw new BadRequestException('A winner ID must be provided to declare a winner');
        }

        if (challenge.hostId !== dto.winnerId && challenge.opponentId !== dto.winnerId) {
          throw new BadRequestException('Declared winner is not a participant of this challenge');
        }

        await tx.challenge.update({
          where: { id: challenge.id },
          data: {
            status: ChallengeStatus.COMPLETED,
            winnerId: dto.winnerId,
          },
        });
      } else if (dto.action === DisputeResolutionAction.REFUND) {
        await tx.challenge.update({
          where: { id: challenge.id },
          data: {
            status: ChallengeStatus.CANCELLED,
          },
        });
      }

      const updatedDispute = await tx.dispute.update({
        where: { id: disputeId },
        data: {
          status: DisputeStatus.RESOLVED,
        },
        include: { proofs: true, challenge: true },
      });

      return {
        message: `Dispute successfully resolved via ${dto.action}`,
        dispute: updatedDispute,
      };
    });
  }
}