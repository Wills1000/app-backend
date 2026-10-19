import { Controller, Get, Post, Patch, Body, Param, Query, UseGuards, Req } from '@nestjs/common';
import { SupportService } from './support.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('support')
export class SupportController {
  constructor(private readonly supportService: SupportService) {}

  @UseGuards(JwtAuthGuard)
  @Post('tickets')
  async createTicket(
    @Req() req: any,
    @Body() body: { subject: string; category: string; priority?: string; initialMessage: string; attachments?: string[] },
  ) {
    const userId = req.user?.id || req.user?.userId;
    return this.supportService.createTicket(userId, body);
  }

  @UseGuards(JwtAuthGuard)
  @Get('tickets')
  async getTickets(@Req() req: any, @Query('isAdmin') isAdmin?: string) {
    const userId = req.user?.id || req.user?.userId;
    const adminFlag = isAdmin === 'true';
    return this.supportService.getTickets(userId, adminFlag);
  }

  @UseGuards(JwtAuthGuard)
  @Get('tickets/:id')
  async getTicketDetails(@Param('id') id: string) {
    return this.supportService.getTicketDetails(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post('tickets/:id/messages')
  async addMessage(
    @Req() req: any,
    @Param('id') ticketId: string,
    @Body() body: { message: string; attachments?: string[] },
  ) {
    const senderId = req.user?.id || req.user?.userId;
    return this.supportService.addTicketMessage(ticketId, senderId, body.message, body.attachments);
  }

  @UseGuards(JwtAuthGuard)
  @Patch('tickets/:id/status')
  async updateStatus(@Param('id') ticketId: string, @Body() body: { status: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED' }) {
    return this.supportService.updateTicketStatus(ticketId, body.status);
  }

  @Get('faqs')
  async getFAQs(@Query('category') category?: string) {
    return this.supportService.getFAQs(category);
  }

  @UseGuards(JwtAuthGuard)
  @Post('faqs')
  async createFAQ(@Body() body: { question: string; answer: string; category?: string }) {
    return this.supportService.createFAQ(body);
  }
}