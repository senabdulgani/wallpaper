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

  // Belirli bir indeksteki duvar kağıdını silen method
  void removeWallpaper(int index) {
    if (index >= 0 && index < _wallpapers.length) {
      _wallpapers.removeAt(index);
      notifyListeners();
    }
  }

  // Tüm duvar kağıtlarını temizleyen method
  void clearWallpapers() {
    _wallpapers.clear();
    notifyListeners();
  }

  // Duvar kağıdı sayısını döndüren getter
  int get wallpaperCount => _wallpapers.length;

  // Belirli bir indeksteki duvar kağıdını döndüren method
  File? getWallpaperAt(int index) {
    if (index >= 0 && index < _wallpapers.length) {
      return _wallpapers[index];
    }
    return null;
  }
}
