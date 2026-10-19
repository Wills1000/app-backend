import { IsBoolean, IsInt, IsNotEmpty, IsString, Min, Max } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class UserComplianceCheckDto {
  @ApiProperty({ example: 18 })
  @IsInt()
  @Min(13)
  @Max(100)
  age: number;

  @ApiProperty({ example: 'NG' })
  @IsString()
  @IsNotEmpty()
  countryCode: string;

  @ApiProperty({ example: true })
  @IsBoolean()
  acceptedTerms: boolean;
}