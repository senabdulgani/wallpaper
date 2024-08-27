import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_app/product/theme/app_colors.dart';
import 'package:wallpaper_app/screens/Add/add_wallpaper_mixin.dart';

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
        title: const Text('Re-Design'),
        actions: [
          !isLoading ? exportButton(context) : const CircularProgressIndicator(),
        ],
        leading: bringFileFromDevice(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            textSizeSlider(),
            checkBox(),
            const Gap(20),
            if (hasText) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: reminderTextController,
                  decoration: const InputDecoration(
                    labelText: 'What do you want to remind you about?',
                  ),
                  onChanged: (value) {
                    // reminderText is value
                    reminderText = value;
                    setState(() {});
                  },
                ),
              ),
              const Gap(20),
            ],
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
                if (hasText)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: AppColors.grey,
                        child: Text(
                          reminderTextController.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize, // Use your desired font size here
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ),
                    ),
                  ),
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
