import 'package:audioplayer/provider/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../provider/audio_playing_provider.dart';

class AudioRecorderPage extends StatelessWidget {
  const AudioRecorderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  String? twoDigitSeconds;
  String? twoDigitMinutes;
  TextEditingController _textFieldController = TextEditingController(
      text: AudioRecorderProvider().generateUniqueFileName());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AudioRecorderProvider>();
      provider.initRecorder(context);
      provider.initAudioRecordingsBox();
    });
  }

  @override
  void dispose() {
    recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AudioRecorderProvider>();
    final audioPlayerProvider = Provider.of<AudioPlayerProvider>(context);
    audioPlayerProvider.initializeAudioPlayer();
    // final isRecording = provider.recorder?.isRecording ?? false;
    if (provider.recorder == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFD6E3EB),
        body: Center(
          child: Column(
            children: [
              const Text(
                  'Turn on permmsion of microphone and restart the application'),
              ElevatedButton(
                  onPressed: () {
                    openAppSettings();
                  },
                  child: const Text('Open Settings')),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFD6E3EB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(image: AssetImage('asset/mic.png'))),
              // child: Image.asset('asset/mic.png'),
            ),
            StreamBuilder<RecordingDisposition>(
              builder: (context, snapshot) {
                final duration =
                    snapshot.hasData ? snapshot.data!.duration : Duration.zero;

                String twoDigits(int n) => n.toString().padLeft(2, '0');
                twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

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
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () async {
                final ispause = context.read<AudioRecorderProvider>().isPaused;
                if (ispause) {
                  await context.read<AudioRecorderProvider>().resumeRecording();
                } else {
                  await context.read<AudioRecorderProvider>().pauseRecording();
                }
              },
              child: Text(
                context.watch<AudioRecorderProvider>().recorder!.isPaused
                    ? 'Resume'
                    : "Pause",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: context.read<AudioRecorderProvider>().visible,
              child: ElevatedButton(
                onPressed: audioPlayerProvider.isPlaying
                    ? audioPlayerProvider.stopAudio
                    : () => audioPlayerProvider
                        .playAudio(provider.filePath.toString()),
                child: const Text(
                  'Play Audio',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Visibility(
              visible: context.read<AudioRecorderProvider>().visible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final audioprovider = Provider.of<AudioRecorderProvider>(
                          context,
                          listen: false);
                      audioprovider.audioSave(
                          context
                              .read<AudioRecorderProvider>()
                              .generateUniqueFileName(),
                          twoDigitMinutes.toString(),
                          twoDigitSeconds.toString());

                      audioprovider.navigateToPage(context);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Recording is saved'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showAlertDialog(context);
                    },
                    child: const Text(
                      'Rename',
                      style: TextStyle(color: Colors.black),
                    ),
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
                      context
                          .read<AudioRecorderProvider>()
                          .navigateToPage(context);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    final audioprovider =
        Provider.of<AudioRecorderProvider>(context, listen: false);
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
              onPressed: () {
                audioprovider.audioSave(_textFieldController.text,
                    twoDigitMinutes.toString(), twoDigitSeconds.toString());
                audioprovider.navigateToPage(context);

                //  context.read<AudioRecorderProvider>().renameHiveDatabase('', _textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
