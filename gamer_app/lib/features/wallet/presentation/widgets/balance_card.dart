import 'package:flutter/material.dart';

class BalanceCard extends StatefulWidget {
  final int totalBalance;
  final double totalNaira;
  final int availableBalance;
  final double availableNaira;
  final int lockedBalance;
  final double lockedNaira;
  final int pendingBalance;
  final double pendingNaira;
  final VoidCallback? onCoinRateTap;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.totalNaira,
    required this.availableBalance,
    required this.availableNaira,
    required this.lockedBalance,
    required this.lockedNaira,
    required this.pendingBalance,
    required this.pendingNaira,
    this.onCoinRateTap,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool isBalanceVisible = true;

  static const Color accentRed = Color(0xFFFF2233);
  static const Color darkRedGlow = Color(0xFF6A040F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accentRed.withOpacity(0.4), width: 1),
        gradient: LinearGradient(
          colors: [
            darkRedGlow.withOpacity(0.4),
            const Color(0xFF120E12),
            Colors.black,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: accentRed.withOpacity(0.12),
            blurRadius: 14,
            spreadRadius: -2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Label, Eye toggle, Coin Rate Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => isBalanceVisible = !isBalanceVisible),
                    child: Icon(
                      isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.white54,
                      size: 15,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onCoinRateTap,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Coin Rate',
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, color: accentRed, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Total Balance Amount Row + Coin Emblem
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isBalanceVisible ? _formatNumber(widget.totalBalance) : '******',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const _CoinBadge(size: 20),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    isBalanceVisible ? '≈ ₦${_formatDecimal(widget.totalNaira)}' : '≈ ₦******',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Emblem Visual
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [accentRed, Color(0xFF300000)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentRed.withOpacity(0.5),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.shield_outlined, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sub-balances
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSubBalanceItem('AVAILABLE', widget.availableBalance, widget.availableNaira, const Color(0xFF4EFE80)),
              _buildVerticalDivider(),
              _buildSubBalanceItem('LOCKED', widget.lockedBalance, widget.lockedNaira, const Color(0xFFFF9F1C)),
              _buildVerticalDivider(),
              _buildSubBalanceItem('PENDING', widget.pendingBalance, widget.pendingNaira, const Color(0xFFB5179E)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubBalanceItem(String title, int count, double naira, Color indicatorColor) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                isBalanceVisible ? '$count' : '***',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 3),
              const _CoinBadge(size: 12),
            ],
          ),
          const SizedBox(height: 1),
          Text(
            isBalanceVisible ? '≈ ₦${_formatDecimal(naira)}' : '≈ ₦***',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 28,
      width: 1,
      color: Colors.white.withOpacity(0.08),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  String _formatNumber(int val) => val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  String _formatDecimal(double val) => val.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

class _CoinBadge extends StatelessWidget {
  final double size;
  const _CoinBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFF2233),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.shield, color: Colors.black, size: size * 0.65),
      ),
    );
  }
}