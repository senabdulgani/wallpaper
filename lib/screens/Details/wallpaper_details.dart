import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walltext/product/components/set_wallpaper_button.dart';
import 'package:walltext/product/state/wallpaper_manager_provider.dart';

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
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.shareXFiles([XFile(savedPhotos[index].path)]);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  savedPhotos[index],
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            SetWallpaperButton(path: savedPhotos[index].path),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
