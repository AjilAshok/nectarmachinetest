import 'dart:io';
import 'package:audioplayer/screens/audio_playing_screen/audio_playing.dart';
import 'package:audioplayer/screens/audio_record/audio_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/audio_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AudioRecorderProvider>();
      provider.initRecorder(context);
      provider.initAudioRecordingsBox(); // Call the method to open the Hive box
    });

    super.initState();
  }

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

        return Scaffold(
          backgroundColor: const Color(0xFFD6E3EB),
          appBar: AppBar(
            backgroundColor: const Color(0xFFD6E3EB),
            centerTitle: true,
            title: const Text('Recordings'),
          ),
          body: ListView.builder(
            itemCount: value.audioRecordings.length,
            itemBuilder: (context, index) {
              final audioRecording = value.audioRecordings[index];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioPlayerPage(
                            audioFilePath: audioRecording.path,
                            title: audioRecording.name,
                            sec: audioRecording.seconds,
                            min: audioRecording.minutues,
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

                        TextButton(
                          onPressed: () async {
                            await AudioRecorderProvider()
                                .shareMethod(audioRecording.path);
                          },
                          child: const Text(
                            'Share',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _showAlertDialog(
                            context, audioRecording.name, value, index);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    leading: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xFFD6E3EB),
                          borderRadius: BorderRadius.circular(100)),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                    )),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
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
