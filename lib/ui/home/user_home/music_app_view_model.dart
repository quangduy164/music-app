import 'dart:async';

import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();
  //Tải dữ liệu từ repository vào StreamControler
  void loadSong(){
    final repository = DefaultSongRepository();
    repository.loadData().then((onValue) => songStream.add(onValue!));

  }
}