import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuestionsPage(),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  int score = 0;
  int currentIndex = 0;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Game images (original, options, correct answer)
  List<Map<String, dynamic>> gameData = [
    {
      'original': 'assets/images/img1.jpg',
      'options': [
        'assets/images/WrongImg1.jpg',
        'assets/images/RigthImg1.jpg',
        'assets/images/WrongImg1(1).jpg'
      ],
      'correct': 'assets/images/RigthImg1.jpg',
    },
    {
      'original': 'assets/images/img2.jpg',
      'options': [
        'assets/images/WrongImg2.jpg',
        'assets/images/WrongImg2(2).jpg',
        'assets/images/RigthImg2.jpg'
      ],
      'correct': 'assets/images/RigthImg2.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    shuffleOptions();
  }

  void shuffleOptions() {
    setState(() {
      gameData[currentIndex]['options'].shuffle();
    });
  }

  void checkAnswer(String selectedImage) {
    bool isCorrect = selectedImage == gameData[currentIndex]['correct'];

    setState(() {
      score = isCorrect ? score + 10 : max(0, score - 5);
    });

    // Show feedback message
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? "✔ Correct! +10 points" : "❌ Wrong! -5 points",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );

    // Wait 1.1 seconds before moving to the next question
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % gameData.length;
        });
        shuffleOptions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ReflectIQ"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Score : $score",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Image.asset(gameData[currentIndex]['original'],
                  width: 200, height: 200),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    gameData[currentIndex]['options'].map<Widget>((option) {
                  return GestureDetector(
                    onTap: () => checkAnswer(option),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(option, width: 100, height: 100),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
