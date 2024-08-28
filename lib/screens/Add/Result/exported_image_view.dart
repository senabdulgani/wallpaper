import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:walltext/product/components/set_wallpaper_button.dart';
import 'package:walltext/product/theme/app_colors.dart';
import 'package:walltext/screens/navbar_and_pages_view.dart.dart';

// ignore: must_be_immutable
class DisplayImageView extends StatefulWidget {
  late String temporaryImagePath;
  DisplayImageView({
    super.key,
    required this.temporaryImagePath,
  });

  @override
  State<DisplayImageView> createState() => _DisplayImageViewState();
}

class _DisplayImageViewState extends State<DisplayImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Wallpaper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Go to home screen with push
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavBarAndPagesView(),
                ),
                (route) => false,
              );
            },
          ),
        ],
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
            SetWallpaperButton(path: widget.temporaryImagePath),
          ],
        ),
      ),
    );
  }
}
