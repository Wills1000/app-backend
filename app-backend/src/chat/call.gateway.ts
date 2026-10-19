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
import { PrismaService } from '../prisma/prisma.service'; // Adjust path to your PrismaService
import { CallType, CallStatus } from '@prisma/client';

@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class CallGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(private prisma: PrismaService) {}

  handleConnection(client: Socket) {
    // Global middleware already attaches userId, but we can track active socket mappings if needed
  }

  handleDisconnect(client: Socket) {
    // Optional: Handle cleanup if a user drops mid-call
  }

  // 1. Initiate a Call (Outgoing / Incoming notification)
  @SubscribeMessage('call:initiate')
  async handleInitiateCall(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { receiverId: string; type: CallType },
  ) {
    const callerId = (client as any).userId;
    if (!callerId) return { success: false, message: 'Unauthorized' };

    try {
      // Create Call record in DB
      const call = await this.prisma.call.create({
        data: {
          callerId,
          type: data.type,
          status: CallStatus.INITIATED,
          participants: {
            create: [
              { userId: callerId },
              { userId: data.receiverId },
            ],
          },
        },
        include: { participants: true },
      });

      // Notify the receiver via their user room or socket id
      this.server.to(data.receiverId).emit('call:incoming', {
        callId: call.id,
        callerId,
        type: data.type,
      });

      return { success: true, callId: call.id };
    } catch (error) {
      return { success: false, message: 'Failed to initiate call' };
    }
  }

  // 2. Accept Call
  @SubscribeMessage('call:accept')
  async handleAcceptCall(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { callId: string },
  ) {
    const userId = (client as any).userId;

    const call = await this.prisma.call.update({
      where: { id: data.callId },
      data: {
        status: CallStatus.ONGOING,
        startedAt: new Date(),
      },
    });

    // Notify caller that call was accepted
    this.server.to(call.callerId).emit('call:accepted', { callId: data.callId, acceptorId: userId });

    return { success: true };
  }

  // 3. Reject Call
  @SubscribeMessage('call:reject')
  async handleRejectCall(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { callId: string },
  ) {
    const call = await this.prisma.call.update({
      where: { id: data.callId },
      data: {
        status: CallStatus.REJECTED,
        endedAt: new Date(),
      },
    });

    this.server.to(call.callerId).emit('call:rejected', { callId: data.callId });

    return { success: true };
  }

  // 4. End Call
  @SubscribeMessage('call:end')
  async handleEndCall(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { callId: string },
  ) {
    const call = await this.prisma.call.update({
      where: { id: data.callId },
      data: {
        status: CallStatus.ENDED,
        endedAt: new Date(),
      },
      include: { participants: true },
    });

    // Notify all participants in the call to terminate WebRTC connection
    call.participants.forEach((p) => {
      this.server.to(p.userId).emit('call:ended', { callId: data.callId });
    });

    return { success: true };
  }

  // --- WebRTC Signaling Relays ---

  @SubscribeMessage('call:offer')
  handleWebRtcOffer(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { targetUserId: string; offer: any },
  ) {
    const senderId = (client as any).userId;
    this.server.to(data.targetUserId).emit('call:offer', {
      senderId,
      offer: data.offer,
    });
  }

  @SubscribeMessage('call:answer')
  handleWebRtcAnswer(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { targetUserId: string; answer: any },
  ) {
    const senderId = (client as any).userId;
    this.server.to(data.targetUserId).emit('call:answer', {
      senderId,
      answer: data.answer,
    });
  }

  @SubscribeMessage('call:ice-candidate')
  handleIceCandidate(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { targetUserId: string; candidate: any },
  ) {
    const senderId = (client as any).userId;
    this.server.to(data.targetUserId).emit('call:ice-candidate', {
      senderId,
      candidate: data.candidate,
    });
  }
}