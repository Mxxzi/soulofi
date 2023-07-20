import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soulofi/screens/play_screen.dart';
import 'package:soulofi/screens/profile_screen.dart';

import '../homeScreen.dart';
import 'library_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> filteredSongs = [];

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
              leading: Icon(Icons.playlist_add),
              title: Text('Add to Playlist'),
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndRequestPermissions();
  }

  String _searchQuery = '';

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
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
            "Search",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: hasPermission
            ? FutureBuilder<List<SongModel>>(
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  // Display error, if any.
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }

                  // Waiting content.
                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }

                  // 'Library' is empty.
                  if (item.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      "Nothing found!",
                      style: TextStyle(color: Colors.red),
                    ));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize
                          .min, // Set mainAxisSize to MainAxisSize.min
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            onChanged: _onSearchTextChanged,
                            decoration: InputDecoration(
                              hintText: 'Search for music',
                              hintStyle: const TextStyle(color: Colors.grey),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        if (_searchQuery
                            .isEmpty) // Show only if search query is empty
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              'All Songs',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        if (_searchQuery.isEmpty)
                          // SizedBox(
                          //   height: 550,
                          //   // height: MediaQuery.of(context).size.height * 0.5,
                          //   child: ListView.builder(
                          //     itemCount: item.data!.length,
                          //     itemBuilder: (context, index) {
                          //       return InkWell(
                          //         onTap: () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (ctx) => PlayScreen(
                          //                 song: item.data![index],
                          //                 allSongs: item.data!,
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //         child: ListTile(
                          //           title: Text(
                          //             item.data![index].title,
                          //             style:
                          //                 const TextStyle(color: Colors.white),
                          //           ),
                          //           subtitle: Text(
                          //             item.data![index].artist ?? "No Artist",
                          //           ),
                          //           trailing: IconButton(
                          //             icon: const Icon(
                          //               Icons.more_vert,
                          //               color: Colors.white,
                          //             ),
                          //             onPressed: () {
                          //               // Show a bottom sheet or dialog to display options
                          //               // for favorites and adding to a playlist.
                          //               _showOptionsDialog();
                          //             },
                          //           ),

                          //           // This Widget will query/load image.
                          //           // You can use/create your own widget/method using [queryArtwork].
                          //           leading: QueryArtworkWidget(
                          //             controller: _audioQuery,
                          //             id: item.data![index].id,
                          //             type: ArtworkType.AUDIO,
                          //             nullArtworkWidget: ClipOval(
                          //               child: Image.asset(
                          //                 'assets/images/.jpg',
                          //                 fit: BoxFit.cover,
                          //                 width: 50,
                          //                 height: 50,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          if (_searchQuery
                              .isNotEmpty) // Show only if there is a search query
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'Search Results',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        if (_searchQuery
                            .isNotEmpty) // Show only if there is a search query
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8.0),
                            itemCount: filteredSongs.length,
                            itemBuilder: (context, index) {
                              final song = filteredSongs[index];
                              return Container(
                                color: Colors.transparent,
                                margin: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    '$song',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text('No Songs'),
              ),
      ),
    );
  }
}
