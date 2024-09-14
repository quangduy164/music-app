import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/ui/now_playing/media_button_control.dart';
import 'package:share_plus/share_plus.dart';

import 'audio_player_manager.dart';
import 'duration_state.dart';

class NowPlayingPage extends StatefulWidget {
  final Song playingSong; //Bài hát hiện tại
  final List<Song> songs;

  NowPlayingPage({super.key, required this.songs, required this.playingSong});

  @override
  State<StatefulWidget> createState() {
    return _NowPlayingPageState();
  }
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController; //Đĩa ảnh
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex; //Vị trí hiện tại bài hát
  late Song _song; //Bài hát hiện tại
  late double _currentAnimationPosition = 0.0; //Vị trí đĩa ảnh hiện tại
  bool _isShuffle = false; //Kiểm tra có trộn bài hát không
  late LoopMode _loopMode; //Kiểm tra chế độ lặp
  bool _isFavorite = false;//Kiểm tra bài hát có phải yêu thích không

  @override
  void initState() {
    _song = widget.playingSong;
    _imageAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 12000));
    _audioPlayerManager = AudioPlayerManager();
    _audioPlayerManager.updateSongUrl(_song.source);
    _audioPlayerManager.prepare();
    _selectedItemIndex = widget.songs.indexOf(_song);
    _loopMode = LoopMode.off;
    _checkIfFavoriteSong();
    super.initState();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; //Chiều rộng màn hình
    const delta = 70; //Cách cạnh khoảng
    final radius = (screenWidth - delta) / 2; //Bán kính đĩa ảnh

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Now Playing'),
          trailing: IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ),
        child: Scaffold(
          body: Center(
              child: SingleChildScrollView(
                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                SizedBox(height: 50,),
                Text(_song.album, style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(
                  height: 8,
                ),
                const Text('_ ___ _'),
                const SizedBox(
                  height: 38,
                ),
                //Đĩa ảnh
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0)
                      .animate(_imageAnimationController),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/music_node.png',
                      image: _song.image,
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/music_node.png',
                          width: screenWidth - delta,
                          height: screenWidth - delta,
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          _shareSong();
                        },
                        icon: const Icon(Icons.share_outlined),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Column(
                        children: [
                          Text(_song.title,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(_song.artist,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .color))
                        ],
                      ),
                      IconButton(
                        onPressed: () async{
                          if(_isFavorite){
                            await SongRepository().removeSongFromFavorites(_song);
                          }
                          else{
                            await SongRepository().addSongToFavorites(_song);
                          }
                          _isFavorite = !_isFavorite;
                          _checkIfFavoriteSong();
                        },
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
                //Thanh tiến trình
                Padding(
                  padding:
                      EdgeInsets.only(top: 20, left: 24, right: 24, bottom: 8),
                  child: _progressBar(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: _mediaButtons(),
                )
                            ],
                          ),
              )),
        ));
  }

  Widget _mediaButtons() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
            function: _setShuffle,
            icon: Icons.shuffle,
            color: _getShuffleColor(),
            size: 24,
          ),
          MediaButtonControl(
            function: _setPreviousSong,
            icon: Icons.skip_previous,
            color: Theme.of(context).colorScheme.primary,
            size: 36,
          ),
          _playButton(),
          MediaButtonControl(
            function: _setNextSong,
            icon: Icons.skip_next,
            color: Theme.of(context).colorScheme.primary,
            size: 36,
          ),
          MediaButtonControl(
            function: _setRepeatOption,
            icon: _repeatingIcon(),
            color: _getRepeatingIconColor(),
            size: 24,
          ),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _progressBar() {
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context, snapshot) {
          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? Duration.zero;
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: _audioPlayerManager.player.seek,
            barHeight: 5.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withOpacity(0.3),
            progressBarColor: Colors.blueGrey,
            bufferedBarColor: Colors.grey,
            thumbColor: Colors.blueGrey,
          );
        });
  }

  StreamBuilder<PlayerState> _playButton() {
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          final playState = snapshot.data;
          final processingState = playState?.processingState;
          final playing = playState?.playing;
          //Dữ liệu đang được tải hoặc bộ đệm đang được lấp đầy
          if (processingState == ProcessingState.loading ||
              processingState == ProcessingState.buffering) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _pauseRotationAnimation();
            });
            return Container(
              margin: const EdgeInsets.all(8),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }
          //Nếu trình phát không ở trạng thái phát
          else if (playing != true) {
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.play();
                },
                icon: Icons.play_arrow,
                color: null,
                size: 48);
          }
          //Nếu trình đang phát nhưng chưa hoàn thành
          else if (processingState != ProcessingState.completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _playRotationAnimation();
            });
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.pause();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _pauseRotationAnimation();
                  });
                },
                icon: Icons.pause,
                color: null,
                size: 48);
          }
          //Nếu nhạc phát xong nhấn nút thì tua lại đầu bài hát
          else {
            if (processingState == ProcessingState.completed) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _stopRotationAnimation();
                _resetRotationAnimation();
              });
            }
            return MediaButtonControl(
                function: () {
                  _audioPlayerManager.player.seek(Duration.zero);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _resetRotationAnimation();
                    _playRotationAnimation();
                  });
                },
                icon: Icons.replay,
                color: null,
                size: 48);
          }
        });
  }

  void _setShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  Color? _getShuffleColor() {
    return _isShuffle ? Theme.of(context).colorScheme.primary : Colors.grey;
  }

  void _setNextSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex < widget.songs.length - 1) {
      ++_selectedItemIndex;
    } else if (_loopMode == LoopMode.all &&
        _selectedItemIndex == widget.songs.length - 1) {
      _selectedItemIndex = 0;
    }
    if (_selectedItemIndex >= widget.songs.length) {
      _selectedItemIndex = _selectedItemIndex % widget.songs.length;
    }
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetRotationAnimation();
    });
    setState(() {
      _song = nextSong;
    });
    _checkIfFavoriteSong();
  }

  void _setPreviousSong() {
    if (_isShuffle) {
      var random = Random();
      _selectedItemIndex = random.nextInt(widget.songs.length);
    } else if (_selectedItemIndex > 0) {
      --_selectedItemIndex;
    } else if (_loopMode == LoopMode.all && _selectedItemIndex == 0) {
      _selectedItemIndex = widget.songs.length - 1;
    }
    if (_selectedItemIndex < 0) {
      _selectedItemIndex = (-1 * _selectedItemIndex) % widget.songs.length;
    }
    final previousSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(previousSong.source);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetRotationAnimation();
    });
    setState(() {
      _song = previousSong;
    });
    _checkIfFavoriteSong();
  }

  void _setRepeatOption() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    setState(() {
      _audioPlayerManager.player.setLoopMode(_loopMode);
    });
  }

  IconData _repeatingIcon() {
    return switch (_loopMode) {
      LoopMode.one => Icons.repeat_one,
      LoopMode.all => Icons.repeat_on,
      _ => Icons.repeat
    };
  }

  Color? _getRepeatingIconColor() {
    return _loopMode == LoopMode.off ? Colors.grey : Theme.of(context).colorScheme.primary;
  }

  void _playRotationAnimation() {
    _imageAnimationController.forward(from: _currentAnimationPosition);
    _imageAnimationController.repeat();
  }

  void _pauseRotationAnimation() {
    _stopRotationAnimation();
    _currentAnimationPosition = _imageAnimationController.value;
  }

  void _stopRotationAnimation() {
    _imageAnimationController.stop();
  }

  void _resetRotationAnimation() {
    _currentAnimationPosition = 0.0;
    _imageAnimationController.value = _currentAnimationPosition;
  }

  void _shareSong(){
    final message = 'Hãy nghe bài hát "${_song.title}" của ${_song.artist} từ album "${_song.album}"! ${_song.source}';
    Share.share(message);
  }

  Future<void> _checkIfFavoriteSong() async {
    _isFavorite = await SongRepository().isFavorite(_song);
    setState(() {});
  }
}
