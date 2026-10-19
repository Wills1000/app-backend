import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../../deposit/presentation/pages/deposit_screen.dart';
import '../../../notifications/presentation/pages/notification_screen.dart';
import '../../../support/presentation/pages/support_screen.dart';
import '../../../transactions/presentation/pages/transaction_history_screen.dart';
import '../../../withdraw/presentation/pages/withdraw_screen.dart';
import '../../../escrow/presentation/pages/escrow_status_screen.dart';
import '../widgets/balance_card.dart';
import '../widgets/coin_breakdown_card.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/wallet_action_button.dart';
import '../widgets/wallet_header.dart';
import '../pages/coin_rate_screen.dart';

class WalletScreen extends StatelessWidget {
  static const String routeName = '/wallet';

  const WalletScreen({super.key});

  static const Color accentRed = Color(0xFFFF2233);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: WalletHeader(
        onBackPressed: () => Navigator.pop(context),
        onSupportPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SupportScreen(),
            ),
          );
        },
        onHistoryPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NotificationScreen(),
            ),
          );
        },
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Hero Balance Card
                BalanceCard(
                  totalBalance: 1250,
                  totalNaira: 18750.00,
                  availableBalance: 950,
                  availableNaira: 14250.00,
                  lockedBalance: 250,
                  lockedNaira: 3750.00,
                  pendingBalance: 50,
                  pendingNaira: 750.00,
                  onCoinRateTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CoinRateScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Quick Actions Row (Deposit, Withdraw, Transfer)
                Row(
                  children: [
                    WalletActionButton(
                      icon: Icons.add,
                      title: 'Deposit',
                      subtitle: 'Add Coins',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DepositScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    WalletActionButton(
                      icon: Icons.north_east_rounded,
                      title: 'Withdraw',
                      subtitle: 'Cash Out',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WithdrawScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    WalletActionButton(
                      icon: Icons.swap_horiz_rounded,
                      title: 'Escrow',
                      subtitle: 'Stake Coins',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EscrowStatusScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Coins Breakdown Card
                const CoinBreakdownCard(
                  cashCoins: 1050,
                  bonusCoins: 200,
                ),
                const SizedBox(height: 16),

                // Recent Transactions Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121215),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECENT TRANSACTIONS',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TransactionHistoryScreen(),
                                ),
                              );
                            },
                            child: const Row(
                              children: [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: accentRed,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: accentRed,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Transactions List
                      TransactionTile(
                        title: 'Deposit Successful',
                        subtitle: 'via Opay',
                        dateText: 'May 19, 2025 • 10:24 AM',
                        coinAmount: 500,
                        isPositive: true,
                        status: TransactionStatus.completed,
                        icon: Icons.arrow_downward_rounded,
                      ),
                      Divider(color: Colors.white.withOpacity(0.05), height: 1),
                      const TransactionTile(
                        title: '1v1 Match – Won',
                        subtitle: 'vs JohnDoe',
                        dateText: 'May 19, 2025 • 09:15 AM',
                        coinAmount: 90,
                        isPositive: true,
                        status: TransactionStatus.completed,
                        icon: Icons.sports_esports_outlined,
                      ),
                      Divider(color: Colors.white.withOpacity(0.05), height: 1),
                      const TransactionTile(
                        title: 'Match Entry',
                        subtitle: 'vs JohnDoe',
                        dateText: 'May 19, 2025 • 09:10 AM',
                        coinAmount: -50,
                        isPositive: false,
                        status: TransactionStatus.locked,
                        icon: Icons.lock_outline_rounded,
                      ),
                      Divider(color: Colors.white.withOpacity(0.05), height: 1),
                      const TransactionTile(
                        title: 'Withdrawal',
                        subtitle: 'To GTBank • • • • 1234',
                        dateText: 'May 18, 2025 • 04:35 PM',
                        coinAmount: -300,
                        isPositive: false,
                        status: TransactionStatus.completed,
                        icon: Icons.account_balance_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}