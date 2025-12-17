import 'package:flutter/material.dart';

class AppTheme {
  // Primary color
  static const Color primaryColor = Colors.deepPurple;

  // Common border radius
  static const BorderRadius defaultRadius = BorderRadius.all(Radius.circular(12));

  // ---------------- LIGHT THEME ----------------
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    // backgroundColor: Colors.white,

    // ---------------- COLOR SCHEME ----------------
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: Colors.deepPurpleAccent,
      onSecondary: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red,
      onError: Colors.white,
    ),

    // ---------------- APPBAR ----------------
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 2,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),

    // ---------------- DRAWER ----------------
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
      scrimColor: Colors.black26,
    ),

    // ---------------- ICON ----------------
    iconTheme: const IconThemeData(color: primaryColor),

    // ---------------- TEXT ----------------
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      bodySmall: TextStyle(fontSize: 12, color: Colors.black54),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      labelMedium: TextStyle(fontSize: 12, color: Colors.black87),
      labelSmall: TextStyle(fontSize: 10, color: Colors.black54),
    ),

    // ---------------- INPUT FIELD ----------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      labelStyle: const TextStyle(color: primaryColor),
      hintStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // ---------------- BUTTONS ----------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
      ),
    ),

    // ---------------- CARD ----------------
    cardTheme: CardThemeData(
      color: Colors.white,
      shadowColor: Colors.black12,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
    ),

    // ---------------- CHIP ----------------
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.deepPurpleAccent,
      disabledColor: Colors.grey,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: TextStyle(color: Colors.white),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      brightness: Brightness.light,
      shape: StadiumBorder(),
    ),

    // ---------------- SWITCH ----------------
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primaryColor),
      trackColor: WidgetStateProperty.all(primaryColor.withValues(alpha: 0.5)),
    ),

    // ---------------- RADIO ----------------
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(primaryColor),
    ),

    // ---------------- CHECKBOX ----------------
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(primaryColor),
    ),

    // ---------------- SLIDER ----------------
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      thumbColor: primaryColor,
      inactiveTrackColor: Colors.grey[300],
      valueIndicatorColor: primaryColor,
    ),

    // ---------------- TAB BAR ----------------
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.black54,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // ---------------- BOTTOM NAVIGATION ----------------
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black54,
      elevation: 8,
    ),

    // ---------------- TOOLTIP ----------------
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: Colors.black87, borderRadius: defaultRadius),
      textStyle: TextStyle(color: Colors.white),
    ),

    // ---------------- DIALOG ----------------
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      contentTextStyle: const TextStyle(color: Colors.black87, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
    ),

    // ---------------- SNACKBAR ----------------
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryColor,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );

  // ---------------- DARK THEME ----------------
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF2A1A3D),
    // backgroundColor: const Color(0xFF2A1A3D),

    // ---------------- COLOR SCHEME ----------------
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: Colors.deepPurpleAccent,
      onSecondary: Colors.white,
      background: const Color(0xFF2A1A3D),
      onBackground: Colors.white,
      surface: const Color(0xFF3C1F57),
      onSurface: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
    ),

    // ---------------- APPBAR ----------------
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 2,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),

    // ---------------- DRAWER ----------------
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF3C1F57),
      scrimColor: Colors.black54,
    ),

    // ---------------- ICON ----------------
    iconTheme: const IconThemeData(color: Colors.white),

    // ---------------- TEXT ----------------
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
      labelMedium: TextStyle(fontSize: 12, color: Colors.white70),
      labelSmall: TextStyle(fontSize: 10, color: Colors.white54),
    ),

    // ---------------- INPUT FIELD ----------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF3C1F57),
      labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
      hintStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: defaultRadius,
        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      ),
    ),

    // ---------------- BUTTONS ----------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: defaultRadius),
      ),
    ),

    // ---------------- CARD ----------------
    cardTheme: CardThemeData(
      color: const Color(0xFF3C1F57),
      shadowColor: Colors.black54,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
    ),

    // ---------------- CHIP ----------------
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.deepPurpleAccent,
      disabledColor: Colors.grey,
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle: TextStyle(color: Colors.white),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      brightness: Brightness.dark,
      shape: StadiumBorder(),
    ),

    // ---------------- SWITCH ----------------
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(primaryColor),
      trackColor: WidgetStateProperty.all(primaryColor.withValues(alpha: 0.5)),
    ),

    // ---------------- RADIO ----------------
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(primaryColor),
    ),

    // ---------------- CHECKBOX ----------------
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(primaryColor),
    ),

    // ---------------- SLIDER ----------------
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      thumbColor: primaryColor,
      inactiveTrackColor: Colors.grey[700],
      valueIndicatorColor: primaryColor,
    ),

    // ---------------- TAB BAR ----------------
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.white70,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),

    // ---------------- BOTTOM NAVIGATION ----------------
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF3C1F57),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.white70,
      elevation: 8,
    ),

    // ---------------- TOOLTIP ----------------
    tooltipTheme: const TooltipThemeData(
      decoration: BoxDecoration(color: Colors.black87, borderRadius: defaultRadius),
      textStyle: TextStyle(color: Colors.white),
    ),

    // ---------------- DIALOG ----------------
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF3C1F57),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      contentTextStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: defaultRadius),
    ),

    // ---------------- SNACKBAR ----------------
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: primaryColor,
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
