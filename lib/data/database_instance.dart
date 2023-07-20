import 'package:hive/hive.dart';
import 'package:soulofi/main.dart';

class Boxes {
  static Box? _box;

  static Box getInstance() {
    _box ??= Hive.box(hiveBoxName);
    return _box!;
  }
}
