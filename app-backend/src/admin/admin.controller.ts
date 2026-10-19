import { Controller, Get, Post, Patch, Body, Param, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { PrismaService } from '../prisma/prisma.service';

@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(private prisma: PrismaService) {}

  @Get('users')
  async getAllUsers() {
    const db: any = this.prisma;
    return db.user.findMany({
      select: { id: true, username: true, email: true, role: true, createdAt: true },
    });
  }

  @Patch('users/:id/status')
  async updateUserStatus(@Param('id') id: string, @Body() body: { status: string }) {
    const db: any = this.prisma;
    return db.user.update({
      where: { id },
      data: { status: body.status },
    });
  }

  @Get('withdrawals')
  async getPendingWithdrawals() {
    const db: any = this.prisma;
    return db.walletTransaction.findMany({
      where: { type: 'WITHDRAWAL', status: 'PENDING' },
      include: { user: { select: { username: true, email: true } } },
    });
  }

  @Patch('withdrawals/:id/process')
  async processWithdrawal(@Param('id') id: string, @Body() body: { status: 'APPROVED' | 'REJECTED' }) {
    const db: any = this.prisma;
    return db.walletTransaction.update({
      where: { id },
      data: { status: body.status },
    });
  }

  @Get('audit-logs')
  async getAuditLogs() {
    const db: any = this.prisma;
    return db.auditLog?.findMany({
      orderBy: { createdAt: 'desc' },
      take: 100,
    }) || [];
  }
}