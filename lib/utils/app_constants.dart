import 'package:flutter/material.dart';

// Color Palette
const Color kDeepSpacePurple = Color(0xFF1E0A3F);
const Color kCosmicCyan = Color(0xFF00C7FF);
const Color kStarlightSilver = Color(0xFFE0E0E0);
const Color kEclipseGrey = Color(0xFF333333);
const Color kPortalPurple = Color(0xFF3B285F);
const Color kStarlightBlue = Color(0xFF3498DB);
const Color kNebulaPink = Color(0xFFD671A3);
const Color kAccentNeonGreen = Color(0xFF90EE90);
const Color kCosmicBlack = Color(0xFF0D0D0D);
const Color kCometWhite = Color(0xFFF7F7F7);
const Color kNebulaWhite = Color(0xFFF0F4F8);

// Text Styles
const TextStyle kTitleTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: kStarlightSilver,
);

const TextStyle kHeadingTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: kStarlightSilver,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: kStarlightSilver,
);

const TextStyle kBodyTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: kStarlightSilver,
);

const TextStyle kButtonTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: kDeepSpacePurple,
);

const TextStyle kLinkTextStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: kCosmicCyan,
  decoration: TextDecoration.underline,
);

// Input Decorations
const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter your email',
  hintStyle: TextStyle(color: kStarlightSilver),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kCosmicCyan, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kCosmicCyan, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  filled: true,
  fillColor: kDeepSpacePurple,
);

// Button Styles
final ButtonStyle kElevatedButtonWithIconStyle = ElevatedButton.styleFrom(
  backgroundColor: kCosmicCyan,
  foregroundColor: kDeepSpacePurple,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  ),
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
);
