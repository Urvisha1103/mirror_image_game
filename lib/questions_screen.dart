import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mirror_image_game/sound_manager.dart';
import 'package:mirror_image_game/timer.dart';
import 'package:provider/provider.dart';

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
    shuffleQuestionsAndOptions();

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
      gameData.shuffle();
      for (var question in gameData) {
        question['options'].shuffle();
      }
      currentIndex = 0;
    });
  }

  void handleTimeUp() {
    if (mounted) {
      setState(() {
        currentIndex = (currentIndex + 1) % gameData.length;
        if (currentIndex == 0) {
          shuffleQuestionsAndOptions();
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
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightBlueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                /// **Decorative Background Elements**
                Positioned(
                  top: 30,
                  left: 50,
                  child: Icon(Icons.star, color: Colors.yellow, size: 40),
                ),
                Positioned(
                  top: 120,
                  right: 30,
                  child: Icon(Icons.star, color: Colors.orange, size: 30),
                ),
                Positioned(
                  bottom: 100,
                  left: 20,
                  child: Icon(Icons.cloud, color: Colors.white, size: 50),
                ),
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: Icon(Icons.cloud, color: Colors.white70, size: 60),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      /// **Score & Timer Row**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.emoji_events,
                                  color: Colors.amber, size: 30),
                              const SizedBox(width: 8),
                              Text(
                                "Score: $score",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.hourglass_bottom,
                                  color: Colors.yellow, size: 30),
                              const SizedBox(width: 8),
                              Consumer<GameTimer>(
                                builder: (context, timer, child) {
                                  return Text(
                                    "${timer.timeLeft}s",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// **Question Image**
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 6),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.7),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            gameData[currentIndex]['original'],
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// **Options**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: gameData[currentIndex]['options']
                            .map<Widget>((option) {
                          return GestureDetector(
                            onTap: () => checkAnswer(option),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  splashColor:
                                      Colors.yellowAccent.withOpacity(0.5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.yellow, width: 3),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.orangeAccent
                                              .withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        option,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
