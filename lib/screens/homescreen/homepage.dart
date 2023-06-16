// import 'dart:io';

// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audioplayer/db/audios.dart';
// import 'package:audioplayer/screens/audio_playing.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import '../audio_record/audio_record_screen.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Box<AudioRecording>? audioRecordingsBox;

//   @override
//   void initState() {
//     super.initState();
//     // openBox();
//   }

//   Future<void> openBox() async {
//     await Hive.initFlutter();

//     audioRecordingsBox = await Hive.openBox<AudioRecording>('audio_recordings');

//     setState(() {}); // Trigger a rebuild after opening the box
//   }

//   Future fetchAudioDataFromHive() async {
//     final box = await Hive.openBox<AudioRecording>(
//         'audio_recordings'); // Replace 'audioBox' with the name of your Hive box

//     return box.values.toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: Hive.openBox<AudioRecording>('audio_recordings'),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Show a loading indicator while fetching data
//           } else if (snapshot.hasError) {
//             return Text(
//                 'Error: ${snapshot.error}'); // Show an error message if fetching data fails
//           } else {
//             final audioRecordingsBox =
//                 Hive.box<AudioRecording>('audio_recordings');
//             final audioRecordings = audioRecordingsBox.values.toList();

//             // Display the audio list using ListView.builder or any other widget
//             return ListView.builder(
//               itemCount: audioRecordings.length,
//               itemBuilder: (context, index) {
//                 final audioRecording = audioRecordings[index];
//                 return ListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             AudioPlayerPage(audioFilePath: audioRecording.path),
//                       ),
//                     );
//                   },
//                   title: Text(audioRecording.name),
//                   subtitle: Row(
//                     children: [
//                       // Text('size'),
//                       sizedOfaudio(audioRecording.path),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       const Text('00:00'),
//                     ],
//                   ),
//                   // leading: Text('duration'),
//                   trailing: IconButton(
//                       onPressed: () {
//                         audioRecordingsBox.delete(audioRecording.key);
//                       },
//                       icon: Icon(Icons.delete)),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AudioRecorderPage()),
//           );
//         },
//         child: Icon(Icons.mic),
//       ),
//     );
//   }
// }

// sizedOfaudio(audioFile) {
//   File file = File(audioFile);
//   int fileSize = file.lengthSync();
//   double sizeInKB = fileSize / 1024;
//   double sizeInMB = sizeInKB / 1024;
//   return Text('${sizeInMB.toStringAsFixed(2)} MB');
// }
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
                      builder: (context) =>
                          AudioPlayerPage(audioFilePath: audioRecording.path),
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
                    const Text('00:00'),
                  ],
                ),
                // leading: Text('duration'),
                trailing: IconButton(
                  onPressed: () {
                    value.deleteAudioRecording(index);
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
}
