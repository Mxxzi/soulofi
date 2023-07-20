import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:soulofi/data/database_instance.dart';
import 'package:soulofi/model/songs_adaptor.dart';
import 'package:soulofi/splash.dart';
import 'package:hive/hive.dart';

const hiveBoxName = 'songs';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());
  await Hive.openBox(hiveBoxName);
  WidgetsFlutterBinding.ensureInitialized();

  final _box = Boxes.getInstance();
  List<String> keys = _box.keys.cast<String>().toList();

  if (!keys.contains("likedSongs")) {
    List<Songs> favourites = [];
    await _box.put("likedSongs", favourites);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
