import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midterm_project/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LogInPage()));
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Color(0xFFA8D1E7),
              Color(0xFFFCFAF2),
              Color(0xFFFFBFC5),
              Color(0xFFEB8DB5),
              Color(0xFFD4A3C4),
              Color(0xFFA8D1E7),
            ],
            center: Alignment.center,
            startAngle: 0.0,
            endAngle: 3.14 * 2,
          ),
        ),
        child: const Center(
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
              SizedBox(
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
