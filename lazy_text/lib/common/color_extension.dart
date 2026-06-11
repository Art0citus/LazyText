import 'package:flutter/material.dart';

class TColor {
  // Primary Purple
  static Color get primary => const Color(0xff5E00F5);
  static Color get primary500 => const Color(0xff7722FF);
  static Color get primary20 => const Color(0xff924EFF);

  // Background Colors
  static Color get gray => const Color(0xff0E0E12);
  static Color get gray80 => const Color(0xff1C1C23);
  static Color get gray70 => const Color(0xff353542);
  static Color get gray60 => const Color(0xff4E4E61);
  static Color get gray50 => const Color(0xff666680);
  static Color get gray40 => const Color(0xff83839C);
  static Color get gray30 => const Color(0xffA2A2B5);

  // Text Colors
  static Color get primaryText => Colors.white;
  static Color get secondaryText => gray40;

  // Status Colors
  static Color get online => const Color(0xff23A55A);
  static Color get offline => gray50;

  // Misc
  static Color get white => Colors.white;
  static Color get transparent => Colors.transparent;
}