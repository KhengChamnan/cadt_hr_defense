import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// A selectable card widget for leave type options
/// Displays leave type information with selection state and handles tap events
class LeaveTypeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback? onTap;

  const LeaveTypeOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: PalmSpacings.s),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          child: Container(
            padding: const EdgeInsets.all(PalmSpacings.m),
            decoration: BoxDecoration(
              color: isSelected
                  ? PalmColors.primary.withOpacity(0.05)
                  : PalmColors.white,
              borderRadius: BorderRadius.circular(PalmSpacings.radius),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(PalmSpacings.s),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(PalmSpacings.s),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: PalmSpacings.m),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: PalmTextStyles.body.copyWith(
                          color: isSelected
                              ? PalmColors.primary
                              : PalmColors.textNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: PalmSpacings.xxs),
                      Text(
                        subtitle,
                        style: PalmTextStyles.caption.copyWith(
                          color: PalmColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(PalmSpacings.xs),
                    decoration: BoxDecoration(
                      color: PalmColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: PalmColors.white,
                      size: 16,
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: PalmColors.greyLight.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
