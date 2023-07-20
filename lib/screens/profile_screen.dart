import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Username';
  final String _imageUrl = 'assets/images/photo2.jpg';
  TextEditingController changeName = TextEditingController();

  Future<void> _changeName() async {
    String newName = await showDialog(
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
                  SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 64.0,
                      backgroundImage:
                          _imageUrl != null ? AssetImage(_imageUrl!) : null,
                    ),
                  ),
                  SizedBox(height: 20.0),
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
                  SizedBox(height: 10.0),
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  const Text(
                    'Version: 1.0.0',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                  SizedBox(height: 8.0),
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
}
