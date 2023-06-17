import 'package:audioplayer/provider/audio_provider.dart';
import 'package:audioplayer/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:provider/provider.dart';

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
                twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                print(twoDigitSeconds);
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
