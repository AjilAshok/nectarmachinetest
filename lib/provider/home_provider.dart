// import 'package:audioplayer/db/audios.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:hive/hive.dart';

// class AudioRecordingsProvider extends ChangeNotifier {
//   List<AudioRecording> audioRecordings = [];
//   FlutterSoundRecorder? recorder;
//   Box<AudioRecording>? audioRecordingsBox;

//   void addAudioRecording(AudioRecording audioRecording) {
//     audioRecordings.add(audioRecording);
//     notifyListeners();
//   }

//   void deleteAudioRecording(int index) async {
//     final audioRecording = audioRecordings[index];
//     final audioRecordingsBox = Hive.box<AudioRecording>('audio_recordings');
//     await audioRecordingsBox.delete(audioRecording.key);
//     audioRecordings.removeAt(index);
//     notifyListeners();
//   }

//   Future<void> fetchAudioRecordings() async {
//     final audioRecordingsBox = Hive.box<AudioRecording>('audio_recordings');
//     audioRecordings = audioRecordingsBox.values.toList();
//     notifyListeners();
//   }
//     String generateUniqueFileName() {
//     final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
//     final String uniqueId = UniqueKey().toString();
//     return 'recording_$timestamp-$uniqueId.wav';
//   }

//   // Future<void> audioSave() async {
//   //   final filePath = await recorder?.stopRecorder();
//   //   final audioRecording = AudioRecording(
//   //     name: generateUniqueFileName(),
//   //     path: filePath.toString(),
//   //   );
//   //   audioRecordingsBox?.add(audioRecording);
//   //   notifyListeners();
//   //   // Navigator.of(
//   //   //   navigatorKey.currentContext!,
//   //   // ).push(MaterialPageRoute(
//   //   //   builder: (context) => HomePage(),
//   //   // ));
//   // }
  
// }
