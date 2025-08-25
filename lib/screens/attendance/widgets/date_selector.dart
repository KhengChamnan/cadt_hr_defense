import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DateSelector extends StatelessWidget {
  final String mainText;
  final String dropdownText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDropdownTap;

  const DateSelector({
    Key? key,
    required this.mainText,
    required this.dropdownText,
    required this.onPrevious,
    required this.onNext,
    required this.onDropdownTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: PalmSpacings.m, vertical: PalmSpacings.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          IconButton(
            icon: Icon(Icons.chevron_left, color: PalmColors.primary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onPrevious,
          ),
          // Text with dropdown
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  mainText,
                  style: PalmTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: PalmColors.textNormal,
                  ),
                ),
                // Only the dropdown part is hoverable/clickable
                InkWell(
                  onTap: onDropdownTap,
                  child: Row(
                    children: [
                      Text(
                        dropdownText,
                        style: PalmTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: PalmColors.primary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: PalmColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Next button
          IconButton(
            icon: Icon(Icons.chevron_right, color: PalmColors.primary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
} 