import 'package:flutter/material.dart';

import './pages/home_page.dart';

void main() => runApp(MyApp());

ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xFFF3791A),
  fontFamily: 'Oxygen',
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flight Tickets',
      theme: appTheme,
      home: HomePage(),
    );
  }
}
