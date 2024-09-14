import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/data/model/song.dart';
import 'package:music_app/ui/now_playing/now_playing_page.dart';

class SongItemSection extends StatelessWidget {
  final Song song;
  final List<Song> songs;

  const SongItemSection({Key? key, required this.song, required this.songs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 24, right: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FadeInImage.assetNetwork(
          //Ảnh khi đang load từ internet
          placeholder: 'assets/images/music_node.png',
          //Ảnh lấy khi lấy được từ internet
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/music_node.png',
              width: 48,
              height: 48,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: const Icon(Icons.more_horiz),
        //Bấm vào 3 chấm => bottomsheet
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                  child: Container(
                    height: 400,
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Modal BottomSheet'),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close BottomSheet')
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
      //Bấm ListTilte
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
          return NowPlayingPage(
            songs: songs,
            playingSong: song,
          );
        }));
      },
    );
  }
}
