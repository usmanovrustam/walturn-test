import 'package:flutter/cupertino.dart';
import 'package:test_app/theme/style.dart';

final theme = CupertinoThemeData(
  brightness: Style.brightness,
  primaryColor: Style.colors.primary,
  textTheme: CupertinoTextThemeData(
    textStyle: TextStyle(fontFamily: Style.fontFamily),
    navActionTextStyle: TextStyle(color: Style.colors.black),
  ),
);
