import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';

class LeaveOverviewTabBar extends StatelessWidget {
  final TabController tabController;
  final Function(int)? onTabTap;
  final List<String> tabs = const ['All', 'Pending', 'Approved'];

  const LeaveOverviewTabBar({
    super.key,
    required this.tabController,
    this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(PalmSpacings.m),
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tabText = entry.value;
              final isSelected = tabController.index == index;
              
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < tabs.length - 1 ? 6 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (onTabTap != null) {
                        onTabTap!(index);
                      } else {
                        tabController.animateTo(index);
                      }
                    },
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: PalmColors.backGroundColor,
                        borderRadius: BorderRadius.circular(PalmSpacings.radius),
                        boxShadow: [
                          BoxShadow(
                            color: PalmColors.dark.withOpacity(0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          tabText,
                          style: PalmTextStyles.button.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: PalmColors.white.withOpacity(isSelected ? 1.0 : 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}