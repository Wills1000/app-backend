import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SupportService {
  constructor(private prisma: PrismaService) {}

  /**
   * Create a new support ticket
   */
  async createTicket(userId: string, data: { subject: string; category: any; priority?: any; initialMessage: string; attachments?: string[] }) {
    const db: any = this.prisma;
    
    return db.ticket.create({
      data: {
        userId,
        subject: data.subject,
        category: data.category || 'GENERAL',
        priority: data.priority || 'MEDIUM',
        messages: {
          create: {
            senderId: userId,
            message: data.initialMessage,
            attachments: data.attachments || [],
          },
        },
      },
      include: { messages: true },
    });
  }

  /**
   * Get user tickets or all tickets for admin
   */
  async getTickets(userId?: string, isAdmin: boolean = false) {
    const db: any = this.prisma;
    const where = isAdmin ? {} : { userId };

    return db.ticket.findMany({
      where,
      include: {
        user: { select: { id: true, name: true, username: true, email: true } },
        messages: { orderBy: { createdAt: 'asc' }, take: 1 }, // Preview first message
      },
      orderBy: { updatedAt: 'desc' },
    });
  }

  /**
   * Get ticket details with full message history
   */
  async getTicketDetails(ticketId: string) {
    const db: any = this.prisma;
    const ticket = await db.ticket.findUnique({
      where: { id: ticketId },
      include: {
        user: { select: { id: true, name: true, username: true, email: true } },
        messages: { orderBy: { createdAt: 'asc' } },
      },
    });

    if (!ticket) throw new NotFoundException('Support ticket not found');
    return ticket;
  }

  /**
   * Add message / reply to ticket (supports file attachments)
   */
  async addTicketMessage(ticketId: string, senderId: string, message: string, attachments: string[] = []) {
    const db: any = this.prisma;
    const ticket = await db.ticket.findUnique({ where: { id: ticketId } });
    if (!ticket) throw new NotFoundException('Support ticket not found');

    const newMessage = await db.ticketMessage.create({
      data: {
        ticketId,
        senderId,
        message,
        attachments,
      },
    });

    // Update ticket timestamp
    await db.ticket.update({
      where: { id: ticketId },
      data: { updatedAt: new Date() },
    });

    return newMessage;
  }

  /**
   * Update ticket status (Admin or User closing)
   */
  async updateTicketStatus(ticketId: string, status: 'OPEN' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED') {
    const db: any = this.prisma;
    const ticket = await db.ticket.findUnique({ where: { id: ticketId } });
    if (!ticket) throw new NotFoundException('Support ticket not found');

    return db.ticket.update({
      where: { id: ticketId },
      data: { status },
    });
  }

  /**
   * FAQ API Management & Retrieval
   */
  async getFAQs(category?: string) {
    const db: any = this.prisma;
    const where = category ? { category } : {};
    return db.fAQ.findMany({ where, orderBy: { createdAt: 'asc' } });
  }

  async createFAQ(data: { question: string; answer: string; category?: string }) {
    const db: any = this.prisma;
    return db.fAQ.create({ data });
  }
}