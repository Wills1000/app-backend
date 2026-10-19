import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StakeSelector extends StatefulWidget {
  final double currentWager;
  final Function(double) onWagerChanged;

  const StakeSelector({
    Key? key,
    required this.currentWager,
    required this.onWagerChanged,
  }) : super(key: key);

  @override
  State<StakeSelector> createState() => _StakeSelectorState();
}

class _StakeSelectorState extends State<StakeSelector> {
  late TextEditingController _controller;
  final List<double> presets = const [100.0, 500.0, 1000.0, 5000.0, 10000.0];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentWager.toInt().toString());
  }

  @override
  void didUpdateWidget(covariant StakeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWager != widget.currentWager) {
      final text = widget.currentWager.toInt().toString();
      if (_controller.text != text) {
        _controller.text = text;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Typeable Custom Wager Input Field
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.textWhite, fontSize: 15, fontWeight: FontWeight.bold),
          onChanged: (val) {
            final parsed = double.tryParse(val);
            if (parsed != null) {
              widget.onWagerChanged(parsed);
            }
          },
          decoration: InputDecoration(
            hintText: 'Enter amount',
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.attach_money, color: AppColors.textMuted, size: 20),
            ),
            suffixIcon: const Icon(Icons.edit, color: AppColors.textMuted, size: 18),
            filled: true,
            fillColor: AppColors.cardBg.withOpacity(0.6),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Quick Selector Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: presets.map((amount) {
            final isSelected = widget.currentWager == amount;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.onWagerChanged(amount);
                  _controller.text = amount.toInt().toString();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryRed.withOpacity(0.2) : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryRed : AppColors.cardBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      amount.toInt().toString(),
                      style: TextStyle(
                        color: isSelected ? AppColors.textWhite : AppColors.textMuted,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}