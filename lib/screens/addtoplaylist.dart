import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:soulofi/model/songs_adaptor.dart';

import '../data/database_instance.dart';

class AddToPlaylist extends StatefulWidget {
  const AddToPlaylist({required this.song});

  final Songs song;
  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
  List playlist = [];
  final _box = Boxes.getInstance();
  List<Songs> playListSongs = [];

  getPlaylist() {
    playlist = _box.keys.toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaylist();
  }

  addToPlaylist(String name) async {
    playListSongs = _box.get(name).toList().cast<Songs>();
    int index = 0;

    for (int i = 0; i < playListSongs.length; i++) {
      if (playListSongs[i].title == widget.song.title) {
        index = 1;
        log('indexxx $index');
      }
    }
    log('indexxx $index');
    if (index == 1) {
      playListSongs.removeWhere((element) => element.title == widget.song);

      await _box.delete(name);
      await _box.put(name, playListSongs);
    } else {
      playListSongs.add(widget.song);
      await _box.delete(name);
      await _box.put(name, playListSongs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        final playlistName = playlist[index];
        return Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.queue_music,
                color: Colors.black,
              ),
              trailing: IconButton(
                onPressed: () {
                  addToPlaylist(playlistName);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add),
                color: Colors.black,
              ),
              title: Text(
                playlistName,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Handle playlist item tap
                // You can navigate to a playlist details screen or perform any other action
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }
}
