import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';
import 'package:music_app/ui/home/admin_home/edit_song_page.dart';

class AdminSongItemSection extends StatefulWidget {
  final Song song;
  final List<Song> songs;
  final VoidCallback onDelete;

  AdminSongItemSection({
    Key? key,
    required this.song,
    required this.songs,
    required this.onDelete,
  }) : super(key: key);

  @override
  _AdminSongItemSectionState createState() => _AdminSongItemSectionState();
}

class _AdminSongItemSectionState extends State<AdminSongItemSection> {
  final SongRepository _songRepository = SongRepository();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/music_node.png',
          image: widget.song.image,
          width: 58,
          height: 58,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/music_node.png',
              width: 58,
              height: 58,
            );
          },
        ),
      ),
      title: Text(widget.song.title),
      subtitle: Text(widget.song.artist),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditSongPage(song: widget.song)));
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa bài hát này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại trước khi xóa
                _deleteSong(); // Thực hiện xóa bài hát
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSong() async {
    try {
      await _songRepository.deleteSong(widget.song);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bài hát được xóa thành công')),
        );
      }
      widget.onDelete(); // Gọi callback để cập nhật danh sách
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa bài hát thất bại: $error')),
        );
      }
    }
  }
}
