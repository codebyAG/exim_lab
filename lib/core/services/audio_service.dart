import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSendMessageSound() async {
    try {
      // Play from assets
      await _player.stop(); // Stop any currently playing sound
      await _player.play(AssetSource('send_message.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      developer.log("⚠️ Audio Playback Error: $e", name: "AUDIO");
    }
  }

  void dispose() {
    _player.dispose();
  }
}
