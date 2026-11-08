import {
  ArrayMaxSize,
  IsArray,
  IsDateString,
  IsIn,
  IsOptional,
  IsString,
  Matches,
  MaxLength,
} from 'class-validator';
 
export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @Matches(/^[a-zA-Z0-9_]{3,20}$/, {
    message: 'Username must be 3-20 characters: letters, numbers or underscore',
  })
  username?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(50)
  firstName?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(50)
  lastName?: string;
 
  @IsOptional()
  @IsDateString()
  dateOfBirth?: string;
 
  @IsOptional()
  @IsIn(['MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'])
  gender?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(80)
  country?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(80)
  state?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(80)
  city?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(50)
  language?: string;
 
  @IsOptional()
  @IsString()
  @MaxLength(180)
  bio?: string;
 
  // Only the avatars bundled with the app are accepted (for example assets/avatars/ava1.jpg)
  @IsOptional()
  @IsString()
  @Matches(/^assets\/avatars\/[A-Za-z0-9_\-.]+$/, {
    message: 'Invalid avatar',
  })
  avatarUrl?: string;
 
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(10)
  @IsString({ each: true })
  quickTags?: string[];
}