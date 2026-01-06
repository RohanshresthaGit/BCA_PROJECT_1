import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: (loading || onPressed == null) ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(label),
        ),
      ),
    );
  }
}

/// Simple text button wrapper used across the app.
class AppTextButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: padding),
      child: Text(label, style: style),
    );
  }
}

/// Text button with an icon.
class AppTextButtonIcon extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final MainAxisSize? mainAxisSize;
  final bool end;
  final EdgeInsetsGeometry padding;

  const AppTextButtonIcon({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.style,
    this.mainAxisSize,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.end = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      iconAlignment: end ? IconAlignment.end : IconAlignment.start,
      onPressed: onPressed,
      icon: icon,
      label: Text(label, style: style),
      style: TextButton.styleFrom(minimumSize: const Size(0, 36), padding: padding),
    );
  }
}
