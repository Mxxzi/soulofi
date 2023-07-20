import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/screens/play_screen.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs({super.key, required this.name});
  final String name;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  List<Songs> playlistSongs = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final _box = Boxes.getInstance();
  List<Songs> favList = [];

  getPlaylist() {
    var playlist = _box.get(widget.name);
    if (playlist != null) {
      playlistSongs = playlist.toList().cast<Songs>();
    } else {
      playlistSongs = [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlaylist();
  }

  void deletePlaylist(String playlistSongs) {
    _box.delete(playlistSongs);
    // You may want to perform additional actions after deleting the playlist, such as updating the UI or showing a confirmation message.
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
          title: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: playlistSongs.isEmpty
            ? const Center(
                child: Text(
                  'No Songs',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: playlistSongs.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => PlayScreen(
                            song: playlistSongs[index],
                            allSongs: playlistSongs,
                          ),
                        ),
                      ).then(
                        (value) {
                          // getFavourites();
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(
                        playlistSongs[index].title ?? 'Track $index',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        playlistSongs[index].artist ?? "No Artist",
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                    'Are you sure you want remove song from this playlist ?'),
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
                                      // playlistSongs[index]
                                      //     .title; // Call the deletePlaylist function
                                      setState(() {
                                        playlistSongs.removeAt(index);
                                      });
                                      _box.put(widget.name, playlistSongs);
                                      Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),

                      // This Widget will query/load image.
                      // You can use/create your own widget/method using [queryArtwork].
                      leading: QueryArtworkWidget(
                        controller: _audioQuery,
                        id: playlistSongs[index].id!,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: ClipOval(
                          child: Image.asset(
                            'assets/images/photo1.jpg',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
