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

@WebSocketGateway({
  cors: { origin: '*' },
})
export class MatchGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private onlineUsers = new Map<string, string>(); // userId -> socketId

  handleConnection(client: Socket) {
    const userId = (client as any).userId || client.handshake.auth?.userId || client.handshake.query?.userId;
    if (userId) {
      (client as any).userId = userId;
      this.onlineUsers.set(userId, client.id);
      this.server.emit('online_presence', { userId, status: 'ONLINE' });
    }
  }

  handleDisconnect(client: Socket) {
    const userId = (client as any).userId;
    if (userId) {
      this.onlineUsers.delete(userId);
      this.server.emit('offline_presence', { userId, status: 'OFFLINE' });
    }
  }

  @SubscribeMessage('send_challenge')
  handleSendChallenge(
    @MessageBody() data: { opponentId: string; gameTitle: string; stake: number },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    const opponentSocketId = this.onlineUsers.get(data.opponentId);
    if (opponentSocketId) {
      this.server.to(opponentSocketId).emit('receive_challenge', {
        challengerId: userId,
        ...data,
      });
    } else {
      client.emit('error', { message: 'Opponent is offline' });
    }
  }

  @SubscribeMessage('accept_challenge')
  handleAcceptChallenge(
    @MessageBody() data: { challengerId: string; matchId: string },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    const challengerSocketId = this.onlineUsers.get(data.challengerId);
    if (challengerSocketId) {
      this.server.to(challengerSocketId).emit('challenge_accepted', {
        acceptedBy: userId,
        matchId: data.matchId,
      });
    }
  }

  @SubscribeMessage('join_waiting_room')
  handleJoinWaitingRoom(
    @MessageBody() data: { matchId: string },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    client.join(`match_${data.matchId}`);
    this.server.to(`match_${data.matchId}`).emit('waiting_room_update', {
      userId,
      status: 'JOINED',
    });
  }

  @SubscribeMessage('player_ready')
  handlePlayerReady(
    @MessageBody() data: { matchId: string },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    this.server.to(`match_${data.matchId}`).emit('player_ready_event', {
      userId,
      ready: true,
    });
  }

  @SubscribeMessage('start_match')
  handleStartMatch(@MessageBody() data: { matchId: string }) {
    this.server.to(`match_${data.matchId}`).emit('match_started', {
      matchId: data.matchId,
      timestamp: new Date(),
    });
  }

  @SubscribeMessage('submit_result')
  handleSumitResult(
    @MessageBody() data: { matchId: string; winnerId: string; proofUrl?: string },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    this.server.to(`match_${data.matchId}`).emit('result_submitted', {
      submittedBy: userId,
      ...data,
    });
  }

  @SubscribeMessage('raise_dispute')
  handleRaiseDispute(
    @MessageBody() data: { matchId: string; reason: string },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    this.server.to(`match_${data.matchId}`).emit('dispute_raised', {
      disputedBy: userId,
      reason: data.reason,
    });
  }

  @SubscribeMessage('send_notification')
  handleSendNotification(@MessageBody() data: { recipientId: string; notification: any }) {
    const socketId = this.onlineUsers.get(data.recipientId);
    if (socketId) {
      this.server.to(socketId).emit('notification_event', data.notification);
    }
  }

  @SubscribeMessage('call_signal')
  handleCallSignal(
    @MessageBody() data: { recipientId: string; signalData: any },
    @ConnectedSocket() client: Socket,
  ) {
    const userId = (client as any).userId;
    const socketId = this.onlineUsers.get(data.recipientId);
    if (socketId) {
      this.server.to(socketId).emit('call_signaling_event', {
        senderId: userId,
        signalData: data.signalData,
      });
    }
  }
}