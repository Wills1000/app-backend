// app-backend/src/games/games.service.ts
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class GamesService {
  constructor(private prisma: PrismaService) {}

  // Get all supported/active games with their modes
  async findAllActiveGames() {
    return this.prisma.game.findMany({
      where: { isActive: true },
      include: { modes: true },
    });
  }

  // Get specific game details by ID or slug
  async findGameById(id: string) {
    const game = await this.prisma.game.findUnique({
      where: { id },
      include: { modes: true },
    });
    if (!game) throw new NotFoundException('Game not found');
    return game;
  }

  // Add game to user profile (Link IGN)
  async addUserGame(userId: string, gameId: string, ign: string) {
    try {
      return await this.prisma.userGame.create({
        data: {
          userId,
          gameId,
          ign,
        },
        include: { game: true },
      });
    } catch (error: any) {
    if (error.code === 'P2002') {
      throw new ConflictException('You have already added this game to your profile.');
    }
    throw error;
  }
  }

  // Get user's linked games
  async getUserGames(userId: string) {
    return this.prisma.userGame.findMany({
      where: { userId },
      include: { game: { include: { modes: true } } },
    });
  }

  // Update game ID / IGN
  async updateUserGameIgn(userId: string, userGameId: string, ign: string) {
    const userGame = await this.prisma.userGame.findUnique({
      where: { id: userGameId },
    });

    if (!userGame || userGame.userId !== userId) {
      throw new NotFoundException('User game profile record not found');
    }

    return this.prisma.userGame.update({
      where: { id: userGameId },
      data: { ign },
    });
  }

  // Remove game from profile
  async removeUserGame(userId: string, userGameId: string) {
    const userGame = await this.prisma.userGame.findUnique({
      where: { id: userGameId },
    });

    if (!userGame || userGame.userId !== userId) {
      throw new NotFoundException('User game profile record not found');
    }

    return this.prisma.userGame.delete({
      where: { id: userGameId },
    });
  }
}