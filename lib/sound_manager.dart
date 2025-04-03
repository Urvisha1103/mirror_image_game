import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _bgPlayer = AudioPlayer();
  static bool soundEnabled = true; // Toggle for sound effects
  static bool musicEnabled = true; // Toggle for background music

  static Future<void> playCorrectSound() async {
    if (soundEnabled) {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/Correct.mp3'));
    }
  }

  static Future<void> playWrongSound() async {
    if (soundEnabled) {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/Wrong.mp3'));
    }
  }

  static Future<void> playBackgroundMusic() async {
    if (musicEnabled) {
      await _bgPlayer.setReleaseMode(ReleaseMode.loop); // Loop music
      await _bgPlayer.setVolume(0.0); // Start from zero volume
      await _bgPlayer.play(AssetSource('sounds/Background.mp3'));

      // Gradually increase volume (fade-in effect)
      for (double volume = 0.0; volume <= 1.0; volume += 0.1) {
        await Future.delayed(Duration(milliseconds: 100));
        await _bgPlayer.setVolume(volume);
      }
    }
  }

  static Future<void> stopBackgroundMusic() async {
    // Gradually decrease volume (fade-out effect)
    for (double volume = 1.0; volume >= 0.0; volume -= 0.1) {
      await Future.delayed(Duration(milliseconds: 100));
      await _bgPlayer.setVolume(volume);
    }
    await _bgPlayer.stop();
  }

  static void toggleSoundEffects() {
    soundEnabled = !soundEnabled;
  }

  static void toggleBackgroundMusic() {
    musicEnabled = !musicEnabled;
    if (musicEnabled) {
      playBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
  }

  static void dispose() {
    _bgPlayer.dispose();
  }
}
