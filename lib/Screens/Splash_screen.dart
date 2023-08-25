import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp_codesoft/Screens/TodoPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _MySplashScreen();
}

class _MySplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoPage()));
    });
  }

  Widget build(BuildContext context) {
    return Material(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/Todoimage.png",
              scale: 7,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Welcome to make todo list",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ]),
    );
  }
}
