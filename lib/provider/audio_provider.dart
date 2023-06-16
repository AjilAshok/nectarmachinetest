import 'package:audioplayer/db/audios.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderProvider with ChangeNotifier {
  FlutterSoundRecorder? recorder;
  Box<AudioRecording>? audioRecordingsBox;
  List<AudioRecording> audioRecordings = [];
  // final GlobalKey<NavigatorState> navigatorKey;
  // AudioRecorderProvider(this.navigatorKey);

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    recorder = FlutterSoundRecorder();
    await recorder!.openRecorder();
    recorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
    notifyListeners();
  }

  Future<void> startRecorder() async {
    await recorder?.startRecorder(toFile: "audio");
    notifyListeners();
  }

  Future<void> stopRecorder() async {
    await recorder?.stopRecorder();
    notifyListeners();
  }

  Future<void> initAudioRecordingsBox() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    audioRecordingsBox = await Hive.openBox<AudioRecording>('audio_recordings');
    notifyListeners();
  }

  String generateUniqueFileName() {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String uniqueId = UniqueKey().toString();
    return 'recording_$timestamp-$uniqueId.wav';
  }

  Future<void> audioSave() async {
    final filePath = await recorder?.stopRecorder();
    print(filePath);
    final audioRecording = AudioRecording(
      name: generateUniqueFileName(),
      path: filePath.toString(),
    );
    audioRecordingsBox?.add(audioRecording);
    initAudioRecordingsBox();

    notifyListeners();
    // Navigator.of(context).pop();
    // Navigator.of(
    //   navigatorKey.currentContext!,
    // ).push(MaterialPageRoute(
    //   builder: (context) => HomePage(),
    // ));
  }

  Future<void> fetchAudioRecordings() async {
    final audioRecordingsBox = Hive.box<AudioRecording>('audio_recordings');
    audioRecordings = audioRecordingsBox.values.toList();
    notifyListeners();
  }

  void deleteAudioRecording(int index) async {
    final audioRecording = audioRecordings[index];
    final audioRecordingsBox = Hive.box<AudioRecording>('audio_recordings');
    await audioRecordingsBox.delete(audioRecording.key);
    audioRecordings.removeAt(index);
    notifyListeners();
  }
   void navigateToPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
