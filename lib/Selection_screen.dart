import 'package:flutter/material.dart';
import 'package:mirror_image_game/waterRef_question.dart';
import 'questions_screen.dart'; // Import your existing game screen

class ReflectionSelectionScreen extends StatelessWidget {
  const ReflectionSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Choose Your Reflection!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Comic Sans MS',
                ),
              ),
              const SizedBox(height: 40),

              // Mirror Reflection Button
              _buildOptionButton(
                context,
                "Mirror Reflection",
                Icons.flip,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuestionsPage()),
                ),
              ),

              const SizedBox(height: 20),

              // Water Reflection Button
              _buildOptionButton(
                context,
                "Water Reflection",
                Icons.water,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WaterrefQuestion()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.yellowAccent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.deepPurple, size: 30),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
