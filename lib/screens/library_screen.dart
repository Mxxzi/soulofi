import 'package:flutter/material.dart';
import 'package:soulofi/screens/favourite_sceen.dart';
import 'package:soulofi/screens/playlist.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
            "Library",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ListTile(
              leading: const Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              title: const Text(
                'Recently Played',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle tap on Albums
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.library_music,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              title: const Text(
                'All Songs',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle tap on Artists
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.queue_music,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              title: const Text(
                'Playlists',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle tap on Playlists
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => const PlaylistScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.music_video,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              title: const Text(
                'Mostly played',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle tap on Folders
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
              title: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle tap on Favorites
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => const FavouriteScreen(
                              favoriteSongs: [],
                              name: "",
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
