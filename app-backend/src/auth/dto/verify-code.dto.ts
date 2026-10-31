import { IsString, Matches } from 'class-validator';
 
export class VerifyCodeDto {
  @IsString()
  @Matches(/^\d{6}$/, { message: 'Code must be 6 digits' })
  code: string;
}
 