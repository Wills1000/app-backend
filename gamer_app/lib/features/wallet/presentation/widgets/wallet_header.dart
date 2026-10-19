import 'package:flutter/material.dart';

class WalletHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final VoidCallback? onSupportPressed;
  final VoidCallback? onHistoryPressed;

  const WalletHeader({
    super.key,
    this.onBackPressed,
    this.onSupportPressed,
    this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
        onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
      ),
      centerTitle: true,
      title: const Text(
        'Wallet',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.headset_mic_outlined, color: Colors.white, size: 18),
          ),
          onPressed: onSupportPressed,
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
          ),
          onPressed: onHistoryPressed,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}