import 'package:flutter/material.dart';
import 'package:midterm_project/splashscreen_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'word_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username') ?? '';

  runApp(
    ChangeNotifierProvider(
      create: (context) => WordState(),
      child: MyApp(username: username),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String username;

  const MyApp({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vocabulary App',
      home: SplashScreen(),
    );
  }
}
