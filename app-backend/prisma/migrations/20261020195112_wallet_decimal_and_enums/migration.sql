/*
  Warnings:

  - The values [WAGER_PAYOUT] on the enum `TransactionType` will be removed. If these variants are still used in the database, this will fail.
  - The primary key for the `wallets` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `currency` on the `wallets` table. All the data in the column will be lost.
  - You are about to drop the `notifications` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `support_tickets` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `transactions` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `waiting_rooms` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[challengeId]` on the table `challenge_results` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[statusId,userId]` on the table `status_reactions` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId]` on the table `wallets` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `status_reactions` table without a default value. This is not possible if the table is not empty.
  - The required column `id` was added to the `wallets` table with a prisma-level default value. This is not possible if the table is not empty. Please add this column as optional, then populate it before making it required.

*/
-- CreateEnum
CREATE TYPE "PostPrivacy" AS ENUM ('PUBLIC', 'FOLLOWERS_ONLY', 'PRIVATE');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'MODERATOR', 'ADMIN', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'BANNED');

-- CreateEnum
CREATE TYPE "TicketCategory" AS ENUM ('GENERAL', 'BILLING', 'TECHNICAL', 'GAMEPLAY', 'REPORT', 'ACCOUNT');

-- CreateEnum
CREATE TYPE "TicketPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'URGENT');

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ChallengeStatus" ADD VALUE 'DRAFT';
ALTER TYPE "ChallengeStatus" ADD VALUE 'PENDING_ACCEPTANCE';
ALTER TYPE "ChallengeStatus" ADD VALUE 'ESCROW_PENDING';
ALTER TYPE "ChallengeStatus" ADD VALUE 'ESCROW_LOCKED';
ALTER TYPE "ChallengeStatus" ADD VALUE 'WAITING_ROOM';
ALTER TYPE "ChallengeStatus" ADD VALUE 'READY';
ALTER TYPE "ChallengeStatus" ADD VALUE 'MATCH_COMPLETED';
ALTER TYPE "ChallengeStatus" ADD VALUE 'RESULT_SUBMITTED';
ALTER TYPE "ChallengeStatus" ADD VALUE 'RESULT_PENDING_CONFIRMATION';
ALTER TYPE "ChallengeStatus" ADD VALUE 'UNDER_REVIEW';
ALTER TYPE "ChallengeStatus" ADD VALUE 'REFUNDED';
ALTER TYPE "ChallengeStatus" ADD VALUE 'EXPIRED';

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "NotificationType" ADD VALUE 'WITHDRAWAL';
ALTER TYPE "NotificationType" ADD VALUE 'WALLET';
ALTER TYPE "NotificationType" ADD VALUE 'DISPUTE';

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "ResultStatus" ADD VALUE 'MATCHED';
ALTER TYPE "ResultStatus" ADD VALUE 'CONFLICTED';
ALTER TYPE "ResultStatus" ADD VALUE 'VERIFIED';

-- AlterEnum
ALTER TYPE "TransactionStatus" ADD VALUE 'SUCCESS';

-- AlterEnum
BEGIN;
CREATE TYPE "TransactionType_new" AS ENUM ('CREDIT', 'DEBIT', 'HOLD', 'RELEASE', 'REFUND', 'DEPOSIT', 'WITHDRAWAL', 'CHALLENGE_STAKE', 'CHALLENGE_WINNINGS', 'PLATFORM_FEE', 'BONUS', 'ADJUSTMENT', 'WAGER_ESCROW');
ALTER TABLE "Transaction" ALTER COLUMN "type" TYPE "TransactionType_new" USING ("type"::text::"TransactionType_new");
ALTER TYPE "TransactionType" RENAME TO "TransactionType_old";
ALTER TYPE "TransactionType_new" RENAME TO "TransactionType";
DROP TYPE "TransactionType_old";
COMMIT;

-- DropForeignKey
ALTER TABLE "escrows" DROP CONSTRAINT "escrows_walletId_fkey";

-- DropForeignKey
ALTER TABLE "notifications" DROP CONSTRAINT "notifications_userId_fkey";

-- DropForeignKey
ALTER TABLE "support_tickets" DROP CONSTRAINT "support_tickets_userId_fkey";

-- DropForeignKey
ALTER TABLE "transactions" DROP CONSTRAINT "transactions_userId_fkey";

-- DropForeignKey
ALTER TABLE "waiting_rooms" DROP CONSTRAINT "waiting_rooms_gameId_fkey";

-- DropForeignKey
ALTER TABLE "waiting_rooms" DROP CONSTRAINT "waiting_rooms_userId_fkey";

-- DropForeignKey
ALTER TABLE "wallet_ledgers" DROP CONSTRAINT "wallet_ledgers_walletId_fkey";

-- DropForeignKey
ALTER TABLE "withdrawals" DROP CONSTRAINT "withdrawals_walletId_fkey";

-- AlterTable
ALTER TABLE "challenge_results" ADD COLUMN     "deadlineAt" TIMESTAMP(3),
ADD COLUMN     "opponentScore" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "playerScore" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "posts" ADD COLUMN     "mediaUrl" TEXT,
ADD COLUMN     "privacy" "PostPrivacy" NOT NULL DEFAULT 'PUBLIC',
ADD COLUMN     "thumbnailUrl" TEXT;

-- AlterTable
ALTER TABLE "result_proofs" ADD COLUMN     "type" TEXT;

-- AlterTable
ALTER TABLE "status_reactions" ADD COLUMN     "userId" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'USER',
ADD COLUMN     "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE "wallets" DROP CONSTRAINT "wallets_pkey",
DROP COLUMN "currency",
ADD COLUMN     "balance" DECIMAL(12,2) NOT NULL DEFAULT 0,
ADD COLUMN     "coinBalance" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
ADD COLUMN     "coinRate" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "id" TEXT NOT NULL,
ADD CONSTRAINT "wallets_pkey" PRIMARY KEY ("id");

-- DropTable
DROP TABLE "notifications";

-- DropTable
DROP TABLE "support_tickets";

-- DropTable
DROP TABLE "transactions";

-- DropTable
DROP TABLE "waiting_rooms";

-- CreateTable
CREATE TABLE "UserStats" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "gamesPlayed" INTEGER NOT NULL DEFAULT 0,
    "wins" INTEGER NOT NULL DEFAULT 0,
    "losses" INTEGER NOT NULL DEFAULT 0,
    "winRate" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "rating" DOUBLE PRECISION NOT NULL DEFAULT 1000.0,
    "totalEarnings" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "region" TEXT,
    "gameType" TEXT,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "UserStats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "moderation_logs" (
    "id" TEXT NOT NULL,
    "adminId" TEXT NOT NULL,
    "targetUserId" TEXT,
    "action" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "moderation_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CoinRate" (
    "id" TEXT NOT NULL,
    "rate" DOUBLE PRECISION NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "updatedBy" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CoinRate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "walletId" TEXT NOT NULL,
    "type" "TransactionType" NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "balanceBefore" DECIMAL(12,2) NOT NULL,
    "balanceAfter" DECIMAL(12,2) NOT NULL,
    "reference" TEXT NOT NULL,
    "status" "TransactionStatus" NOT NULL DEFAULT 'SUCCESS',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT,

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WaitingRoom" (
    "id" TEXT NOT NULL,
    "challengeId" TEXT NOT NULL,
    "roomCode" TEXT,
    "hostReady" BOOLEAN NOT NULL DEFAULT false,
    "opponentReady" BOOLEAN NOT NULL DEFAULT false,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT,
    "gameId" TEXT,

    CONSTRAINT "WaitingRoom_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post_reports" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "postId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DeviceToken" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "deviceType" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DeviceToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotificationPreference" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "challenges" BOOLEAN NOT NULL DEFAULT true,
    "walletUpdates" BOOLEAN NOT NULL DEFAULT true,
    "withdrawals" BOOLEAN NOT NULL DEFAULT true,
    "messages" BOOLEAN NOT NULL DEFAULT true,
    "marketing" BOOLEAN NOT NULL DEFAULT false,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NotificationPreference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_ticket_records" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "status" "TicketStatus" NOT NULL DEFAULT 'OPEN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "support_ticket_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_tickets_main" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "category" "TicketCategory" NOT NULL DEFAULT 'GENERAL',
    "status" "TicketStatus" NOT NULL DEFAULT 'OPEN',
    "priority" "TicketPriority" NOT NULL DEFAULT 'MEDIUM',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "support_tickets_main_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket_messages" (
    "id" TEXT NOT NULL,
    "ticketId" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "attachments" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ticket_messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "faqs" (
    "id" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT NOT NULL,
    "category" TEXT NOT NULL DEFAULT 'General',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "faqs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "UserStats_userId_key" ON "UserStats"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_reference_key" ON "Transaction"("reference");

-- CreateIndex
CREATE INDEX "Transaction_walletId_idx" ON "Transaction"("walletId");

-- CreateIndex
CREATE INDEX "Transaction_reference_idx" ON "Transaction"("reference");

-- CreateIndex
CREATE UNIQUE INDEX "WaitingRoom_challengeId_key" ON "WaitingRoom"("challengeId");

-- CreateIndex
CREATE UNIQUE INDEX "DeviceToken_token_key" ON "DeviceToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "NotificationPreference_userId_key" ON "NotificationPreference"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "challenge_results_challengeId_key" ON "challenge_results"("challengeId");

-- CreateIndex
CREATE UNIQUE INDEX "status_reactions_statusId_userId_key" ON "status_reactions"("statusId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "wallets_userId_key" ON "wallets"("userId");

-- AddForeignKey
ALTER TABLE "UserStats" ADD CONSTRAINT "UserStats_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderation_logs" ADD CONSTRAINT "moderation_logs_adminId_fkey" FOREIGN KEY ("adminId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "moderation_logs" ADD CONSTRAINT "moderation_logs_targetUserId_fkey" FOREIGN KEY ("targetUserId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WaitingRoom" ADD CONSTRAINT "WaitingRoom_challengeId_fkey" FOREIGN KEY ("challengeId") REFERENCES "challenges"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WaitingRoom" ADD CONSTRAINT "WaitingRoom_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WaitingRoom" ADD CONSTRAINT "WaitingRoom_gameId_fkey" FOREIGN KEY ("gameId") REFERENCES "games"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "wallet_ledgers" ADD CONSTRAINT "wallet_ledgers_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "escrows" ADD CONSTRAINT "escrows_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "withdrawals" ADD CONSTRAINT "withdrawals_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "wallets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_reports" ADD CONSTRAINT "post_reports_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "post_reports" ADD CONSTRAINT "post_reports_postId_fkey" FOREIGN KEY ("postId") REFERENCES "posts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "status_reactions" ADD CONSTRAINT "status_reactions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeviceToken" ADD CONSTRAINT "DeviceToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NotificationPreference" ADD CONSTRAINT "NotificationPreference_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "support_ticket_records" ADD CONSTRAINT "support_ticket_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "support_tickets_main" ADD CONSTRAINT "support_tickets_main_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_messages" ADD CONSTRAINT "ticket_messages_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "support_tickets_main"("id") ON DELETE CASCADE ON UPDATE CASCADE;
