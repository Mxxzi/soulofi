import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/screens/play_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool fetchingSongs = false;
  List<Songs> allSongs = [];
  final box = Boxes.getInstance();
  final searchTextController = TextEditingController();

  fetchSongs() {
    allSongs = box.get('allSongs');
  }

  String searchtext = "";
  List<Songs>? results = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    if (searchtext.isEmpty) {
      results = allSongs;
    }
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
          body: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!fetchingSongs && allSongs.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'All Songs ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 233, 215, 47),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                if (!fetchingSongs && allSongs.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: searchTextController,
                      onChanged: (value) {
                        searchtext = value;
                        print(searchtext);
                        results = allSongs
                            .where((element) => element.title!
                                .toLowerCase()
                                .contains(searchtext.toLowerCase()))
                            .toList();
                        setState(() {});
                        log('results = ${results!.length}');
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'What do you want to listen to?',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                if (fetchingSongs)
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                if (!fetchingSongs && allSongs.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No Songs Found',
                        style: TextStyle(
                            color: Color.fromARGB(255, 233, 215, 47),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: results!.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => PlayScreen(
                                  song: results![index],
                                  allSongs: results!,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              results![index].title ?? 'Track $index',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              results![index].artist ?? "No Artist",
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Show a bottom sheet or dialog to display options
                                // for favorites and adding to a playlist.
                              },
                            ),

                            // This Widget will query/load image.
                            // You can use/create your own widget/method using [queryArtwork].
                            leading: QueryArtworkWidget(
                              controller: _audioQuery,
                              id: results![index].id!,
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
            ),
          )),
    );
  }
}
