import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class LeaderboardService {
  constructor(private prisma: PrismaService) {}

  /**
   * Update or initialize player stats after a match conclusion
   */
  async recordGameResult(userId: string, won: boolean, earningsChange: number, region?: string, gameType?: string) {
    const db: any = this.prisma;
    
    // Fetch existing stats or create default
    const existing = await db.userStats.findUnique({ where: { userId } });
    
    const gamesPlayed = (existing?.gamesPlayed || 0) + 1;
    const wins = (existing?.wins || 0) + (won ? 1 : 0);
    const losses = (existing?.losses || 0) + (won ? 0 : 1);
    const winRate = Number(((wins / gamesPlayed) * 100).toFixed(2));
    const totalEarnings = (existing?.totalEarnings || 0) + earningsChange;
    const rating = (existing?.rating || 1000) + (won ? 25 : -15); // Basic Elo adjustment example

    return db.userStats.upsert({
      where: { userId },
      update: {
        gamesPlayed,
        wins,
        losses,
        winRate,
        rating,
        totalEarnings,
        ...(region ? { region } : {}),
        ...(gameType ? { gameType } : {}),
      },
      create: {
        userId,
        gamesPlayed,
        wins,
        losses,
        winRate,
        rating,
        totalEarnings,
        region: region || 'Global',
        gameType: gameType || 'General',
      },
    });
  }

  /**
   * Global Ranking Leaderboard (Paginated)
   */
  async getGlobalLeaderboard(page: number = 1, limit: number = 10, sortBy: 'rating' | 'earnings' | 'wins' = 'rating') {
    const db: any = this.prisma;
    const skip = (page - 1) * limit;

    const orderByMap = {
      rating: { rating: 'desc' },
      earnings: { totalEarnings: 'desc' },
      wins: { wins: 'desc' },
    };

    const [rankings, total] = await Promise.all([
      db.userStats.findMany({
        skip,
        take: limit,
        orderBy: orderByMap[sortBy] || { rating: 'desc' },
        include: {
          user: {
            select: { id: true, name: true, username: true, email: true },
          },
        },
      }),
      db.userStats.count(),
    ]);

    return {
      data: rankings,
      meta: {
        total,
        page,
        lastPage: Math.ceil(total / limit),
      },
    };
  }

  /**
   * Regional Ranking Leaderboard (Paginated)
   */
  async getRegionalLeaderboard(region: string, page: number = 1, limit: number = 10) {
    const db: any = this.prisma;
    const skip = (page - 1) * limit;

    const [rankings, total] = await Promise.all([
      db.userStats.findMany({
        where: { region: { equals: region, mode: 'insensitive' } },
        skip,
        take: limit,
        orderBy: { rating: 'desc' },
        include: {
          user: { select: { id: true, name: true, username: true } },
        },
      }),
      db.userStats.count({ where: { region: { equals: region, mode: 'insensitive' } } }),
    ]);

    return {
      data: rankings,
      meta: { total, page, lastPage: Math.ceil(total / limit) },
    };
  }

  /**
   * Game-Specific Ranking Leaderboard
   */
  async getGameSpecificLeaderboard(gameType: string, page: number = 1, limit: number = 10) {
    const db: any = this.prisma;
    const skip = (page - 1) * limit;

    const [rankings, total] = await Promise.all([
      db.userStats.findMany({
        where: { gameType: { equals: gameType, mode: 'insensitive' } },
        skip,
        take: limit,
        orderBy: { rating: 'desc' },
        include: {
          user: { select: { id: true, name: true, username: true } },
        },
      }),
      db.userStats.count({ where: { gameType: { equals: gameType, mode: 'insensitive' } } }),
    ]);

    return {
      data: rankings,
      meta: { total, page, lastPage: Math.ceil(total / limit) },
    };
  }

  /**
   * Get Individual Player Statistics
   */
  async getPlayerStats(userId: string) {
    const db: any = this.prisma;
    const stats = await db.userStats.findUnique({
      where: { userId },
      include: { user: { select: { name: true, username: true } } },
    });
    if (!stats) {
      return { gamesPlayed: 0, wins: 0, losses: 0, winRate: 0, rating: 1000, totalEarnings: 0 };
    }
    return stats;
  }
}