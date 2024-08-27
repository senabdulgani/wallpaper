import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/product/state/wallpaper_manager_provider.dart';

class WallpaperDetails extends StatelessWidget {
  final int index;

  const WallpaperDetails({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final wallpaperManagerProvider = Provider.of<WallpaperManagerProvider>(context, listen: true);
    List<File> savedPhotos = wallpaperManagerProvider.savedWallpapers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Remove the wallpaper and navigate back
              wallpaperManagerProvider.removeWallpaper(index);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            image: DecorationImage(
              image: FileImage(
                savedPhotos[index],
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
