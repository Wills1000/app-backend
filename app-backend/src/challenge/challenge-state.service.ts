import { Injectable, BadRequestException } from '@nestjs/common';
import { ChallengeStatus } from '@prisma/client';

@Injectable()
export class ChallengeStateService {
  // Use string indexing with 'any' casting to bypass missing Prisma client enum properties temporarily
  private readonly allowedTransitions: Record<string, string[]> = {
    [ChallengeStatus.OPEN]: ['PENDING_ACCEPTANCE', 'ACCEPTED', 'CANCELLED', 'EXPIRED'],
    'PENDING_ACCEPTANCE': ['ACCEPTED', 'ESCROW_PENDING', 'CANCELLED'],
    'ACCEPTED': ['ESCROW_LOCKED', 'CANCELLED'],
    'ESCROW_PENDING': ['ESCROW_LOCKED', 'REFUNDED'],
    'ESCROW_LOCKED': ['WAITING_ROOM', 'CANCELLED', 'REFUNDED'],
    'WAITING_ROOM': ['READY', 'CANCELLED'],
    'READY': ['IN_PROGRESS', 'CANCELLED'],
    [ChallengeStatus.IN_PROGRESS]: ['MATCH_COMPLETED', 'DISPUTED'],
    'MATCH_COMPLETED': ['RESULT_SUBMITTED', 'DISPUTED'],
    'RESULT_SUBMITTED': ['RESULT_PENDING_CONFIRMATION', 'DISPUTED', 'COMPLETED'],
    'RESULT_PENDING_CONFIRMATION': ['COMPLETED', 'DISPUTED'],
    'DISPUTED': ['UNDER_REVIEW'],
    'UNDER_REVIEW': ['COMPLETED', 'REFUNDED'],
    [ChallengeStatus.COMPLETED]: [],
    [ChallengeStatus.CANCELLED]: ['REFUNDED'],
    'REFUNDED': [],
    'EXPIRED': ['REFUNDED'],
  };

  validateTransition(currentStatus: ChallengeStatus, targetStatus: ChallengeStatus) {
    const allowed = this.allowedTransitions[currentStatus] || [];
    if (!allowed.includes(targetStatus)) {
      throw new BadRequestException(
        `Invalid state transition from ${currentStatus} to ${targetStatus}`
      );
    }
    return true;
  }
}