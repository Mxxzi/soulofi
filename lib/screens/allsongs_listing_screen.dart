import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/screens/play_screen.dart';

class SongsListScreen extends StatefulWidget {
  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> localSongs = [];
  List<Songs> dbSongs = [];
  final box = Boxes.getInstance();
  List<Songs> songsFromDB = [];
  bool fetchingSongs = false;
  bool hasPermission = false;

  bool isFavorite = false;
  String selectedPlaylist = '';

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void addToPlaylist(String playlistName) {
    setState(() {
      selectedPlaylist = playlistName;
    });
  }

  void _showOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              title: Text(
                  isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
              onTap: toggleFavorite,
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Playlist'),
              onTap: () {
                // Show another bottom sheet or dialog to select a playlist
                _showPlaylistDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showPlaylistDialog() {
    // Replace this with your own implementation to show a dialog
    // or bottom sheet with a list of playlists to choose from.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Playlist'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    addToPlaylist('Playlist 1');
                    Navigator.pop(context);
                  },
                  child: const Text('Playlist 1'),
                ),
                GestureDetector(
                  onTap: () {
                    addToPlaylist('Playlist 2');
                    Navigator.pop(context);
                  },
                  child: const Text('Playlist 2'),
                ),
                // Add more options as needed
              ],
            ),
          ),
        );
      },
    );
  }

  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    hasPermission ? setState(() {}) : null;
    log('hasPErmission $hasPermission');
    if (hasPermission) {
      fetchSongs();
    }
  }

  fetchSongs() async {
    fetchingSongs = true;
    localSongs = await _audioQuery.querySongs();
    dbSongs = localSongs
        .map((e) => Songs(
            title: e.title,
            artist: e.artist,
            uri: e.uri,
            id: e.id,
            duration: e.duration))
        .toList();

    await box.put('allSongs', dbSongs);
    setState(() {
      songsFromDB = box.get('allSongs');
    });
    fetchingSongs = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndRequestPermissions();
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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: const Text(
            "SouLoFi",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        body: hasPermission
            ? Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Text(
                          'Welcome ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 233, 215, 47),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          'to the Music World',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (fetchingSongs)
                    const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  if (!fetchingSongs && songsFromDB.isEmpty)
                    const Center(
                      child: Text('No Songs Found'),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: songsFromDB.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => PlayScreen(
                                    song: songsFromDB[index],
                                    allSongs: songsFromDB,
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              title: Text(
                                songsFromDB[index].title ?? 'Track $index',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                songsFromDB[index].artist ?? "No Artist",
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Show a bottom sheet or dialog to display options
                                  // for favorites and adding to a playlist.
                                  _showOptionsDialog();
                                },
                              ),

                              // This Widget will query/load image.
                              // You can use/create your own widget/method using [queryArtwork].
                              leading: QueryArtworkWidget(
                                controller: _audioQuery,
                                id: songsFromDB[index].id!,
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
                ],
              )
            : const Center(
                child: Text('No Songs'),
              ),
      ),
    );
  }
}
