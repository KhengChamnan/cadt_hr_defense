import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// SettingsSection displays a group of settings with a title
/// - Shows a section title
/// - Contains a list of setting items
class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingItem> items;

  const SettingsSection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PalmColors.white,
        borderRadius: BorderRadius.circular(PalmSpacings.radius - 3),
        boxShadow: [
          BoxShadow(
            color: PalmColors.dark.withOpacity(0.25),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(PalmSpacings.s),
        child: Column(
          children: [
            // Section Title
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0, 
                left: 7.0, 
                top: 4.0
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: PalmTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: PalmColors.neutralDark,
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings Items
            ...items,
          ],
        ),
      ),
    );
  }
}

/// SettingItem represents a single setting option
/// - Shows an icon and title
/// - Optionally shows a subtitle
/// - Provides tap functionality
/// - Can be styled as the last item (no divider)
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon and Title/Subtitle
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(
                          icon,
                          color: PalmColors.neutral,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: PalmSpacings.s + 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: PalmTextStyles.body.copyWith(
                                color: PalmColors.neutral,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle!,
                                style: PalmTextStyles.label.copyWith(
                                  color: PalmColors.neutral.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: PalmIcons.size - 8,
                  color: PalmColors.neutral,
                ),
              ],
            ),
          ),
        ),
        // Divider (except for the last item)
        if (!isLast)
          const Divider(
            color: Color(0xFFD9D9D9),
            thickness: 0.3,
            height: 1,
          ),
      ],
    );
  }
} 