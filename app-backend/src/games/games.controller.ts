// app-backend/src/games/games.controller.ts
import { 
  Controller, 
  Get, 
  Post, 
  Patch, 
  Delete, 
  Param, 
  Body, 
  UseGuards, 
  Req 
} from '@nestjs/common';
import { GamesService } from './games.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // Adjust based on your auth guard path

@Controller('games')
export class GamesController {
  constructor(private readonly gamesService: GamesService) {}

  // [GET] /games - Get supported games
  @Get()
  async getSupportedGames() {
    return this.gamesService.findAllActiveGames();
  }

  // [GET] /games/:id - Get game details
  @Get(':id')
  async getGameDetails(@Param('id') id: string) {
    return this.gamesService.findGameById(id);
  }

  // [GET] /games/user/me - Get logged-in user's games
  @UseGuards(JwtAuthGuard)
  @Get('user/me')
  async getMyGames(@Req() req: any) {
    const userId = req.user.id; // From JWT payload
    return this.gamesService.getUserGames(userId);
  }

  // [POST] /games/user - Add game to profile
  @UseGuards(JwtAuthGuard)
  @Post('user')
  async addGameToProfile(
    @Req() req: any,
    @Body() body: { gameId: string; ign: string },
  ) {
    const userId = req.user.id;
    return this.gamesService.addUserGame(userId, body.gameId, body.ign);
  }

  // [PATCH] /games/user/:id - Update game ID/IGN
  @UseGuards(JwtAuthGuard)
  @Patch('user/:id')
  async updateGameIgn(
    @Req() req: any,
    @Param('id') userGameId: string,
    @Body() body: { ign: string },
  ) {
    const userId = req.user.id;
    return this.gamesService.updateUserGameIgn(userId, userGameId, body.ign);
  }

  // [DELETE] /games/user/:id - Remove game from profile
  @UseGuards(JwtAuthGuard)
  @Delete('user/:id')
  async removeGameFromProfile(
    @Req() req: any,
    @Param('id') userGameId: string,
  ) {
    const userId = req.user.id;
    return this.gamesService.removeUserGame(userId, userGameId);
  }
}