import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSendMessageSound() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('send_message.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      developer.log("⚠️ Audio Playback Error: $e", name: "AUDIO");
    }
  }

  Future<void> playNotificationSound() async {
    try {
      await _player.stop();
      // Reuse send_message.mp3 as it's the only one available
      await _player.play(AssetSource('send_message.mp3'), mode: PlayerMode.lowLatency);
    } catch (e) {
      developer.log("⚠️ Audio Playback Error: $e", name: "AUDIO");
    }
  }

  void dispose() {
    _player.dispose();
  }
}
