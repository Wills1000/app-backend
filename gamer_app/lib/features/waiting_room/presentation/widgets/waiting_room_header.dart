import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WaitingRoomHeader extends StatelessWidget implements PreferredSizeWidget {
  const WaitingRoomHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textWhite, size: 18),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: const Text(
        'WAITING ROOM',
        style: TextStyle(color: AppColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shield_outlined, color: AppColors.primaryRed),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}