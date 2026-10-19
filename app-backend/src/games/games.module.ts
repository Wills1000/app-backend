// app-backend/src/games/games.module.ts
import { Module } from '@nestjs/common';
import { GamesService } from './games.service';
import { GamesController } from './games.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module'; // <-- 1. Import AuthModule

@Module({
  imports: [PrismaModule, AuthModule], // <-- 2. Add AuthModule here
  controllers: [GamesController],
  providers: [GamesService],
})
export class GamesModule {}