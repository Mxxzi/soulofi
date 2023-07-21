import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soulofi/data/hive_database.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/screens/addtoplaylist.dart';
import 'package:soulofi/screens/favourite_sceen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key, required this.song, required this.allSongs})
      : super(key: key);

  final Songs? song;
  final List<Songs> allSongs;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  // Box<List<AllSongModel>>? songBox;
  bool playingSong = false;
  Songs? currentSong;
  List<Songs> favList = [];
  bool isFavSong = false;
  final database = HiveDatabase();

  // final hiveDatabase = HiveDatabase();

  @override
  void initState() {
    super.initState();
    // will call seturl() method here, which will helps in playing the selected song when user clicks on song from all songs listing screen
    setUrl(widget.song!);
    checkLikedSong(widget.song!);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<bool> onWillPop() async {
    Navigator.of(context).pop(favList);
    return false;
  }

  void setUrl(Songs song) async {
    // will set the url into audioPlayer for playing song
    currentSong = song;
    await audioPlayer.setUrl(song.uri!);
    // will call play() method after setting the url
    play();
  }

  void play() {
    audioPlayer.play();
    setState(() {
      // for changing the state of buttons
      playingSong = true;
    });
  }

  void pause() {
    setState(() {
      playingSong = false;
    });
    audioPlayer.pause();
  }

  next(Songs song) {
    int currentPosition = widget.allSongs.indexOf(song);
    audioPlayer.stop();
    if (widget.allSongs.last == song) {
      setUrl(widget.allSongs.first);
    } else {
      Songs nextSong = widget.allSongs[currentPosition + 1];
      setUrl(nextSong);
    }
  }

  previous(Songs song) {
    int currentPosition = widget.allSongs.indexOf(song);
    audioPlayer.stop();
    if (widget.allSongs.first == song) {
      setUrl(widget.allSongs.last);
    } else {
      Songs preSong = widget.allSongs[currentPosition - 1];
      setUrl(preSong);
    }
  }

  bool isLiked = false;

  checkLikedSong(Songs song) {
    List<Songs> songs = database.getFavSong();
    if (songs.contains(song)) {
      log('cccc');
      setState(() {
        isLiked = true;
      });
    } else {
      log('nnnn');
      setState(() {
        isLiked = false;
      });
    }
  }

  refreshPage() {
    setState(() {
      currentSong = widget.allSongs.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkLikedSong(currentSong!);
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              refreshPage(); // Refresh the page when back icon is clicked
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: isLiked ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  database
                      .addToFav(currentSong!)
                      .then((_) => checkLikedSong(currentSong!));
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  // setState(() {
                  //   Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const FavouriteScreen(
                  //               favoriteSongs: [],
                  //             )),
                  //   );
                  // });
                },
              ),
            )
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          title: const Text(
            "SouLoFi",
            // widget.song!.displayName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        // appBar: AppBar(title: Text(widget.song!.displayName)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'assets/images/photo1.jpg',
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              currentSong!.title ?? '',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              currentSong!.artist ?? '',
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.shuffle,
                    color: Colors.white,
                  ),
                  iconSize: 20,
                  onPressed: () {
                    // Implement skip to next song functionality
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.blue,
                  ),
                  iconSize: 48,
                  onPressed: () {
                    previous(currentSong!);
                    // Implement skip to previous song functionality
                  },
                ),
                IconButton(
                  icon: Icon(
                    playingSong ? Icons.pause : Icons.play_arrow,
                    color: Colors.grey,
                  ),
                  iconSize: 64,
                  onPressed: () {
                    if (playingSong) {
                      pause();
                    } else {
                      play();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.blue,
                  ),
                  iconSize: 48,
                  onPressed: () {
                    next(currentSong!);
                    // Implement skip to next song functionality
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                  iconSize: 25,
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return AddToPlaylist(
                            song: currentSong!,
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
