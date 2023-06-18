//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/audio_playing_provider.dart';

class AudioPlayerPage extends StatelessWidget {
  final String audioFilePath;
  final String title;

  const AudioPlayerPage({
    Key? key,
    required this.audioFilePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    audioPlayerProvider.initializeAudioPlayer(); // Initialize the audio player

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
                borderRadius: BorderRadius.circular(100),
                color: Colors.blue,
              ),
              child: Image.asset(
                'asset/images.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: audioPlayerProvider.isPlaying
                  ? audioPlayerProvider.stopAudio
                  : () => audioPlayerProvider.playAudio(audioFilePath),
              child: Icon(
                audioPlayerProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
