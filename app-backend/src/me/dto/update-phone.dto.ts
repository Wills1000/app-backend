import { Matches } from 'class-validator';

export class UpdatePhoneDto {
  @Matches(/^\+?[0-9]{7,15}$/, {
    message: 'Enter a valid phone number (7-15 digits)',
  })
  phone: string;
}