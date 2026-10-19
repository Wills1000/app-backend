import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { ChallengeStatus } from '@prisma/client';

@Injectable()
export class WaitingRoomService {
  constructor(private prisma: PrismaService) {}

  // 1. Create Waiting Room when a challenge is accepted
  async createWaitingRoom(challengeId: string, roomCode?: string) {
    const challenge = await this.prisma.challenge.findUnique({ where: { id: challengeId } });
    if (!challenge) throw new NotFoundException('Challenge not found');

    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    // Use type casting to bypass strict client generation cache
    return (this.prisma as any).waitingRoom.create({
      data: {
        challengeId,
        roomCode: roomCode || Math.random().toString(36).substring(2, 8).toUpperCase(),
        expiresAt,
      },
    });
  }

  // 2. Toggle Player Ready / Unready Status
  async setPlayerReady(challengeId: string, userId: string, isReady: boolean) {
    const challenge = await this.prisma.challenge.findUnique({ where: { id: challengeId } });
    if (!challenge) throw new NotFoundException('Challenge not found');

    const room = await (this.prisma as any).waitingRoom.findUnique({ where: { challengeId } });
    if (!room) throw new NotFoundException('Waiting room not found');

    const isHost = challenge.hostId === userId;
    const isOpponent = challenge.opponentId === userId;

    if (!isHost && !isOpponent) {
      throw new BadRequestException('You are not a participant in this challenge');
    }

    const updatedRoom = await (this.prisma as any).waitingRoom.update({
      where: { challengeId },
      data: isHost ? { hostReady: isReady } : { opponentReady: isReady },
    });

    if (updatedRoom.hostReady && updatedRoom.opponentReady) {
      await this.prisma.challenge.update({
        where: { id: challengeId },
        data: { status: 'READY' as ChallengeStatus },
      });
    }

    return updatedRoom;
  }

  // 3. Handle Leave / Match Cancellation from Waiting Room
  async leaveWaitingRoom(userId: string, challengeId: string) {
    const challenge = await this.prisma.challenge.findUnique({ where: { id: challengeId } });
    if (!challenge) throw new NotFoundException('Challenge not found');

    return (this.prisma as any).waitingRoom.delete({
      where: { challengeId },
    }).catch(() => {
      throw new NotFoundException('Active waiting room not found');
    });
  }
}