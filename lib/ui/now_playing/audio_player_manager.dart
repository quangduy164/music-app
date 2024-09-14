import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'duration_state.dart';

class AudioPlayerManager {
  AudioPlayerManager._internal();
  static final AudioPlayerManager _instance = AudioPlayerManager._internal();
  String songUrl = '';
  final player = AudioPlayer();

  factory AudioPlayerManager() => _instance;

  Stream<DurationState>? durationState;

  void prepare() async{
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
            (position, playbackEvent) =>
            DurationState(progress: position,
                buffered: playbackEvent.bufferedPosition,
                total: playbackEvent.duration)
    );
    try {
      await player.setUrl(songUrl); // Thử thiết lập URL
    } catch (error) {
      print("Error setting song URL: $error"); // Log lỗi nếu có
    }
  }

  void updateSongUrl(String url){
    songUrl = url;
    prepare();
  }

  void dispose(){
    player.dispose();
  }
}