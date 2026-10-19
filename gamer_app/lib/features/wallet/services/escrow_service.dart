import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/providers/wallet_provider.dart';

class EscrowService {
  final Ref ref;

  EscrowService(this.ref);

  /// Locks the player's stake when they accept a challenge.
  Future<bool> lockStake({
    required String challengeId,
    required double amount,
  }) async {
    if (amount <= 0) {
      return false;
    }

    final wallet = ref.read(walletProvider.notifier);

    // Await the async backend call and pass the challengeId
    final success = await wallet.lockFunds(amount, challengeId);

    if (!success) {
      return false;
    }

    return true;
  }

  /// Releases escrow money to the winner.
  Future<void> releaseStake({
    required String challengeId,
    required double amount,
  }) async {
    if (amount <= 0) return;
    
    final wallet = ref.read(walletProvider.notifier);
    await wallet.releaseFunds(amount, challengeId);
  }

  /// Returns the player's locked stake if the challenge is rejected or refunded.
  Future<void> refundStake({
    required String challengeId,
    required double amount,
  }) async {
    if (amount <= 0) return;

    final wallet = ref.read(walletProvider.notifier);
    await wallet.refundFunds(amount, challengeId);
  }
}