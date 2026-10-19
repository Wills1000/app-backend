import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DisputeScreen extends StatelessWidget {
  const DisputeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121214),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('DISPUTE SUBMITTED', style: TextStyle(color: AppColors.textWhite, fontSize: 15, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Purple Shield Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF8E24AA).withOpacity(0.15),
                ),
                child: const Icon(Icons.verified_user_outlined, color: Color(0xFFAB47BC), size: 54),
              ),
              const SizedBox(height: 20),

              const Text('DISPUTE SUBMITTED', style: TextStyle(color: AppColors.textWhite, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 8),
              const Text('Our team will review the proof\nand determine the correct result.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 28),

              // Dispute ID Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  children: [
                    const Text('DISPUTE ID', style: TextStyle(color: AppColors.textMuted, fontSize: 9, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('#DSP-782341', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(width: 8),
                        Icon(Icons.copy, color: AppColors.textMuted, size: 14),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Return Home Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('BACK TO HOME', style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}