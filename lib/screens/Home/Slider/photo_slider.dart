import 'package:flutter/material.dart';
import 'package:wallpaper_manager/product/theme/app_colors.dart';

class PhotoSlider extends StatefulWidget {
  const PhotoSlider({
    super.key,
  });

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: AppColors.borderRadiusAll,
              child: SizedBox(
                width: 160,
                child: Image.network(
                  'https://picsum.photos/1080/1920',
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
