// import 'package:audioplayer/screens/homescreen/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// // import '../../constant/constant.dart';
// import '../../db/audios.dart';

// class AudioRecorderPage extends StatefulWidget {
//   const AudioRecorderPage({Key? key}) : super(key: key);

//   @override
//   State<AudioRecorderPage> createState() => _AudioRecorderPageState();
// }

// class _AudioRecorderPageState extends State<AudioRecorderPage> {
//   @override
//   void initState() {
//     initRecorder();
//     initAudioRecordingsBox();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     recorder.closeRecorder();
//     super.dispose();
//   }

//   final recorder = FlutterSoundRecorder();
//   Box<AudioRecording>? _audioRecordingsBox;
//   TextEditingController _textFieldController = TextEditingController();

//   String? timer = '';
//   String? filePath;

//   Future initRecorder() async {
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw 'Permission not granted';
//     }
//     await recorder.openRecorder();
//     recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }

//   Future startRecord() async {
//     await recorder.startRecorder(toFile: "audio");
//   }

//   Future stopRecorder() async {
//     filePath = await recorder.stopRecorder();

//     setState(() {});
//   }

//   Future<void> initAudioRecordingsBox() async {
//     final appDocumentDir = await getApplicationDocumentsDirectory();
//     Hive.init(appDocumentDir.path);
//     _audioRecordingsBox =
//         await Hive.openBox<AudioRecording>('audio_recordings');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // backgroundColor: Colors.teal.shade700,
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           StreamBuilder<RecordingDisposition>(
//             builder: (context, snapshot) {
//               final duration =
//                   snapshot.hasData ? snapshot.data!.duration : Duration.zero;

//               String twoDigits(int n) => n.toString().padLeft(2, '0');

//               final twoDigitMinutes =
//                   twoDigits(duration.inMinutes.remainder(60));
//               final twoDigitSeconds =
//                   twoDigits(duration.inSeconds.remainder(60));
//               // setState(() {
//               timer = twoDigitMinutes;
//               // });

//               return Text(
//                 '$twoDigitMinutes:$twoDigitSeconds',
//                 style: const TextStyle(
//                   color: Colors.black,
//                   fontSize: 50,
//                   fontWeight: FontWeight.bold,
//                 ),
//               );
//             },
//             stream: recorder.onProgress,
//           ),
//           const SizedBox(height: 50),
//           ElevatedButton(
//             onPressed: () async {
//               if (recorder.isRecording) {
//                 await stopRecorder();
//                 setState(() {});
//               } else {
//                 await startRecord();
//                 setState(() {});
//               }
//             },
//             child: Icon(
//               recorder.isRecording ? Icons.stop : Icons.mic,
//             ),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton(
//                   onPressed: () {
//                     audioSave();
//                   },
//                   child: const Text('Save')),
//               ElevatedButton(
//                   onPressed: () {
//                     _showAlertDialog(context);
//                   },
//                   child: const Text('Rename')),
//               ElevatedButton(
//                   onPressed: () {
//                     final audioRecordings = _audioRecordingsBox!.values;
//                     _audioRecordingsBox!.delete(audioRecordings);
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => HomePage(),
//                     ));
//                   },
//                   child: const Text('Delete'))
//             ],
//           )
//         ],
//       ),
//     ));
//   }

//   String generateUniqueFileName() {
//     final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     final String uniqueId = UniqueKey().toString();
//     return 'recording_$timestamp-$uniqueId.wav';
//   }

//   audioSave() async {
//     filePath = await recorder.stopRecorder();
//     setState(() {
//       final audioRecording = AudioRecording(
//           name: generateUniqueFileName(), path: filePath.toString());

//       _audioRecordingsBox!.add(audioRecording);

//       _textFieldController.text = generateUniqueFileName();
//       Navigator.of(context).pop();
//     });
//   }

//   void _showAlertDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Enter a Value'),
//           content: TextField(
//             controller: _textFieldController,
//             decoration: InputDecoration(hintText: 'Default Value'),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('OK'),
//               onPressed: () async {},
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:audioplayer/provider/audio_provider.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:provider/provider.dart';

class AudioRecorderPage extends StatelessWidget {
  const AudioRecorderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return ChangeNotifierProvider(
      create: (context) => AudioRecorderProvider(),
      builder: (context, _) {
        return _AudioRecorderPage();
      },
    );
  }
}

class _AudioRecorderPage extends StatefulWidget {
  @override
  _AudioRecorderPageState createState() => _AudioRecorderPageState();
}

class _AudioRecorderPageState extends State<_AudioRecorderPage> {
  FlutterSoundRecorder? recorder;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recorder = FlutterSoundRecorder();
    context.read<AudioRecorderProvider>().initRecorder();
    context.read<AudioRecorderProvider>().initAudioRecordingsBox();
  }

  @override
  void dispose() {
    recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;
                String twoDigits(int n) => n.toString().padLeft(2, '0');
                final twoDigitMinutes =
                    twoDigits(duration.inMinutes.remainder(60));
                final twoDigitSeconds =
                    twoDigits(duration.inSeconds.remainder(60));

                return Text(
                  '$twoDigitMinutes:$twoDigitSeconds',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              stream:
                  context.watch<AudioRecorderProvider>().recorder?.onProgress,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final isRecording =
                    context.read<AudioRecorderProvider>().recorder!.isRecording;
                if (isRecording) {
                  await context.read<AudioRecorderProvider>().stopRecorder();
                } else {
                  await context.read<AudioRecorderProvider>().startRecorder();
                }
              },
              child: Icon(
                context.watch<AudioRecorderProvider>().recorder!.isRecording
                    ? Icons.stop
                    : Icons.mic,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    Provider.of<AudioRecorderProvider>(context, listen: false)
                        .audioSave();
                         Provider.of<AudioRecorderProvider>(context, listen: false)
                        .navigateToPage(context);
                  },
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAlertDialog(context);
                  },
                  child: const Text('Rename'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final audioRecordings = context
                        .read<AudioRecorderProvider>()
                        .audioRecordingsBox
                        ?.values;
                    context
                        .read<AudioRecorderProvider>()
                        .audioRecordingsBox
                        ?.deleteAll(audioRecordings!);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a Value'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Default Value'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {},
            ),
          ],
        );
      },
    );
  }
}
