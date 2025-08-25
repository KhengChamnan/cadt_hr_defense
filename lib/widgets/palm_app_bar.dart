import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A global app bar widget that provides:
/// - A customizable title
/// - Optional back button functionality
/// - Optional right action button
/// - Customizable background color
class PalmAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTitleTap;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final bool centerTitle;
  final double height;

  const PalmAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.onTitleTap,
    this.backgroundColor,
    this.actions,
    this.centerTitle = false,
    this.height = 96,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor ?? PalmColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m),
      child: Row(
        children: [
          if (onBackPressed != null || Navigator.of(context).canPop())
            IconButton(
              icon: Icon(Icons.arrow_back, color: PalmColors.white),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          if (onBackPressed != null || Navigator.of(context).canPop())
            const SizedBox(width: PalmSpacings.s / 1.5),
          
          // Title section (optionally tappable)
          Expanded(
            child: InkWell(
              onTap: onTitleTap,
              child: Row(
                mainAxisAlignment: centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: PalmTextStyles.title.copyWith(
                      color: PalmColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Optional action buttons
          if (actions != null)
            ...actions!,
        ],
      ),
    );
  }
} 