import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mirror_image_game/questions_screen.dart';

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Scale Animation (Bouncy effect)
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _scaleAnimation =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);

    // Fade Animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    // Navigate to the game screen after animation
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const QuestionsPage()),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCCDFF3), // Light blue background
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/splash.png', 
                  width: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'ReflectIQ',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001858),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
