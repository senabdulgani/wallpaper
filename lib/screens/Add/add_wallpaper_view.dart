import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wallpaper_manager/product/theme/app_colors.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:wallpaper_manager/screens/Add/DisplayImage/exported_image_view.dart';

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

  int selectedImageIndex = 2;

  List<String> images = [
    "https://images.pexels.com/photos/1624496/pexels-photo-1624496.jpeg",
    "https://images.pexels.com/photos/1496373/pexels-photo-1496373.jpeg",
    "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg",
    "https://images.pexels.com/photos/1526713/pexels-photo-1526713.jpeg",
    "https://images.pexels.com/photos/1535162/pexels-photo-1535162.jpeg",
    "https://images.pexels.com/photos/2670898/pexels-photo-2670898.jpeg",
    "https://images.pexels.com/photos/1366630/pexels-photo-1366630.jpeg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Re-Design'),
        actions: [
          GestureDetector(
            onTap: () async {
              if (hasText) {
                final imageBytes = await createImageWithText(
                  images[selectedImageIndex],
                  reminderText,
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayImageScreen(imageBytes: imageBytes),
                  ),
                );
              } else {
                // Eğer metin eklenmemişse, orijinal resmi göster
                final response = await http.get(Uri.parse(images[selectedImageIndex]));
                final imageBytes = response.bodyBytes;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayImageScreen(imageBytes: imageBytes),
                  ),
                );
              }
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
                      images[selectedImageIndex],
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
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              reminderText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          selectedImageIndex = (selectedImageIndex - 1 + images.length) % images.length;
                          setState(() {});
                        },
                      ),
                      const Gap(16),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          selectedImageIndex = (selectedImageIndex + 1) % images.length;
                          setState(() {});
                        },
                      ),
                    ],
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

  Future<Uint8List> createImageWithText(String imageUrl, String text) async {
    // Görüntüyü indir
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    // Görüntüyü ui.Image'e dönüştür
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    // Metin eklemek için bir resim oluştur
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final size = Size(image.width.toDouble(), image.height.toDouble());

    // Arka plan görüntüsünü çiz
    canvas.drawImage(image, Offset.zero, Paint());

    // Metni hazırla
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout(maxWidth: size.width * 0.8); // Metnin maksimum genişliğini sınırla

    // Metin için arka plan kutusu çiz
    final textBackgroundRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: textPainter.width + 40,
      height: textPainter.height + 20,
    );
    canvas.drawRect(
      textBackgroundRect,
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    // Metni çiz
    final textOffset = size.center(Offset.zero) - Offset(textPainter.width / 2, textPainter.height / 2);
    textPainter.paint(canvas, textOffset);

    // Resmi oluştur
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
