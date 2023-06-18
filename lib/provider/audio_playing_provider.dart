import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class AudioPlayerProvider extends ChangeNotifier {
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> initializeAudioPlayer() async {
    await _player.openPlayer();
    _player.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future<void> playAudio(String audioFilePath) async {
    try {
      await _player.startPlayer(fromURI: audioFilePath);
      _isPlaying = true;
      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await _player.stopPlayer();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }
}
