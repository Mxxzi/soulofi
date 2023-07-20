import 'dart:developer';
// ignore: unused_import
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/model/songs_adaptor.dart';

class HiveDatabase {
  List<Songs> getFavSong() {
    final box = Boxes.getInstance();
    final List<Songs> likedSongs =
        box.get('likedSongs')?.toList().cast<Songs>() ?? [];
    return likedSongs;
  }

  addToFav(Songs song) async {
    final box = Boxes.getInstance();
    final List<Songs> likedSongs = box.get('likedSongs').toList().cast<Songs>();
    final keys = box.keys.toList();
    log('keysssf $keys');
    if (likedSongs.contains(song)) {
      likedSongs.remove(song);
      await box.put('likedSongs', likedSongs);
      log('keysssf $keys');
    } else {
      likedSongs.add(song);
      await box.put('likedSongs', likedSongs);
    }
  }

  List<Songs> getPlaylistSong() {
    final box = Boxes.getInstance();
    final List<Songs>? playlist = box.get('playlist');
    if (playlist != null) {
      return playlist.toList().cast<Songs>();
    } else {
      return [];
    }
  }

  addToPlayList(Songs song) async {
    final box = Boxes.getInstance();
    final List<Songs>? playlist = box.get('playlist')?.toList().cast<Songs>();
    final keys = box.keys.toList();
    log('keysss $keys');
    if (playlist != null) {
      if (playlist.contains(song)) {
        playlist.remove(song);
        await box.put('playlist', playlist);
      } else {
        playlist.add(song);
        await box.put('playlist', playlist);
      }
    } else {
      await box.put('playlist', [song]);
    }
  }
}
