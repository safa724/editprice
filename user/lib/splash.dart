import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/loginscreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds (adjust the duration as needed)
    Timer(Duration(seconds: 3), () {
      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (BuildContext scaffoldContext) {
            return Container(
          
        child: Center(
        child: Container(
          height: 150,
          width: 150,
          child: Image.asset('images/logo.png')),
        ),
      );
          }
      )  
    );
  }
}
