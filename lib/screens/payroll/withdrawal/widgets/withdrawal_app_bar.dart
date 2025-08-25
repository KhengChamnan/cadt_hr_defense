import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

/// This widget creates a consistent app bar for the withdrawal screen.
/// Follows the app's design system for navigation and styling.
class WithdrawalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const WithdrawalAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: PalmColors.primary,
      foregroundColor: PalmColors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: PalmColors.white,
          size: PalmIcons.size,
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      ),
      title: Text(
        title,
        style: PalmTextStyles.title.copyWith(
          color: PalmColors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
