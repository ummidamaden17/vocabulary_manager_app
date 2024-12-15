import 'dart:async';

import 'package:flutter/material.dart';

import 'familiar_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NameEntryScreen()));
    });
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color(0xFFA8D1E7), // Light Blue
              Color(0xFFFCFAF2), // Off White
              Color(0xFFFFBFC5), // Light Pink
              Color(0xFFEB8DB5), // Soft Magenta
              Color(0xFFD4A3C4), // Lavender
              Color(0xFFA8D1E7), // Repeat first color for a seamless loop
            ],
            center: Alignment.center,
            startAngle: 0.0,
            endAngle: 3.14 * 2, // Full circle
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '   Welcome\nto My Words!',
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily: 'Nunito'),
              ),
              Container(
                width: 250,
                height: 250,
                child: Image(image: AssetImage('assets/images/logo.png')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
