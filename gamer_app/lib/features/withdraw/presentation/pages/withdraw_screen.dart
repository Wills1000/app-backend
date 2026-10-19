import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../models/bank_account_model.dart';
import '../widgets/amount_input.dart';
import '../widgets/bank_account_tile.dart';
import '../widgets/withdraw_button.dart';
import '../widgets/withdraw_header.dart';
import '../widgets/withdraw_summary_card.dart';

class WithdrawScreen extends StatefulWidget {
  static const String routeName = '/withdraw';

  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final int _availableCoins = 1050;
  final double _ratePerCoin = 15.0; // 100 G = 1500 NGN -> 1 G = 15 NGN

  late TextEditingController _coinsController;

  final BankAccountModel _selectedBank = const BankAccountModel(
    id: '1',
    bankName: 'GTBank',
    accountNumberMasked: '**** 1234',
    accountName: 'John Prince',
  );

  @override
  void initState() {
    super.initState();
    _coinsController = TextEditingController(text: '500');
  }

  @override
  void dispose() {
    _coinsController.dispose();
    super.dispose();
  }

  double get _calculatedNaira {
    final int coins = int.tryParse(_coinsController.text.replaceAll(',', '')) ?? 0;
    return coins * _ratePerCoin;
  }

  void _selectQuickCoins(int amount) {
    setState(() {
      _coinsController.text = amount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        title: const Text(
          'Withdraw',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: Colors.white, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Balance Header Card
                      WithdrawHeader(
                        availableCoins: _availableCoins,
                        ratePerCoin: _ratePerCoin,
                      ),
                      const SizedBox(height: 18),

                      // 2. Coin Input & Quick Action Chips
                      AmountInput(
                        controller: _coinsController,
                        maxCoins: _availableCoins,
                        onChanged: (_) => setState(() {}),
                        onSelectQuickCoins: _selectQuickCoins,
                      ),
                      const SizedBox(height: 16),

                      // 3. Calculated Payout Summary
                      WithdrawSummaryCard(
                        calculatedNaira: _calculatedNaira,
                        rateCoins: 100,
                        rateNaira: 1500,
                      ),
                      const SizedBox(height: 18),

                      // 4. Target Bank Account Selector
                      BankAccountTile(
                        bankAccount: _selectedBank,
                        onTap: () {
                          // Navigate to BankSelectionScreen or open bottom sheet
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 5. Submit Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: WithdrawButton(
                  onPressed: () {
                    // Navigate to WithdrawReviewScreen or trigger controller action
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}