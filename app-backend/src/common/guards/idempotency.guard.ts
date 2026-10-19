import { Injectable, CanActivate, ExecutionContext, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class IdempotencyGuard implements CanActivate {
  constructor(private prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const idempotencyKey = request.headers['x-idempotency-key'];

    if (!idempotencyKey) {
      return true; // Skip if no key provided, or enforce strictly for financial routes
    }

    const db: any = this.prisma;
    const existingLog = await db.idempotencyLog?.findUnique({
      where: { key: idempotencyKey },
    });

    if (existingLog) {
      throw new ConflictException('Duplicate transaction request detected via Idempotency Key.');
    }

    // Save key to prevent replay
    await db.idempotencyLog?.create({
      data: { key: idempotencyKey, path: request.url },
    }).catch(() => {
      throw new ConflictException('Concurrent duplicate transaction blocked.');
    });

    return true;
  }
} 