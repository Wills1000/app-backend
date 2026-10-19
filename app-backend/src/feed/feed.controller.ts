import { 
  Controller, 
  Get, 
  Post, 
  Delete, 
  Param, 
  Body, 
  Query, 
  UseGuards, 
  Req 
} from '@nestjs/common';
import { FeedService } from './feed.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard'; // Assumes you have standard JWT protection

@Controller('feed')
@UseGuards(JwtAuthGuard) // Protects all feed routes so users must be logged in
export class FeedController {
  constructor(private readonly feedService: FeedService) {}

  // 1. Create a Post
  // POST /feed
  @Post()
  async createPost(@Req() req: any, @Body() body: { content?: string; mediaUrl?: string; mediaType?: string; thumbnailUrl?: string; privacy?: 'PUBLIC' | 'FOLLOWERS_ONLY' | 'PRIVATE' }) {
    const userId = req.user.userId; // Extracted safely from the logged-in user's token
    return this.feedService.createPost(userId, body);
  }

  // 2. Get Paginated Feed
  // GET /feed?page=1&limit=10
  @Get()
  async getFeed(@Req() req: any, @Query('page') page?: string, @Query('limit') limit?: string) {
    const userId = req.user.userId;
    return this.feedService.getFeed(
      userId, 
      page ? parseInt(page) : 1, 
      limit ? parseInt(limit) : 10
    );
  }

  // 3. Edit a Post
  // PATCH /feed/:id
  @Post(':id/edit') // Or @Patch if you prefer patch
  async editPost(@Req() req: any, @Param('id') id: string, @Body() body: { content?: string }) {
    const userId = req.user.userId;
    return this.feedService.editPost(userId, id, body);
  }

  // 4. Delete a Post
  // DELETE /feed/:id
  @Delete(':id')
  async deletePost(@Req() req: any, @Param('id') id: string) {
    const userId = req.user.userId;
    return this.feedService.deletePost(userId, id);
  }

  // 5. Add Comment to Post
  // POST /feed/:id/comments
  @Post(':id/comments')
  async addComment(@Req() req: any, @Param('id') id: string, @Body() body: { content: string }) {
    const userId = req.user.userId;
    return this.feedService.addComment(userId, id, body.content);
  }

  // 6. Delete Comment
  // DELETE /feed/comments/:commentId
  @Delete('comments/:commentId')
  async deleteComment(@Req() req: any, @Param('commentId') commentId: string) {
    const userId = req.user.userId;
    return this.feedService.deleteComment(userId, commentId);
  }
}