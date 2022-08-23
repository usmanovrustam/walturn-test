import 'package:flutter/material.dart';
import 'package:test_app/theme/colors.dart';

class Style {
  static AppColor get colors => AppColor();

  static String get fontFamily => "Inter";

  static Brightness get brightness => Brightness.light;

  static EdgeInsets get padding12 => const EdgeInsets.all(12.0);

  static EdgeInsets get padding16 => const EdgeInsets.all(16.0);

  static BorderRadius get border8 => const BorderRadius.all(
        Radius.circular(8.0),
      );

  static TextStyle get body1 => TextStyle(
        fontSize: 16.0,
        letterSpacing: 0.5,
        color: colors.black,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 12.0,
        letterSpacing: 0.4,
        color: colors.black,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w300,
      );

  static TextStyle get headline6 => TextStyle(
        fontSize: 20.0,
        letterSpacing: 0.15,
        color: colors.black,
        fontFamily: fontFamily,
        fontWeight: FontWeight.w800,
      );
}
