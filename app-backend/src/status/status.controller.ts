import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Req,
  UseInterceptors,
  UploadedFiles,
} from '@nestjs/common';
import { FilesInterceptor } from '@nestjs/platform-express';
import { StatusService } from './status.service';

@Controller('statuses')
export class StatusController {
  constructor(private readonly statusService: StatusService) {}

  // 1. Create Status with Multiple Media Files
  @Post()
  @UseInterceptors(FilesInterceptor('files', 10)) // Allow up to 10 files at once
  async createStatus(
    @Req() req: any,
    @UploadedFiles() files: any[],
    @Body('caption') caption?: string,
  ) {
    const userId = req.user?.id; // Assumes auth guard populates req.user
    return this.statusService.createStatus(userId, files, caption);
  }

  // 2. Get Active Statuses (With viewed/unviewed state)
  @Get()
  async getActiveStatuses(@Req() req: any) {
    const currentUserId = req.user?.id;
    return this.statusService.getActiveStatuses(currentUserId);
  }

  // 3. Record a Status View
  @Post(':id/view')
  async recordView(@Param('id') statusId: string, @Req() req: any) {
    const userId = req.user?.id;
    return this.statusService.recordView(statusId, userId);
  }

  // 4. Add or Update a Reaction
  @Post(':id/react')
  async addReaction(
    @Param('id') statusId: string,
    @Body('emoji') emoji: string,
    @Req() req: any,
  ) {
    const userId = req.user?.id;
    return this.statusService.addReaction(statusId, userId, emoji);
  }

  // 5. Reply to a Status
  @Post(':id/reply')
  async addReply(
    @Param('id') statusId: string,
    @Body('message') message: string,
    @Req() req: any,
  ) {
    const userId = req.user?.id;
    return this.statusService.addReply(statusId, userId, message);
  }

  // 6. Delete a Status
  @Delete(':id')
  async deleteStatus(@Param('id') statusId: string, @Req() req: any) {
    const userId = req.user?.id;
    return this.statusService.deleteStatus(statusId, userId);
  }
}