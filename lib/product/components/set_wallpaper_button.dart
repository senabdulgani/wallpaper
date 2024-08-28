import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gap/gap.dart';
import 'package:walltext/product/theme/app_colors.dart';

class SetWallpaperButton extends StatefulWidget {
  final String path;

  const SetWallpaperButton({
    super.key,
    required this.path,
  });

  @override
  State<SetWallpaperButton> createState() => _SetWallpaperButtonState();
}

class _SetWallpaperButtonState extends State<SetWallpaperButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              FloatingActionButton(
                heroTag: 'home',
                onPressed: () async {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await WallpaperManager.setWallpaperFromFile(
                      widget.path,
                      WallpaperManager.HOME_SCREEN,
                    );

                    setState(() {
                      isLoading = false;
                    });
                  } catch (exception) {
                    // Scaffold Message
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('There is an error while setting wallpaper.'),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.lock,
                  color: AppColors.black,
                ),
              ),
              const Gap(6),
              const Text('Set Lock Screen')
            ],
          );
  }
}
