import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioFilePath;

  AudioPlayerPage({required this.audioFilePath});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _initializeAudioPlayer() async {
    await _player.openPlayer();
    _player.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future<void> _playAudio() async {
    try {
      await _player.startPlayer(fromURI: widget.audioFilePath);
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _player.stopPlayer();
      setState(() {
        _isPlaying = false;
      });
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'asset/images.png',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blue),
              // child: Image.asset('asset/disc.jpg'),
            ),
            // Icon(
            //   _isPlaying ? Icons.volume_up : Icons.volume_off,
            //   size: 100,
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPlaying ? _stopAudio : _playAudio,
              child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }
}