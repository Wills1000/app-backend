import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SearchService {
  constructor(private prisma: PrismaService) {}

  // 1. All Search / Global Search
  async searchAll(query: string, userId?: string) {
    if (!query) return { players: [], games: [], challenges: [], posts: [] };

    if (userId) {
      await this.saveSearchHistory(userId, query);
    }

    const [players, games, challenges, posts] = await Promise.all([
      this.prisma.user.findMany({
        where: {
          OR: [
            { email: { contains: query, mode: 'insensitive' } },
            { profile: { username: { contains: query, mode: 'insensitive' } } },
          ],
        },
        take: 5,
        select: {
          id: true,
          email: true,
          profile: { select: { username: true, avatarUrl: true } },
        },
      }),
      this.prisma.game.findMany({
        where: {
          title: { contains: query, mode: 'insensitive' },
        },
        take: 5,
      }),
      this.prisma.challenge.findMany({
        where: {
          game: { title: { contains: query, mode: 'insensitive' } },
        },
        take: 5,
      }),
      this.prisma.post.findMany({
        where: {
          content: { contains: query, mode: 'insensitive' },
        },
        take: 5,
      }),
    ]);

    return { players, games, challenges, posts };
  }

  // 2. Players Search with Pagination
  async searchPlayers(query: string, page = 1, limit = 10) {
    const skip = (page - 1) * limit;
    const [players, total] = await Promise.all([
      this.prisma.user.findMany({
        where: {
          OR: [
            { email: { contains: query, mode: 'insensitive' } },
            { profile: { username: { contains: query, mode: 'insensitive' } } },
          ],
        },
        skip,
        take: limit,
        select: {
          id: true,
          email: true,
          createdAt: true,
          profile: { select: { username: true, avatarUrl: true, region: true } },
        },
      }),
      this.prisma.user.count({
        where: {
          OR: [
            { email: { contains: query, mode: 'insensitive' } },
            { profile: { username: { contains: query, mode: 'insensitive' } } },
          ],
        },
      }),
    ]);

    return { data: players, total, page, lastPage: Math.ceil(total / limit) };
  }

  // 3. Games Search with Pagination
  async searchGames(query: string, page = 1, limit = 10) {
    const skip = (page - 1) * limit;
    const [games, total] = await Promise.all([
      this.prisma.game.findMany({
        where: { title: { contains: query, mode: 'insensitive' } },
        skip,
        take: limit,
      }),
      this.prisma.game.count({
        where: { title: { contains: query, mode: 'insensitive' } },
      }),
    ]);

    return { data: games, total, page, lastPage: Math.ceil(total / limit) };
  }

  // 4. Search History Management
  async getSearchHistory(userId: string) {
    return this.prisma.searchHistory.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      take: 10,
    });
  }

  async clearSearchHistory(userId: string) {
    await this.prisma.searchHistory.deleteMany({
      where: { userId },
    });
    return { success: true, message: 'Search history cleared' };
  }

  private async saveSearchHistory(userId: string, query: string) {
    const latest = await this.prisma.searchHistory.findFirst({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    if (latest?.query.toLowerCase() !== query.toLowerCase()) {
      await this.prisma.searchHistory.create({
        data: { userId, query },
      });
    }
  }
}