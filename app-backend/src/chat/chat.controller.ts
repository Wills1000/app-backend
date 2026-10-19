import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Query,
  Req,
  UseInterceptors,
  UploadedFiles,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { ChatService } from './chat.service';
import { ConversationType, MessageType } from '@prisma/client';

@Controller('chats')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  // 1. Create Conversation
  @Post('conversations')
  async createConversation(
    @Req() req: any,
    @Body('memberIds') memberIds: string[],
    @Body('type') type: ConversationType,
  ) {
    const userId = req.user?.id;
    return this.chatService.createConversation(userId, memberIds, type);
  }

  // 2. Get User Conversations
  @Get('conversations')
  async getUserConversations(@Req() req: any) {
    const userId = req.user?.id;
    return this.chatService.getUserConversations(userId);
  }

  // 3. Add Participant to Group Chat
  @Post('conversations/:id/participants')
  async addParticipant(
    @Param('id') conversationId: string,
    @Body('userId') userIdToAdd: string,
    @Req() req: any,
  ) {
    const requesterId = req.user?.id;
    return this.chatService.addParticipant(conversationId, userIdToAdd, requesterId);
  }

  // 4. Remove Participant from Group Chat
  @Delete('conversations/:id/participants/:userId')
  async removeParticipant(
    @Param('id') conversationId: string,
    @Param('userId') userIdToRemove: string,
    @Req() req: any,
  ) {
    const requesterId = req.user?.id;
    return this.chatService.removeParticipant(conversationId, userIdToRemove, requesterId);
  }

  // 5. Send Message (with optional media attachments)
  @Post('conversations/:id/messages')
  @UseInterceptors(FilesInterceptor('files', 5))
  async sendMessage(
    @Param('id') conversationId: string,
    @Req() req: any,
    @UploadedFiles() files?: any[],
    @Body('content') content?: string,
    @Body('type') type?: MessageType,
  ) {
    const senderId = req.user?.id;
    return this.chatService.sendMessage(senderId, conversationId, content, files, type);
  }

  // 6. Get Message History (with pagination)
  @Get('conversations/:id/messages')
  async getMessages(
    @Param('id') conversationId: string,
    @Req() req: any,
    @Query('skip') skip?: string,
    @Query('take') take?: string,
  ) {
    const userId = req.user?.id;
    return this.chatService.getMessages(
      conversationId,
      userId,
      skip ? parseInt(skip, 10) : 0,
      take ? parseInt(take, 10) : 50,
    );
  }

  // 7. Mark Message as Read
  @Post('messages/:id/read')
  async markAsRead(@Param('id') messageId: string, @Req() req: any) {
    const userId = req.user?.id;
    return this.chatService.markAsRead(messageId, userId);
  }

  // 8. Add Reaction to Message
  @Post('messages/:id/react')
  async addReaction(
    @Param('id') messageId: string,
    @Body('emoji') emoji: string,
    @Req() req: any,
  ) {
    const userId = req.user?.id;
    return this.chatService.addReaction(messageId, userId, emoji);
  }

  // 9. Delete Message
  @Delete('messages/:id')
  async deleteMessage(@Param('id') messageId: string, @Req() req: any) {
    const userId = req.user?.id;
    return this.chatService.deleteMessage(messageId, userId);
  }
}