import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sivy/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen()));
}
