import 'package:flutter/foundation.dart';
import 'dart:io';

class WallpaperProvider with ChangeNotifier {
  final List<File> _wallpapers = [];

  // Duvar kağıtları listesini döndüren getter
  List<File> get wallpapers => _wallpapers;

  // Yeni bir duvar kağıdı ekleyen method
  void addWallpaper(File wallpaper) {
    _wallpapers.add(wallpaper);
    notifyListeners();
  }
}
