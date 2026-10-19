import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';

@Injectable()
export class WalletOwnerGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const targetUserId = request.params.userId || request.body.userId;

    if (!user) throw new ForbiddenException('Authentication required.');

    // Admins can check any wallet, users can only check their own
    if (['ADMIN', 'SUPER_ADMIN'].includes(user.role)) {
      return true;
    }

    const currentUserId = user.id || user.userId;
    if (targetUserId && targetUserId !== currentUserId) {
      throw new ForbiddenException('Unauthorized access to external user wallet.');
    }

    return true;
  }
}