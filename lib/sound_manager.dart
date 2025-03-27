import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static Future<void> playCorrectSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/Correct.mp3'));
  }

  static Future<void> playWrongSound() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/Wrong.mp3'));
  }

  static void dispose() {
    // No need to dispose since we create new instances per sound
  }
}
