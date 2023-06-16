

import 'package:hive/hive.dart';
part 'audios.g.dart';

@HiveType(typeId: 0)
class AudioRecording extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String path;

  AudioRecording({
    required this.name,
    required this.path,
  });
}
