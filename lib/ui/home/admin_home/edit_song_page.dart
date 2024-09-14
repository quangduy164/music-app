import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/repository/song_repository.dart';

class EditSongPage extends StatefulWidget {
  final Song song;

  const EditSongPage({Key? key, required this.song}) : super(key: key);

  @override
  State<EditSongPage> createState() => _EditSongPageState();
}

class _EditSongPageState extends State<EditSongPage> {
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _albumController = TextEditingController();
  final _sourceController = TextEditingController();
  final _imageController = TextEditingController();
  final _durationController = TextEditingController();
  final SongRepository _songRepository = SongRepository();

  Future<void> _editSong() async{
    final updatedSong = widget.song.copyWith(
      title: _titleController.text,
      artist: _artistController.text,
      album: _albumController.text,
      source: _sourceController.text,
      image: _imageController.text,
      duration: int.parse(_durationController.text),
    );
    try {
      await _songRepository.updateSong(updatedSong);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chỉnh sửa bài hát thành công')),
      );
      Navigator.of(context).pop(); // Quay lại màn hình trước
    } catch (error) {
      // Hiển thị thông báo lỗi nếu có vấn đề xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chỉnh sửa bài hát: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.song.title;
    _artistController.text = widget.song.artist;
    _albumController.text = widget.song.album;
    _sourceController.text = widget.song.source;
    _imageController.text = widget.song.image;
    _durationController.text = widget.song.duration.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa bài hát'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tên bài hát'),
              ),
              TextField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Tên nghệ sĩ'),
              ),
              TextField(
                controller: _albumController,
                decoration: const InputDecoration(labelText: 'Album'),
              ),
              TextField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Nguồn'),
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
                onPressed: _editSong,
                child: Text('Lưu thay đổi', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
