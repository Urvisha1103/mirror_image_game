import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mirror_image_game/animation_widget.dart';
import 'package:mirror_image_game/splash_screen.dart';
import 'package:mirror_image_game/questions_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReflectIQ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
