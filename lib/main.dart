import 'package:audioplayer/provider/audio_playing_provider.dart';
import 'package:audioplayer/provider/audio_provider.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'db/audios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<AudioRecording>(AudioRecordingAdapter());
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.openBox<AudioRecording>('audio_recordings',
      path: '${appDocumentDir.path}/hive.db');
  final audioRecordingsProvider = AudioRecorderProvider();
  await audioRecordingsProvider.fetchAudioRecordings();

  runApp(ChangeNotifierProvider(
      create: (_) => AudioPlayerProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage());
  }
}
