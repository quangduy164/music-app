class Song{
  String id;
  String title;
  String album;
  String artist;
  String source;
  String image;
  int duration;
  Song({
  required this.id,
  required this.title,
  required this.album,
  required this.artist,
  required this.source,
  required this.image,
  required this.duration
  });

  // Factory method để tạo đối tượng Song từ Firestore data
  factory Song.fromFirebase(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as String,
      title: map['title'] as String,
      album: map['album'] as String,
      artist: map['artist'] as String,
      source: map['source'] as String,
      image: map['image'] as String,
      duration: map['duration'] as int,
    );
  }
  // Factory method để tạo đối tượng Song từ Json data
  factory Song.fromJs(Map<String, dynamic> map){
    return Song(
        id: map['id'],
        title: map['title'],
        album: map['album'],
        artist: map['artist'],
        source: map['source'],
        image: map['image'],
        duration: map['duration']
    );
  }
  // Chuyển đối tượng Song thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'album': album,
      'artist': artist,
      'source': source,
      'image': image,
      'duration': duration,
    };
  }

  // Phương thức copyWith để tạo một bản sao của bài hát với các giá trị đã thay đổi
  Song copyWith({
    String? id,
    String? title,
    String? album,
    String? artist,
    String? source,
    String? image,
    int? duration,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      album: album ?? this.album,
      artist: artist ?? this.artist,
      source: source ?? this.source,
      image: image ?? this.image,
      duration: duration ?? this.duration,
    );
  }

  //Kiểm tra 2 đối tượng có giống nhau k
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $album, artist: $artist, '
        'source: $source, image: $image, duration: $duration}';
  }
}