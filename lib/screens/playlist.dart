// import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/screens/playlist_songs.dart';

import '../data/hive_database.dart';
import '../model/songs_adaptor.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  HiveDatabase database = HiveDatabase();
  List<Songs> playlistSongs = [];
  Songs? currentSong;
  Box<List<Songs>>? songBox;
  List<Songs> pLayList = [];
  final playListNameControllor = TextEditingController();

  void updateplaylistSongs(List<Songs> songs) {
    setState(() {
      playlistSongs = songs;
    });
  }

  Box<List<Songs>> getSongsInstance() {
    return songBox ??= Hive.box('musicBox');
  }

  void removeFromPlatList(Songs song) async {
    final box = getSongsInstance();
    pLayList.removeWhere((element) => element == song);
    await box.put("PLayListSongs", pLayList);

    setState(() {
      pLayList = pLayList;
    });
  }

  List playlist = [];

  getPlaylist() {
    playlist = _box.keys.toList();
  }



  final _box = Boxes.getInstance();

  addPlaylist(String playlistName) async {
    List playlist = [];
    List keys = _box.keys.toList();
    if (!keys.contains(playlistName)) {
      await _box.put(playlistName, playlist);
    }
  }

  @override
  void initState() {
    super.initState();
    getPlaylist();
  }

  void deletePlaylist(String playlistName) async {
    setState(() {
      playlist.remove(playlistName);
    });

    await _box.delete(playlistName);
  }

  void _showOptionsDialog(String playlistName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: Colors.black,
              ),
              title: const Text('Edit'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this playlist?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close the confirmation dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            deletePlaylist(
                                playlistName); // Call the deletePlaylist function
                            Navigator.of(context)
                                .pop(); // Close the confirmation dialog
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Playlist",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            // Other widgets here
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final playlistName = playlist[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.queue_music,
                            color: Colors.white,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _showOptionsDialog(playlistName);
                            },
                            icon: const Icon(Icons.more_vert),
                            color: Colors.white,
                          ),
                          title: Text(
                            playlistName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => PlaylistSongs(
                                  name: playlistName,
                                ),
                              ),
                            );
                            // Handle playlist item tap
                            // You can navigate to a playlist details screen or perform any other action
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
             

                return AlertDialog(
                  title: const Text(
                    'New Playlist',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: TextFormField(
                    controller: playListNameControllor,
                    decoration: const InputDecoration(
                      hintText: 'Enter playlist name',
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () {
                        setState(() {
                          addPlaylist(playListNameControllor.text);
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PlaylistScreen()),
                          );
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class PlaylistItem {
  final String name;

  PlaylistItem(this.name);
}
