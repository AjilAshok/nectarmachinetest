import 'dart:io';
import 'package:audioplayer/screens/audio_playing.dart';
import 'package:audioplayer/screens/audio_record/audio_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/audio_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final audioRecordingsProvider = AudioRecorderProvider();
    audioRecordingsProvider.fetchAudioRecordings();

    return ChangeNotifierProvider.value(
      value: audioRecordingsProvider,
      child: Consumer<AudioRecorderProvider>(builder: (context, value, child) {
        print(value.audioRecordings.length);
        if (value.audioRecordings.isEmpty) {
          return Scaffold(
            body: const Center(
              child: Text(
                'No Recors',
                style: TextStyle(color: Colors.black),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AudioRecorderPage()),
                );
              },
              child: const Icon(Icons.mic),
            ),
          );
        }
        // final audioRecordings = audioRecordingsProvider.audioRecordings;

        return Scaffold(
          body: ListView.builder(
            itemCount: value.audioRecordings.length,
            itemBuilder: (context, index) {
              final audioRecording = value.audioRecordings[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioPlayerPage(
                        audioFilePath: audioRecording.path,
                        title: audioRecording.name,
                      ),
                    ),
                  );
                },
                title: Text(audioRecording.name),
                subtitle: Row(
                  children: [
                    // Text('size'),
                    sizedOfaudio(audioRecording.path),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                        '${audioRecording.minutues}:${audioRecording.seconds}'),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    _showAlertDialog(
                        context, audioRecording.name, value, index);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Navigate to the audio recording screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AudioRecorderPage()),
              );
            },
            child: const Icon(Icons.mic),
          ),
        );
      }),
    );
  }

  sizedOfaudio(audioFile) {
    File file = File(audioFile);
    int fileSize = file.lengthSync();
    double sizeInKB = fileSize / 1024;
    double sizeInMB = sizeInKB / 1024;
    return Text('${sizeInMB.toStringAsFixed(2)} MB');
  }

  void _showAlertDialog(BuildContext context, String name,
      AudioRecorderProvider value, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure'),
          content: Text('Do you want to delete the $name'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  value.deleteAudioRecording(index);

                  Navigator.of(context).pop();
                }),
          ],
        );
      },
    );
  }
}
