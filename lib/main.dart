// @dart=2.9
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:blackcoffer_project/pages/login%20page.dart';
import 'package:blackcoffer_project/pages/splash%20screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Defining routes for navigation
var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(brightness: Brightness.dark),
    debugShowCheckedModeBanner: false,
    routes: routes,
    home: AnimatedSplashScreen(
      splash: 'assetts/blacklogo.jpg',
      splashIconSize: 150,
      duration: 1000,
      splashTransition: SplashTransition.rotationTransition,
      nextScreen: SplashScreen(),
    ),
  ));
}
