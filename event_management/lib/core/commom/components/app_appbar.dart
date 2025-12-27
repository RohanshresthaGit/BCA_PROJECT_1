import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    this.title,
    this.actions,
    this.leading,
    this.elevation = 0.5,
    this.backgroundColor,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      elevation: elevation,
      centerTitle: centerTitle,
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
