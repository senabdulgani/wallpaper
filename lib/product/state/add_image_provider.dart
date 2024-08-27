import 'package:flutter/foundation.dart';
import 'dart:io';

class WallpaperProvider with ChangeNotifier {
  File? _wallpapersFromDevice;

  // Duvar kağıtları listesini döndüren getter
  File? get wallpapers => _wallpapersFromDevice;

  // Yeni bir duvar kağıdı ekleyen method
  void addWallpaper(File wallpaper) {
    _wallpapersFromDevice = wallpaper;
    notifyListeners();
  }

  // remove wallpaper
  void removeWallpaper() {
    _wallpapersFromDevice = null;
    notifyListeners();
  }
}
