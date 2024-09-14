import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/home/admin_home/add_song_page.dart';
import 'package:music_app/ui/home/admin_home/admin_song_item_section.dart';
import 'package:music_app/ui/home/user_home/music_app_view_model.dart';

class AdminHomeTab extends StatefulWidget{
  const AdminHomeTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminHomeTabState();
  }
}

class _AdminHomeTabState extends State<AdminHomeTab>{
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
      floatingActionButton: Container(
        width: 90,
        height: 40,
        child: FloatingActionButton(
          onPressed: _navigateToAddSongPage,
          backgroundColor: Colors.pink,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle_outline, size: 24), // Kích thước biểu tượng
              SizedBox(width: 8), // Khoảng cách giữa biểu tượng và chữ
              Text('Add', style: TextStyle(fontSize: 16)), // Chữ trên nút
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          ),
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
        return AdminSongItemSection(song: searchSongs[position], songs: searchSongs, onDelete: _refreshSong,);
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

  void _navigateToAddSongPage(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => const AddSongPage())).then((value){
          _refreshSong();//Khi quay về thì refresh lại
    });
  }
}