import { Controller, Get, Post, Body, Req, UseGuards, Param, Query } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { WithdrawDto, TransferDto } from './dto/wallet.dto';

@Controller('wallet')
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @UseGuards(JwtAuthGuard)
  @Get('me')
  async getMyWallet(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.getOrCreateWallet(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('balance')
  async getBalance(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.getWalletBalance(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('history')
  async getHistory(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.getWalletHistory(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Get('statistics')
  async getStatistics(@Req() req: any) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.getWalletStatistics(userId);
  }

  @UseGuards(JwtAuthGuard)
  @Post('deposit/initialize')
  async initializeDeposit(@Req() req: any, @Body('amount') amount: number) {
    const userId = req.user?.id || req.user?.userId;
    const email = req.user?.email || 'user@example.com';
    return this.walletService.initializeDeposit(userId, amount, email);
  }

  @Post('webhook/paystack')
  async paystackWebhook(
    @Req() req: any,
    @Body() body: any,
  ) {
    const signature = req.headers['x-paystack-signature'];
    // Note: To use rawBody securely, ensure your NestJS main.ts is configured to capture raw body for this route, 
    // or verify via standard payload hash if raw body middleware isn't active.
    
    return this.walletService.handlePaystackWebhook(body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('payment/verify/:reference')
  async verifyPayment(@Param('reference') reference: string) {
    return this.walletService.verifyPayment(reference);
  }

  @UseGuards(JwtAuthGuard)
  @Post('withdraw')
  async requestWithdrawal(@Req() req: any, @Body() dto: WithdrawDto) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.requestWithdrawal(userId, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('withdraw/cancel/:reference')
  async cancelWithdrawal(@Req() req: any, @Param('reference') reference: string) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.cancelWithdrawal(userId, reference);
  }

  @UseGuards(JwtAuthGuard)
  @Post('transfer')
  async transfer(@Req() req: any, @Body() dto: TransferDto) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.transfer(userId, dto.recipientUserId, dto.amount);
  }

  /**
   * Get paginated transaction history for the authenticated user
   */
  @UseGuards(JwtAuthGuard)
  @Get('transactions/paginated')
  async getTransactionHistory(
    @Req() req: any,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    const userId = req.user?.id || req.user?.userId;
    return this.walletService.getTransactionHistory(
      userId, 
      page ? Number(page) : 1, 
      limit ? Number(limit) : 20
    );
  }

  /**
   * Get single transaction details by transaction ID or unique reference
   */
  @UseGuards(JwtAuthGuard)
  @Get('transaction/:identifier')
  async getTransactionDetails(@Param('identifier') identifier: string) {
    return this.walletService.getTransactionDetails(identifier);
  }

  @UseGuards(JwtAuthGuard)
  @Post('bank/verify')
  async verifyBankAccount(@Body() body: { accountNumber: string; bankCode: string }) {
    return this.walletService.verifyBankAccount(body.accountNumber, body.bankCode);
  }

  @Get('coin/rate')
  async getCurrentCoinRate() {
    return this.walletService.getCurrentRate();
  }

  @UseGuards(JwtAuthGuard)
  @Get('coin/history')
  async getCoinRateHistory() {
    return this.walletService.getRateHistory();
  }

  @UseGuards(JwtAuthGuard)
  @Post('admin/coin/rate')
  async updateCoinRate(@Req() req: any, @Body('rate') rate: number) {
    const adminUserId = req.user?.id || req.user?.userId;
    return this.walletService.setCoinRate(adminUserId, rate);
  }
}