import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:walltext/core/helper.dart';
import 'package:walltext/product/state/add_image_provider.dart';
import 'package:walltext/product/theme/app_colors.dart';
import 'package:walltext/screens/Add/Result/exported_image_view.dart';
import 'package:walltext/screens/Add/Add%20Text/add_wallpaper_view.dart';

mixin AddWallpaperMixin on State<AddWallpaperView> {
  final TextEditingController reminderTextController = TextEditingController();
  String reminderText = '';

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

  // temporary photo path
  String temporaryPhotoPath = '';
  String? selectedImagePath;

  double fontSize = 30;

  bool isLoading = false;
  late int imageWidth;
  late double previewRatio;

  @override
  void initState() {
    super.initState();
    getImageWidth(images[selectedImageIndex]);
  }

  Positioned movementArrows() {
    return Positioned(
      top: 10,
      right: 10,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              selectedImageIndex = (selectedImageIndex - 1 + images.length) % images.length;
              setState(() {});
              getImageWidth(images[selectedImageIndex]);
            },
          ),
          const Gap(16),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              selectedImageIndex = (selectedImageIndex + 1) % images.length;
              setState(() {});
              getImageWidth(images[selectedImageIndex]);
            },
          ),
        ],
      ),
    );
  }

  Slider textSizeSlider() {
    return Slider(
      value: fontSize,
      min: 0,
      max: 120,
      divisions: 120,
      onChanged: (double value) {
        setState(() {
          fontSize = value;
          debugPrint('$fontSize');
        });
      },
    );
  }

  GestureDetector bringFileFromDevice(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _pickImage(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.transparent,
        child: const Icon(Icons.upload),
      ),
    );
  }

  GestureDetector exportButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        temporaryPhotoPath = await createImageWithText(
          selectedImagePath ?? images[selectedImageIndex],
          reminderTextController.text,
        );

        // Navigate to the DisplayImageScreen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DisplayImageView(
              temporaryImagePath: temporaryPhotoPath,
            ),
          ),
        );

        // Save the photo to the documents directory
        await saveNewWallpaper(temporaryPhotoPath);

        setState(() {
          isLoading = false;
        });
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
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    if (!await Helper().accessRequest()) return;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      setState(() {
        selectedImagePath = image.path;
      });

      // ignore: use_build_context_synchronously
      Provider.of<WallpaperProvider>(context, listen: false).addWallpaper(image);

      getImageWidth(pickedFile.path);
    }
  }

  Future<void> getImageWidth(String imagePath) async {
    Uint8List bytes;

    if (selectedImagePath == null) {
      final response = await http.get(Uri.parse(imagePath));
      bytes = response.bodyBytes;
    } else {
      final file = File(imagePath);
      bytes = await file.readAsBytes();
    }

    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    imageWidth = image.width;
    debugPrint('${image.width}');

    previewRatio = imageWidth / (MediaQuery.of(context).size.width - 16);
  }

  Future<String> createImageWithText(String imagePath, String text) async {
    // Load image data
    Uint8List bytes;
    if (selectedImagePath == null) {
      final response = await http.get(Uri.parse(imagePath));
      bytes = response.bodyBytes;
    } else {
      final file = File(imagePath);
      bytes = await file.readAsBytes();
    }

    // Decode image to get the original dimensions
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final size = Size(image.width.toDouble(), image.height.toDouble());

    // Create a new picture recorder to draw on
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Draw the original image
    canvas.drawImage(image, Offset.zero, Paint());

    // Prepare the text with the specified font size
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize * previewRatio,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Layout the text
    textPainter.layout(maxWidth: size.width - 20);

    // Calculate position to center the text
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Draw background for text (optional)
    canvas.drawRect(
      Rect.fromLTWH(
        textOffset.dx - 10,
        textOffset.dy - 5,
        textPainter.width + 20,
        textPainter.height + 10,
      ),
      Paint()..color = AppColors.grey,
    );

    // Draw the text on the image
    textPainter.paint(canvas, textOffset);

    // Finalize the drawing
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    // Save the final image to a file
    final directory = await getApplicationDocumentsDirectory();
    final imagePathWithText = '${directory.path}/image_with_text.png';
    final file = File(imagePathWithText);

    await file.writeAsBytes(pngBytes!.buffer.asUint8List());

    return imagePathWithText;
  }

  Future<void> saveNewWallpaper(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final wallpaperDirectory = Directory('${directory.path}/Wallpapers');

      if (!await wallpaperDirectory.exists()) {
        await wallpaperDirectory.create(recursive: true);
      }

      final imageFile = File(imagePath);
      final newImagePath = '${wallpaperDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await imageFile.copy(newImagePath);

      print("Wallpaper saved to: $newImagePath");
    } catch (e) {
      print("Error saving wallpaper: $e");
    }
  }
}
