import 'package:flutter/material.dart';

import 'view/splash_screen.dart';

void main() {

  runApp(MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: SplashScreen()
  ));
}
