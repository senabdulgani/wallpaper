import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // For accessing application documents directory

class WallpaperManagerProvider extends ChangeNotifier {
  List<File> savedWallpapers = [];

  WallpaperManagerProvider() {
    _loadSavedWallpapers();
  }

  // Method to load saved wallpapers from the Wallpapers directory
  Future<void> _loadSavedWallpapers() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final wallpaperDirectory = Directory('${directory.path}/Wallpapers');

      if (await wallpaperDirectory.exists()) {
        final wallpaperFiles = wallpaperDirectory.listSync().whereType<File>().toList();

        savedWallpapers = wallpaperFiles;
        notifyListeners(); // Notify listeners about the state change
      }
    } catch (e) {
      print("Error loading saved wallpapers: $e");
    }
  }

  // Public method to manually trigger the loading of wallpapers
  Future<void> loadWallpapers() async {
    await _loadSavedWallpapers();
  }

  void removeWallpaper(int index) async {
    try {
      // Delete the file from the storage
      await savedWallpapers[index].delete();

      // Remove from the list
      savedWallpapers.removeAt(index);

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print("Error removing wallpaper: $e");
    }
  }
}
