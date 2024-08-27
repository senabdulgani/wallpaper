import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/product/state/wallpaper_manager_provider.dart';
import 'package:wallpaper_app/product/theme/app_colors.dart';
import 'package:wallpaper_app/screens/Details/wallpaper_details.dart';

class PhotoSlider extends StatefulWidget {
  const PhotoSlider({super.key});

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  @override
  void initState() {
    super.initState();
    // Load wallpapers when the widget is initialized
    final wallpaperManagerProvider = Provider.of<WallpaperManagerProvider>(context, listen: false);
    wallpaperManagerProvider.loadWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider to use saved wallpapers
    final wallpaperManagerProvider = context.watch<WallpaperManagerProvider>();

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wallpaperManagerProvider.savedWallpapers.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WallpaperDetails(
                    index: index,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: AppColors.borderRadiusAll,
                child: SizedBox(
                  width: 160,
                  child: Image.file(
                    wallpaperManagerProvider.savedWallpapers[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
