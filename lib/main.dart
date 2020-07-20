import 'package:flutter/material.dart';

import './pages/home_page.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

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
