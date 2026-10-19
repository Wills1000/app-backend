import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../models/transaction_model.dart';
import '../widgets/transaction_filter_bar.dart';
import '../widgets/transaction_tile.dart';
import 'search_transactions_screen.dart';
import 'transaction_details_screen.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static const String routeName = '/transaction-history';

  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Deposits',
    'Matches',
    'Payouts',
    'Rewards',
  ];

  final List<TransactionModel> _allTransactions = const [
    TransactionModel(
      id: 'TXN-20250519-1024-1102',
      title: 'Deposit Successful',
      subtitle: 'via OPay',
      timestamp: 'May 19, 2025 • 10:24 AM',
      coins: 500,
      type: TransactionType.deposit,
    ),
    TransactionModel(
      id: 'TXN-20250519-0915-7852',
      title: '1v1 Match Won',
      subtitle: 'vs JohnDoe',
      timestamp: 'May 19, 2025 • 09:15 AM',
      coins: 90,
      type: TransactionType.matchWon,
      opponentName: 'JohnDoe',
      matchType: '1v1 Challenge',
    ),
    TransactionModel(
      id: 'TXN-20250519-0910-4491',
      title: 'Match Entry',
      subtitle: 'vs JohnDoe',
      timestamp: 'May 19, 2025 • 09:10 AM',
      coins: -50,
      type: TransactionType.matchEntry,
      opponentName: 'JohnDoe',
      matchType: '1v1 Challenge',
    ),
    TransactionModel(
      id: 'TXN-20250518-1635-3091',
      title: 'Withdrawal',
      subtitle: 'To GTBank **** 1234',
      timestamp: 'May 18, 2025 • 04:35 PM',
      coins: -300,
      type: TransactionType.withdrawal,
    ),
    TransactionModel(
      id: 'TXN-20250518-1322-8820',
      title: 'Referral Bonus',
      subtitle: 'Invite Reward',
      timestamp: 'May 18, 2025 • 01:22 PM',
      coins: 50,
      type: TransactionType.referralBonus,
    ),
    TransactionModel(
      id: 'TXN-20250517-2010-9012',
      title: 'Tournament Prize',
      subtitle: 'Weekly Cup',
      timestamp: 'May 17, 2025 • 08:10 PM',
      coins: 200,
      type: TransactionType.tournamentPrize,
    ),
  ];

  List<TransactionModel> get _filteredTransactions {
    if (_selectedCategory == 'All') return _allTransactions;
    if (_selectedCategory == 'Deposits') {
      return _allTransactions.where((t) => t.type == TransactionType.deposit).toList();
    }
    if (_selectedCategory == 'Matches') {
      return _allTransactions
          .where((t) => t.type == TransactionType.matchWon || t.type == TransactionType.matchEntry)
          .toList();
    }
    if (_selectedCategory == 'Payouts' || _selectedCategory == 'Withdrawals') {
      return _allTransactions.where((t) => t.type == TransactionType.withdrawal).toList();
    }
    if (_selectedCategory == 'Rewards') {
      return _allTransactions
          .where((t) => t.type == TransactionType.referralBonus || t.type == TransactionType.tournamentPrize)
          .toList();
    }
    return _allTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 6, 3, 4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SearchTransactionsScreen(
                    allTransactions: _allTransactions,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),

              TransactionFilterBar(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onSelected: (cat) => setState(() => _selectedCategory = cat),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF121215),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredTransactions.length,
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.white.withOpacity(0.05),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final item = _filteredTransactions[index];
                        return TransactionTile(
                          transaction: item,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TransactionDetailsScreen(transaction: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}