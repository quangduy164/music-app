import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:music_app/data/model/song.dart';

abstract interface class DataSource {
  Future<List<Song>?> loadData();
}
//Lấy danh sách bài hát từ firebase
class RemoteDataSource implements DataSource {
  final CollectionReference _songsCollection =
  FirebaseFirestore.instance.collection('songs');

  @override
  Future<List<Song>?> loadData() async {
    try {
      // Lấy tất cả các document từ collection "songs"
      QuerySnapshot querySnapshot = await _songsCollection.get();
      // Chuyển đổi mỗi document thành đối tượng Song
      List<Song> songs = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        // Sử dụng factory method fromFirebase để tạo đối tượng Song
        return Song.fromFirebase(data);
      }).toList();
      // Trả về danh sách các bài hát
      return songs;
    } catch (error) {
      // Xử lý lỗi nếu xảy ra
      print('Error loading songs: $error');
      return null;
    }
  }
}

//Lấy danh sách bài hát từ dữ liệu json local
class LocalDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData() async {
    final String response = await rootBundle.loadString('assets/songs.json');
    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    List<Song> songs = songList.map((song) => Song.fromJs(song)).toList();
    return songs;
  }
}
