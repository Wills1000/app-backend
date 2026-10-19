import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/wallet_model.dart';
import '/../core/providers/api_provider.dart';

final walletProvider =
    NotifierProvider<WalletNotifier, WalletModel>(WalletNotifier.new);

class WalletNotifier extends Notifier<WalletModel> {
  @override
  WalletModel build() {
    // Initial placeholder while fetching live data from the backend
    fetchWalletBalance();
    return const WalletModel(
      availableBalance: 0,
      lockedBalance: 0,
    );
  }

  /// Fetches real wallet balance and locked stake amounts from the backend
  Future<void> fetchWalletBalance() async {
    try {
      final dioClient = ref.read(dioClientProvider);
      final response = await dioClient.dio.get('wallet/balance');
      
      state = WalletModel(
        availableBalance: (response.data['availableBalance'] as num).toDouble(),
        lockedBalance: (response.data['lockedBalance'] as num).toDouble(),
      );
    } catch (e) {
      // Retain current state or handle error gracefully if offline
    }
  }

  /// Locks money on the backend when a challenge is accepted.
  Future<bool> lockFunds(double amount, String challengeId) async {
    if (amount <= 0) return false;
    if (state.availableBalance < amount) return false;

    try {
      final dioClient = ref.read(dioClientProvider);
      await dioClient.dio.post('wallet/lock', data: {
        'amount': amount,
        'challengeId': challengeId,
      });

      state = state.copyWith(
        availableBalance: state.availableBalance - amount,
        lockedBalance: state.lockedBalance + amount,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Releases escrow money to the winner via backend synchronization.
  Future<void> releaseFunds(double amount, String challengeId) async {
    if (amount <= 0) return;

    final amountToRelease =
        amount > state.lockedBalance ? state.lockedBalance : amount;

    try {
      final dioClient = ref.read(dioClientProvider);
      await dioClient.dio.post('wallet/release', data: {
        'amount': amountToRelease,
        'challengeId': challengeId,
      });

      state = state.copyWith(
        lockedBalance: state.lockedBalance - amountToRelease,
        availableBalance: state.availableBalance + amountToRelease,
      );
    } catch (e) {
      // Handle error sync
    }
  }

  /// Returns locked money to the player.
  Future<void> refundFunds(double amount, String challengeId) async {
    await releaseFunds(amount, challengeId);
  }

  /// Adds money to the available wallet balance (e.g., after deposit verification).
  Future<void> addFunds(double amount) async {
    if (amount <= 0) return;

    try {
      final dioClient = ref.read(dioClientProvider);
      await dioClient.dio.post('wallet/deposit', data: {'amount': amount});

      state = state.copyWith(
        availableBalance: state.availableBalance + amount,
      );
    } catch (e) {
      // Handle error sync
    }
  }

  /// Removes available money from the wallet (e.g., withdrawal request).
  Future<bool> deductFunds(double amount) async {
    if (amount <= 0) return false;
    if (state.availableBalance < amount) return false;

    try {
      final dioClient = ref.read(dioClientProvider);
      await dioClient.dio.post('wallet/withdraw', data: {'amount': amount});

      state = state.copyWith(
        availableBalance: state.availableBalance - amount,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}