import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mirror_image_game/sound_manager.dart';
import 'package:mirror_image_game/timer.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameTimer(
        maxTime: 10,
        onTimeUp: () {}, // Temporary placeholder, it will be overridden
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const QuestionsPage(),
      ),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentIndex = 0;
  late AnimationController _animationController;
  late GameTimer gameTimer;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

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
    {
      'original': 'assets/images/img3.jpg',
      'options': [
        'assets/images/WrongImg3.jpg',
        'assets/images/WrongImg3(1).jpg',
        'assets/images/RigthImg3.jpg'
      ],
      'correct': 'assets/images/RigthImg3.jpg',
    },
    {
      'original': 'assets/images/img4.jpg',
      'options': [
        'assets/images/WrongImg4.jpg',
        'assets/images/WrongImg4(1).jpg',
        'assets/images/RigthImg4.jpg'
      ],
      'correct': 'assets/images/RigthImg4.jpg',
    },
    {
      'original': 'assets/images/img5.jpg',
      'options': [
        'assets/images/WrongImg5.jpg',
        'assets/images/WrongImg5(1).jpg',
        'assets/images/RigthImg5.jpg'
      ],
      'correct': 'assets/images/RigthImg5.jpg',
    },
    {
      'original': 'assets/images/img6.jpg',
      'options': [
        'assets/images/WrongImg6.jpg',
        'assets/images/WrongImg6(1).jpg',
        'assets/images/RigthImg6.jpg'
      ],
      'correct': 'assets/images/RigthImg6.jpg',
    },
    {
      'original': 'assets/images/img7.jpg',
      'options': [
        'assets/images/WrongImg7.jpg',
        'assets/images/WrongImg7(1).jpg',
        'assets/images/RigthImg7.jpg'
      ],
      'correct': 'assets/images/RigthImg7.jpg',
    },
    {
      'original': 'assets/images/img8.jpg',
      'options': [
        'assets/images/WrongImg8.jpg',
        'assets/images/WrongImg8(1).jpg',
        'assets/images/RigthImg8.jpg'
      ],
      'correct': 'assets/images/RigthImg8.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    shuffleQuestionsAndOptions(); // for shuffle questions
    // shuffleOptions(); // for shuffle options

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    gameTimer = GameTimer(
      maxTime: 10,
      onTimeUp: handleTimeUp,
    );

    gameTimer.startTimer();
  }

  void shuffleQuestionsAndOptions() {
    setState(() {
      gameData.shuffle(); // question shuffles randomly

      for (var question in gameData) {
        question['options'].shuffle(); // Shuffle the options for each question
      }

      currentIndex = 0; // reset to first after shuffling
    });
  }

  void handleTimeUp() {
    if (mounted) {
      setState(() {
        currentIndex = (currentIndex + 1) % gameData.length;
        if (currentIndex == 0) {
          shuffleQuestionsAndOptions(); // Reshuffle after all questions are completed
        } else {
          gameData[currentIndex]['options'].shuffle();
        }
        _animationController.reset();
        _animationController.forward();
        gameTimer.startTimer();
      });
    }
  }

  void checkAnswer(String selectedImage) {
    bool isCorrect = selectedImage == gameData[currentIndex]['correct'];

    if (isCorrect) {
      SoundManager.playCorrectSound();
      setState(() {
        score += 10;
      });
    } else {
      SoundManager.playWrongSound();
      setState(() {
        score = max(0, score - 5);
      });
    }

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

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % gameData.length;
          shuffleQuestionsAndOptions();
          gameTimer.startTimer();
          _animationController.reset();
          _animationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    gameTimer.stopTimer();
    _animationController.dispose();
    SoundManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameTimer,
      child: ScaffoldMessenger(
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
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                /// Timer Display
                Consumer<GameTimer>(
                  builder: (context, timer, child) {
                    return Text(
                      "Time Left: ${timer.timeLeft}s",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    );
                  },
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
      ),
    );
  }
}
