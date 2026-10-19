import { IsString, IsEmail, IsNumber, IsPositive, Matches, Min, Max, IsNotEmpty, IsInt } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserValidationDto {
  @ApiProperty({ example: 'johndoe_99' })
  @IsString()
  @IsNotEmpty()
  @Matches(/^[a-zA-Z0-9_]{3,20}$/, {
    message: 'Username must be 3-20 characters long and can only contain letters, numbers, and underscores.',
  })
  username: string;

  @ApiProperty({ example: 'user@example.com' })
  @IsEmail({}, { message: 'Invalid email address format.' })
  email: string;

  @ApiProperty({ example: '+2348012345678' })
  @IsString()
  @Matches(/^\+?[1-9]\d{1,14}$/, {
    message: 'Invalid phone number format. Use international E.164 standard.',
  })
  phone: string;
}

export class FinancialAmountValidationDto {
  @ApiProperty({ example: 1000.50 })
  @IsNumber({ maxDecimalPlaces: 2 }, { message: 'Amount must be a valid number with up to 2 decimal places.' })
  @IsPositive({ message: 'Amount must be greater than zero.' })
  @Min(100, { message: 'Minimum transaction amount is 100.' })
  @Max(1000000, { message: 'Maximum transaction limit exceeded.' })
  amount: number;
}

export class GameChallengeValidationDto {
  @ApiProperty({ example: 'uuid-game-id' })
  @IsString()
  @IsNotEmpty()
  gameId: string;

  @ApiProperty({ example: 500 })
  @IsNumber()
  @IsPositive()
  stakeAmount: number;
}

export class ScoreValidationDto {
  @ApiProperty({ example: 3 })
  @IsInt()
  @Min(0, { message: 'Score cannot be negative.' })
  @Max(999, { message: 'Invalid maximum score limit.' })
  score: number;
}