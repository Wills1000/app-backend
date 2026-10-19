import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../models/transaction_model.dart';
import '../widgets/empty_transaction.dart';
import '../widgets/transaction_search_bar.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_details_screen.dart';

class SearchTransactionsScreen extends StatefulWidget {
  static const String routeName = '/search-transactions';

  final List<TransactionModel> allTransactions;

  const SearchTransactionsScreen({
    super.key,
    required this.allTransactions,
  });

  @override
  State<SearchTransactionsScreen> createState() => _SearchTransactionsScreenState();
}

class _SearchTransactionsScreenState extends State<SearchTransactionsScreen> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TransactionModel> get _searchResults {
    if (_query.trim().isEmpty) return [];

    final q = _query.toLowerCase().trim();
    return widget.allTransactions.where((t) {
      final matchesTitle = t.title.toLowerCase().contains(q);
      final matchesSubtitle = t.subtitle.toLowerCase().contains(q);
      final matchesId = t.id.toLowerCase().contains(q);
      final matchesOpponent = t.opponentName?.toLowerCase().contains(q) ?? false;

      return matchesTitle || matchesSubtitle || matchesId || matchesOpponent;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _searchResults;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TransactionSearchBar(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val),
            onClear: () {
              _searchController.clear();
              setState(() => _query = '');
            },
          ),
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: _query.trim().isEmpty
                ? const EmptyTransaction(message: 'Type to search transactions by title, ID, or opponent')
                : results.isEmpty
                    ? EmptyTransaction(message: 'No transactions matching "$_query"')
                    : Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF121215),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: results.length,
                          separatorBuilder: (_, __) => Divider(
                            color: Colors.white.withOpacity(0.05),
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = results[index];
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
      ),
    );
  }
}