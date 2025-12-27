import 'package:flutter/material.dart';
import 'app_appbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final FloatingActionButton? floatingActionButton;
  final bool safeArea;
  final EdgeInsetsGeometry padding;

  const AppScaffold({
    Key? key,
    this.title,
    required this.body,
    this.actions,
    this.leading,
    this.floatingActionButton,
    this.safeArea = true,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: body);

    return Scaffold(
      appBar: CustomAppBar(title: title, actions: actions, leading: leading),
      body: safeArea ? SafeArea(child: content) : content,
      floatingActionButton: floatingActionButton,
    );
  }
}
