import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends ChangeNotifier {
  Timer? _timer;
  int timeLeft = 10; // Default time in seconds
  final int maxTime;
  final VoidCallback onTimeUp;

  GameTimer({this.maxTime = 10, required this.onTimeUp}) {
    resetTimer();
  }

  void startTimer() {
    _timer?.cancel();
    timeLeft = maxTime;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        notifyListeners();
      } else {
        timer.cancel();
        onTimeUp();
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    timeLeft = maxTime;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
