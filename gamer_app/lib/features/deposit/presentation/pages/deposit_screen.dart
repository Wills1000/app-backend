import 'package:flutter/material.dart';

import '/../../core/widgets/app_background.dart';
import '../../models/conversion_model.dart';
import '../../models/payment_method_model.dart';
import '../widgets/amount_input.dart';
import '../widgets/coin_conversion_card.dart';
import '../widgets/payment_method_tile.dart';

class DepositScreen extends StatefulWidget {
  static const String routeName = '/deposit';

  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  static const Color accentRed = Color(0xFFFF2233);
  static const Color cardBg = Color(0xFF121215);

  final ConversionModel _conversionRate = const ConversionModel(
    rateNaira: 1500.0,
    rateCoins: 100, 
  );

  PaymentMethodType _selectedMethod = PaymentMethodType.bankTransfer;
  final TextEditingController _amountController = TextEditingController(text: '15000');
  final List<int> _quickAmounts = [5000, 10000, 20000, 50000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _calculatedCoins {
    final double rawAmount = double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
    return _conversionRate.calculateCoins(rawAmount);
  }

  void _selectQuickAmount(int amount) {
    setState(() {
      _amountController.text = amount.toString();
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
          'Deposit',
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
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- SELECT PAYMENT METHOD ---
                      Text(
                        'Select Payment Method',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Column(
                          children: [
                            PaymentMethodTile(
                              method: PaymentMethodModel(
                                type: PaymentMethodType.bankTransfer,
                                title: 'Bank Transfer',
                                badgeText: 'Recommended',
                                icon: const Icon(Icons.account_balance_outlined, color: Colors.white70, size: 18),
                              ),
                              isSelected: _selectedMethod == PaymentMethodType.bankTransfer,
                              onTap: () => setState(() => _selectedMethod = PaymentMethodType.bankTransfer),
                            ),
                            _buildDivider(),
                            PaymentMethodTile(
                              method: PaymentMethodModel(
                                type: PaymentMethodType.opay,
                                title: 'Opay',
                                icon: _buildBrandLogo('O', const Color(0xFF00C853)),
                              ),
                              isSelected: _selectedMethod == PaymentMethodType.opay,
                              onTap: () => setState(() => _selectedMethod = PaymentMethodType.opay),
                            ),
                            _buildDivider(),
                            PaymentMethodTile(
                              method: PaymentMethodModel(
                                type: PaymentMethodType.moniepoint,
                                title: 'Moniepoint',
                                icon: _buildBrandLogo('M', const Color(0xFF0052FF)),
                              ),
                              isSelected: _selectedMethod == PaymentMethodType.moniepoint,
                              onTap: () => setState(() => _selectedMethod = PaymentMethodType.moniepoint),
                            ),
                            _buildDivider(),
                            PaymentMethodTile(
                              method: PaymentMethodModel(
                                type: PaymentMethodType.card,
                                title: 'Card Payment',
                                icon: const Icon(Icons.credit_card_rounded, color: Colors.white70, size: 18),
                                trailingBadge: const Row(
                                  children: [
                                    Text(
                                      'VISA',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    _MasterCardLogo(),
                                  ],
                                ),
                              ),
                              isSelected: _selectedMethod == PaymentMethodType.card,
                              onTap: () => setState(() => _selectedMethod = PaymentMethodType.card),
                            ),
                            _buildDivider(),
                            PaymentMethodTile(
                              method: PaymentMethodModel(
                                type: PaymentMethodType.usdt,
                                title: 'USDT (TRC20)',
                                icon: _buildBrandLogo('₮', const Color(0xFF26A17B)),
                              ),
                              isSelected: _selectedMethod == PaymentMethodType.usdt,
                              onTap: () => setState(() => _selectedMethod = PaymentMethodType.usdt),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- ENTER AMOUNT ---
                      AmountInput(
                        controller: _amountController,
                        quickAmounts: _quickAmounts,
                        onQuickAmountSelected: _selectQuickAmount,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      // --- CONVERSION CARD ---
                      CoinConversionCard(
                        calculatedCoins: _calculatedCoins,
                        rateNaira: _conversionRate.rateNaira,
                        rateCoins: _conversionRate.rateCoins,
                      ),
                    ],
                  ),
                ),
              ),

              // --- BOTTOM CONTINUE BUTTON ---
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to processing or payment screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 14,
      endIndent: 14,
    );
  }

  Widget _buildBrandLogo(String letter, Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _MasterCardLogo extends StatelessWidget {
  const _MasterCardLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 12,
      child: Stack(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 6,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Color(0xFFF79E1B),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}