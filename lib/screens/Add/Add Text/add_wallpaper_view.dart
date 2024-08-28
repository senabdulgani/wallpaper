import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:walltext/product/state/add_image_provider.dart';
import 'package:walltext/product/theme/app_colors.dart';
import 'package:walltext/screens/Add/Add%20Text/add_wallpaper_mixin.dart';

class AddWallpaperView extends StatefulWidget {
  const AddWallpaperView({super.key});

  @override
  State<AddWallpaperView> createState() => _AddWallpaperViewState();
}

class _AddWallpaperViewState extends State<AddWallpaperView> with AddWallpaperMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design'),
        actions: [
          !isLoading ? exportButton(context) : const CircularProgressIndicator(),
        ],
        leading: bringFileFromDevice(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Gap(12),
                      Text(
                        'Adjust the font size as you wish.',
                        style: TextStyle(color: AppColors.grey),
                      ),
                      Spacer(),
                    ],
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: textSizeSlider(),
                  ),
                ],
              ),
            ),
            const Gap(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: reminderTextController,
                decoration: const InputDecoration(
                  labelText: 'Write Something',
                ),
                onChanged: (value) {
                  // reminderText is value
                  reminderText = value;
                  setState(() {});
                },
              ),
            ),
            const Gap(20),
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: AppColors.borderRadiusAll * 2,
                    child: selectedImagePath == null
                        ? Image.network(
                            images[selectedImageIndex],
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: AppColors.grey,
                      child: Text(
                        reminderTextController.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          //TODO: Synchronize preview with reality.
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                if (selectedImagePath != null) ...[
                  Positioned(
                    // TODO: Adjust according to user device.
                    top: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        // remove device file wallpaper
                        Provider.of<WallpaperProvider>(context, listen: false).removeWallpaper();
                        selectedImagePath = null;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.transparantBlack,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
                if (selectedImagePath == null) ...[
                  movementArrows(),
                ]
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
