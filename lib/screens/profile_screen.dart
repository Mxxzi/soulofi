import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Username 🖋️';
  final String _imageUrl = 'assets/images/photo2.jpg';
  TextEditingController changeName = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? imageXFile;
  String avatarimage = "";
  dynamic picture;
  final box = Boxes.getInstance();

  String url = 'https://sites.google.com/view/soulofi/home';

  void _launchURL() async {
    log('Launching URL');
    launchUrl(Uri.parse(url));
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
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "SouLoFi",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 209, 206, 46),
                        fontSize: 30),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: imageXFile?.path != null
                        ?
                        // ? CircleAvatar(
                        //     child: Container(
                        //       width: 100,
                        //       height: 100,
                        //       decoration: const BoxDecoration(
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: ClipOval(
                        //         child: Image.file(
                        //           File(imageXFile!.path),
                        //           fit: BoxFit.fill,
                        //         ),
                        //       ),
                        //     ),
                        //   )
                        CircleAvatar(
                            radius:
                                50, // Set the desired radius for the circular avatar
                            backgroundColor: Colors
                                .transparent, // Set the background color to transparent
                            child: Container(
                              width: 120, // Set the width of the container
                              height: 120, // Set the height of the container
                              decoration: ShapeDecoration(
                                color: Colors
                                    .white, // Set the background color of the container
                                shape:
                                    CircleBorder(), // Use CircleBorder to create a circular shape
                                shadows: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        0.5), // Set the color and opacity of the shadow
                                    spreadRadius:
                                        2, // Set how far the shadow spreads
                                    blurRadius:
                                        5, // Set the blur radius (the larger, the more spread out the shadow)
                                    offset: const Offset(0,
                                        2), // Set the offset of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                // Clip the child (asset image) to a circular shape
                                child: Image.file(
                                  File(imageXFile!
                                      .path), // Replace 'image_name.png' with the actual asset image path
                                  fit: BoxFit
                                      .cover, // Choose the appropriate BoxFit option based on your requirement
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius:
                                70, // Set the desired radius for the circular avatar
                            backgroundColor: Colors
                                .transparent, // Set the background color to transparent
                            child: Container(
                              width: 120, // Set the width of the container
                              height: 120, // Set the height of the container
                              decoration: ShapeDecoration(
                                color: Colors
                                    .white, // Set the background color of the container
                                shape:
                                    CircleBorder(), // Use CircleBorder to create a circular shape
                                shadows: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(
                                        0.5), // Set the color and opacity of the shadow
                                    spreadRadius:
                                        2, // Set how far the shadow spreads
                                    blurRadius:
                                        5, // Set the blur radius (the larger, the more spread out the shadow)
                                    offset: const Offset(0,
                                        2), // Set the offset of the shadow (x, y)
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                // Clip the child (asset image) to a circular shape
                                child: Image.asset(
                                  _imageUrl, // Replace 'image_name.png' with the actual asset image path
                                  fit: BoxFit
                                      .cover, // Choose the appropriate BoxFit option based on your requirement
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      _changeName();
                    },
                    child: Text(
                      _name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Version: 1.0.0',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: _launchURL,
                    child: const Text('Privacy Policy'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _changeName() async {
    String? newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Change Name',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          content: TextField(
            controller: changeName,
            decoration: const InputDecoration(
              hintText: 'Enter your name',
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
                // Get the new name from the TextField
                String newName = changeName.text.trim();

                // Update the name only if it's not empty
                if (newName.isNotEmpty) {
                  Navigator.of(context).pop(newName);
                }
              },
            ),
          ],
        );
      },
    );

    // The newName will be null if the user cancels the dialog
    if (newName != null) {
      setState(() {
        _name = newName; // Update the name in the UI
      });

      // Save the updated name to SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('userName', newName);
    }
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });

    Uint8List avatarimage = await imageXFile!.readAsBytes();

    picture = await base64Encode(avatarimage);
  }
}
