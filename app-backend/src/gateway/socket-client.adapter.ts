import { IoAdapter } from '@nestjs/platform-socket.io';
import { WSAuthMiddleware } from './ws-auth.middleware';

export class SocketClientAdapter extends IoAdapter {
  createIOServer(port: number, options?: any): any {
    const server = super.createIOServer(port, options);
    
    // Apply the authentication middleware safely
    (server as any).use(WSAuthMiddleware());
    
    return server;
  }
}