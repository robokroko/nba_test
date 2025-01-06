import 'package:flutter/material.dart';
import 'colors.dart';

//TextStyles
TextStyle get titleSmallTextStyle => const TextStyle(color: primaryTextColor, fontSize: 18, fontWeight: FontWeight.w300);
TextStyle get titleMiniTextStyle => const TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.w100);
TextStyle get panelDescriptionTextStyle => const TextStyle(color: textThemeColor, fontSize: 18, fontWeight: FontWeight.w400);

//BoxDecorations
BoxDecoration get primaryBoxDecoration => BoxDecoration(borderRadius: BorderRadius.circular(14), color: primaryBlueColor);
