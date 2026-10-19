import { Injectable, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ChallengeStatus, ResultStatus } from '@prisma/client';

@Injectable()
export class ResultService {
  constructor(private prisma: PrismaService) {}

  async submitResult(userId: string, challengeId: string, dto: {
    claimedWinnerId: string;
    playerScore: number;
    opponentScore: number;
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
        throw new ForbiddenException('You are not a participant in this challenge');
      }

      // 1. Validate scores
      if (dto.playerScore < 0 || dto.opponentScore < 0) {
        throw new BadRequestException('Scores cannot be negative');
      }

      // 2. Set response deadline (e.g., 15 minutes from submission)
      const deadlineAt = new Date(Date.now() + 15 * 60 * 1000);

      const existingResult = await tx.challengeResult.findFirst({
        where: { challengeId },
        include: { proofs: true },
      });

      if (existingResult) {
        if (existingResult.submittedBy === userId) {
          throw new BadRequestException('You have already submitted a result for this challenge');
        }

        // 3. Compare submissions for conflicts (winner and flipped scores)
        const res = existingResult as any;
        const isConflict = 
          res.claimedWinnerId !== dto.claimedWinnerId ||
          res.playerScore !== dto.opponentScore ||
          res.opponentScore !== dto.playerScore;

        const finalStatus = isConflict ? ResultStatus.DISPUTED : ResultStatus.CONFIRMED;

        if (isConflict) {
          await tx.challenge.update({
            where: { id: challengeId },
            data: { status: ChallengeStatus.DISPUTED },
          });
        } else {
          await tx.challenge.update({
            where: { id: challengeId },
            data: { 
              status: ChallengeStatus.COMPLETED,
              winnerId: dto.claimedWinnerId 
            },
          });
        }

        const updatedResult = await tx.challengeResult.update({
          where: { id: existingResult.id },
          data: {
            status: finalStatus,
          },
          include: { proofs: true },
        });

        if (dto.proofUrls && dto.proofUrls.length > 0) {
          await tx.resultProof.createMany({
            data: dto.proofUrls.map((url) => ({
              resultId: existingResult.id,
              mediaUrl: url,
            })),
          });
        }

        return updatedResult;
      }

      // 4. First player submission with scores & deadline
      const challengeResult = await tx.challengeResult.create({
        data: {
          challengeId,
          submittedBy: userId,
          claimedWinnerId: dto.claimedWinnerId,
          playerScore: dto.playerScore,
          opponentScore: dto.opponentScore,
          status: ResultStatus.PENDING,
          deadlineAt,
          proofs: dto.proofUrls && dto.proofUrls.length > 0 ? {
            create: dto.proofUrls.map((url) => ({ mediaUrl: url }))
          } : undefined,
        },
        include: { proofs: true },
      });

      await tx.challenge.update({
        where: { id: challengeId },
        data: { status: ChallengeStatus.IN_PROGRESS }, // Or your equivalent active status
      });

      return challengeResult;
    });
  }
}