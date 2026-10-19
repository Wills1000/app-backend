import { IsString, IsNotEmpty, IsEnum, IsOptional } from 'class-validator';

export enum DisputeResolutionAction {
  DECLARE_WINNER = 'DECLARE_WINNER',
  REFUND = 'REFUND',
}

export class ResolveDisputeDto {
  @IsEnum(DisputeResolutionAction)
  @IsNotEmpty()
  action: DisputeResolutionAction;

  @IsString()
  @IsOptional()
  winnerId?: string; // Required if action is DECLARE_WINNER

  @IsString()
  @IsNotEmpty()
  adminNotes: string; // Audit trail / reason for decision
}