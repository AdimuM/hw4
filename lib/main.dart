import 'package:flutter/material.dart';
import 'package:hw4/screen2.dart';
import 'package:hw4/screen3.dart';
import 'package:hw4/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Homework 4',
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/second': (context) => SecondScreen(),
          '/third': (context) => ThirdScreen(),
        }
    );
  }
}