import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper/product/theme/app_colors.dart';

class AddWallpaperView extends StatefulWidget {
  const AddWallpaperView({super.key});

  @override
  State<AddWallpaperView> createState() => _AddWallpaperViewState();
}

class _AddWallpaperViewState extends State<AddWallpaperView> {
  final TextEditingController reminderTextController = TextEditingController();
  String reminderText = '';

  String selectedFont = 'Regular';

  List<String> fonts = ['Times New Roman', 'Roboto', 'Regular'];

  bool hasText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Design'),
        // export --> text button
        actions: [
          GestureDetector(
            onTap: () {
              // set wallpaper function.
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.transparent,
              child: const Text(
                'Export',
                style: TextStyle(
                  fontSize: 17,
                  color: AppColors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(children: [
              Checkbox(
                value: hasText,
                onChanged: (value) {
                  setState(() {
                    hasText = value!;
                  });
                },
              ),
              const Text(
                'Add text to your walpaper',
                style: TextStyle(fontSize: 24),
              ),
            ]),
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
                    // remoinderText is value
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
                    child: Image.network(
                      'https://picsum.photos/1080/1920',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (hasText)
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: AppColors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              reminderText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: AppColors.main,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}
