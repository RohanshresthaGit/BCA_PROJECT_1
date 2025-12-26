import 'package:flutter/material.dart';
import '../../config/localization/l10n/app_localizations.dart';

/// Extensions on `BuildContext` for localization, navigation and responsiveness.
extension ContextExtensions on BuildContext {
  /// Shortcut to generated localization
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Navigator shortcuts
  NavigatorState get nav => Navigator.of(this);

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      nav.pushNamed<T>(routeName, arguments: arguments);

  Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) => nav.pushReplacementNamed<T, TO>(
    routeName,
    result: result,
    arguments: arguments,
  );

  void pop<T extends Object?>([T? result]) => nav.pop(result);

  /// Screen dimensions and responsive helpers
  double get sw => MediaQuery.of(this).size.width;
  double get sh => MediaQuery.of(this).size.height;

  bool get isMobile => sw < 600;
  bool get isTablet => sw >= 600 && sw < 1024;
  bool get isDesktop => sw >= 1024;

  /// Percentage helpers: pass 0.5 for 50% width/height
  double percentWidth(double percent) => sw * percent;
  double percentHeight(double percent) => sh * percent;
}

/// Extensions on `Widget` for quick padding wrappers.
extension WidgetPaddingExtensions on Widget {
  Widget paddingAll([double value = 8]) =>
      Padding(padding: EdgeInsets.all(value), child: this);
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );
}
