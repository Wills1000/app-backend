import { Module } from '@nestjs/common';
import { NotificationService } from './notification.service'; // Adjust path if needed

@Module({
  providers: [NotificationService],
  exports: [NotificationService], // <-- Export it so WalletModule can inject it
})
export class NotificationsModule {}