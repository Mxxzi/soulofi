import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soulofi/data/hive_database.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/screens/play_screen.dart';

import '../data/database_instance.dart';

class FavouriteScreen extends StatefulWidget {
  final List<Songs> favoriteSongs;

  const FavouriteScreen(
      {Key? key, required this.favoriteSongs, required this.name})
      : super(key: key);
  final String name;

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Songs> favoriteSongs = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool isFavorite = false;
  String selectedPlaylist = '';

  void updateFavoriteSongs(List<Songs> songs) {
    setState(() {
      favoriteSongs = songs;
    });
  }

  Box<List<Songs>>? songBox;

  Box<List<Songs>> getSongsInstance() {
    return songBox ??= Hive.box('musicBox');
  }

  List<Songs> favList = [];
  final database = HiveDatabase();
  final _box = Boxes.getInstance();

  void deleteFavlist(String likedSongs) {
    _box.delete(likedSongs);
    // You may want to perform additional actions after deleting the playlist, such as updating the UI or showing a confirmation message.
  }

  getFavSongs() {
    favList = database.getFavSong();
    log('gfavvvv $favList');
  }

  @override
  void initState() {
    super.initState();
    getFavSongs();
  }

  toggleFavorite(Songs song) async {
    final box = Boxes.getInstance();
    final List<Songs> likedSongs = box.get('likedSongs').toList().cast<Songs>();

    if (likedSongs.contains(song)) {
      likedSongs.remove(song);
    } else {
      likedSongs.add(song);
    }

    await box.put('likedSongs', likedSongs);

    // Update the favList after adding/removing the song from favorites
    getFavSongs();
  }

  void addToPlaylist(String playlistName) {
    setState(() {
      selectedPlaylist = playlistName;
    });
  }

  void deleteSong(Songs song) async {
    // Remove the song from favorites
    await toggleFavorite(song);

    // Refresh the FavouriteScreen by navigating back to it
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FavouriteScreen(
          name: widget.name,
          favoriteSongs: const [],
        ),
      ),
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
            "Favourites",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: favList.isEmpty
            ? const Center(
                child: Text('No Fav Songs'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: favList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => PlayScreen(
                            song: favList[index],
                            allSongs: favList,
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
                        favList[index].title ?? 'Track $index',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        favList[index].artist ?? "No Artist",
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
                                    'Are you sure you want remove song from this Favourites ?'),
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
                                    onPressed: () async {
                                      if (index >= 0 &&
                                          index < favList.length) {
                                        final song = favList[index];

                                        // Call the deleteSong method to remove the song from favorites and refresh the screen
                                        deleteSong(song);
                                      }

                                      Navigator.of(context)
                                          .pop(); // Close the confirmation dialog
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
                        id: favList[index].id!,
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
