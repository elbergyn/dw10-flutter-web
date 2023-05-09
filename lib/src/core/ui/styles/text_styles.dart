import 'package:flutter/material.dart';

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  String get fontFamilly => 'mplus1';

  TextStyle get textLight =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.w300);
  TextStyle get textRegular =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.normal);
  TextStyle get textMedium =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.w500);
  TextStyle get textSemiBold =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.w600);
  TextStyle get textBold =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.bold);
  TextStyle get textExtraBold =>
      TextStyle(fontFamily: fontFamilly, fontWeight: FontWeight.w800);

  TextStyle get textButtonLabel => textBold.copyWith(fontSize: 14);
  TextStyle get textTitle => textBold.copyWith(fontSize: 22);
}

extension TextStylesExtensions  on BuildContext{
  TextStyles get textStyles => TextStyles.instance;
}