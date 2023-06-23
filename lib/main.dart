import 'package:audioplayer/provider/audio_playing_provider.dart';
import 'package:audioplayer/provider/audio_provider.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'db/audios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<AudioRecording>(AudioRecordingAdapter());

  await Hive.openBox<AudioRecording>('audio_recordings');


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
      ChangeNotifierProvider(create: (_) => AudioRecorderProvider())
    ],
    child: MyApp(),
  ));
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
