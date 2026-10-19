import { IsString, IsEnum, IsOptional, IsObject } from 'class-validator';

export enum NotificationTypeEnum {
  CHALLENGE = 'CHALLENGE',
  FRIEND = 'FRIEND',
  MESSAGE = 'MESSAGE',
  STATUS = 'STATUS',
  WALLET = 'WALLET',
  PAYMENT = 'PAYMENT',
  WITHDRAWAL = 'WITHDRAWAL',
  RESULT = 'RESULT',
  DISPUTE = 'DISPUTE',
}

export class CreateNotificationDto {
  @IsString()
  userId: string;

  @IsString()
  title: string;

  @IsString()
  message: string;

  @IsEnum(NotificationTypeEnum)
  type: NotificationTypeEnum;

  @IsOptional()
  @IsObject()
  metadata?: any;
}