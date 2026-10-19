import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { FirebaseService } from './firebase.service';
import { FirebaseAuthGuard } from './guards/firebase-auth.guard';

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    FirebaseService,
    FirebaseAuthGuard,
  ],
  exports: [
    AuthService,
    FirebaseService,
    FirebaseAuthGuard,
    PassportModule,
  ],
})
export class AuthModule {}