import { IsString, IsNotEmpty, IsEnum, IsUrl } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export enum DisputeReason {
  CHEATING_HACKING = 'CHEATING_HACKING',
  FALSE_RESULT = 'FALSE_RESULT',
  OPPONENT_ABANDONED = 'OPPONENT_ABANDONED',
  SERVER_DISCONNECT = 'SERVER_DISCONNECT',
  HARASSMENT = 'HARASSMENT',
}

export class RaiseDisputeDto {
  @ApiProperty({ example: 'uuid-challenge-id' })
  @IsString()
  @IsNotEmpty()
  challengeId: string;

  @ApiProperty({ enum: DisputeReason, example: DisputeReason.FALSE_RESULT })
  @IsEnum(DisputeReason)
  reason: DisputeReason;

  @ApiProperty({ example: 'Opponent submitted a fake score card screenshot.' })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiProperty({ example: 'https://storage.googleapis.com/gamer-app-proofs/evidence.mp4' })
  @IsUrl()
  evidenceUrl: string;
}