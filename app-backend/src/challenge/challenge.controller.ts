import { Controller, Get, Post, Patch, Delete, Body, Param, Query, Req } from '@nestjs/common';
import { ChallengeService } from './challenge.service';
import { ChallengeStatus } from '@prisma/client';

@Controller('challenges')
export class ChallengeController {
  constructor(private readonly challengeService: ChallengeService) {}

  // 1. Create Challenge (Matches your service signature)
  @Post()
  async create(
    @Req() req: any,
    @Body() body: { gameId: string; stakeAmount: number; userId?: string },
  ) {
    const userId = req.user?.id || body.userId;
    return this.challengeService.createChallenge(userId, body.gameId, body.stakeAmount);
  }

  // 2. Join Challenge (Escrow lock for opponent)
  @Post(':id/join')
  async join(
    @Req() req: any,
    @Param('id') challengeId: string,
    @Body() body: { userId?: string },
  ) {
    const userId = req.user?.id || body.userId;
    return this.challengeService.joinChallenge(userId, challengeId);
  }

  // 3. Get / Filter Challenges
  @Get()
  async getAll(
    @Query('status') status?: ChallengeStatus,
    @Query('gameId') gameId?: string,
    @Query('isPublic') isPublic?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.challengeService.getChallenges({
      status,
      gameId,
      isPublic: isPublic !== undefined ? isPublic === 'true' : undefined,
      page: page ? Number(page) : 1,
      limit: limit ? Number(limit) : 10,
    });
  }

  // 4. Cancel Challenge & Refund Escrow
  @Delete(':id')
  async cancel(
    @Req() req: any,
    @Param('id') challengeId: string,
    @Body() body: { userId?: string },
  ) {
    const userId = req.user?.id || body?.userId;
    return this.challengeService.cancelChallenge(userId, challengeId);
  }

  // 5. Send Challenge Invitation
  @Post(':id/invite')
  async invite(
    @Req() req: any,
    @Param('id') challengeId: string,
    @Body() body: { receiverId: string; userId?: string },
  ) {
    const userId = req.user?.id || body.userId;
    return this.challengeService.invitePlayer(userId, challengeId, body.receiverId);
  }
}