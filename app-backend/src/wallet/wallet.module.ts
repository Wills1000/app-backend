import { Module } from '@nestjs/common';
import { WalletService } from './wallet.service';
import { WalletController } from './wallet.controller';
import { LedgerService } from './ledger.service';
import { AuthModule } from '../auth/auth.module';
import { NotificationsModule } from '../notifications/notifications.module'; // <-- Import notifications module

@Module({
  imports: [AuthModule, NotificationsModule], // <-- Add it to imports here
  controllers: [WalletController],
  providers: [WalletService, LedgerService],
  exports: [WalletService, LedgerService],
})
export class WalletModule {}