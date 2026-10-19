import { Controller, Post, Body, Param, Req, UseGuards } from '@nestjs/common';
import { ResultService } from './result.service';
import { SubmitResultDto } from './dto/submit-result.dto';
// Adjust this import to match your actual authentication guard path
// import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard'; 

@Controller('challenges')
// @UseGuards(JwtAuthGuard) // Uncomment once your auth guard is configured
export class ResultController {
  constructor(private readonly resultService: ResultService) {}

  @Post(':challengeId/result')
  async submitResult(
    @Req() req: any,
    @Param('challengeId') challengeId: string,
    @Body() dto: SubmitResultDto,
  ) {
    // Extracts the user ID from the authenticated request payload
    const userId = req.user?.id || req.user?.userId; 

    return this.resultService.submitResult(userId, challengeId, dto);
  }
}