import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SolidAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final double elevation;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;
  final Widget? flexibleContent;
  final bool showUserWelcome;
  final String? username;
  final String? avatarUrl;

  const SolidAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = const Color(0xFF2C5282),
    this.titleStyle,
    this.elevation = 0,
    this.actions,
    this.leading,
    this.centerTitle,
    this.flexibleContent,
    this.showUserWelcome = false,
    this.username,
    this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      title: showUserWelcome ? _buildWelcomeTitle() : Text(
        title,
        style: titleStyle ?? const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: elevation,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
    );
  }

  Widget _buildWelcomeTitle() {
    return Row(
      children: [
        if (avatarUrl != null)
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(avatarUrl!),
          )
        else
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 20, color: Colors.white),
          ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            Text(
              username ?? 'User',
              style: titleStyle ?? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 