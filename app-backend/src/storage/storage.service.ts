import { Injectable, BadRequestException } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { getStorage } from 'firebase-admin/storage';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class StorageService {
  private bucket: any;

  constructor() {
    try {
      (admin as any).app();
    } catch (e) {
      (admin as any).initializeApp({
        storageBucket: 'your-project-id.appspot.com', // Replace with your actual Firebase storage bucket name
      });
    }
    this.bucket = getStorage().bucket();
  }

  private readonly allowedMimeTypes = {
    image: ['image/jpeg', 'image/png', 'image/webp', 'image/gif'],
    video: ['video/mp4', 'video/quicktime', 'video/webm'],
    audio: ['audio/mpeg', 'audio/wav', 'audio/ogg', 'audio/webm'],
    document: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
  };
  
  async uploadFile(
    file: any,
    folder: string,
    fileTypeCategory: 'image' | 'video' | 'audio' | 'document' = 'image',
    maxSizeInMB: number = 10,
  ): Promise<string> {
    if (!file) {
      throw new BadRequestException('No file provided');
    }

    const maxSize = maxSizeInMB * 1024 * 1024;
    if (file.size > maxSize) {
      throw new BadRequestException(`File size exceeds the limit of ${maxSizeInMB}MB`);
    }

    const validMimes = this.allowedMimeTypes[fileTypeCategory] || [];
    if (!validMimes.includes(file.mimetype)) {
      throw new BadRequestException(`Invalid file type for ${fileTypeCategory}.`);
    }

    const fileExtension = file.originalname.split('.').pop()?.toLowerCase();
    const uniqueFileName = `${folder}/${uuidv4()}-${Date.now()}.${fileExtension}`;
    const blob = this.bucket.file(uniqueFileName);

    const blobStream = blob.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    return new Promise((resolve, reject) => {
      blobStream.on('error', (error: any) => {
        reject(new BadRequestException(`Could not upload file: ${error.message}`));
      });

      blobStream.on('finish', async () => {
        await blob.makePublic();
        const publicUrl = `https://storage.googleapis.com/${this.bucket.name}/${blob.name}`;
        resolve(publicUrl);
      });

      blobStream.end(file.buffer);
    });
  }

  async deleteFile(fileUrl: string): Promise<boolean> {
    try {
      const baseUrl = `https://storage.googleapis.com/${this.bucket.name}/`;
      if (!fileUrl.startsWith(baseUrl)) return false;
      
      const filePath = fileUrl.replace(baseUrl, '');
      await this.bucket.file(filePath).delete();
      return true;
    } catch (error) {
      return false;
    }
  }

  async getSignedUrl(fileUrl: string): Promise<string> {
    const baseUrl = `https://storage.googleapis.com/${this.bucket.name}/`;
    const filePath = fileUrl.replace(baseUrl, '');
    
    const [url] = await this.bucket.file(filePath).getSignedUrl({
      action: 'read',
      expires: Date.now() + 15 * 60 * 1000,
    });
    
    return url;
  }
}