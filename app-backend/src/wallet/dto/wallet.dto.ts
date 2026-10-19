import { IsNumber, IsPositive, IsString, IsOptional, Min, Max, IsNotEmpty } from 'class-validator';

export class DepositDto {
  @IsNumber()
  @IsPositive()
  amount: number;

  @IsString()
  @IsOptional()
  reference?: string;
}

export class WithdrawDto {
  @IsNumber()
  @Min(500, { message: 'Minimum withdrawal amount is 500 NGN' })
  @Max(5000000, { message: 'Maximum withdrawal amount is 5,000,000 NGN' })
  amount: number;

  @IsString()
  @IsNotEmpty({ message: 'Bank code is required' })
  bankCode: string;

  @IsString()
  @IsNotEmpty({ message: 'Account number is required' })
  accountNumber: string;

  @IsString()
  @IsNotEmpty({ message: 'Account name is required' })
  accountName: string;
}

export class TransferDto {
  @IsNumber()
  @IsPositive()
  amount: number;

  @IsString()
  recipientUserId: string;
}