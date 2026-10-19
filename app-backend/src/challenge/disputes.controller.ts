import { Controller, Post, Get, Body, Param, Req, UseGuards } from '@nestjs/common';
import { DisputesService } from './dispute.service';
import { CreateDisputeDto } from './dto/create-dispute.dto';
import { ResolveDisputeDto } from './dto/resolve-dispute.dto';
// Adjust import to match your authentication guard path
// import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('challenges')
// @UseGuards(JwtAuthGuard) // Uncomment once your auth guard is configured
export class DisputesController {
  constructor(private readonly disputesService: DisputesService) {}

  @Post(':challengeId/dispute')
  async createDispute(
    @Req() req: any,
    @Param('challengeId') challengeId: string,
    @Body() dto: CreateDisputeDto,
  ) {
    const userId = req.user?.id || req.user?.userId;
    return this.disputesService.createDispute(userId, challengeId, dto);
  }

  @Get(':challengeId/dispute')
  async getDispute(@Param('challengeId') challengeId: string) {
    return this.disputesService.getDisputeByChallenge(challengeId);
  }

  @Post('disputes/:disputeId/resolve')
  // @UseGuards(AdminRoleGuard) // Protect with your admin guard if necessary
  async resolveDispute(
    @Req() req: any,
    @Param('disputeId') disputeId: string,
    @Body() dto: ResolveDisputeDto,
  ) {
    const adminId = req.user?.id || req.user?.userId;
    return this.disputesService.resolveDispute(adminId, disputeId, dto);
  }
}