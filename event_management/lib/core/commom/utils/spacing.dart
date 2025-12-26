import 'package:flutter/material.dart';

/// Common EdgeInsets presets used across the app.
class Insets {
  Insets._();

  static const EdgeInsets xs = EdgeInsets.all(4);
  static const EdgeInsets sm = EdgeInsets.all(8);
  static const EdgeInsets md = EdgeInsets.all(16);
  static const EdgeInsets lg = EdgeInsets.all(24);
  static const EdgeInsets xl = EdgeInsets.all(32);

  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: 8);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: 16);
}

/// Prebuilt SizedBox gaps for quick layout.
class Spaces {
  Spaces._();

  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h32 = SizedBox(height: 32);

  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w24 = SizedBox(width: 24);
  static const SizedBox w32 = SizedBox(width: 32);
}
