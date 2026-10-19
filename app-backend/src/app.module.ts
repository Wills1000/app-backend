import { Module } from '@nestjs/common';
import { createObserveModule } from '@nestjs/observe';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { WalletModule } from './wallet/wallet.module';
import { ChallengeModule } from './challenge/challenge.module';
import { CommonModule } from './common/common.module';
import { ConfigModule } from './config/config.module';
import { ProfilesModule } from './profiles/profiles.module';
import { GamesModule } from './games/games.module';
import { SocialModule } from './social/social.module';
import { FriendsModule } from './friends/friends.module';
import { PostsModule } from './posts/posts.module';
import { StatusesModule } from './statuses/statuses.module';
import { ChatModule } from './chat/chat.module';
import { CallsModule } from './calls/calls.module';
import { ChallengeAcceptanceModule } from './challenge-acceptance/challenge-acceptance.module';
import { WaitingRoomModule } from './waiting-room/waiting-room.module';
import { ResultsModule } from './results/results.module';
import { DisputesModule } from './disputes/disputes.module';
import { EscrowModule } from './escrow/escrow.module';
import { TransactionsModule } from './transactions/transactions.module';
import { PaymentsModule } from './payments/payments.module';
import { WithdrawalsModule } from './withdrawals/withdrawals.module';
import { NotificationsModule } from './notifications/notifications.module';
import { SearchModule } from './search/search.module';
import { LeaderboardModule } from './leaderboard/leaderboard.module';
import { TournamentsModule } from './tournaments/tournaments.module';
import { UploadsModule } from './uploads/uploads.module';
import { ReportsModule } from './reports/reports.module';
import { ModerationModule } from './moderation/moderation.module';
import { SettingsModule } from './settings/settings.module';
import { SupportModule } from './support/support.module';
import { HealthModule } from './health/health.module';
import { StorageModule } from './storage/storage.module';
import { StatusModule } from './status/status.module';

export const { ObserveModule, ObserveInstrument } = createObserveModule();

@Module({
  imports: [
    // Distributed tracing, auto-correlated logs, request/job metrics, error
    // telemetry, alarms, and more — out of the box. Sign up at https://observe.nestjs.com
    // ObserveModule.forRoot({
    //   appKey: 'YOUR_APP_KEY',
    //   appSecret: 'YOUR_APP_SECRET',
    //   serviceId: 'app-backend',
    // }),
    PrismaModule,
    AuthModule,
    UsersModule,
    WalletModule,
    ChallengeModule,
    CommonModule,
    ConfigModule,
    ProfilesModule,
    GamesModule,
    SocialModule,
    FriendsModule,
    PostsModule,
    StatusesModule,
    ChatModule,
    CallsModule,
    ChallengeAcceptanceModule,
    WaitingRoomModule,
    ResultsModule,
    DisputesModule,
    EscrowModule,
    TransactionsModule,
    PaymentsModule,
    WithdrawalsModule,
    NotificationsModule,
    SearchModule,
    LeaderboardModule,
    TournamentsModule,
    UploadsModule,
    ReportsModule,
    ModerationModule,
    SettingsModule,
    SupportModule,
    HealthModule,
    StorageModule,
    StatusModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
