import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  
  const MenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: PalmColors.backgroundAccent,
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
          border: Border.all(
            color: PalmColors.greyLight.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: PalmColors.primary,
            ),
            const SizedBox(height: PalmSpacings.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: PalmTextStyles.label.copyWith(
                color: PalmColors.textNormal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}