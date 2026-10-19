import { Socket } from 'socket.io';
import { WsException } from '@nestjs/websockets';

export type SocketWithAuth = Socket & {
  userId?: string;
};

export const WSAuthMiddleware = () => {
  return (client: SocketWithAuth, next: (err?: Error) => void) => {
    try {
      // Extract userId or token from handshake auth or query parameters
      const userId = client.handshake.auth?.userId || client.handshake.query?.userId;

      if (!userId) {
        return next(new WsException('Unauthorized connection: Missing user ID'));
      }

      client.userId = userId; 
      client.join(userId);
      next();
    } catch (error) {
      next(new WsException('Unauthorized connection'));
    }
  };
};