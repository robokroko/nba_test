import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData get testApptheme => ThemeData(
    fontFamily: 'Outfit',
    primaryColor: primaryBlueColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: primaryBlueColor,
      surface: primaryLightColor,
    ),
    scaffoldBackgroundColor: primaryLightColor,
    visualDensity: VisualDensity.adaptivePlatformDensity);
