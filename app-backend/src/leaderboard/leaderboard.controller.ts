import { Controller, Get, Query, Param, UseGuards, Req } from '@nestjs/common';
import { LeaderboardService } from './leaderboard.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('leaderboard')
export class LeaderboardController {
  constructor(private readonly leaderboardService: LeaderboardService) {}

  @UseGuards(JwtAuthGuard)
  @Get('me')
  async getMyStats(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.leaderboardService.getPlayerStats(userId);
  }

  @Get('global')
  async getGlobalLeaderboard(
    @Query('page') page: string = '1',
    @Query('limit') limit: string = '10',
    @Query('sortBy') sortBy: 'rating' | 'earnings' | 'wins' = 'rating',
  ) {
    return this.leaderboardService.getGlobalLeaderboard(Number(page), Number(limit), sortBy);
  }

  @Get('regional/:region')
  async getRegionalLeaderboard(
    @Param('region') region: string,
    @Query('page') page: string = '1',
    @Query('limit') limit: string = '10',
  ) {
    return this.leaderboardService.getRegionalLeaderboard(region, Number(page), Number(limit));
  }

  @Get('game/:gameType')
  async getGameSpecificLeaderboard(
    @Param('gameType') gameType: string,
    @Query('page') page: string = '1',
    @Query('limit') limit: string = '10',
  ) {
    return this.leaderboardService.getGameSpecificLeaderboard(gameType, Number(page), Number(limit));
  }
}