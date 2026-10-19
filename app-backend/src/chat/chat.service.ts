import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StorageService } from '../storage/storage.service';
import { MessageType, ConversationType } from '@prisma/client';

@Injectable()
export class ChatService {
  constructor(
    private prisma: PrismaService,
    private storageService: StorageService,
  ) {}

  // 1. Create a Conversation (Direct or Group)
  async createConversation(userId: string, memberIds: string[], type: ConversationType = ConversationType.DIRECT) {
    // Ensure the creator is included in members
    const allMembers = Array.from(new Set([userId, ...memberIds]));

    if (type === ConversationType.DIRECT && allMembers.length !== 2) {
      throw new ForbiddenException('Direct conversations must have exactly 2 participants');
    }

    // For direct chats, check if a conversation between these two already exists
    if (type === ConversationType.DIRECT) {
      const existing = await this.prisma.conversation.findFirst({
        where: {
          type: ConversationType.DIRECT,
          AND: allMembers.map((id) => ({
            members: { some: { userId: id } },
          })),
        },
        include: { members: { include: { user: { select: { id: true, name: true, avatar: true } } } } },
      });

      if (existing) return existing;
    }

    return this.prisma.conversation.create({
      data: {
        type,
        members: {
          create: allMembers.map((id) => ({ userId: id })),
        },
      },
      include: {
        members: { include: { user: { select: { id: true, name: true, avatar: true } } } },
      },
    });
  }

  // 2. Get All Conversations for User
  async getUserConversations(userId: string) {
    return this.prisma.conversation.findMany({
      where: {
        members: { some: { userId } },
      },
      include: {
        members: { include: { user: { select: { id: true, name: true, avatar: true } } } },
        messages: {
          orderBy: { createdAt: 'desc' },
          take: 1, // Get last message for chat preview
          include: { sender: { select: { id: true, name: true } } },
        },
      },
      orderBy: { updatedAt: 'desc' },
    });
  }

  // 3. Add Participant (For Group Chats)
  async addParticipant(conversationId: string, userId: string, requesterId: string) {
    const convo = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
      include: { members: true },
    });

    if (!convo || convo.type !== ConversationType.GROUP) {
      throw new NotFoundException('Group conversation not found');
    }

    const isMember = convo.members.some((m) => m.userId === requesterId);
    if (!isMember) throw new ForbiddenException('Unauthorized to add participants');

    return this.prisma.conversationMember.create({
      data: { conversationId, userId },
    });
  }

  // 4. Remove Participant
  async removeParticipant(conversationId: string, userIdToRemove: string, requesterId: string) {
    const membership = await this.prisma.conversationMember.findUnique({
      where: { conversationId_userId: { conversationId, userId: userIdToRemove } },
    });

    if (!membership) throw new NotFoundException('Participant not found in conversation');

    if (userIdToRemove !== requesterId) {
      // If removing someone else, ensure requester is part of the group
      const requesterMembership = await this.prisma.conversationMember.findUnique({
        where: { conversationId_userId: { conversationId, userId: requesterId } },
      });
      if (!requesterMembership) throw new ForbiddenException('Unauthorized');
    }

    return this.prisma.conversationMember.delete({
      where: { conversationId_userId: { conversationId, userId: userIdToRemove } },
    });
  }

  // 5. Send Message (with optional files/attachments)
  async sendMessage(
    senderId: string,
    conversationId: string,
    content?: string,
    files?: any[],
    type: MessageType = MessageType.TEXT,
  ) {
    // Verify user is part of conversation
    const membership = await this.prisma.conversationMember.findUnique({
      where: { conversationId_userId: { conversationId, userId: senderId } },
    });

    if (!membership) throw new ForbiddenException('You are not a member of this conversation');

    let messageType = type;
    const attachmentData: { fileUrl: string; fileType: string }[] = [];

    // Handle file uploads using your StorageService if files are attached
    if (files && files.length > 0) {
      for (const file of files) {
        const category = file.mimetype.startsWith('video')
          ? 'video'
          : file.mimetype.startsWith('audio')
          ? 'audio'
          : 'image';

        const url = await this.storageService.uploadFile(file, 'chats', category, 25);
        attachmentData.push({
          fileUrl: url,
          fileType: category.toUpperCase(),
        });
      }
      messageType = attachmentData[0].fileType === 'VIDEO' ? MessageType.VIDEO : MessageType.IMAGE;
    }

    // Create the message and update conversation timestamp
    const message = await this.prisma.message.create({
      data: {
        conversationId,
        senderId,
        content,
        type: messageType,
        attachments: {
          create: attachmentData,
        },
      },
      include: {
        sender: { select: { id: true, name: true, avatar: true } },
        attachments: true,
        reactions: true,
        reads: true,
      },
    });

    // Touch conversation updated time
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: { updatedAt: new Date() },
    });

    return message;
  }

  // 6. Get Message History (with pagination)
  async getMessages(conversationId: string, userId: string, skip = 0, take = 50) {
    const membership = await this.prisma.conversationMember.findUnique({
      where: { conversationId_userId: { conversationId, userId } },
    });
    if (!membership) throw new ForbiddenException('Unauthorized');

    return this.prisma.message.findMany({
      where: { conversationId },
      include: {
        sender: { select: { id: true, name: true, avatar: true } },
        attachments: true,
        reactions: { include: { user: { select: { id: true, name: true } } } },
        reads: true,
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take,
    });
  }

  // 7. Mark Message as Read
  async markAsRead(messageId: string, userId: string) {
    return this.prisma.messageRead.upsert({
      where: { messageId_userId: { messageId, userId } },
      update: { readAt: new Date() },
      create: { messageId, userId },
    });
  }

  // 8. Add Reaction
  async addReaction(messageId: string, userId: string, emoji: string) {
    const existing = await this.prisma.messageReaction.findFirst({
      where: { messageId, userId },
    });

    if (existing) {
      return this.prisma.messageReaction.update({
        where: { id: existing.id },
        data: { emoji },
      });
    }

    return this.prisma.messageReaction.create({
      data: { messageId, userId, emoji },
    });
  }

  // 9. Delete Message
  async deleteMessage(messageId: string, userId: string) {
    const message = await this.prisma.message.findUnique({
      where: { id: messageId },
      include: { attachments: true },
    });

    if (!message || message.senderId !== userId) {
      throw new NotFoundException('Message not found or unauthorized');
    }

    // Clean up file storage if attachments exist
    for (const att of message.attachments) {
      await this.storageService.deleteFile(att.fileUrl);
    }

    return this.prisma.message.delete({ where: { id: messageId } });
  }
}