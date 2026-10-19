import 'package:flutter/material.dart';
import '../../../../core/widgets/app_background.dart';
import '../../models/coin_rate_model.dart';
import '../widgets/currency_rate_card.dart';
import '../widgets/currency_rate_list.dart';
import '../widgets/currency_converter.dart';
import '../widgets/rate_info_card.dart';

class CoinRateScreen extends StatefulWidget {
  const CoinRateScreen({Key? key}) : super(key: key);

  @override
  State<CoinRateScreen> createState() => _CoinRateScreenState();
}

class _CoinRateScreenState extends State<CoinRateScreen> {
  int _activeTab = 0; // 0: Rates, 1: Converter

  final List<CurrencyRateModel> currencyRates = const [
    CurrencyRateModel(code: 'USD', name: 'US Dollar', ratePerCoin: 0.10, symbol: '\$', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'NGN', name: 'Nigerian Naira', ratePerCoin: 150.35, symbol: '₦', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'GBP', name: 'British Pound', ratePerCoin: 0.08, symbol: '£', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'EUR', name: 'Euro', ratePerCoin: 0.09, symbol: '€', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'CAD', name: 'Canadian Dollar', ratePerCoin: 0.14, symbol: '\$', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'AUD', name: 'Australian Dollar', ratePerCoin: 0.15, symbol: '\$', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'ZAR', name: 'South African Rand', ratePerCoin: 1.83, symbol: 'R', flagAssetOrUrl: ''),
    CurrencyRateModel(code: 'GHS', name: 'Ghana Cedi', ratePerCoin: 1.55, symbol: '₵', flagAssetOrUrl: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Coin Rate',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RateInfoCard(),
                ),
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                // Hero Banner
                const CurrencyRateCard(),
                const SizedBox(height: 18),

                // Tab Switcher (Rates vs Converter)
                Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _activeTab == 0 ? const Color(0xFFE50914) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Rates',
                                style: TextStyle(
                                  color: _activeTab == 0 ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeTab = 1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _activeTab == 1 ? const Color(0xFFE50914) : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Converter',
                                style: TextStyle(
                                  color: _activeTab == 1 ? Colors.white : Colors.white54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Dynamic Tab View Content
                if (_activeTab == 0) ...[
                  CurrencyRateList(currencies: currencyRates),
                ] else ...[
                  const CurrencyConverter(),
                  const SizedBox(height: 24),
                  const RateInfoCard(),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}