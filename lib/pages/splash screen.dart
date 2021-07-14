import 'dart:async';

import 'package:blackcoffer_project/pages/home%20page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    initializeUser();
    navigateUser();
  }

  ///
  Future initializeUser() async {
    await Firebase.initializeApp();
    final User? firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser!.reload();
    _user = await _auth.currentUser;
    // get User authentication status here
  }

  ///
  navigateUser() async {
    // checking whether user already loggedIn or not
    if (_auth.currentUser != null) {
      // &&  FirebaseAuth.instance.currentUser.reload() != null
      Timer(
        Duration(milliseconds: 1),
        () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false),
      );
    } else {
      Timer(Duration(milliseconds: 1),
          () => Navigator.pushReplacementNamed(context, "/login"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
