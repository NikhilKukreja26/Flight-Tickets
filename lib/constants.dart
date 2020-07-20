import 'package:flutter/material.dart';

const Color firstColor = Color(0xFFF47D15);
const Color secondColor = Color(0xFFEF772C);

ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFFF3791A),
  fontFamily: 'Oxygen',
);

BoxDecoration containerBoxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomLeft,
    colors: [
      firstColor,
      secondColor,
    ],
  ),
);
