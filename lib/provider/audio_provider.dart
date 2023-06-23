import 'package:audioplayer/db/audios.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class AudioRecorderProvider with ChangeNotifier {
  FlutterSoundRecorder? recorder;
  Box<AudioRecording>? audioRecordingsBox;
  List<AudioRecording> audioRecordings = [];

  String? filePath;
  bool isPaused = false;
  bool visible = false;

  Future<void> initRecorder(BuildContext context) async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission not granted.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
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
    filePath = await recorder?.stopRecorder();
    visible = true;
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
    return 'recording_$timestamp-$uniqueId.mp3';
  }

  Future<void> audioSave(
    String name,
    String min,
    String sec,
  ) async {
    filePath = await recorder?.stopRecorder();

    // await audioPlayer!.

    final audioRecording = AudioRecording(
      name: name,
      path: filePath.toString(),
      minutues: min,
      seconds: sec,
    );

    audioRecordingsBox?.add(audioRecording);
    initAudioRecordingsBox();
    notifyListeners();
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  shareMethod(path) async {
    final xFile = XFile(path);
    await Share.shareXFiles([xFile], text: 'audios');
    notifyListeners();
  }

  Future<void> pauseRecording() async {
    await recorder!.pauseRecorder();

    isPaused = true;
    notifyListeners();
  }

  Future<void> resumeRecording() async {
    await recorder!.resumeRecorder();

    isPaused = false;
    notifyListeners();
  }
}
