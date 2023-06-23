//
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../provider/audio_playing_provider.dart';

class AudioPlayerPage extends StatefulWidget {
  final String audioFilePath;
  final String title;
  final String min;
  final String sec;

  const AudioPlayerPage(
      {Key? key,
      required this.audioFilePath,
      required this.title,
      required this.min,
      required this.sec})
      : super(key: key);

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  double currentPosition = 00.00;
  @override
  Widget build(BuildContext context) {
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    audioPlayerProvider.initializeAudioPlayer(); // Initialize the audio player

    return Scaffold(
      backgroundColor: const Color(0xFFD6E3EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6E3EB),
        title: const Text('Audio Player'),
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
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            Slider.adaptive(
                inactiveColor: Colors.white,
                activeColor: Colors.black,
                value: currentPosition,
                min: 0.0,
                max: 10,
                onChanged: (value) {
                  onSliderChanged(value);
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '00:00',
                    style: const TextStyle(color: Colors.black),
                  ),
                  Text(
                    '${widget.min}:${widget.sec}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 80,
              width: 80,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: audioPlayerProvider.isPlaying
                    ? audioPlayerProvider.stopAudio
                    : () => audioPlayerProvider.playAudio(widget.audioFilePath),
                child: Center(
                  child: Icon(
                    audioPlayerProvider.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSliderChanged(double value) {
    setState(() {
      currentPosition = value;
    });
    // audioPlayer.seek((value * 1000).toInt()); // Convert to milliseconds
  }
}
