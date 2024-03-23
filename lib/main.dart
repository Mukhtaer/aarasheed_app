import 'package:aa_rasheed_data/screens/home_screen.dart';
import 'package:aa_rasheed_data/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AA Rasheed Data',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // Show the splash screen first
      routes: {
        '/main_screen': (context) => HomePage(), // Define your main screen
      },
    );
  }
}
