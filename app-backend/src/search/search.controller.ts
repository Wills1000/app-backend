import { Controller, Get, Delete, Query, Req, UseGuards } from '@nestjs/common';
import { SearchService } from './search.service';
// Assuming you have an authentication guard for your HTTP routes
// import { JwtAuthGuard } from '../auth/jwt-auth.guard'; 

@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Get()
  async globalSearch(@Query('q') query: string, @Req() req: any) {
    const userId = req.user?.id; // Extracted from HTTP auth guard if available
    return this.searchService.searchAll(query, userId);
  }

  @Get('players')
  async searchPlayers(
    @Query('q') query: string,
    @Query('page') page = '1',
    @Query('limit') limit = '10',
  ) {
    return this.searchService.searchPlayers(query, Number(page), Number(limit));
  }

  @Get('games')
  async searchGames(
    @Query('q') query: string,
    @Query('page') page = '1',
    @Query('limit') limit = '10',
  ) {
    return this.searchService.searchGames(query, Number(page), Number(limit));
  }

  @Get('history')
  // @UseGuards(JwtAuthGuard)
  async getHistory(@Req() req: any) {
    const userId = req.user?.id;
    return this.searchService.getSearchHistory(userId);
  }

  @Delete('history')
  // @UseGuards(JwtAuthGuard)
  async clearHistory(@Req() req: any) {
    const userId = req.user?.id;
    return this.searchService.clearSearchHistory(userId);
  }
}