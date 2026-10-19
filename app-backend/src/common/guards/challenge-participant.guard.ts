import { Injectable, CanActivate, ExecutionContext, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class ChallengeParticipantGuard implements CanActivate {
  constructor(private prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || request.user?.userId;
    const challengeId = request.params.id || request.body.challengeId;

    if (!challengeId) return true; // Skip if no challenge context

    const challenge = await (this.prisma as any).challenge?.findUnique({
      where: { id: challengeId },
    });

    if (!challenge) {
      throw new NotFoundException('Challenge or match not found.');
    }

    const isParticipant = challenge.creatorId === userId || challenge.opponentId === userId;
    if (!isParticipant) {
      throw new ForbiddenException('Access denied: You are not a participant in this challenge.');
    }

    return true;
  }
}