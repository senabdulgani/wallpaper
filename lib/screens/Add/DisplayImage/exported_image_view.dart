import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_app/product/theme/app_colors.dart';

// ignore: must_be_immutable
class DisplayImageScreen extends StatefulWidget {
  late String temporaryImagePath;
  DisplayImageScreen({
    super.key,
    required this.temporaryImagePath,
  });

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  String home = "Home Screen";
  String lock = "Lock Screen";
  String both = "Both Screen";
  String system = "System";

  late Stream<String> progressString;

  // late String res;
  bool isLoading = false;

  var result = "Waiting to set wallpaper";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Wallpaper'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ClipRRect(
                borderRadius: AppColors.borderRadiusAll * 2,
                child: Image.file(File(widget.temporaryImagePath)),
              ),
            ),
            const Gap(5),
            isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'home',
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            int location = WallpaperManager.HOME_SCREEN;
                            await WallpaperManager.setWallpaperFromFile(widget.temporaryImagePath, location);
                            setState(() {
                              isLoading = false;
                            });
                          } catch (exception) {
                            // Scaffold Message
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Bu bir Snackbar mesajıdır!'),
                                action: SnackBarAction(
                                  label: 'Geri Al',
                                  onPressed: () {
                                    // Snackbar eylem tıklandığında yapılacaklar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Geri alma işlemi yapıldı.')),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        child: const Icon(
                          Icons.home,
                          color: AppColors.black,
                        ),
                      ),
                      FloatingActionButton(
                        heroTag: 'lock',
                        onPressed: () async {
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            int location = WallpaperManager.LOCK_SCREEN;
                            await WallpaperManager.setWallpaperFromFile(
                              widget.temporaryImagePath,
                              location,
                            );
                            setState(() {
                              isLoading = false;
                            });
                          } catch (exception) {
                            // Scaffold Message
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('There is an error!'),
                              ),
                            );
                          }
                        },
                        child: const Icon(
                          Icons.lock,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
