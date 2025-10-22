import 'package:example_mobile_consent/support/sp_app_colors.dart';
import 'package:flutter/cupertino.dart';

class SPCupertinoStyles {
  const SPCupertinoStyles._();

  static final appTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: SPAppColors.primary,
    primaryContrastingColor: SPAppColors.onPrimary,
    scaffoldBackgroundColor: SPAppColors.background,
    barBackgroundColor: SPAppColors.primary,
    textTheme: CupertinoTextThemeData(
      primaryColor: SPAppColors.onPrimary,
      textStyle: TextStyle(color: SPAppColors.onBackground),
      navTitleTextStyle: TextStyle(
        color: SPAppColors.onPrimary,
        fontSize: 18,
        fontFamily: '.SF Pro Text', // iOS system font
        fontWeight: FontWeight.w600,
      ),
      navLargeTitleTextStyle: TextStyle(
        color: SPAppColors.onPrimary,
        fontSize: 28,
        fontFamily: '.SF Pro Text',
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
