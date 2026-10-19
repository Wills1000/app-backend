import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';

@WebSocketGateway({
  cors: {
    origin: '*', // Adjust based on your production frontend URLs if needed
  },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  // Track online users: Map<userId, socketId[]>
  private onlineUsers = new Map<string, Set<string>>();

  constructor(private readonly chatService: ChatService) {}

  handleConnection(client: Socket) {
    const userId = (client.handshake.auth?.userId || client.handshake.query?.userId) as string;
    if (userId) {
      // Safely assign to custom client data object
      (client.data as any).userId = userId;
      
      if (!this.onlineUsers.has(userId)) {
        this.onlineUsers.set(userId, new Set());
      }
      this.onlineUsers.get(userId)?.add(client.id);

      // Broadcast online status
      this.server.emit('user_online', { userId });
    }
  }

  handleDisconnect(client: Socket) {
    const userId = (client.data as any)?.userId;
    if (userId && this.onlineUsers.has(userId)) {
      this.onlineUsers.get(userId)?.delete(client.id);
      if (this.onlineUsers.get(userId)?.size === 0) {
        this.onlineUsers.delete(userId);
        // Broadcast offline status
        this.server.emit('user_offline', { userId });
      }
    }
  }

  // 1. Send Message via Socket & Broadcast to Conversation Participants
  @SubscribeMessage('send_message')
  async handleSendMessage(
    @MessageBody()
    data: {
      conversationId: string;
      content?: string;
      files?: any[];
      type?: any;
    },
    @ConnectedSocket() client: Socket,
  ) {
    const senderId = client.data.userId;
    if (!senderId) return;

    try {
      const message = await this.chatService.sendMessage(
        senderId,
        data.conversationId,
        data.content,
        data.files,
        data.type,
      );

      // Broadcast to everyone in the conversation room
      this.server.to(data.conversationId).emit('receive_message', message);
    } catch (error: any) {
      client.emit('error', { message: error.message });
    }
  }

  // 2. Join Conversation Room
  @SubscribeMessage('join_conversation')
  handleJoinConversation(
    @MessageBody() data: { conversationId: string },
    @ConnectedSocket() client: Socket,
  ) {
    client.join(data.conversationId);
  }

  // 3. Typing Indicator
  @SubscribeMessage('typing')
  handleTyping(
    @MessageBody() data: { conversationId: string; isTyping: boolean },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = client.data.userId;
    client.to(data.conversationId).emit('user_typing', { userId, isTyping: data.isTyping });
  }

  // 4. Check Online Status
  @SubscribeMessage('check_online')
  handleCheckOnline(@MessageBody() data: { userId: string }, @ConnectedSocket() client: Socket) {
    const isOnline = this.onlineUsers.has(data.userId);
    client.emit('online_status_response', { userId: data.userId, isOnline });
  }
}