import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mirror_image_game/sound_manager.dart';
import 'package:mirror_image_game/timer.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with SingleTickerProviderStateMixin {
  int score = 0;
  int currentIndex = 0;
  int hintCount = 3; // Number of hints available
  bool showHint = false; // To show the highlighted answer

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

    // Start background music
    SoundManager.playBackgroundMusic();
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
      Vibration.vibrate(duration: 100); // short vibration for rigth answer
      setState(() {
        score += 10;
      });
    } else {
      SoundManager.playWrongSound();
      Vibration.vibrate(duration: 300); // longer vibration for wrong answer
      setState(() {
        score = max(0, score - 5);
      });
    }

    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          isCorrect ? "✔ Correct! +10 points 🎉" : "❌ Wrong! -5 points 😕",
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

  void useHint() {
    if (hintCount > 0) {
      setState(() {
        showHint = true;
        hintCount--;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            showHint = false;
          });
        }
      });
    } else {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text("No hints left!"),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  void dispose() {
    gameTimer.stopTimer();
    _animationController.dispose();
    SoundManager.dispose();
    super.dispose();
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: const Color.fromARGB(255, 248, 247, 152),
          title: const Text(
            "Exit Game?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to exit?",
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "No",
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Exits game screen
              },
              child: const Text(
                "Yes",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
                const Positioned(
                  top: 30,
                  left: 50,
                  child: Icon(Icons.star, color: Colors.yellow, size: 40),
                ),
                const Positioned(
                  top: 120,
                  right: 30,
                  child: Icon(Icons.star, color: Colors.orange, size: 30),
                ),
                const Positioned(
                  bottom: 100,
                  left: 20,
                  child: Icon(Icons.cloud, color: Colors.white, size: 50),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.emoji_events,
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

                          // Buttons Row
                          Row(
                            children: [
                              // Sound Effects Toggle Button
                              IconButton(
                                icon: Icon(
                                  SoundManager.soundEnabled
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                ),
                                iconSize: 32,
                                tooltip: "Toggle Sound Effects",
                                onPressed: () {
                                  setState(() {
                                    SoundManager.toggleSoundEffects();
                                  });
                                },
                              ),

                              // Background Music Toggle Button
                              IconButton(
                                icon: Icon(
                                  SoundManager.musicEnabled
                                      ? Icons.music_note
                                      : Icons.music_off,
                                  color: Colors.white,
                                ),
                                iconSize: 32,
                                tooltip: "Toggle Background Music",
                                onPressed: () {
                                  setState(() {
                                    SoundManager.toggleBackgroundMusic();
                                  });
                                },
                              ),

                              // Exit Button
                              IconButton(
                                icon: const Icon(Icons.exit_to_app,
                                    color: Colors.red),
                                iconSize: 32,
                                tooltip: "Exit Game",
                                onPressed: () {
                                  _showExitConfirmationDialog();
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.hourglass_bottom,
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
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: useHint,
                        icon: const Icon(Icons.lightbulb_outline,
                            color: Colors.yellow),
                        label: Text("Hint ($hintCount left)"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellowAccent
                                  .withOpacity(0.8), // Glowing effect color
                              blurRadius: 20, // Intensity of the glow
                              spreadRadius: 5, // How far it spreads
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: gameData[currentIndex]['options']
                            .map<Widget>((option) {
                          bool isCorrect =
                              option == gameData[currentIndex]['correct'];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0), // Space between options
                            child: GestureDetector(
                              onTap: () => checkAnswer(option),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: showHint && isCorrect
                                          ? Colors.green
                                          : Colors.yellow,
                                      width: showHint && isCorrect ? 6 : 3),
                                  borderRadius: BorderRadius.circular(
                                      15), // Rounded corners
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2), // Adds depth
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      12), // Match border radius
                                  child: Image.asset(option,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
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
