import { IsString, IsNotEmpty, IsUrl, IsInt, Min, Max } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SubmitMatchResultDto {
  @ApiProperty({ example: 'uuid-challenge-id' })
  @IsString()
  @IsNotEmpty()
  challengeId: string;

  @ApiProperty({ example: 3 })
  @IsInt()
  @Min(0)
  @Max(99)
  reportedScore: number;

  @ApiProperty({ example: 'https://storage.googleapis.com/gamer-app-proofs/screenshot123.png' })
  @IsUrl({}, { message: 'Proof must be a valid image or video URL.' })
  @IsNotEmpty()
  proofUrl: string;

  @ApiProperty({ example: 'Opponent disconnected in round 2 and refused to rejoin.' })
  @IsString()
  @IsNotEmpty()
  matchSummary: string;
}