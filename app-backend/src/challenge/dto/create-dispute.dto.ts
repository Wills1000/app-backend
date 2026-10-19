import { IsString, IsNotEmpty, IsOptional, IsArray } from 'class-validator';

export class CreateDisputeDto {
  @IsString()
  @IsNotEmpty()
  reason: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  proofUrls?: string[];
}