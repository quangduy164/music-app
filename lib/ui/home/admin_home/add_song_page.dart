import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _albumController = TextEditingController();
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final SongRepository _songRepository = SongRepository();

  Future<void> _addSong() async {
    final id = _idController.text;
    final title = _titleController.text;
    final album = _albumController.text;
    final artist = _artistController.text;
    final source = _sourceController.text;
    final image = _imageController.text;
    final duration = int.tryParse(_durationController.text) ?? 0;

    if (id.isNotEmpty && title.isNotEmpty && album.isNotEmpty &&
        artist.isNotEmpty && source.isNotEmpty && image.isNotEmpty && duration > 0) {
      final song = Song(
        id: id,
        title: title,
        album: album,
        artist: artist,
        source: source,
        image: image,
        duration: duration,
      );

      try {
        await _songRepository.addSong(song);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm bài hát thành công')),
        );
        Navigator.of(context).pop(); // Return to the previous screen
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi thêm bài hát: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yêu cầu nhập đúng thông tin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm bài hát'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Id'),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tên bài hát'),
              ),
              TextField(
                controller: _albumController,
                decoration: const InputDecoration(labelText: 'Album'),
              ),
              TextField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Tên nghệ sĩ'),
              ),
              TextField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'URL nguồn'),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'URL hình ảnh'),
              ),
              TextField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Thời lượng (giây)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addSong,
                child: Text('Add song', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
