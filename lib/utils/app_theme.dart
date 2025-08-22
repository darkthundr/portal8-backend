import 'package:flutter/material.dart';
import 'package:portal8/utils/app_constants.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: kDeepSpacePurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: kDeepSpacePurple,
    elevation: 0,
    titleTextStyle: kTitleTextStyle,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: kDeepSpacePurple,
    selectedItemColor: kCosmicCyan,
    unselectedItemColor: kNebulaWhite,
  ),
  colorScheme: const ColorScheme.dark(
    primary: kCosmicCyan,
    secondary: kNebulaPink,
    surface: kPortalPurple,
    onPrimary: kCosmicBlack,
    onSecondary: kCometWhite,
    onBackground: kCometWhite,
    onSurface: kCometWhite,
  ),
  textTheme: const TextTheme(
    displayLarge: kTitleTextStyle,
    displayMedium: kHeadingTextStyle,
    bodyLarge: kSubtitleTextStyle,
    bodyMedium: kBodyTextStyle,
    labelLarge: kButtonTextStyle,
  ),
  inputDecorationTheme: kTextFieldDecoration,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: kElevatedButtonWithIconStyle,
  ),
);
