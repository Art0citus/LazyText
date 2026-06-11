import 'package:flutter/material.dart';

import 'common/color_extension.dart';
import 'screens/auth/welcome_screen.dart';

void main() {
  runApp(const LazyText());
}

class LazyText extends StatelessWidget {
  const LazyText({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LazyText',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: TColor.gray,
        appBarTheme: AppBarTheme(
          backgroundColor: TColor.gray,
          foregroundColor: TColor.white,
          elevation: 0,
        ),
      ),

      home: const WelcomeScreen(),
    );
  }
}