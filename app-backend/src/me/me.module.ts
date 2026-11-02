import { Module } from '@nestjs/common';
import { AuthModule } from '../auth/auth.module';
import { StorageService } from '../storage/storage.service';
import { MeController } from './me.controller';
import { MeService } from './me.service';
 
@Module({
  imports: [AuthModule],
  controllers: [MeController],
  providers: [MeService, StorageService],
})
export class MeModule {}
 