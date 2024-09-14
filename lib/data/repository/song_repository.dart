import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/data/source/data_source.dart';

class SongRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  //Constructor
  SongRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore}):
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  // Thêm bài hát vào Firestore
  Future<void> addSong(Song song) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        String? role = docSnapshot['role'];
        if (role == 'admin') {
          // Thêm bài hát vào Firestore
          await _firestore.collection('songs').doc(song.id).set(song.toMap());
          print('Thêm bài hát thành công');
        } else {
          print('Người dùng không có quyền thêm bài hát');
        }
      }
    } catch (error) {
      print('Lỗi thêm bài hát: $error');
    }
  }

  // Chỉnh sửa bài hát trong Firestore
  Future<void> updateSong(Song song) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        String? role = docSnapshot['role'];
        if (role == 'admin') {
          // Cập nhật bài hát trong Firestore
          await _firestore.collection('songs').doc(song.id).update(song.toMap());
          print('Chỉnh sửa bài hát thành công');
        } else {
          print('Người dùng không có quyền chỉnh sửa bài hát');
        }
      }
    } catch (error) {
      print('Lỗi chỉnh sửa bài hát: $error');
    }
  }

  // Xóa bài hát khỏi Firestore
  Future<void> deleteSong(Song song) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        final userDoc = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        String? role = docSnapshot['role'];
        if (role == 'admin') {
          // Xóa bài hát khỏi Firestore
          await _firestore.collection('songs').doc(song.id).delete();
          print('Xóa bài hát thành công');
        } else {
          print('Người dùng không có quyền xóa bài hát');
        }
      }
    } catch (error) {
      print('Lỗi xóa bài hát: $error');
    }
  }

  Future<void> addSongToFavorites(Song song) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.update({
        'favorites': FieldValue.arrayUnion([song.toMap()]), // Thêm bài hát vào danh sách
      });
    }
  }

  Future<void> removeSongFromFavorites(Song song) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.update({
        'favorites': FieldValue.arrayRemove([song.toMap()]), // Xóa bài hát khỏi danh sách
      });
    }
  }

  Future<bool> isFavorite(Song song) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      List<dynamic> favorites = docSnapshot['favorites'] ?? [];
      // Kiểm tra bài hát đã có trong danh sách yêu thích chưa
      return favorites.any((item) => item['id'] == song.id);
    }
    return false;
  }

  Future<List<Song>> getFavoriteSong() async{
    User? user = _firebaseAuth.currentUser;
    if(user != null){
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnashot = await userDoc.get();
      List<dynamic> favorites = docSnashot['favorites'] ?? [];
      //Chuyển danh sách từ map sang đối tượng song
      return favorites.map((songMap) => Song.fromFirebase(songMap)).toList();
    }
    return [];
  }
}

class DefaultSongRepository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  Future<List<Song>?> loadData() async {
    List<Song> songs = [];
    await _remoteDataSource.loadData().then((remoteSongs) {
      if (remoteSongs == null) {
        _localDataSource.loadData().then((localSongs) {
          if (localSongs != null) {
            songs.addAll(localSongs);
          } else {
            print('Error loadData');
          }
        });
      } else {
        songs.addAll(remoteSongs);
      }
    });
    return songs;
  }
}
