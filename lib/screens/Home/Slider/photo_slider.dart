import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // For accessing application documents directory
import 'package:wallpaper_app/product/theme/app_colors.dart';

class PhotoSlider extends StatefulWidget {
  const PhotoSlider({super.key});

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  List<File> savedPhotos = [];

  @override
  void initState() {
    super.initState();
    _loadSavedPhotos(); // Load photos when the widget is initialized
  }

  // Load saved photos from the Wallpapers directory
  Future<void> _loadSavedPhotos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final wallpaperDirectory = Directory('${directory.path}/Wallpapers');

      if (await wallpaperDirectory.exists()) {
        final photoFiles = wallpaperDirectory.listSync().whereType<File>().map((e) => e).toList();
        setState(() {
          savedPhotos = photoFiles;
        });
      }
    } catch (e) {
      print("Error loading saved photos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: savedPhotos.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: AppColors.borderRadiusAll,
              child: SizedBox(
                width: 160,
                child: Image.file(
                  savedPhotos[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
