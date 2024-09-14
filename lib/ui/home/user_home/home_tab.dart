import 'package:flutter/material.dart';
import 'package:music_app/ui/home/user_home/music_app_view_model.dart';
import 'package:music_app/ui/home/user_home/song_item_section.dart';
import 'package:music_app/ui/now_playing/audio_player_manager.dart';
import '../../../data/model/song.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeTapState();
  }
}

class _HomeTapState extends State<HomeTab> {
  List<Song> songs = [];
  List<Song> searchSongs = [];
  late MusicAppViewModel _musicAppViewModel;
  bool _showLoading = true;

  @override
  void initState() {
    _musicAppViewModel = MusicAppViewModel();
    observeData();
    _loadSongs();
    super.initState();
  }

  @override
  void dispose() {
    _musicAppViewModel.songStream.close();
    AudioPlayerManager().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Sử dụng SafeArea để đảm bảo vùng hiển thị an toàn
        child: Column(
          children: [
            _searchBar(),
            Expanded(
              child: getBody(), // ListView cuộn bên trong Expanded
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return RefreshIndicator(
      onRefresh: _refreshSong,
      child: _showLoading ? getProgressBar() : getListView(),
    );
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return SongItemSection(song: searchSongs[position], songs: searchSongs);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: searchSongs.length,
      shrinkWrap: true,
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 12),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 9),//Chiều cao thanh tìm kiếm
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Colors.lightBlueAccent,
              width: 2.0,
            ),
          ),
          hintText: 'Tìm kiếm bài hát...',
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            searchSongs = songs.where((song) {
              var songTitle = song.title.toLowerCase();
              return songTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  // Lấy dữ liệu từ stream khi nó trả về
  void observeData() {
    _musicAppViewModel.songStream.stream.listen((songList) {
      setState(() {
        songs = songList;
        searchSongs = List.from(songs);
        _showLoading = false;
      });
    });
  }

  void _loadSongs() {
    setState(() {
      _showLoading = true; // Hiển thị vòng tròn tải khi bắt đầu load dữ liệu
    });
    _musicAppViewModel.loadSong();
  }

  // Làm mới danh sách bài hát
  Future<void> _refreshSong() async {
    setState(() {
      _showLoading = true;
      songs.clear();
      searchSongs.clear();
    });
    _musicAppViewModel.loadSong();
  }
}
