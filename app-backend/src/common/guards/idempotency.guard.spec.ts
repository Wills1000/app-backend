import { ExecutionContext, ConflictException } from '@nestjs/common';
import { IdempotencyGuard } from './idempotency.guard'; // Adjust path to your guard location

describe('IdempotencyGuard', () => {
  let guard: IdempotencyGuard;
  let cacheManagerMock: any;

  beforeEach(() => {
    cacheManagerMock = {
      get: jest.fn(),
      set: jest.fn(),
    };
    guard = new IdempotencyGuard(cacheManagerMock);
  });

  it('should allow a request if the idempotency key is new', async () => {
    cacheManagerMock.get.mockResolvedValue(null);

    const mockContext = {
      switchToHttp: () => ({
        getRequest: () => ({
          headers: { 'x-idempotency-key': 'test-key-123' },
          method: 'POST',
        }),
      }),
    } as unknown as ExecutionContext;

    const result = await guard.canActivate(mockContext);
    expect(result).toBe(true);
  });

  it('should block and throw ConflictException if the idempotency key already exists', async () => {
    cacheManagerMock.get.mockResolvedValue('processed');

    const mockContext = {
      switchToHttp: () => ({
        getRequest: () => ({
          headers: { 'x-idempotency-key': 'test-key-123' },
          method: 'POST',
        }),
      }),
    } as unknown as ExecutionContext;

    await expect(guard.canActivate(mockContext)).rejects.toThrow(ConflictException);
  });
});