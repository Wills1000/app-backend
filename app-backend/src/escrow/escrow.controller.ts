import { Controller, Post, Get, Body, Param, Query } from '@nestjs/common';
import { EscrowService } from './escrow.service';

@Controller('escrow')
export class EscrowController {
  constructor(private readonly escrowService: EscrowService) {}

  @Post('stake')
  async createAndLockEscrow(
    @Body('userId') userId: string,
    @Body('challengeId') challengeId: string,
    @Body('amount') amount: number,
  ) {
    return this.escrowService.createAndLockEscrow(userId, challengeId, amount);
  }

  @Get('verify/:challengeId')
  async verifyEscrow(@Param('challengeId') challengeId: string) {
    return this.escrowService.verifyEscrow(challengeId);
  }

  @Post('dispute')
  async disputeHold(
    @Body('challengeId') challengeId: string,
    @Body('reason') reason: string,
  ) {
    return this.escrowService.disputeHold(challengeId, reason);
  }

  @Post('refund')
  async refundEscrow(@Body('challengeId') challengeId: string) {
    return this.escrowService.refundEscrow(challengeId);
  }

  @Post('settle')
  async settleMatch(
    @Body('challengeId') challengeId: string,
    @Body('winnerId') winnerId: string,
    @Body('loserId') loserId: string,
    @Body('feePercentage') feePercentage?: number,
  ) {
    return this.escrowService.settleMatch(challengeId, winnerId, loserId, feePercentage);
  }

  @Get('audit/:challengeId')
  async getEscrowAuditTrail(@Param('challengeId') challengeId: string) {
    return this.escrowService.getEscrowAuditTrail(challengeId);
  }

  @Post('expire-stale')
  async expireStaleEscrows(@Body('maxAgeHours') maxAgeHours?: number) {
    return this.escrowService.expireStaleEscrows(maxAgeHours);
  }
}