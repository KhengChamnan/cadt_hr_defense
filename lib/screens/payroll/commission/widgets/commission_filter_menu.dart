import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

/// Widget that displays filter menu for commission time periods:
/// - Last 7 days, 28 days, 90 days, 365 days, Lifetime
class CommissionFilterMenu extends StatelessWidget {
  final Function(String) onFilterSelected;

  const CommissionFilterMenu({
    super.key,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "7",
          child: Text("Last 7 days"),
        ),
        const PopupMenuItem(
          value: "28",
          child: Text("Last 28 days"),
        ),
        const PopupMenuItem(
          value: "90",
          child: Text("Last 90 days"),
        ),
        const PopupMenuItem(
          value: "365",
          child: Text("Last 365 days"),
        ),
        const PopupMenuItem(
          value: "1000",
          child: Text("Lifetime"),
        ),
      ],
      icon: const Icon(Icons.filter_list),
      color: PalmColors.backgroundAccent,
      onSelected: onFilterSelected,
    );
  }
}
