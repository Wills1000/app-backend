import { Injectable, CanActivate, ExecutionContext, ForbiddenException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class ResourceOwnerGuard implements CanActivate {
  constructor(private prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const resourceId = request.params.id;
    const path = request.route.path;

    if (!user) throw new ForbiddenException('Authentication required.');

    // Admins and Super Admins bypass resource ownership checks
    if (['ADMIN', 'SUPER_ADMIN'].includes(user.role)) {
      return true;
    }

    let ownerId = null;

    if (path.includes('support/tickets')) {
      const ticket = await (this.prisma as any).ticket.findUnique({ where: { id: resourceId } });
      if (!ticket) throw new NotFoundException('Ticket not found.');
      ownerId = ticket.userId;
    } else if (path.includes('settings')) {
      ownerId = user.id || user.userId;
    }

    if (ownerId && ownerId !== (user.id || user.userId)) {
      throw new ForbiddenException('You do not have permission to modify this resource.');
    }

    return true;
  }
}