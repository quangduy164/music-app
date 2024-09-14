import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/ui/home/user_home/song_item_section.dart';

class DiscoveryTab extends StatefulWidget{
  const DiscoveryTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DiscoveryTabState();
  }
}

class _DiscoveryTabState extends State<DiscoveryTab>{
  List<Song> _favoriteSongs = [];
  bool _showLoading = true;

  @override
  void initState() {
    _loadFavoriteSongs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // Sử dụng SafeArea để đảm bảo vùng hiển thị an toàn
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10, bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.redAccent,),
                  Text(' Bài hát yêu thích (${_favoriteSongs.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 9, right: 9),
              child: Divider(height: 1, color: Colors.grey),
            ),
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
      onRefresh: _loadFavoriteSongs,
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
        return SongItemSection(song: _favoriteSongs[position], songs: _favoriteSongs);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: _favoriteSongs.length,
      shrinkWrap: true,
    );
  }

  Future<void> _loadFavoriteSongs() async{
    final songs = await SongRepository().getFavoriteSong();
    setState(() {
      _favoriteSongs = songs;
      _showLoading = false;
    });
  }

}