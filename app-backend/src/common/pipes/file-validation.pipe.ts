import { PipeTransform, Injectable, BadRequestException } from '@nestjs/common';

@Injectable()
export class FileValidationPipe implements PipeTransform {
  private readonly maxSizeBytes = 5 * 1024 * 1024; // 5 MB
  private readonly allowedMimeTypes = ['image/jpeg', 'image/png', 'image/webp', 'application/pdf'];

  transform(value: any) {
    if (!value) {
      throw new BadRequestException('No file uploaded.');
    }

    if (value.size > this.maxSizeBytes) {
      throw new BadRequestException('File size exceeds the 5MB limit.');
    }

    if (!this.allowedMimeTypes.includes(value.mimetype)) {
      throw new BadRequestException('Invalid file type. Allowed formats: JPEG, PNG, WEBP, PDF.');
    }

    return value;
  }
}