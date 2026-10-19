import { IsString, IsNotEmpty, IsOptional, IsArray, IsInt, Min } from 'class-validator';

export class SubmitResultDto {
  @IsString()
  @IsNotEmpty()
  claimedWinnerId: string;

  @IsInt()
  @Min(0)
  playerScore: number;

  @IsInt()
  @Min(0)
  opponentScore: number;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  proofUrls?: string[];
}