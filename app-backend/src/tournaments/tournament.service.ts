import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { WalletService } from '../wallet/wallet.service';

@Injectable()
export class TournamentService {
  constructor(
    private prisma: PrismaService,
    private walletService: WalletService,
  ) {}

  /**
   * Create Tournament (Admin)
   */
  async createTournament(data: {
    gameId: string;
    title: string;
    entryFee: number;
    prizePool: number;
    startDate: Date;
  }) {
    const db: any = this.prisma;
    return db.tournament.create({
      data: {
        gameId: data.gameId,
        title: data.title,
        entryFee: data.entryFee,
        prizePool: data.prizePool,
        startDate: data.startDate,
        status: 'UPCOMING',
      },
    });
  }

  /**
   * Get Tournament Details, Participants, Rounds, and Matches
   */
  async getTournamentDetails(tournamentId: string) {
    const db: any = this.prisma;
    const tournament = await db.tournament.findUnique({
      where: { id: tournamentId },
      include: {
        game: true,
        participants: {
          include: {
            user: { select: { id: true, name: true, username: true } },
          },
        },
        rounds: {
          include: {
            matches: true,
          },
        },
      },
    });
    if (!tournament) throw new NotFoundException('Tournament not found');
    return tournament;
  }

  /**
   * Register & Enter Tournament (Deducts entry fee from wallet using Prisma Decimal compatibility)
   */
  async registerTournament(userId: string, tournamentId: string) {
    const db: any = this.prisma;

    const tournament = await db.tournament.findUnique({
      where: { id: tournamentId },
      include: { participants: true },
    });

    if (!tournament) throw new NotFoundException('Tournament not found');
    if (tournament.status !== 'UPCOMING') {
      throw new BadRequestException('Tournament registration is closed');
    }

    const alreadyRegistered = tournament.participants.find(
      (p: any) => p.userId === userId,
    );
    if (alreadyRegistered) {
      throw new BadRequestException('Already registered for this tournament');
    }

    // Convert Prisma Decimal entry fee to number for wallet service check/deduction
    const feeNumber = Number(tournament.entryFee);
    if (feeNumber > 0) {
      await db.wallet.update({
        where: { userId },
        data: { balance: { decrement: feeNumber } },
      });
    }

    return db.tournamentParticipant.create({
      data: { tournamentId, userId },
    });
  }

  /**
   * Generate Round 1 Bracket & Matches
   */
  async generateBracket(tournamentId: string) {
    const db: any = this.prisma;
    const tournament = await db.tournament.findUnique({
      where: { id: tournamentId },
      include: { participants: true },
    });

    if (!tournament) throw new NotFoundException('Tournament not found');
    const participants = tournament.participants;
    if (participants.length < 2) {
      throw new BadRequestException('Not enough participants to generate bracket');
    }

    // Shuffle participants randomly for pairings
    const shuffled = [...participants].sort(() => 0.5 - Math.random());

    // 1. Create Round 1 record
    const round = await db.tournamentRound.create({
      data: {
        tournamentId,
        roundNumber: 1,
      },
    });

    // 2. Create Round 1 matches linked to roundId
    const matchesData = [];
    for (let i = 0; i < shuffled.length; i += 2) {
      if (shuffled[i + 1]) {
        matchesData.push({
          roundId: round.id,
          player1Id: shuffled[i].userId,
          player2Id: shuffled[i + 1].userId,
        });
      }
    }

    await db.tournamentMatch.createMany({ data: matchesData });

    // Update tournament status to ONGOING
    return db.tournament.update({
      where: { id: tournamentId },
      data: { status: 'ONGOING' },
    });
  }

  /**
   * Progress Match & Record Winner
   */
  async updateMatchResult(matchId: string, winnerId: string) {
    const db: any = this.prisma;
    const match = await db.tournamentMatch.findUnique({ where: { id: matchId } });
    if (!match) throw new NotFoundException('Match not found');

    if (match.player1Id !== winnerId && match.player2Id !== winnerId) {
      throw new BadRequestException('Declared winner is not a participant of this match');
    }

    return db.tournamentMatch.update({
      where: { id: matchId },
      data: { winnerId },
    });
  }

  /**
   * Settle Tournament Prize & Finalize Winner
   */
  async settleTournament(tournamentId: string, winnerId: string) {
    const db: any = this.prisma;
    const tournament = await db.tournament.findUnique({ where: { id: tournamentId } });
    if (!tournament) throw new NotFoundException('Tournament not found');

    const prizeNumber = Number(tournament.prizePool);
    if (prizeNumber > 0) {
      await db.wallet.update({
        where: { userId: winnerId },
        data: { balance: { increment: prizeNumber } },
      });
    }

    return db.tournament.update({
      where: { id: tournamentId },
      data: { status: 'COMPLETED' },
    });
  }
}