import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';

class AudioPlayerProvider extends ChangeNotifier {
  FlutterSoundPlayer player = FlutterSoundPlayer();
  bool _isPlaying = false;
  double _sliderValue = 0.0;
  int currentPosition = 0;

  double get sliderValue => _sliderValue;

  Duration? duration;

  AudioPlayer? audioPlayer;

  bool get isPlaying => _isPlaying;

  Future<void> initializeAudioPlayer() async {
    await player.openPlayer();

    player.setSubscriptionDuration(Duration(milliseconds: 500));
    audioPlayer = AudioPlayer();
  }

  Future<void> playAudio(String audioFilePath) async {
    try {
      await player.startPlayer(fromURI: audioFilePath);
      audioPlayer!.setSource(UrlSource(audioFilePath));

      _isPlaying = true;

      notifyListeners();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      await player.stopPlayer();
      duration = await audioPlayer!.getDuration();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  @override
  void dispose() {
    player.closePlayer();
    audioPlayer!.dispose();
    super.dispose();
  }

  void setSliderValue(double value) {
    _sliderValue = value;
    notifyListeners();
  }
}
